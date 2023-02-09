# Software Install

Write-Output "`nInstall PacketManager and Basic Software:`n"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); 
SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin";
choco feature enable -n=allowGlobalConfirmation;
#MS Teams installation über Choco macht Probleme: Paket  microsoft-teams.install entfernt
#Full Setup:
#choco install chocolateygui googlechrome adobereader discord.install obs-studio.install drawio spotify vlc irfanview irfanview-languages irfanviewplugins sharex bitwarden 7zip advanced-renamer.install mediainfo teamviewer vscode.install putty.install filezilla winscp.install;

#Basic Setup: 
choco install chocolateygui googlechrome vlc irfanview irfanview-languages irfanviewplugins 7zip vscode.install;

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

# Disable Lockscreen Tips
Write-Output "Disable Lockscreen Tips`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338387Enabled -Value 0 -Type Dword -Force

# Set File Explorer to open This PC
Write-Output "Set File Explorer to open This PC`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1 -Type Dword -Force

# Show File Extensions
Write-Output "Show File Extensions`n"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Type Dword -Force

# Restore Win 10 Context Menue
Write-Output "Restore Win 10 Context Menue`n"
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Show All Folder in Navigation Panel
#Write-Output "Show All Folder in Navigation Panel`n"
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1 -Type Dword -Force

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
    
    
    Write-Host "Uninstalling default apps"
$apps = @(
            "CandyCrushSaga" 
            "CandyCrush" # CandyCrushSaga
            "wallet" 
            "Microsoft Pay"  # Microsoft Wallet (Microsoft Pay)
            "skypeapp"       # App Get Skype
            "officehub"      # App Get Office
            "getstarted"     # Get Started or Tips
            "solitaire"      # Microsoft Solitaire Collection
             #"bing"           # Money, News, Sports and Weather apps together
            "bingfinance"    # Money
             #"bingweather"    # Weather
            "bingnews"       # News
            "bingsports"     # Sports
            "onenote"        # OneNote
            "sway"           # Sway
            "oneconnect"     # Paid Wi-Fi & Cellular
            "cortana"        # Cortana used to be Non-Removable but is removable on some version of Windows
            "Microsoft.549981C3F5F10"
            "Cortana" # Alias for cortana on some version of Windows
            "Help"
            "tiktok"
            "twitter"
            "instagram"
            "BubbleWitchSaga"
            "MarchOfEmpires"
            "Disney"
            "spotify"
            "hulu"
            "photoshop"
            "Clipchamp.Clipchamp"
            "picsart"
            "Facebook"
            "phone"          # Phone and Phone Companion apps together
            "feedback" 
            "Feedback Hub" # Feedback Hub
            "xbox"           # All Xbox Apps
            "xboxapp"
            "XBox"
            "Microsoft.XboxGamingOverlay"
            "GamingApp"
            #"communicationsapps"  # Calendar and Mail apps together
            "todos"
            "maps"           # Maps
            "messaging"      # Messaging and Skype Video apps together
            #"onedrive"       # OneDrive Connect
            "connectivitystore"  # Microsoft Wi-Fi
            "mspaint"        # Paint 3D
            "people"         # People
            "sticky"         # Sticky Notes
            "3dbuilder"      # 3D Builder
            "3d"             # View 3D
            "soundrecorder"  # Voice Recorder
            "holographic"    # Windows Holographic
            "mixedReality"
            "Mixed Reality Portal" 
            "Dolby"
            "Teams"
            "zune"           # Groove Music and Movies & TV apps together
            "zunemusic"      # Groove Music
            "zunevideo"      # Movies & TV
            

)
foreach ($app in $apps) {
    #Simple Version     
    #get-appxpackage -AllUsers -ErrorAction SilentlyContinue *$app* | remove-appxpackage
    $package = Get-AppxPackage -Name *$app* -AllUsers -ErrorAction SilentlyContinue
    if ($package) { 
        Remove-AppxPackage -Package $package.PackageFullName
        Get-AppXProvisionedPackage -Online | where DisplayName -EQ $app |`
            Remove-AppxProvisionedPackage -Online
    }
}

