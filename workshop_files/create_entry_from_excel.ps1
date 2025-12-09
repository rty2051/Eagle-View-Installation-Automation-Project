$FilePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\workshop_files\test.txt"
(Get-Content $filePath | Select-Object -Skip 1) |
ForEach-Object {
    # Split line by whitespace
    $parts = $_ -split '\s+', 2

    $Name = $parts[0]
    $Path = $parts[1]

    Write-Host "Name: $name"
    Write-Host "Location: $location"
    Write-Host "----"

    $data = @{
      "Name" = $Name
      "Extension" = [System.IO.Path]::GetExtension($Path)
      "Path" = "$Path"
      "Flags" = @("/s")
    }

    # Convert the object to JSON
    $json = $data | ConvertTo-Json
    $filePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$($data["Name"]).json"
    $json | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "JSON written to $filePath"

}
