# Makes the json file for parent categories

param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Files

    )

    function Main {
    param (
        [string]$Name,
        [string[]]$Files
    )
    
    for ($i = 0; $i -lt $Files.Length; $i++) {
        $Files[$i] = "$($Files[$i]).json"
    }

    $data = @{
      "Name" = $Name
      "Installs" = $Files
    }

    # Convert the object to JSON
    $json = $data | ConvertTo-Json
    $filePath = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\Groups\$($data["Name"]).json"
    $json | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "JSON written to $filePath"
}

Main -Name $Name -Files $Files
