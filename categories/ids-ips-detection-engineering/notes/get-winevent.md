Windows Event Logs and Finding Evil
Windows Commands


# Get-WinEvent Command Summary

The `Get-WinEvent` cmdlet in PowerShell is a powerful tool for querying and analyzing Windows Event Logs and Sysmon logs, which are critical for cybersecurity tasks like Incident Response (IR) and threat hunting. Below is a list of key commands and parameters, their explanations, and examples of how to use them.

---

## 1. Get-WinEvent -ListLog

- **Description**: Retrieves a comprehensive list of available event logs on the system, including properties like `LogName`, `RecordCount`, `IsClassicLog`, `IsEnabled`, `LogMode`, and `LogType`. Useful for identifying logs available for analysis.
- **Use Case**: To explore all logs on a system without filtering, helping to understand the scope of logs for further investigation.
- **Example**:

    ```powershell
    Get-WinEvent -ListLog * | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType | Format-Table -AutoSize
    ```

    - **Output**: Displays a table of logs (e.g., `System`, `Security`, `Application`) with details like record count and log mode (e.g., Circular, Administrative).

---

## 2. Pipe Operator (`|`)

- **Description**: Passes the output of one command to another for further processing. Essential for chaining commands in PowerShell to refine or format results.
- **Use Case**: Combine with other cmdlets like `Select-Object` or `Format-Table` to customize output.
- **Example**:

    ```powershell
    Get-WinEvent -ListLog * | Select-Object LogName, RecordCount
    ```

    - **Output**: Takes the list of logs from `Get-WinEvent -ListLog` and filters to show only `LogName` and `RecordCount`.

---

## 3. Get-WinEvent -ListProvider

- **Description**: Lists event log providers and their associated logs. Providers are sources of events within logs, helping identify which components generate specific log entries.
- **Use Case**: To discover providers for filtering or to understand event sources for specific logs.
- **Example**:

    ```powershell
    Get-WinEvent -ListProvider * | Format-Table -AutoSize
    ```

    - **Output**: Shows providers (e.g., `PowerShell`, `Microsoft-Windows-Eventlog`) and their linked logs (e.g., `Windows PowerShell`, `System`).

---

## 4. Get-WinEvent -LogName

- **Description**: Retrieves events from a specified event log (e.g., `System`, `Microsoft-Windows-WinRM/Operational`). Can limit output with `-MaxEvents` to avoid overwhelming results.
- **Use Case**: To analyze specific logs for troubleshooting or detecting suspicious activity.
- **Example**:

    ```powershell
    Get-WinEvent -LogName 'System' -MaxEvents 50 | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize
    ```

    - **Output**: Displays the first 50 events from the `System` log, showing details like creation time, event ID, and message.

---

## 5. Get-WinEvent -Oldest

- **Description**: Retrieves the oldest events from a specified log, useful for chronological analysis of historical events.
- **Use Case**: To investigate early events in a log, such as initial system issues or attack indicators.
- **Example**:

    ```powershell
    Get-WinEvent -LogName 'Microsoft-Windows-WinRM/Operational' -Oldest -MaxEvents 30 | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize
    ```

    - **Output**: Shows the oldest 30 events from the `Microsoft-Windows-WinRM/Operational` log, useful for tracking early WinRM activity.

---

## 6. Get-WinEvent -Path

- **Description**: Queries events from an exported `.evtx` file, enabling analysis of logs from another system or backed-up logs.
- **Use Case**: For auditing or analyzing logs in scripts, especially when logs are archived or from remote systems.
- **Example**:

    ```powershell
    Get-WinEvent -Path 'C:\Tools\chainsaw\EVTX-ATTACK-SAMPLES\Execution\exec_sysmon_1_lolbin_pcalua.evtx' -MaxEvents 5 | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize
    ```

    - **Output**: Retrieves the first 5 events from the specified `.evtx` file, showing process creation details.

---

## 7. Get-WinEvent -FilterHashtable

- **Description**: Filters events based on specific conditions (e.g., log name, event ID, date range) using a hashtable. Highly flexible for targeted log analysis.
- **Use Case**: To narrow down events to specific IDs or time frames, such as detecting process creation or network activity.
- **Example**:

    ```powershell
    Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=1,3} | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize
    ```

    - **Output**: Retrieves Sysmon events with IDs 1 (Process Create) and 3 (Network Connection), useful for detecting potential C2 activity.

---

## 8. Get-WinEvent -FilterHashtable with Date Range

- **Description**: Extends `-FilterHashtable` to filter events within a specific date range using `StartTime` and `EndTime`.
- **Use Case**: To focus on events within a known incident timeframe.
- **Example**:

    ```powershell
    $startDate = (Get-Date -Year 2023 -Month 5 -Day 28).Date
    $endDate = (Get-Date -Year 2023 -Month 6 -Day 3).Date
    Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=1,3; StartTime=$startDate; EndTime=$endDate} | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize
    ```

    - **Output**: Shows Sysmon events (IDs 1, 3) from May 28, 2023, to June 2, 2023.

---

## 9. Get-WinEvent -FilterHashtable & XML Parsing

- **Description**: Parses XML event data to extract specific fields (e.g., Source IP, Destination IP) for advanced filtering, often used with Sysmon Event ID 3 (Network Connection).
- **Use Case**: To investigate network connections to a specific IP address, such as a suspected C2 server.
- **Example**:

    ```powershell
    Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=3} | ForEach-Object {
        $xml = [xml]$_.ToXml()
        $eventData = $xml.Event.EventData.Data
        New-Object PSObject -Property @{
            SourceIP = $eventData | Where-Object {$_.Name -eq "SourceIp"} | Select-Object -ExpandProperty '#text'
            DestinationIP = $eventData | Where-Object {$_.Name -eq "DestinationIp"} | Select-Object -ExpandProperty '#text'
            ProcessGuid = $eventData | Where-Object {$_.Name -eq "ProcessGuid"} | Select-Object -ExpandProperty '#text'
            ProcessId = $eventData | Where-Object {$_.Name -eq "ProcessId"} | Select-Object -ExpandProperty '#text'
        }
    } | Where-Object {$_.DestinationIP -eq "52.113.194.132"}
    ```

    - **Output**: Filters Sysmon network connection events to show only those with a destination IP of `52.113.194.132`, displaying source IP, process ID, and GUID.

---

## 10. Get-WinEvent -FilterXml

- **Description**: Uses an XML query to filter events based on specific conditions, such as event ID and data values (e.g., DLL loading).
- **Use Case**: To detect anomalous activity, like loading of specific DLLs (`clr.dll`, `mscoree.dll`) in processes.
- **Example**:

    ```powershell
    $Query = @"
        <QueryList>
            <Query Id="0">
                <Select Path="Microsoft-Windows-Sysmon/Operational">*[System[(EventID=7)]] and *[EventData[Data='mscoree.dll']] or *[EventData[Data='clr.dll']]
                </Select>
            </Query>
        </QueryList>
    "@
    Get-WinEvent -FilterXml $Query | ForEach-Object {Write-Host $_.Message `n}
    ```

    - **Output**: Lists Sysmon Event ID 7 events where `mscoree.dll` or `clr.dll` was loaded, showing details like process and file metadata.

---

## 11. Get-WinEvent -FilterXPath

- **Description**: Uses XPath queries to filter events based on specific event data fields, such as process image or command line.
- **Use Case**: To identify specific process activities, like Sysinternals tool installations or network connections to a suspicious IP.
- **Example**:

    ```powershell
    Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' -FilterXPath "*[System[EventID=3] and EventData[Data[@Name='DestinationIp']='52.113.194.132']]"
    ```

    - **Output**: Retrieves Sysmon Event ID 3 events with a destination IP of `52.113.194.132`, showing network connection details.

---

## 12. Select-Object -Property *

- **Description**: Selects all properties of an event, providing a comprehensive view of event details.
- **Use Case**: To inspect all available data for an event, useful for detailed analysis or debugging.
- **Example**:

    ```powershell
    Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=1} -MaxEvents 1 | Select-Object -Property *
    ```

    - **Output**: Displays all properties of a single Sysmon Event ID 1 (Process Create), including process ID, command line, and hashes.

---

## 13. Where-Object with Properties Filtering

- **Description**: Filters events based on specific property values, such as checking for encoded commands (`-enc`) in the parent command line.
- **Use Case**: To detect suspicious activities, like obfuscated PowerShell scripts.
- **Example**:

    ```powershell
    Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=1} | Where-Object {$_.Properties[21].Value -like "*-enc*"} | Format-List
    ```

    - **Output**: Lists Sysmon Event ID 1 events where the parent command line contains `-enc`, indicating potential encoded PowerShell commands.

---

This summary provides a quick reference for using `Get-WinEvent` and related commands to analyze Windows Event Logs, with examples tailored for cybersecurity tasks like threat hunting and incident response.
