# Makes the json file for the application

param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

function Main {
    param (
        [string]$Path
    )

    $data = @{
      # Name = "$(Split-Path -Path $Path -Leaf)"
      Name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
      Path = "$Path"
      Flags = @()
    }

    # Convert the object to JSON
    $json = $data | ConvertTo-Json
    $filePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$($data["Name"]).json"
    $json | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "JSON written to $filePath"
}

Main -Path $Path
