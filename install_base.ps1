function InstallApps {
    param (
        [string]$Type
    )

    # Load Group File
    $Path = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\Groups\$Type.json"
    $InstallNames = (Get-Content -Path $Path -Raw | ConvertFrom-Json).Installs
    $InstallData = @{}
    foreach ($name in $InstallNames) {
        $Path = "C:\Users\admin.ryany\Desktop\Eagle-View-Installation-Automation-Project\json_files\$name"
        $InstallData[$name] = Get-Content -Path $Path -Raw | ConvertFrom-Json
    }

    Write-Host "---- Running $Type Installs ----"
    foreach ($name in $InstallNames){
        $targetInstall = $InstallData[$name]
        $Flag = $targetInstall.Flags -join " "
        switch ($targetInstall.Extension) {
            ".exe" {
                Start-Process $targetInstall.Path -ArgumentList $Flag -NoNewWindow -Wait
            }
            ".msi" {
                Start-Process msiexec.exe -ArgumentList $Flag -Verb RunAs -Wait
            }
        }
    }
}

function InstallWinUps {
    $Session = News-Object -ComObject Microsoft.Update.Session
    $Searcher = $Session.CreateUpdateSearcher()
    
    Write-Host "Searching for updates..."
    $SearchResult = $Searcher.Search("IsInstalled=0")
    
    $Updates = New-Object -ComObject Microsoft.Update.UpdateColl
    
    foreach ($Update in $SearchResult.Updates) {
        $Updates.Add($Update) | Out-Null
    }
    
    $Installer = $Session.CreateUpdateInstaller()
    $Installer.Updates = $Updates
    
    Write-Host "Installing updates..."
    $Installer.Install()
}

Write-Host "==== Installing Base Apps ===="
InstallApps "Base"
# Write-Host "==== Starting Windows Updates ===="
# InstallWinUps