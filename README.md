# basic-soft-install
Basic Software Installation

When executed, the script checks if installed or installs `chocolatey` on the local machine and then installs all applications defined in the `packages` config file.

## Install application list from Github:
In order to run, open a Powershell instance in admin mode (Run as Administrator) and execute:

```console
Set-ExecutionPolicy Bypass -Scope Process -Force
```
After that, run the following:
```console
Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/lde100/basic-soft-install/main/package1.ps1'))
```
It downloads the chocolatey script and executes it.

## Install custom (local) application list:
Download the `basic_install.ps1` file from this repository:
```
https://raw.githubusercontent.com/lde100/basic-soft-install/main/basic_install.ps1
```

Create a `packages.config` file in the same directory, add the chocolatey app names line by line and execute the script in an admin Powershell
```
$ install.ps1 local
```
