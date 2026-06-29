# basic-soft-install / work-vm.ps1  -- Arbeits-VM (Win11)

Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/common.ps1'))

Assert-Admin
Start-InstallLog -Name "work-vm"
Initialize-ProgressGui -Title "Work-VM Setup (Win11)"

$steps = [ordered]@{
    "Chocolatey installieren"        = { Install-Chocolatey }
    "Software installieren"          = { Install-Packages @(
            'chocolateygui','googlechrome','git.install','vscode.install','claude','claude-code',
            '7zip','vlc','irfanview','irfanview-languages','irfanviewplugins',
            'obs-studio.install','mediainfo','teamviewer','putty.install','winscp.install',
            'filezilla','sharex','bitwarden','drawio'
        ) }
    "Office 365 (inkl. Outlook classic)" = { Install-Office -Product "O365ProPlusRetail" -Language "de-de" }
    "Dark Mode"                      = { Enable-DarkMode }
    "Explorer-Tweaks"                = { Set-ExplorerTweaks }
    "Klassisches Kontextmenue"       = { Restore-ClassicContextMenu }
    "Lockscreen-Tipps aus"           = { Disable-LockscreenTips }
    "PC-Verknuepfung umbenennen"     = { Set-PCShortcutName -Prefix "Arbeitsplatz" }
    "Systemlaufwerk-Label"           = { Set-SystemDriveLabel }
    "Chrome als Standard (PDF/HTML)" = { Set-DefaultBrowserChrome }
    "Debloat (Teams bleibt)"         = { Remove-Bloatware -Exclude @('MicrosoftTeams','MSTeams') -Additional @('Microsoft.OutlookForWindows') }
}

Invoke-Steps $steps
Complete-InstallGui "Work-VM Setup abgeschlossen."
