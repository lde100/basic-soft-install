# basic-soft-install / work-vm.ps1  -- Arbeits-VM (Win11)

Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/common.ps1'))

Assert-Admin
Install-Chocolatey

# Software
Install-Packages @(
    'chocolateygui','googlechrome','git.install','vscode.install','claude','claude-code',
    '7zip','vlc','irfanview','irfanview-languages','irfanviewplugins',
    'obs-studio.install','mediainfo','teamviewer','putty.install','winscp.install',
    'filezilla','sharex','bitwarden','drawio'
)

# Office: Microsoft 365 Apps inkl. Outlook classic (Edition ggf. anpassen)
Install-Office -Product "O365ProPlusRetail" -Language "de-de"

# Windows Customize
Enable-DarkMode
Set-ExplorerTweaks
Restore-ClassicContextMenu
Disable-LockscreenTips
Set-PCShortcutName -Prefix "Arbeitsplatz"
Set-SystemDriveLabel

# Default Apps: PDF + HTML/HTTP(S) auf Chrome (deckt auch Outlook-Links ab)
Set-DefaultBrowserChrome

# Debloat: Teams behalten, neues Outlook (Store-App) raus zugunsten Outlook classic
Remove-Bloatware -Exclude @('MicrosoftTeams','MSTeams') -Additional @('Microsoft.OutlookForWindows')
