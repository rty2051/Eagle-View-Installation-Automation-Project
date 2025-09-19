$remoteHost = "MATLAB-ROCD25"
# $cred = Get-Credential

Invoke-Command -ComputerName $remoteHost -ScriptBlock {
    Write-Host "IT WORKS! :D"
} -Verbose
