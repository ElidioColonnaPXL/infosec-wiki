#requires -Version 5.1
<#
.SYNOPSIS
    Builds the Windows 11 DFIR workstation used in the investigations.
    SHA-256: 8bf563536f46c75c2c01e01bc8c27724b3f71c4314fe11c443b8e13d5cf82cb6

.DESCRIPTION
    Installs and configures:
      - PowerShell 7, 7-Zip, Git, Python 3.13, VS Code, Notepad++
      - .NET 9 Desktop Runtime
      - Eric Zimmerman Tools (.NET 9 builds + synced maps)
      - Hayabusa
      - Chainsaw and its repository files
      - SigmaHQ rules
      - Volatility 3 in an isolated Python virtual environment
      - YARA CLI and yara-python
      - Autopsy
      - Start Menu shortcuts and command wrappers

    The script is designed to be rerunnable. It records every component as
    SUCCESS, FAILED, SKIPPED, or INFO and writes transcript, CSV, JSON, summary,
    failure, and software-inventory logs under C:\DFIR\Logs.

.NOTES
    Run from an elevated PowerShell window:

        Set-ExecutionPolicy -Scope Process Bypass -Force
        .\Install-DFIR-Workstation.ps1

    This is an evidence-analysis workstation build. It intentionally does not:
      - disable Microsoft Defender;
      - create broad Defender exclusions;
      - install FLARE-VM;
      - execute malware;
      - install VMware Tools (VMware Tools must be mounted by the hypervisor).
#>

[CmdletBinding()]
param(
    [string]$Root = 'C:\DFIR',
    [switch]$SkipAutopsy,
    [switch]$SkipRuleRepositories,
    [switch]$ForceRefreshDownloads
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$StartedAt = Get-Date
$TimeStamp = $StartedAt.ToString('yyyyMMdd-HHmmss')

$Paths = [ordered]@{
    Root          = $Root
    Tools         = Join-Path $Root 'Tools'
    Cases         = Join-Path $Root 'Cases'
    Scripts       = Join-Path $Root 'Scripts'
    Temp          = Join-Path $Root 'Temp'
    Rules         = Join-Path $Root 'Rules'
    Documentation = Join-Path $Root 'Documentation'
    Logs          = Join-Path $Root 'Logs'
}

foreach ($Path in $Paths.Values) {
    New-Item -Path $Path -ItemType Directory -Force | Out-Null
}

$TranscriptPath = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-transcript.log"
$CsvPath        = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-results.csv"
$JsonPath       = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-results.json"
$SummaryPath    = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-summary.txt"
$FailurePath    = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-failures.txt"
$WingetListPath = Join-Path $Paths.Logs "DFIR-Setup-$TimeStamp-winget-list.txt"

$script:Results = [System.Collections.Generic.List[object]]::new()
$script:TranscriptStarted = $false

function Add-Result {
    param(
        [Parameter(Mandatory)][string]$Component,
        [Parameter(Mandatory)][ValidateSet('SUCCESS', 'FAILED', 'SKIPPED', 'INFO')][string]$Status,
        [string]$Version = '',
        [string]$Path = '',
        [string]$Details = ''
    )

    $script:Results.Add([pscustomobject]@{
        Timestamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        Component = $Component
        Status    = $Status
        Version   = $Version
        Path      = $Path
        Details   = $Details
    })
}

function Write-Stage {
    param([string]$Message)

    Write-Host "`n============================================================" -ForegroundColor DarkCyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
}

function Invoke-Component {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][scriptblock]$Action
    )

    Write-Host "`n[$Name]" -ForegroundColor Cyan

    try {
        $Info = & $Action

        if ($null -eq $Info) {
            $Info = [pscustomobject]@{}
        }

        $Version = if ($Info.PSObject.Properties['Version']) { [string]$Info.Version } else { '' }
        $Path    = if ($Info.PSObject.Properties['Path'])    { [string]$Info.Path }    else { '' }
        $Details = if ($Info.PSObject.Properties['Details']) { [string]$Info.Details } else { 'Completed.' }
        $Status  = if ($Info.PSObject.Properties['Status']) { [string]$Info.Status } else { 'SUCCESS' }

        if ($Status -notin @('SUCCESS', 'FAILED', 'SKIPPED', 'INFO')) {
            $Status = 'SUCCESS'
        }

        Add-Result -Component $Name -Status $Status -Version $Version -Path $Path -Details $Details

        switch ($Status) {
            'SUCCESS' { Write-Host "SUCCESS: $Details" -ForegroundColor Green }
            'SKIPPED' { Write-Host "SKIPPED: $Details" -ForegroundColor Yellow }
            'INFO'    { Write-Host "INFO: $Details" -ForegroundColor Gray }
            'FAILED'  { Write-Host "FAILED: $Details" -ForegroundColor Red }
        }
    }
    catch {
        $Message = $_.Exception.Message
        Add-Result -Component $Name -Status 'FAILED' -Details $Message
        Write-Host "FAILED: $Message" -ForegroundColor Red
    }
}

function Test-IsAdministrator {
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = [Security.Principal.WindowsPrincipal]::new($Identity)
    return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Update-ProcessPath {
    $MachinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')

    $Combined = @($MachinePath, $UserPath) |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { $_.TrimEnd(';') }

    $env:Path = ($Combined -join ';')
}

function Add-UserPathEntry {
    param([Parameter(Mandatory)][string]$Directory)

    $Current = [Environment]::GetEnvironmentVariable('Path', 'User')
    $Entries = @()

    if (-not [string]::IsNullOrWhiteSpace($Current)) {
        $Entries = @($Current -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }

    if ($Entries -notcontains $Directory) {
        $NewValue = (@($Entries + $Directory) -join ';')
        [Environment]::SetEnvironmentVariable('Path', $NewValue, 'User')
    }

    Update-ProcessPath
}

function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string[]]$Arguments,
        [string]$WorkingDirectory = '',
        [int[]]$SuccessExitCodes = @(0)
    )

    $PreviousLocation = Get-Location

    try {
        if (-not [string]::IsNullOrWhiteSpace($WorkingDirectory)) {
            Set-Location $WorkingDirectory
        }

        $Output = & $FilePath @Arguments 2>&1
        $ExitCode = $LASTEXITCODE

        if ($SuccessExitCodes -notcontains $ExitCode) {
            $Rendered = ($Output | Out-String).Trim()
            throw "Command failed with exit code $ExitCode: $FilePath $($Arguments -join ' ')`n$Rendered"
        }

        return @($Output)
    }
    finally {
        Set-Location $PreviousLocation
    }
}

function Invoke-WingetInstall {
    param(
        [Parameter(Mandatory)][string]$Id,
        [switch]$Interactive
    )

    $Arguments = @(
        'install',
        '--id', $Id,
        '--exact',
        '--source', 'winget',
        '--accept-source-agreements',
        '--accept-package-agreements',
        '--disable-interactivity'
    )

    if (-not $Interactive) {
        $Arguments += '--silent'
    }

    $Output = & winget @Arguments 2>&1
    $ExitCode = $LASTEXITCODE
    $Text = ($Output | Out-String).Trim()

    $BenignMessages = @(
        'No available upgrade found',
        'No newer package versions are available',
        'already installed',
        'Found an existing package already installed'
    )

    $Benign = $false
    foreach ($Pattern in $BenignMessages) {
        if ($Text -match [regex]::Escape($Pattern)) {
            $Benign = $true
            break
        }
    }

    if (($ExitCode -ne 0) -and (-not $Benign)) {
        throw "WinGet failed for $Id with exit code $ExitCode.`n$Text"
    }

    return $Text
}

function Find-FirstExistingPath {
    param([Parameter(Mandatory)][string[]]$Candidates)

    foreach ($Candidate in $Candidates) {
        if (-not [string]::IsNullOrWhiteSpace($Candidate) -and (Test-Path $Candidate)) {
            return (Resolve-Path $Candidate).Path
        }
    }

    return $null
}

function Get-GitHubLatestRelease {
    param([Parameter(Mandatory)][string]$Repository)

    $Headers = @{
        'User-Agent' = 'DFIR-WS01-Setup'
        'Accept'     = 'application/vnd.github+json'
    }

    return Invoke-RestMethod `
        -Uri "https://api.github.com/repos/$Repository/releases/latest" `
        -Headers $Headers
}

function Install-GitHubReleaseZip {
    param(
        [Parameter(Mandatory)][string]$Repository,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][scriptblock]$AssetFilter,
        [Parameter(Mandatory)][string]$TempName
    )

    $Release = Get-GitHubLatestRelease -Repository $Repository
    $Asset = $Release.assets | Where-Object $AssetFilter | Select-Object -First 1

    if (-not $Asset) {
        $Available = ($Release.assets.name -join ', ')
        throw "No suitable Windows x64 ZIP asset found for $Repository. Available assets: $Available"
    }

    $DownloadDirectory = Join-Path $Paths.Temp $TempName
    $Archive = Join-Path $DownloadDirectory $Asset.name

    if ($ForceRefreshDownloads) {
        Remove-Item $DownloadDirectory -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $Destination -Recurse -Force -ErrorAction SilentlyContinue
    }

    New-Item $DownloadDirectory -ItemType Directory -Force | Out-Null
    New-Item $Destination -ItemType Directory -Force | Out-Null

    Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $Archive
    $Hash = (Get-FileHash $Archive -Algorithm SHA256).Hash

    Remove-Item (Join-Path $Destination '*') -Recurse -Force -ErrorAction SilentlyContinue
    Expand-Archive -Path $Archive -DestinationPath $Destination -Force

    return [pscustomobject]@{
        Release = $Release
        Asset   = $Asset
        Archive = $Archive
        SHA256  = $Hash
    }
}

function Sync-GitRepository {
    param(
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][string]$Destination
    )

    if (Test-Path (Join-Path $Destination '.git')) {
        Invoke-ExternalCommand -FilePath 'git.exe' -Arguments @('-C', $Destination, 'fetch', '--depth', '1', 'origin') | Out-Null
        Invoke-ExternalCommand -FilePath 'git.exe' -Arguments @('-C', $Destination, 'reset', '--hard', 'FETCH_HEAD') | Out-Null
    }
    else {
        Remove-Item $Destination -Recurse -Force -ErrorAction SilentlyContinue
        Invoke-ExternalCommand -FilePath 'git.exe' -Arguments @('clone', '--depth', '1', $Uri, $Destination) | Out-Null
    }

    $Commit = (Invoke-ExternalCommand -FilePath 'git.exe' -Arguments @('-C', $Destination, 'rev-parse', '--short', 'HEAD'))[0]
    return ([string]$Commit).Trim()
}

function New-CommandWrapper {
    param(
        [Parameter(Mandatory)][string]$CommandName,
        [Parameter(Mandatory)][string]$Executable,
        [string]$ArgumentsPrefix = ''
    )

    $WrapperPath = Join-Path $Paths.Scripts "$CommandName.cmd"
    $Prefix = if ([string]::IsNullOrWhiteSpace($ArgumentsPrefix)) { '' } else { "$ArgumentsPrefix " }

    @"
@echo off
"$Executable" $Prefix%*
"@ | Set-Content -Path $WrapperPath -Encoding ASCII

    return $WrapperPath
}

function New-StartMenuShortcut {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$TargetPath,
        [string]$Arguments = '',
        [string]$WorkingDirectory = '',
        [string]$Subfolder = 'DFIR Tools'
    )

    if (-not (Test-Path $TargetPath)) {
        throw "Shortcut target does not exist: $TargetPath"
    }

    $StartMenuRoot = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
    $ShortcutDirectory = Join-Path $StartMenuRoot $Subfolder
    New-Item $ShortcutDirectory -ItemType Directory -Force | Out-Null

    $ShortcutPath = Join-Path $ShortcutDirectory "$Name.lnk"
    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Arguments = $Arguments
    $Shortcut.WorkingDirectory = if ([string]::IsNullOrWhiteSpace($WorkingDirectory)) {
        Split-Path $TargetPath -Parent
    }
    else {
        $WorkingDirectory
    }
    $Shortcut.IconLocation = "$TargetPath,0"
    $Shortcut.Description = $Name
    $Shortcut.Save()

    return $ShortcutPath
}

function Get-UninstallEntries {
    $RegistryPaths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    return Get-ItemProperty $RegistryPaths -ErrorAction SilentlyContinue |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.DisplayName) }
}

function Get-InstalledApp {
    param([Parameter(Mandatory)][string]$DisplayNamePattern)

    return Get-UninstallEntries |
        Where-Object { $_.DisplayName -like $DisplayNamePattern } |
        Sort-Object DisplayVersion -Descending |
        Select-Object -First 1
}

try {
    Start-Transcript -Path $TranscriptPath -Force | Out-Null
    $script:TranscriptStarted = $true

    Write-Stage 'DFIR WORKSTATION INSTALLATION'
    Write-Host "Started: $StartedAt"
    Write-Host "Root:    $Root"
    Write-Host "Logs:    $($Paths.Logs)"

    if (-not (Test-IsAdministrator)) {
        throw 'Run this script from an elevated PowerShell window (Run as administrator).'
    }

    Add-Result -Component 'Administrator check' -Status 'SUCCESS' -Details 'The script is running elevated.'

    Invoke-Component -Name 'Windows platform' -Action {
        $Os = Get-CimInstance Win32_OperatingSystem
        [pscustomobject]@{
            Version = $Os.Version
            Path    = $env:SystemRoot
            Details = "$($Os.Caption), build $($Os.BuildNumber), $($Os.OSArchitecture)"
        }
    }

    Invoke-Component -Name 'VMware Tools detection' -Action {
        $Service = Get-Service -Name VMTools -ErrorAction SilentlyContinue
        $App = Get-InstalledApp -DisplayNamePattern 'VMware Tools*'

        if (-not $Service -and -not $App) {
            return [pscustomobject]@{
                Status  = 'INFO'
                Details = 'VMware Tools was not detected. Mount and install it from VMware Workstation if needed.'
            }
        }

        [pscustomobject]@{
            Version = if ($App) { $App.DisplayVersion } else { '' }
            Path    = if ($App) { $App.InstallLocation } else { '' }
            Details = if ($Service) { "Service state: $($Service.Status)." } else { 'Installed application detected.' }
        }
    }

    Invoke-Component -Name 'Microsoft Defender state' -Action {
        $Defender = Get-MpComputerStatus
        $Status = if ($Defender.AntivirusEnabled -and $Defender.RealTimeProtectionEnabled) { 'SUCCESS' } else { 'INFO' }

        [pscustomobject]@{
            Status  = $Status
            Version = [string]$Defender.AntivirusSignatureVersion
            Path    = ''
            Details = "AntivirusEnabled=$($Defender.AntivirusEnabled); RealTimeProtectionEnabled=$($Defender.RealTimeProtectionEnabled). No exclusions were created."
        }
    }

    Write-Stage 'DIRECTORY STRUCTURE'

    Invoke-Component -Name 'C:\DFIR directory structure' -Action {
        $Required = @(
            $Paths.Root,
            $Paths.Tools,
            $Paths.Cases,
            $Paths.Scripts,
            $Paths.Temp,
            $Paths.Rules,
            $Paths.Documentation,
            $Paths.Logs,
            (Join-Path $Paths.Cases 'Autopsy')
        )

        foreach ($Directory in $Required) {
            New-Item $Directory -ItemType Directory -Force | Out-Null
        }

        [pscustomobject]@{
            Path    = $Paths.Root
            Details = "$($Required.Count) directories verified."
        }
    }

    Write-Stage 'WINDOWS PACKAGE MANAGER'

    Invoke-Component -Name 'WinGet' -Action {
        $Winget = Get-Command winget.exe -ErrorAction Stop
        $Version = (& $Winget.Source --version 2>&1 | Select-Object -First 1).ToString().Trim()
        & $Winget.Source source update --accept-source-agreements 2>&1 | Out-Null

        [pscustomobject]@{
            Version = $Version
            Path    = $Winget.Source
            Details = 'WinGet is available and package sources were updated.'
        }
    }

    $BasePackages = @(
        [pscustomobject]@{ Name = 'PowerShell 7';       Id = 'Microsoft.PowerShell' },
        [pscustomobject]@{ Name = '7-Zip';              Id = '7zip.7zip' },
        [pscustomobject]@{ Name = 'Git';                Id = 'Git.Git' },
        [pscustomobject]@{ Name = 'Python 3.13';        Id = 'Python.Python.3.13' },
        [pscustomobject]@{ Name = 'Visual Studio Code'; Id = 'Microsoft.VisualStudioCode' },
        [pscustomobject]@{ Name = 'Notepad++';          Id = 'Notepad++.Notepad++' },
        [pscustomobject]@{ Name = '.NET 9 Desktop Runtime'; Id = 'Microsoft.DotNet.DesktopRuntime.9' },
        [pscustomobject]@{ Name = 'YARA CLI';           Id = 'VirusTotal.YARA' }
    )

    if (-not $SkipAutopsy) {
        $BasePackages += [pscustomobject]@{ Name = 'Autopsy'; Id = 'SleuthKit.Autopsy' }
    }

    foreach ($Package in $BasePackages) {
        Invoke-Component -Name $Package.Name -Action {
            Invoke-WingetInstall -Id $Package.Id | Out-Null
            Update-ProcessPath

            switch ($Package.Id) {
                'Microsoft.PowerShell' {
                    $Exe = (Get-Command pwsh.exe -ErrorAction Stop).Source
                    $Version = (& $Exe -NoProfile -Command '$PSVersionTable.PSVersion.ToString()').Trim()
                    return [pscustomobject]@{ Version = $Version; Path = $Exe; Details = 'PowerShell 7 installed and verified.' }
                }
                '7zip.7zip' {
                    $Exe = Find-FirstExistingPath -Candidates @(
                        "$env:ProgramFiles\7-Zip\7z.exe",
                        "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
                    )
                    if (-not $Exe) { throw '7z.exe was not found after installation.' }
                    $Version = (Get-Item $Exe).VersionInfo.ProductVersion
                    return [pscustomobject]@{ Version = $Version; Path = $Exe; Details = '7-Zip installed and verified.' }
                }
                'Git.Git' {
                    $Exe = (Get-Command git.exe -ErrorAction Stop).Source
                    $Version = (& $Exe --version).Trim()
                    & $Exe config --system core.longpaths true
                    return [pscustomobject]@{ Version = $Version; Path = $Exe; Details = 'Git installed; system core.longpaths=true.' }
                }
                'Python.Python.3.13' {
                    $Py = (Get-Command py.exe -ErrorAction Stop).Source
                    $Version = (& $Py -3.13 --version 2>&1).ToString().Trim()
                    & $Py -3.13 -m pip install --upgrade pip setuptools wheel | Out-Null
                    return [pscustomobject]@{ Version = $Version; Path = $Py; Details = 'Python 3.13 installed; pip, setuptools, and wheel updated.' }
                }
                'Microsoft.VisualStudioCode' {
                    $Exe = Find-FirstExistingPath -Candidates @(
                        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
                        "$env:ProgramFiles\Microsoft VS Code\Code.exe"
                    )
                    if (-not $Exe) { throw 'Code.exe was not found after installation.' }
                    $Version = (Get-Item $Exe).VersionInfo.ProductVersion
                    return [pscustomobject]@{ Version = $Version; Path = $Exe; Details = 'Visual Studio Code installed and verified.' }
                }
                'Notepad++.Notepad++' {
                    $Exe = Find-FirstExistingPath -Candidates @(
                        "$env:ProgramFiles\Notepad++\notepad++.exe",
                        "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
                    )
                    if (-not $Exe) { throw 'notepad++.exe was not found after installation.' }
                    $Version = (Get-Item $Exe).VersionInfo.ProductVersion
                    return [pscustomobject]@{ Version = $Version; Path = $Exe; Details = 'Notepad++ installed and verified.' }
                }
                'Microsoft.DotNet.DesktopRuntime.9' {
                    $RuntimeLine = & dotnet.exe --list-runtimes 2>&1 |
                        Where-Object { $_ -match '^Microsoft\.WindowsDesktop\.App 9\.' } |
                        Select-Object -First 1
                    if (-not $RuntimeLine) { throw '.NET 9 Windows Desktop Runtime was not detected.' }
                    $Version = ([regex]::Match([string]$RuntimeLine, '9\.\d+\.\d+')).Value
                    return [pscustomobject]@{ Version = $Version; Path = (Get-Command dotnet.exe).Source; Details = [string]$RuntimeLine }
                }
                'VirusTotal.YARA' {
                    $Yara = (Get-Command yara.exe -ErrorAction Stop).Source
                    $Yarac = (Get-Command yarac.exe -ErrorAction Stop).Source
                    $Version = (& $Yara --version).Trim()
                    return [pscustomobject]@{ Version = $Version; Path = $Yara; Details = "YARA and YARAC verified. Compiler: $Yarac" }
                }
                'SleuthKit.Autopsy' {
                    $AutopsyDirectory = Get-ChildItem "$env:ProgramFiles\Autopsy-*" -Directory -ErrorAction SilentlyContinue |
                        Sort-Object Name -Descending |
                        Select-Object -First 1
                    if (-not $AutopsyDirectory) { throw 'Autopsy installation directory was not found.' }

                    $Exe = Get-ChildItem $AutopsyDirectory.FullName -Filter 'autopsy*.exe' -File -Recurse -ErrorAction SilentlyContinue |
                        Select-Object -First 1
                    $App = Get-InstalledApp -DisplayNamePattern 'Autopsy*'
                    $Version = if ($App) { $App.DisplayVersion } else { $AutopsyDirectory.Name -replace '^Autopsy-' }

                    return [pscustomobject]@{
                        Version = $Version
                        Path    = if ($Exe) { $Exe.FullName } else { $AutopsyDirectory.FullName }
                        Details = 'Autopsy installed and its case directory is C:\DFIR\Cases\Autopsy.'
                    }
                }
            }
        }
    }

    if ($SkipAutopsy) {
        Add-Result -Component 'Autopsy' -Status 'SKIPPED' -Details 'Skipped by -SkipAutopsy.'
    }

    Write-Stage 'ERIC ZIMMERMAN TOOLS'

    Invoke-Component -Name 'Eric Zimmerman Tools' -Action {
        $ScriptDirectory = Join-Path $Paths.Scripts 'EZTools'
        $ScriptPath = Join-Path $ScriptDirectory 'Get-ZimmermanTools.ps1'
        $Destination = Join-Path $Paths.Tools 'EZTools'

        New-Item $ScriptDirectory -ItemType Directory -Force | Out-Null
        New-Item $Destination -ItemType Directory -Force | Out-Null

        Invoke-WebRequest `
            -Uri 'https://raw.githubusercontent.com/EricZimmerman/Get-ZimmermanTools/master/Get-ZimmermanTools.ps1' `
            -OutFile $ScriptPath

        & $ScriptPath -Dest $Destination -NetVersion 9 -Sync

        $Expected = @(
            'AmcacheParser.exe',
            'AppCompatCacheParser.exe',
            'EvtxECmd.exe',
            'JLECmd.exe',
            'LECmd.exe',
            'MFTECmd.exe',
            'PECmd.exe',
            'RBCmd.exe',
            'RECmd.exe',
            'SBECmd.exe',
            'SQLECmd.exe',
            'WxTCmd.exe',
            'TimelineExplorer.exe',
            'RegistryExplorer.exe',
            'MFTExplorer.exe'
        )

        $Missing = [System.Collections.Generic.List[string]]::new()
        foreach ($Name in $Expected) {
            $Found = Get-ChildItem $Destination -Filter $Name -File -Recurse -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if (-not $Found) { $Missing.Add($Name) }
        }

        if ($Missing.Count -gt 0) {
            throw "Missing expected Zimmerman tools: $($Missing -join ', ')"
        }

        [pscustomobject]@{
            Version = '.NET 9 builds'
            Path    = $Destination
            Details = "$($Expected.Count) expected core tools verified; EvtxECmd, RECmd, and SQLECmd supporting files synced."
        }
    }

    Invoke-Component -Name 'Zimmerman command wrappers' -Action {
        $Destination = Join-Path $Paths.Tools 'EZTools'
        $CliTools = @(
            'AmcacheParser.exe',
            'AppCompatCacheParser.exe',
            'EvtxECmd.exe',
            'JLECmd.exe',
            'LECmd.exe',
            'MFTECmd.exe',
            'PECmd.exe',
            'RBCmd.exe',
            'RECmd.exe',
            'SBECmd.exe',
            'SQLECmd.exe',
            'WxTCmd.exe'
        )

        $Created = 0
        foreach ($Tool in $CliTools) {
            $Exe = Get-ChildItem $Destination -Filter $Tool -File -Recurse -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if (-not $Exe) { continue }

            $CommandName = [IO.Path]::GetFileNameWithoutExtension($Tool)
            New-CommandWrapper -CommandName $CommandName -Executable $Exe.FullName | Out-Null
            $Created++
        }

        Add-UserPathEntry -Directory $Paths.Scripts

        [pscustomobject]@{
            Path    = $Paths.Scripts
            Details = "$Created Zimmerman CLI command wrappers created and C:\DFIR\Scripts added to the user PATH."
        }
    }

    Invoke-Component -Name 'Zimmerman Start Menu shortcuts' -Action {
        $Destination = Join-Path $Paths.Tools 'EZTools'
        $GuiTools = @('TimelineExplorer.exe', 'RegistryExplorer.exe', 'MFTExplorer.exe')
        $Created = 0

        foreach ($Tool in $GuiTools) {
            $Exe = Get-ChildItem $Destination -Filter $Tool -File -Recurse -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if (-not $Exe) { continue }

            $Name = [IO.Path]::GetFileNameWithoutExtension($Tool)
            New-StartMenuShortcut `
                -Name $Name `
                -TargetPath $Exe.FullName `
                -WorkingDirectory $Exe.DirectoryName `
                -Subfolder 'DFIR Tools\Eric Zimmerman Tools' | Out-Null
            $Created++
        }

        [pscustomobject]@{
            Path    = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\DFIR Tools\Eric Zimmerman Tools'
            Details = "$Created GUI shortcuts created."
        }
    }

    Write-Stage 'EVENT LOG AND TIMELINE TOOLS'

    Invoke-Component -Name 'Hayabusa' -Action {
        $Destination = Join-Path $Paths.Tools 'Hayabusa'
        $Install = Install-GitHubReleaseZip `
            -Repository 'Yamato-Security/hayabusa' `
            -Destination $Destination `
            -TempName 'Hayabusa' `
            -AssetFilter {
                $_.name -match '(?i)win-x64.*\.zip$' -and
                $_.name -notmatch '(?i)live-response|all-platforms'
            }

        $Exe = Get-ChildItem $Destination -Filter 'hayabusa*.exe' -File -Recurse |
            Select-Object -First 1
        if (-not $Exe) { throw 'Hayabusa executable was not found after extraction.' }

        & $Exe.FullName help 2>&1 | Out-Null

        [pscustomobject]@{
            Version = $Install.Release.tag_name
            Path    = $Exe.FullName
            Details = "Latest stable Windows x64 release installed. Archive SHA256=$($Install.SHA256)"
        }
    }

    Invoke-Component -Name 'Chainsaw' -Action {
        $RootDirectory = Join-Path $Paths.Tools 'Chainsaw'
        $Destination = Join-Path $RootDirectory 'bin'
        $Install = Install-GitHubReleaseZip `
            -Repository 'WithSecureLabs/chainsaw' `
            -Destination $Destination `
            -TempName 'Chainsaw' `
            -AssetFilter {
                $_.name -match '(?i)\.zip$' -and
                $_.name -match '(?i)(windows|pc-windows-msvc)' -and
                $_.name -match '(?i)(x86_64|x64)' -and
                $_.name -notmatch '(?i)(aarch64|arm64)'
            }

        $Exe = Get-ChildItem $Destination -Filter 'chainsaw.exe' -File -Recurse |
            Select-Object -First 1
        if (-not $Exe) { throw 'Chainsaw executable was not found after extraction.' }

        $VersionText = (& $Exe.FullName --version 2>&1 | Select-Object -First 1).ToString().Trim()

        [pscustomobject]@{
            Version = if ($VersionText) { $VersionText } else { $Install.Release.tag_name }
            Path    = $Exe.FullName
            Details = "Latest stable Windows x64 release installed. Archive SHA256=$($Install.SHA256)"
        }
    }

    if (-not $SkipRuleRepositories) {
        Invoke-Component -Name 'Chainsaw repository files' -Action {
            $Destination = Join-Path $Paths.Tools 'Chainsaw\Repository'
            $Commit = Sync-GitRepository `
                -Uri 'https://github.com/WithSecureLabs/chainsaw.git' `
                -Destination $Destination

            $Mapping = Join-Path $Destination 'mappings\sigma-event-logs-all.yml'
            $Rules = Join-Path $Destination 'rules'

            if (-not (Test-Path $Mapping)) { throw "Chainsaw mapping file not found: $Mapping" }
            if (-not (Test-Path $Rules)) { throw "Chainsaw rules directory not found: $Rules" }

            [pscustomobject]@{
                Version = $Commit
                Path    = $Destination
                Details = 'Repository mapping and native rules verified.'
            }
        }

        Invoke-Component -Name 'SigmaHQ rules' -Action {
            $Destination = Join-Path $Paths.Rules 'Sigma'
            $Commit = Sync-GitRepository `
                -Uri 'https://github.com/SigmaHQ/sigma.git' `
                -Destination $Destination

            $RuleCount = (Get-ChildItem (Join-Path $Destination 'rules') -Filter '*.yml' -File -Recurse -ErrorAction Stop).Count
            if ($RuleCount -le 0) { throw 'No Sigma YAML rules were found.' }

            [pscustomobject]@{
                Version = $Commit
                Path    = $Destination
                Details = "$RuleCount Sigma YAML rules found."
            }
        }
    }
    else {
        Add-Result -Component 'Chainsaw repository files' -Status 'SKIPPED' -Details 'Skipped by -SkipRuleRepositories.'
        Add-Result -Component 'SigmaHQ rules' -Status 'SKIPPED' -Details 'Skipped by -SkipRuleRepositories.'
    }

    Write-Stage 'MEMORY FORENSICS'

    Invoke-Component -Name 'Volatility 3 and yara-python' -Action {
        $VolRoot = Join-Path $Paths.Tools 'Volatility3'
        $Venv = Join-Path $VolRoot '.venv'
        $VolPython = Join-Path $Venv 'Scripts\python.exe'
        $VolExe = Join-Path $Venv 'Scripts\vol.exe'

        New-Item $VolRoot -ItemType Directory -Force | Out-Null

        if (-not (Test-Path $VolPython)) {
            & py.exe -3.13 -m venv $Venv
        }

        if (-not (Test-Path $VolPython)) { throw 'Volatility Python virtual environment was not created.' }

        & $VolPython -m pip install --upgrade pip setuptools wheel | Out-Null
        & $VolPython -m pip install --upgrade 'volatility3[full]' yara-python | Out-Null

        if (-not (Test-Path $VolExe)) { throw 'vol.exe was not created inside the virtual environment.' }

        & $VolExe -h 2>&1 | Out-Null

        $VolVersion = (& $VolPython -c "import importlib.metadata; print(importlib.metadata.version('volatility3'))").Trim()
        $YaraPythonVersion = (& $VolPython -c 'import yara; print(yara.__version__)').Trim()

        New-CommandWrapper -CommandName 'vol3' -Executable $VolExe | Out-Null
        Add-UserPathEntry -Directory $Paths.Scripts

        [pscustomobject]@{
            Version = $VolVersion
            Path    = $VolExe
            Details = "Volatility 3 installed in an isolated venv; yara-python=$YaraPythonVersion; command wrapper=vol3."
        }
    }

    Write-Stage 'YARA VERIFICATION'

    Invoke-Component -Name 'YARA source and compiled-rule test' -Action {
        Update-ProcessPath
        $Yara = (Get-Command yara.exe -ErrorAction Stop).Source
        $Yarac = (Get-Command yarac.exe -ErrorAction Stop).Source

        $TestDirectory = Join-Path $Paths.Temp 'YARA-Test'
        $TestFile = Join-Path $TestDirectory 'sample.txt'
        $TestRule = Join-Path $TestDirectory 'dfir-test.yar'
        $CompiledRule = Join-Path $TestDirectory 'dfir-test.yarc'

        New-Item $TestDirectory -ItemType Directory -Force | Out-Null
        'Normal text containing DFIR_TEST_MARKER_2026.' | Set-Content $TestFile

        @'
rule DFIR_Test
{
    meta:
        description = "Harmless installation verification rule"

    strings:
        $marker = "DFIR_TEST_MARKER_2026" ascii

    condition:
        $marker
}
'@ | Set-Content -Path $TestRule -Encoding ASCII

        $SourceOutput = & $Yara $TestRule $TestFile 2>&1
        if ($LASTEXITCODE -ne 0 -or ($SourceOutput -notmatch 'DFIR_Test')) {
            throw "YARA source-rule test failed: $($SourceOutput | Out-String)"
        }

        & $Yarac $TestRule $CompiledRule 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $CompiledRule)) {
            throw 'YARAC failed to compile the harmless test rule.'
        }

        $CompiledOutput = & $Yara -C $CompiledRule $TestFile 2>&1
        if ($LASTEXITCODE -ne 0 -or ($CompiledOutput -notmatch 'DFIR_Test')) {
            throw "YARA compiled-rule test failed: $($CompiledOutput | Out-String)"
        }

        [pscustomobject]@{
            Version = (& $Yara --version).Trim()
            Path    = $Yara
            Details = 'Source rule and compiled rule (-C) both matched the harmless test marker.'
        }
    }

    Write-Stage 'START MENU SHORTCUTS'

    Invoke-Component -Name 'PowerShell 7 Start Menu shortcut' -Action {
        Update-ProcessPath
        $Pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source
        $Shortcut = New-StartMenuShortcut `
            -Name 'PowerShell 7 (DFIR)' `
            -TargetPath $Pwsh `
            -Arguments '-NoLogo' `
            -WorkingDirectory $env:USERPROFILE `
            -Subfolder 'DFIR Tools'

        [pscustomobject]@{
            Path    = $Shortcut
            Details = 'Searchable Start Menu shortcut created.'
        }
    }

    if (-not $SkipAutopsy) {
        Invoke-Component -Name 'Autopsy Start Menu shortcut' -Action {
            $AutopsyDirectory = Get-ChildItem "$env:ProgramFiles\Autopsy-*" -Directory -ErrorAction SilentlyContinue |
                Sort-Object Name -Descending |
                Select-Object -First 1
            if (-not $AutopsyDirectory) { throw 'Autopsy installation directory was not found.' }

            $Exe = Get-ChildItem $AutopsyDirectory.FullName -Filter 'autopsy*.exe' -File -Recurse -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if (-not $Exe) { throw 'Autopsy executable was not found.' }

            $Shortcut = New-StartMenuShortcut `
                -Name 'Autopsy' `
                -TargetPath $Exe.FullName `
                -WorkingDirectory $Exe.DirectoryName `
                -Subfolder 'DFIR Tools'

            [pscustomobject]@{
                Path    = $Shortcut
                Details = 'Searchable Start Menu shortcut created.'
            }
        }
    }

    Write-Stage 'FINAL INVENTORY'

    Invoke-Component -Name 'WinGet software inventory' -Action {
        $Output = & winget list --accept-source-agreements 2>&1
        $Output | Set-Content $WingetListPath -Encoding UTF8

        [pscustomobject]@{
            Path    = $WingetListPath
            Details = 'Current WinGet software inventory exported.'
        }
    }

    Invoke-Component -Name 'Core tool verification' -Action {
        Update-ProcessPath

        $Checks = [ordered]@{
            pwsh   = [bool](Get-Command pwsh.exe -ErrorAction SilentlyContinue)
            git    = [bool](Get-Command git.exe -ErrorAction SilentlyContinue)
            py     = [bool](Get-Command py.exe -ErrorAction SilentlyContinue)
            yara   = [bool](Get-Command yara.exe -ErrorAction SilentlyContinue)
            yarac  = [bool](Get-Command yarac.exe -ErrorAction SilentlyContinue)
            vol3   = Test-Path (Join-Path $Paths.Scripts 'vol3.cmd')
            EZTools = Test-Path (Join-Path $Paths.Tools 'EZTools')
            Hayabusa = [bool](Get-ChildItem (Join-Path $Paths.Tools 'Hayabusa') -Filter 'hayabusa*.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1)
            Chainsaw = [bool](Get-ChildItem (Join-Path $Paths.Tools 'Chainsaw') -Filter 'chainsaw.exe' -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1)
        }

        $FailedChecks = @($Checks.GetEnumerator() | Where-Object { -not $_.Value })
        if ($FailedChecks.Count -gt 0) {
            throw "Failed core checks: $($FailedChecks.Name -join ', ')"
        }

        [pscustomobject]@{
            Path    = $Paths.Root
            Details = "$($Checks.Count) core checks passed."
        }
    }
}
catch {
    $FatalMessage = $_.Exception.Message
    Add-Result -Component 'Fatal script error' -Status 'FAILED' -Details $FatalMessage
    Write-Host "`nFATAL: $FatalMessage" -ForegroundColor Red
}
finally {
    $EndedAt = Get-Date
    $Duration = New-TimeSpan -Start $StartedAt -End $EndedAt

    $script:Results | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
    $script:Results | ConvertTo-Json -Depth 5 | Set-Content -Path $JsonPath -Encoding UTF8

    $SuccessCount = @($script:Results | Where-Object Status -eq 'SUCCESS').Count
    $FailureCount = @($script:Results | Where-Object Status -eq 'FAILED').Count
    $SkippedCount = @($script:Results | Where-Object Status -eq 'SKIPPED').Count
    $InfoCount    = @($script:Results | Where-Object Status -eq 'INFO').Count

    $Summary = @"
DFIR Workstation Installation Summary
=====================================
Started:  $StartedAt
Finished: $EndedAt
Duration: $($Duration.ToString())
Computer: $env:COMPUTERNAME
User:     $env:USERDOMAIN\$env:USERNAME
Root:     $Root

SUCCESS:  $SuccessCount
FAILED:   $FailureCount
SKIPPED:  $SkippedCount
INFO:     $InfoCount

Transcript: $TranscriptPath
CSV:        $CsvPath
JSON:       $JsonPath
Failures:   $FailurePath
WinGet:     $WingetListPath
"@

    $Summary | Set-Content -Path $SummaryPath -Encoding UTF8

    $Failures = @($script:Results | Where-Object Status -eq 'FAILED')
    if ($Failures.Count -eq 0) {
        'No failed components.' | Set-Content -Path $FailurePath -Encoding UTF8
    }
    else {
        $Failures | Format-List Timestamp, Component, Version, Path, Details |
            Out-String |
            Set-Content -Path $FailurePath -Encoding UTF8
    }

    Write-Host "`n============================================================" -ForegroundColor DarkCyan
    Write-Host 'INSTALLATION SUMMARY' -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor DarkCyan
    Write-Host "SUCCESS: $SuccessCount" -ForegroundColor Green
    Write-Host "FAILED:  $FailureCount" -ForegroundColor $(if ($FailureCount -eq 0) { 'Green' } else { 'Red' })
    Write-Host "SKIPPED: $SkippedCount" -ForegroundColor Yellow
    Write-Host "INFO:    $InfoCount" -ForegroundColor Gray
    Write-Host "`nSummary:  $SummaryPath"
    Write-Host "Results:  $CsvPath"
    Write-Host "Failures: $FailurePath"
    Write-Host "Log:      $TranscriptPath"

    if ($script:TranscriptStarted) {
        try { Stop-Transcript | Out-Null } catch { }
    }
}

$FinalFailureCount = @($script:Results | Where-Object Status -eq 'FAILED').Count
if ($FinalFailureCount -gt 0) {
    exit 1
}

exit 0
