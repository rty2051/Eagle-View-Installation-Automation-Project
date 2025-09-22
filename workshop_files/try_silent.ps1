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
    $flag = @()

    ### EXE INSTALL
    # Copy-Item $data.Path -Destination "\\magneto2\company_temp\ePlus\Imaging Automation\Installations\TEMP_Reader_en_install.exe"
    # Start-Process "\\magneto2\company_temp\ePlus\Imaging Automation\Installations\TEMP_Reader_en_install.exe" -ArgumentList "/sAll", "/rs", "/rps", "/msi", "EULA_ACCEPT=YES" -NoNewWindow -Wait
    Start-Process $data.Path -ArgumentList "/sAll", "/msi" -NoNewWindow -Wait
    $flag += "/sAll"
    $flag += "/msi"

    ### MSI INSTALL
    # Start-Process msiexec.exe -ArgumentList "/i `"$($data.Path)`" /q /l*V debug.txt" -Verb RunAs -Wait
    # $flag += "/i `"$($data.Path)`" /q /l*V debug.txt"

    # $flag = Read-Host "Enter working flag"
    foreach($f in $flag){
        $data.Flags += $f
    }

    # Convert the object to JSON
    $json = $data | ConvertTo-Json
    $filePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$($data.Name).json"
    $json | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "JSON written to $filePath"

}

Main -FileName $FileName
