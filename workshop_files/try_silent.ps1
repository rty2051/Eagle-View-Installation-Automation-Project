# Test different flags for a given install

param (
        [Parameter(Mandatory=$true)]
        [string]$FileName
    )

function Main {
    param (
        [string]$FileName
    )
    $Path = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$FileName.json"
    $data = Get-Content -Path $Path -Raw | ConvertFrom-Json

    Start-Process $data["Path"] -ArgumentList "/s" -Wait
}

Main -FileName $FileName
