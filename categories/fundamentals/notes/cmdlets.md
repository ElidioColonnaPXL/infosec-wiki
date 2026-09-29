# cmdlets

re small single-function tools built into the shell. There are more than 100 core cmdlets, and many additional ones have been written, or we can author our own to perform more complex tasks. PowerShell also supports both simple and complex scripts used for system administration tasks, automation, and more.

Cmdlets are in the form of `Verb-Noun`. For example, the command `Get-ChildItem` can be used to list our current directory. Cmdlets also take arguments or flags. We can type `Get-ChildItem -` and hit the tab key to iterate through the arguments. A command such as `Get-ChildItem -Recurse` will show us the contents of our current working directory and all subdirectories. Another example would be `Get-ChildItem -Path %USERPROFILE%\Documents` to get the contents of another directory. Finally, we can combine arguments such as this to list all subdirectories' contents within another directory recursively: `Get-ChildItem -Path %USERPROFILE%\Downloads -Recurse`.
Windows Fundamentals
Windows Commands
Introduction to Windows Command Line
