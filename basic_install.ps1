
# basic_install 

#Requires -RunAsAdministrator
$run_local=$args[0]

# install chocolatey if not installed
if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
  choco feature enable -n=allowGlobalConfirmation
  
}

if ($run_local -eq "local") {
# for each package in the list run install
  Get-Content ".\basic_packages.config" | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object{choco install -y $_}
}
else
{
# for each package in the list run install
  (Invoke-webrequest -URI "https://raw.githubusercontent.com/lde100/basic-soft-install/main/basic_packages.config").Content | ForEach-Object{($_ -split "\r\n")[0]} | ForEach-Object {choco install $_ }
}
