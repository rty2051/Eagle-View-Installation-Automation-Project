# main.ps1

param (
        [Parameter(Mandatory=$true)]
        [string[]]$HostNames,

        [Parameter(Mandatory=$true)]
        [string]$Type
    )

function Main {
    param (
        [string[]]$HostNames,
        [string]$Type
    )

    # Load Group File
    $Path = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\Groups\$Type.json"
    $InstallNames = (Get-Content -Path $Path -Raw | ConvertFrom-Json).Installs
    $InstallData = @{}
    foreach ($name in $InstallNames) {
        $Path = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$name"
        $InstallData[$name] = Get-Content -Path $Path -Raw | ConvertFrom-Json
    }

    Write-Host "---- Running $Type Installs ----"
    foreach ($name in $HostNames) {
      Write-Host "Connecting to: $name"
      foreach ($name in $InstallNames){
        $targetInstall = $InstallData[$name]
        $Flag = $targetInstall.Flags -join " "
        switch ($targetInstall.Extension) {
            ".exe" {
                Start-Process $targetInstall.Path -ArgumentList $Flag -NoNewWindow -Wait
            }
            ".msi" {
                Start-Process msiexec.exe -ArgumentList $Flag -Verb RunAs -Wait
            }
        }
      }
    }
}

Main -HostNames $HostNames -Type $Type