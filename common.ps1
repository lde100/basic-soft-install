<#
    basic-soft-install / common.ps1
    Shared core for all profile scripts (Win11).
    Profiles load this via:
        Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/common.ps1'))
    then call the functions below.
#>

function Assert-Admin {
    # Soft self-elevation guard. README already says "Run as Administrator";
    # this just fails clean instead of crashing mid-run.
    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "Dieses Script braucht Adminrechte. PowerShell als Administrator starten."
        throw "Not running as administrator."
    }
}

function Install-Chocolatey {
    Write-Output "`nInstall Chocolatey:`n"
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Output "Chocolatey bereits vorhanden - skip.`n"
    } else {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    choco feature enable -n=allowGlobalConfirmation
}

function Install-Packages {
    param([Parameter(Mandatory)][string[]] $Packages)
    Write-Output "`nInstall Packages: $($Packages -join ' ')`n"
    $i = 0
    foreach ($p in $Packages) {
        $i++
        Update-GuiStatus ("Installiere {0} ({1}/{2})" -f $p, $i, $Packages.Count)
        choco install $p -y
    }
}

function Enable-DarkMode {
    Write-Output "Enable Dark Mode`n"
    $p = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    Set-ItemProperty -Path $p -Name SystemUsesLightTheme -Value 0 -Type Dword -Force
    Set-ItemProperty -Path $p -Name AppsUseLightTheme   -Value 0 -Type Dword -Force
}

function Set-ExplorerTweaks {
    # Show "This PC" icon on desktop
    Write-Output "Show Computer Shortcut on Desktop`n"
    $p = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type Dword -Force

    $adv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    Write-Output "Disable Taskbar Widgets / Task View`n"
    Set-ItemProperty -Path $adv -Name TaskbarDa          -Value 0 -Type Dword -Force
    Set-ItemProperty -Path $adv -Name TaskbarMn          -Value 0 -Type Dword -Force
    Set-ItemProperty -Path $adv -Name ShowTaskViewButton -Value 0 -Type Dword -Force

    Write-Output "Disable Taskbar Search`n"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" `
        -Name SearchboxTaskbarMode -Value 0 -Type Dword -Force

    Write-Output "File Explorer opens This PC`n"
    Set-ItemProperty -Path $adv -Name LaunchTo -Value 1 -Type Dword -Force

    Write-Output "Show File Extensions`n"
    Set-ItemProperty -Path $adv -Name HideFileExt -Value 0 -Type Dword -Force

    Write-Output "Show All Folders in Navigation Panel`n"
    Set-ItemProperty -Path $adv -Name NavPaneShowAllFolders -Value 1 -Type Dword -Force
}

function Restore-ClassicContextMenu {
    # Win11: bring back the full right-click context menu
    Write-Output "Restore classic context menu`n"
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve | Out-Null
}

function Disable-LockscreenTips {
    Write-Output "Disable Lockscreen Tips`n"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
        -Name SubscribedContent-338387Enabled -Value 0 -Type Dword -Force
}

function Set-PCShortcutName {
    param([string] $Prefix = "Arbeitsplatz")
    Write-Output "Rename This PC Shortcut`n"
    $p = "HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "(Default)" -Value "$Prefix $env:COMPUTERNAME" -Type String -Force
}

function Set-SystemDriveLabel {
    param([string] $Prefix = "SYSTEM")
    Write-Output "Rename System Drive`n"
    $p = "HKCU:Software\Classes\Applications\Explorer.exe\Drives\C\DefaultLabel"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "(Default)" -Value "$Prefix $env:COMPUTERNAME" -Type String -Force
}

function Disable-ServerManagerOnLogon {
    # Only relevant on Windows Server
    Write-Output "Disable Server Manager at Logon`n"
    $p = "HKLM:Software\Microsoft\ServerManager"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "DoNotOpenServerManagerAtLogon" -Value 1 -Type Dword -Force
    $p = "HKCU:Software\Microsoft\ServerManager"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "CheckedUnattendLaunchSetting" -Value 0 -Type Dword -Force
}

function Disable-ShutdownEventTracker {
    Write-Output "Disable Shutdown Event-Tracker`n"
    $p = "HKLM:\Software\Policies\Microsoft\Windows NT\Reliability"
    if (!(Test-Path $p)) { New-Item $p -Force | Out-Null }
    Set-ItemProperty $p "shutdownReasonUI" -Value 0 -Type Dword -Force
}

function Enable-RemoteDesktop {
    Write-Output "Enable Remote Desktop`n"
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
}

function Invoke-WindowsActivation {
    param(
        [Parameter(Mandatory)][string] $KmsServer,
        [int] $Port = 1688
    )
    Write-Output "Activate Windows via KMS $KmsServer`n"
    $slmgr = Join-Path $env:windir "System32\slmgr.vbs"
    cscript //nologo //b $slmgr /skms "${KmsServer}:${Port}"
    cscript //nologo //b $slmgr /ato
}

function Remove-Bloatware {
    # Win11 default bloat. Override with -Apps to use a custom list.
    # NOTE intentionally kept OUT vs. the old Win10 list:
    #   - mspaint  -> that's Paint itself on Win11
    #   - zune*    -> Microsoft.ZuneMusic IS the Win11 Media Player
    param(
        [string[]] $Exclude = @(),      # diese NICHT entfernen (z.B. Teams)
        [string[]] $Additional = @(),   # zusaetzlich entfernen (z.B. neues Outlook)
        [string[]] $Apps = @(
        "Microsoft.BingNews"
        "Microsoft.BingFinance"
        "Microsoft.BingSports"
        "Microsoft.BingWeather"
        "Microsoft.WindowsMaps"
        "Microsoft.People"
        "Microsoft.MicrosoftStickyNotes"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"            # Tips
        "Microsoft.MicrosoftOfficeHub"    # Get Office
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.Todos"
        "Microsoft.PowerAutomateDesktop"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.OneConnect"            # Paid Wi-Fi & Cellular
        "Microsoft.WindowsCommunicationsApps"  # Mail & Calendar (Outlook ersetzt)
        "Microsoft.YourPhone"             # Phone Link
        "Microsoft.ZuneVideo"             # Movies & TV
        "Microsoft.GamingApp"             # Xbox App
        "Microsoft.XboxGamingOverlay"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.Xbox.TCUI"
        "Microsoft.549981C3F5F10"         # Cortana (auf 24H2 meist eh weg)
        "Clipchamp.Clipchamp"
        "MicrosoftTeams"                  # Consumer Chat/Teams
        "MSTeams"                         # neues Teams
        # --- Drittanbieter-"Suggested"-Apps ---
        "*CandyCrush*"
        "*Spotify*"
        "*Disney*"
        "*Hulu*"
        "*Netflix*"
        "*Prime*"
        "*TikTok*"
        "*Facebook*"
        "*Instagram*"
        "*Twitter*"
        "*BubbleWitch*"
        "*MarchOfEmpires*"
        "*Picsart*"
        "*Photoshop*"
    ))
    $effective = (@($Apps) + @($Additional)) |
        Where-Object { $_ -and ($Exclude -notcontains $_) } |
        Select-Object -Unique
    Write-Output "`nUninstalling default apps`n"
    foreach ($app in $effective) {
        $pkg = Get-AppxPackage -Name "*$app*" -AllUsers -ErrorAction SilentlyContinue
        if ($pkg) {
            $pkg | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online |
                Where-Object DisplayName -Like "*$app*" |
                Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

function Install-Office {
    # Microsoft 365 Apps (inkl. Outlook classic) via ODT.
    # Perpetual stattdessen: -Product ProPlus2021Volume  oder  ProPlus2024Volume
    param(
        [string] $Product  = "O365ProPlusRetail",
        [string] $Language = "de-de",
        [switch] $Is32Bit
    )
    Write-Output "`nInstall Microsoft Office ($Product, $Language)`n"
    $bit = if ($Is32Bit) { "" } else { "/64bit" }
    choco install microsoft-office-deployment -y --params="'$bit /Product:$Product /Language:$Language /Exclude:Lync,Groove'"
}

function Set-DefaultBrowserChrome {
    # Win11 schuetzt die UserChoice-Zuordnung per Hash -> reine Registry-Writes werden
    # zurueckgesetzt. SetUserFTA (Choco: setuserfta) erzeugt den gueltigen Hash.
    # Laeuft im Kontext des AUSFUEHRENDEN Users -> Script als der Zielnutzer (mit UAC) starten.
    Write-Output "`nSet Chrome as default for browser + PDF`n"
    $fta = Join-Path $env:ChocolateyInstall "bin\SetUserFTA.exe"
    if (-not (Test-Path $fta)) { $fta = "SetUserFTA" }   # Fallback auf PATH-Shim
    & $fta http  ChromeHTML
    & $fta https ChromeHTML
    & $fta .htm  ChromeHTML
    & $fta .html ChromeHTML
    & $fta .pdf  ChromeHTML
}

# ==========================================================================
#  Logging (%TEMP%) + GUI-Fortschritt
# ==========================================================================

$script:LogFile   = $null
$script:Gui       = $null
$script:StepNo    = 0
$script:StepTotal = 0

function Start-InstallLog {
    param([string] $Name = "basic-soft-install")
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $script:LogFile = Join-Path $env:TEMP "$($Name)_$stamp.log"
    try { Start-Transcript -Path $script:LogFile -Append -ErrorAction Stop | Out-Null } catch {}
    Write-Log "Logdatei: $script:LogFile"
}

function Write-Log {
    param([string] $Message, [ValidateSet("INFO","WARN","ERROR")][string] $Level = "INFO")
    $line = "{0} [{1}] {2}" -f (Get-Date -Format "HH:mm:ss"), $Level, $Message
    if ($script:LogFile) { Add-Content -Path $script:LogFile -Value $line -ErrorAction SilentlyContinue }
    switch ($Level) {
        "ERROR" { Write-Host $line -ForegroundColor Red }
        "WARN"  { Write-Host $line -ForegroundColor Yellow }
        default { Write-Host $line }
    }
    if ($script:Gui) {
        try {
            $script:Gui.Box.AppendText($line + [Environment]::NewLine)
            [System.Windows.Forms.Application]::DoEvents()
        } catch {}
    }
}

function Initialize-ProgressGui {
    param([string] $Title = "Basic Soft Install")
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        $f = New-Object System.Windows.Forms.Form
        $f.Text = $Title
        $f.Size = New-Object System.Drawing.Size(660,440)
        $f.StartPosition = "CenterScreen"
        $f.TopMost = $true
        $f.FormBorderStyle = "FixedDialog"
        $f.MaximizeBox = $false; $f.MinimizeBox = $true

        $lbl = New-Object System.Windows.Forms.Label
        $lbl.Location = New-Object System.Drawing.Point(12,12)
        $lbl.Size = New-Object System.Drawing.Size(630,20)
        $lbl.Text = "Starte..."

        $bar = New-Object System.Windows.Forms.ProgressBar
        $bar.Location = New-Object System.Drawing.Point(12,38)
        $bar.Size = New-Object System.Drawing.Size(630,24)
        $bar.Style = "Marquee"; $bar.MarqueeAnimationSpeed = 30

        $box = New-Object System.Windows.Forms.TextBox
        $box.Location = New-Object System.Drawing.Point(12,72)
        $box.Size = New-Object System.Drawing.Size(630,320)
        $box.Multiline = $true
        $box.ScrollBars = "Vertical"
        $box.ReadOnly = $true
        $box.BackColor = [System.Drawing.Color]::Black
        $box.ForeColor = [System.Drawing.Color]::LightGray
        $box.Font = New-Object System.Drawing.Font("Consolas",9)

        $f.Controls.AddRange(@($lbl,$bar,$box))
        $f.Show(); $f.Refresh()
        [System.Windows.Forms.Application]::DoEvents()
        $script:Gui = @{ Form=$f; Bar=$bar; Box=$box; Label=$lbl }
    } catch {
        $script:Gui = $null
        Write-Log "GUI nicht verfuegbar - nur Konsole/Log. ($($_.Exception.Message))" "WARN"
    }
}

function Update-GuiStatus {
    # aktualisiert Statuszeile + Log, OHNE den Balken weiterzuschieben (haelt Fenster reaktiv)
    param([string] $Message)
    if ($script:Gui) {
        try {
            $script:Gui.Label.Text = $Message
            $script:Gui.Form.Refresh()
            [System.Windows.Forms.Application]::DoEvents()
        } catch {}
    }
    Write-Log $Message
}

function Step {
    param([Parameter(Mandatory)][string] $Message)
    $script:StepNo++
    if ($script:Gui) {
        try {
            if ($script:StepTotal -gt 0) {
                $v = [math]::Min($script:StepNo, $script:StepTotal)
                $script:Gui.Bar.Value = $v
                $pct = [int](($v / $script:StepTotal) * 100)
                $script:Gui.Label.Text = "[$pct%] $Message"
            } else {
                $script:Gui.Label.Text = $Message
            }
            $script:Gui.Form.Refresh()
            [System.Windows.Forms.Application]::DoEvents()
        } catch {}
    }
    Write-Log "==> $Message"
}

function Invoke-Steps {
    # [ordered]@{ "Name" = { scriptblock }; ... }
    param([Parameter(Mandatory)][System.Collections.Specialized.OrderedDictionary] $Steps)
    $script:StepTotal = $Steps.Count
    $script:StepNo = 0
    if ($script:Gui) {
        try { $script:Gui.Bar.Style="Continuous"; $script:Gui.Bar.Minimum=0; $script:Gui.Bar.Maximum=$Steps.Count } catch {}
    }
    foreach ($name in $Steps.Keys) {
        Step $name
        try { & $Steps[$name] }
        catch { Write-Log "FEHLER bei '$name': $($_.Exception.Message)" "ERROR" }
    }
}

function Complete-InstallGui {
    param([string] $Message = "Setup abgeschlossen.")
    if ($script:Gui) {
        try {
            $script:Gui.Bar.Style = "Continuous"
            $script:Gui.Bar.Maximum = [math]::Max(1,$script:Gui.Bar.Maximum)
            $script:Gui.Bar.Value = $script:Gui.Bar.Maximum
            $script:Gui.Label.Text = $Message
            $script:Gui.Form.Text += "  -  fertig (Fenster schliessen)"
            $script:Gui.Form.Refresh()
            [System.Windows.Forms.Application]::DoEvents()
        } catch {}
    }
    Write-Log $Message
    try { Stop-Transcript | Out-Null } catch {}
    # Fenster offen halten bis der User schliesst, damit er das Log lesen kann
    if ($script:Gui) {
        try { while ($script:Gui.Form.Visible) { [System.Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 150 } } catch {}
    }
}
