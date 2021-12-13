# Software Install

Write-Output "Install PacketManager and Basic Software..."
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;
#choco install googlechrome adobereader microsoft-teams.install spotify vlc irfanview sharex 7zip teamviewer vscode putty.install winscp;

#Windows Customize

#Disables Web Search in Start Menu
    Write-Output "Disabling Bing Search in Start Menu..."
    $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty $WebSearch DisableWebSearch -Value 1 

# Enable Dark Mode
Write-Output "Enable Dark Mode"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force


# Show Computer Shortcut
Write-Output "Show Computer Shortcut"
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type Dword -Force
$RegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$RegKey = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    If (!(Test-Path $RegPath)) {
        New-Item $RegPath
    }
    Set-ItemProperty $RegPath $RegKey -Value 0 -Type Dword -Force