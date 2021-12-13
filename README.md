# basic-soft-install
Basic Software Installation

When executed, the script checks if installed or installs `chocolatey` on the local machine and then installs all applications defined in the `package1.ps1` config file.

## Install application list from Github:
In order to run, open a Powershell instance in admin mode (Run as Administrator) and execute:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/setup1.ps1'))
```

It downloads the chocolatey script and executes it.

