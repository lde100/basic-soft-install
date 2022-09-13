# basic-soft-install
Basic Software Installation

When executed, the script  installs `chocolatey` on the local machine and then installs all applications and customizations defined in the `setup1.ps1` script file.

## Install applications and customizations:
In order to run, open a Powershell instance in admin mode (Run as Administrator) and execute:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/setup1.ps1'))
```

It downloads the setup script and executes it.

### Other Setup Scripts:
Windows Server Setup:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/server1.ps1'))
```

Video WS Setup:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/video-ws-setup.ps1'))
```

AD CLIENT Software only Setup:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/setup-ad.ps1'))
```

VM-Activate + Basic Soft Setup:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/vm-setup.ps1'))
```

###Cheats

Remove all pre-installed Win10 Apps:

```console
Get-AppxPackage | Remove-AppPackage
```
