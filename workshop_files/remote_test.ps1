# $remoteHost = "MATLAB-ROCD25"
$remoteHost = "MININT-I3GVPJ0"
# $cred = Get-Credential

# Invoke-Command -ComputerName $remoteHost -ScriptBlock {
#     # & "\\magneto2\company_temp\ePlus\Eagle-View-Installation-Automation-Project\workshop_files\try_silent.ps1" -Name "Chrome"
#     Test-Path "\\magneto2\company_temp\ePlus\Eagle-View-Installation-Automation-Project\workshop_files\try_silent.ps1"
# }


# Invoke-Command -ComputerName $remoteHost -Credential $cred -ScriptBlock {

$type = "Base"
$jsonFilePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\Groups\$type.json"
$jsonContent = Get-Content -Path $jsonFilePath -Raw
$data = $jsonContent | ConvertFrom-Json

$installs = $data.Installs

Invoke-Command -ComputerName $remoteHost -ScriptBlock {
    function Test {
        # Start-Process -FilePath "C:\Users\admin.ryany\Desktop\ChromeSetup.exe" -ArgumentList "/silent", "/install" -NoNewWindow -Wait
        # $zipPath = "C:\Users\admin.ryany\Desktop\Installs.zip"
        # $destPath = "C:\Users\admin.ryany\Desktop\"
        # Expand-Archive -Path $zipPath -DestinationPath $destPath -Force
        # Start-Process -FilePath "C:\Users\admin.ryany\Desktop\ImagingInstalls\ChromeSetup.exe" -ArgumentList "/silent", "/install" -NoNewWindow -Wait
        foreach($i in $using:installs){
            Write-Host $i
        }

        Write-Host "IT WORKS! :D"
    }

    Test
} -Verbose
