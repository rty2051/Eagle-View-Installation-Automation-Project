# $PRESET_PATH = "C:\Users\admin.ryany\Desktop\Imaging Automation\presets.json"
$PRESET_PATH = "C:\Users\admin.ryany\Desktop\Imaging Automation\empty_preset.json"
# $FILE_PATH = "C:\Users\admin.ryany\Desktop\Imaging Automation\tester.json"
# $FILE_PATH = "C:\Users\admin.ryany\Desktop\Imaging Automation\example.json"
$FILE_PATH = "C:\Users\admin.ryany\Desktop\Imaging Automation\empty_data.json"
$NUM_SPACES = 45
$hashtable = @{}
$pretable = @{}

function main {
    param (
        $extension = "-m", 
        $params
    )
        
    Write-Host "====== Starting script ======" -ForegroundColor Green
    foreach($val in $params){
        Write-Host "Args: $($val)"
        if(("" -eq ($val.Trim() -replace " ", ""))){
            Write-Host "ERROR: Parameters must not be blank strings. Try again."
            exit 1
        }
    }


    # Load individual and preset data
    # $data_path = "\\magneto2\company_temp\ePlus\Imaging Automation\data.json"
    $data_path = $($FILE_PATH)
    $json = Get-Content -Path "$data_path" -Raw | ConvertFrom-Json
    foreach ($object in $json.PSObject.Properties) {
        $hashtable["$($object.Name)"] = $object.Value
    }
    $data_path = $($PRESET_PATH)
    $json = Get-Content -Path "$data_path" -Raw | ConvertFrom-Json
    foreach ($object in $json.PSObject.Properties) {
        $pretable["$($object.Name)"] = $object.Value
    }

    switch ($extension) {
        "-m" {
            # Menu Option
        }        
        "-i" {
            # Fast Install [needs prefix]
            if($params.Length -ne 2+1){
                usage_err "i"
                exit 1   
            }
            install $params[0]
        }        
        "-l" {
            # View list
            list_registered
        }        
        "-a" {
            # Add [name] [path] [type]
            if($params.Length -ne 3){
                usage_err "a"
                exit 1   
            }
            add $params[0] $params[1] $params[2]
        }       
        "-r" {
            # Remove [name]
            if($params.Length -ne 1){
                usage_err "r"
                exit 1   
            }
            remove $params[0]
        }        
        "-u" {
            # Update [name] [attribute] [new value]
            if($params.Length -ne 3){
                usage_err "u"
                exit 1   
            }
            update $params[0] $params[1] $params[2]
        }        
        
    }


    Write-Host "------ Installation Done ------" -ForegroundColor Green    

    # Save hash to file
    $json = $hashtable | ConvertTo-Json
    $destination = "C:\Users\admin.ryany\Desktop\Imaging Automation"
    # $json | Set-Content -Path "$destination\tester.json"
    $json | Set-Content -Path $FILE_PATH
    $json = $pretable | ConvertTo-Json
    # $destination = "C:\Users\admin.ryany\Desktop\Imaging Automation"
    $json | Set-Content -Path $PRESET_PATH
}

function usage_err{
    param(
        $type
    )
    switch ($type) {
        "a" {
            Write-Host "Usage: -a <name> <path> <category>"
            $spaces=20- $("   <name>").Length
            "{0}{1,$spaces}" -f "   <name>", ""+"Name of program"
            $spaces=20- $("   <path>").Length
            "{0}{1,$spaces}" -f "   <path>", ""+"File path"
            $spaces=20- $("   <category>").Length
            "{0}{1,$spaces}" -f "   <category>", ""+"Name of preset group"
        }
        "i"{
            Write-Host "Usage: -i <category>"
            $spaces=20- $("   <category>").Length
            "{0}{1,$spaces}" -f "   <category>", ""+"Name of preset group"
        }
        "r" {
            Write-Host "Usage: -r <name>"
            $spaces=20- $("   <name>").Length
            "{0}{1,$spaces}" -f "   <name>", ""+"Name of program"
        }
        "u"{
            Write-Host "Usage: -u <name> <attribute> <new value>"
            $spaces=20- $("   <name>").Length
            "{0}{1,$spaces}" -f "   <name>", ""+"Name of program"
            $spaces=20- $("   <attribute>").Length
            "{0}{1,$spaces}" -f "   <attribute>", ""+"Field to be modified: [Extension, Category, Path]"
            $spaces=20- $("   <new value>").Length
            "{0}{1,$spaces}" -f "   <new value>", ""+"Values to be updated with"
            $spaces=20- $(" ").Length
            "{0}{1,$spaces}" -f " ", ""+"For Category Values use: +/-<New Value>,..."
        }
        
    }
}

function add{
    param (
        [Parameter(Position=0,Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        $name,
        [Parameter(Position=1)]
        [ValidateNotNullorEmpty()]
        $path,
        [Parameter(Position=2)]
        [ValidateNotNullorEmpty()]
        $category
    )

    # Check if empty string after trimming
    $check1 = ($null -eq ($name.Trim() -replace " ", ""))
    $check2 = ($null -eq ($path.Trim() -replace " ", ""))
    $check3 = ($null -eq ($category.Trim() -replace " ", ""))
    $empty_str = $check1 -or $check2 -or $check3

    # Display help message
    if($empty_str){
        Write-Host "Usage: -a <name> <path> <category>"
        $spaces=20- $("   <name>").Length
        "{0}{1,$spaces}" -f "   <name>", ""+"Name of program"
        $spaces=20- $("   <path>").Length
        "{0}{1,$spaces}" -f "   <path>", ""+"File path"
        $spaces=20- $("   <category>").Length
        "{0}{1,$spaces}" -f "   <category>", ""+"Name of preset group"
                
        exit 1
    }

    # Check file path
    if(!(Test-Path -Path $($path))){
        Write-Host "    Invalid file path detected. Please try again"
        exit 1
    }

    # Check if item already exists
    $new = Get-ChildItem -Path $($path)    
    foreach($key in $hashtable.keys){
        if("$($key)" -like "$($name)*"){
            Write-Host "    Program already exists updating preset and file path"
            $hashtable[$($key)].Category += $($category)
            $hashtable[$($key)].Path = $($new.PSPath)
            
            return
        }
    }
    $hashtable["$($name)"] = @{
        "Extension"= "$($new.Extension)"
        "Category"= @("$($category)")
        "Path"= "$($new.PSPath)"
    }
    if ("$($category)" -in $pretable.keys){
        $pretable["$($category)"] += "$($name)"
    } 
    else{
        $pretable["$($category)"] = @("$($name)")
    }
}
function update{
    param (
        [Parameter(Position=0,Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        $name,
        [Parameter(Position=1)]
        [ValidateNotNullorEmpty()]
        $attribute,
        [Parameter(Position=2)]
        [ValidateNotNullorEmpty()]
        $new_val
    )

    if(!($name -in $hashtable.keys)){
        usage_err "u"
        return
    }
    try {
        $temp = $hashtable["$($name)"].$($attribute)
    }
    catch {
        Write-Host "Invalid attribute <$($attribute)> detected please try again."
    }
    if("Category" -eq $attribute){
        $vals = $new_val -split ","
        $remove = @()
        $new = @()
        foreach($v in $vals){
            $op = $v[0]
            $v = "$($v.Substring(1))"
            switch ($op) {
                "+" {
                    if(!($v -in $hashtable["$($name)"].Category)){
                        # $hashtable["$($name)"].Category += $v
                        $new += $v
                    }
                    else{
                        Write-Host "$($name) already has $($v) under $($attribute)"
                    }
                }
                "-" {
                    if(($v -in $hashtable["$($name)"].Category)){
                        # $hashtable["$($name)"].Category += $v
                        $remove += $v
                    }
                    else{
                        Write-Host "$($name) does not have $($v) under $($attribute)"
                    }
                }
                default {
                    Write-Host "Missing +/- Operators"
                    usage_err "u"
                    return
                }
            }
            
        }
        if($remove.Length -gt 0){
            foreach($var in $remove){
                $hashtable["$($name)"].Category = $hashtable["$($name)"].Category  -ne $var
                $pretable["$($var)"] = $pretable["$($var)"] -ne $name
            }
        }
        if($new.Length -gt 0){
            foreach($var in $new){
                $hashtable["$($name)"].Category += "$($var)"
                if(!($var -in $pretable.keys)){
                    $pretable["$($var)"] = @("$($name)")
                }
                else{
                    $pretable["$($var)"] += $name
                }

                # if(!($name -in $pretable["$($var)"] )){
                #     $pretable["$($var)"] += $name
                # }
            }
        }
    }
    else{
        $hashtable["$($name)"].$($attribute) = $new_val
    }
}

function install{
    param(
        $category
    )
    $installs = $pretable["$($category)"]
    foreach($install in $installs){
        $file = $hashtable["$($install)"]
        Write-Host "Installing: $install"
        switch ($file.Extension) {
            ".exe" {
                if(@("hp-hpia-5.3.2.exe", "global-mapper-26_1-x64.exe") -contains $file.Name){
                    Start-Process $file.Path -ArgumentList "/s" -Wait
                }
                elseif ($file.Name -eq "Reader_en_install.exe") {
                    Start-Process $file.Path -ArgumentList "/quiet" -Wait
                }
                else{
                    Start-Process $file.Path -ArgumentList "/silent" -Wait
                }
            }
            ".msi" {
                if(@("BuildModeApp.lnk") -contains $file.Name){
                    Start-Process msiexec.exe -ArgumentList "/I `"$($file.Path)`" /qn /L*V temp.txt" -Wait -Verb RunAs
                }        
            }
            default {
                Start-Process $file.Path -ArgumentList "/silent" -Wait   
            }
        }
    }

}

function remove{
    param (
        [Parameter(Position=0,Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        $name
    ) 
    if($name -in $hashtable.keys){
        $search = $hashtable["$($name)"].Category
        foreach($cat in $search){
            $pretable["$($cat)"] = $pretable["$($cat)"] -ne $name
        }
        $hashtable.Remove("$($name)")   
    }
    else{
        Write-Host "Invalid name detected. Please try again"
    }
}

function list_registered{
    foreach($key in $hashtable.keys){
        $spaces= $NUM_SPACES- $($key).Length
        $temp = $($hashtable["$($key)"].Path) -replace [Regex]::Escape("Microsoft.PowerShell.Core\FileSystem::"),""        
        "{0}{1,$spaces}" -f $($key), " --   "+$($temp)
    }    
}

main $args[0] $args[1..($args.Length - 1)]