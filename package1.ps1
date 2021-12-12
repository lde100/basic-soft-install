iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;
#choco install googlechrome adobereader microsoft-teams.install spotify vlc irfanview sharex 7zip teamviewer vscode putty.install winscp;
choco install vlc;
