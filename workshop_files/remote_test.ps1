$remoteHost = "MATLAB-ROCD25"
# $remoteHost = "MININT-EBFF9T6"
# $cred = Get-Credential

Invoke-Command -ComputerName $remoteHost -ScriptBlock {
    # & "\\magneto2\company_temp\ePlus\Eagle-View-Installation-Automation-Project\workshop_files\try_silent.ps1" -Name "Chrome"
    Test-Path "\\magneto2\company_temp\ePlus\Eagle-View-Installation-Automation-Project\workshop_files\try_silent.ps1"
}


# Invoke-Command -ComputerName $remoteHost -Credential $cred -ScriptBlock {
#     function Test {
#         Write-Host "IT WORKS! :D"
#     }

#     Test
# } -Verbose
