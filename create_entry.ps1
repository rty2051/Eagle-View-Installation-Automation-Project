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
      Name = "$(Split-Path -Path $Path -Leaf)"
      Path = "$Path"
      Flags = @()
    }

    # Convert the object to JSON
    $json = $data | ConvertTo-Json

    # Define file path
    $filePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\test.json"

    # Write JSON to file (overwrite if exists)
    $json | Out-File -FilePath $filePath -Encoding UTF8

    Write-Host "JSON written to $filePath"
}

Main -Path $Path
