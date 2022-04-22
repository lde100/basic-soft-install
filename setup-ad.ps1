# Software Install

Write-Output "`nInstall PacketManager and Basic Software:`n"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;
#MS Teams installation über Choco macht Probleme: Paket  microsoft-teams.install entfernt
#Full Setup:
#choco install chocolateygui googlechrome adobereader discord.install obs-studio.install drawio spotify vlc irfanview irfanview-languages irfanviewplugins sharex bitwarden 7zip advanced-renamer.install mediainfo teamviewer vscode.install putty.install filezilla winscp.install;

#Basic Setup: 
choco install googlechrome adobereader vlc irfanview irfanview-languages irfanviewplugins 7zip vscode.install mediainfo teamviewer;

