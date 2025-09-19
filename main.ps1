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

    Write-Host "---- Running $Type Installs ----"
    foreach ($name in $HostNames) {
      Write-Host "Connecting to: $name"
    }
}

Main -HostNames $HostNames -Type $Type