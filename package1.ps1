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

