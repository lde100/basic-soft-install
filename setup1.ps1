# Software Install

Write-Output "`nInstall PacketManager and Basic Software:`n"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;
choco install googlechrome adobereader microsoft-teams.install spotify vlc irfanview sharex 7zip teamviewer vscode putty.install winscp;

# Windows Customize

# Disables Web Search in Start Menu
    Write-Output "`nDisabling Bing Search in Start Menu`n"
    $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty $WebSearch DisableWebSearch -Value 1 

# Enable Dark Mode
Write-Output "Enable Dark Mode`n"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force


# Show Computer Shortcut on Desktop
Write-Output "Show Computer Shortcut on Desktop`n"
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$RegKey = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    If (!(Test-Path $RegPath)) {
        New-Item $RegPath
    }
    Set-ItemProperty $RegPath $RegKey -Value 0 -Type Dword -Force
    
# Disable Taskbar Widgets
Write-Output "Disable Taskbar Widgets`n"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value 0 -Type Dword -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value 0 -Type Dword -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Type Dword -Force

# Disable Taskbar Search
Write-Output "Disable Taskbar Search`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Type Dword -Force

# Set File Explorer to open This PC
Write-Output "Set File Explorer to open This PC`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1 -Type Dword -Force

# Show File Extensions
Write-Output "Show File Extensions`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Type Dword -Force

# Show All Folder in Navigation Panel
Write-Output "Show All Folder in Navigation Panel`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1 -Type Dword -Force

# Rename This PC
Write-Output "Rename This PC`n"
$RegPath = "HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
$RegKey = "(Default)"
$RegValue = "Arbeitsplatz "+ $env:COMPUTERNAME
    If (!(Test-Path $RegPath)) {
        New-Item $RegPath
    }
    Set-ItemProperty $RegPath $RegKey -Value $RegValue -Type String -Force
    
# Rename System Drive
Write-Output "Rename System Drive`n"
$RegPath = "HKCU:Software\Classes\Applications\Explorer.exe\Drives\C\DefaultLabel"
$RegKey = "(Default)"
$RegValue = "SYSTEM "+ $env:COMPUTERNAME
    If (!(Test-Path $RegPath)) {
        New-Item HKCU:Software\Classes\Applications
        New-Item HKCU:Software\Classes\Applications\Explorer.exe
        New-Item HKCU:Software\Classes\Applications\Explorer.exe\Drives
        New-Item HKCU:Software\Classes\Applications\Explorer.exe\Drives\C
        New-Item $RegPath
    }
    Set-ItemProperty $RegPath $RegKey -Value $RegValue -Type String -Force

