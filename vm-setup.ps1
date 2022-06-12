# Software Install

Write-Output "`nInstall PacketManager and Basic Software:`n"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;

#Basic Setup: 
choco install  googlechrome  7zip vscode.install chocolateygui

# Windows Customize

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


# Rename This PC Shortcut
Write-Output "Rename This PC Shortcut`n"
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
    
  # Enable Remote Desktop
    Write-Output "Enable Remote Deskto`n" 
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
   
   #Activate Windows 
    Write-Output "Activate Windows`n"
   slmgr //b /skms 192.168.2.72
   slmgr //b /ato 
