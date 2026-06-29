# basic-soft-install / setup1.ps1  -- Standard Client (Win11)

Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/common.ps1'))

Assert-Admin
Install-Chocolatey

# Full Setup (auskommentiert - bei Bedarf statt Basic nutzen):
# Install-Packages @('chocolateygui','googlechrome','adobereader','discord.install','obs-studio.install','drawio','spotify','vlc','irfanview','irfanview-languages','irfanviewplugins','sharex','bitwarden','7zip','advanced-renamer.install','mediainfo','teamviewer','vscode.install','putty.install','filezilla','winscp.install')

# Basic Setup:
Install-Packages @('chocolateygui','googlechrome','vlc','irfanview','irfanview-languages','irfanviewplugins','7zip','vscode.install')

# Windows Customize
Enable-DarkMode
Set-ExplorerTweaks
Restore-ClassicContextMenu
Disable-LockscreenTips
Set-PCShortcutName -Prefix "Arbeitsplatz"
Set-SystemDriveLabel
Remove-Bloatware
