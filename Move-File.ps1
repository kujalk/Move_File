<#
Purpose - 
 - Move files from folder A to B
 - If files already there, will rename to <file name>-<date>.txt

Date - 9/9/2020
Developer - K.Janarthanan
Version - 1
#>

$source_folder="E:\sample1"
$destination_folder="E:\sample2"

$source=Get-ChildItem -Path $source_folder -Recurse  | Where-Object {$_.Extension -eq '.txt'} | select Name -ExpandProperty Name
$dest=Get-ChildItem -Path $destination_folder -Recurse | Where-Object {$_.Extension -eq '.txt'} | select Name -ExpandProperty Name

$date_name= (Get-date).tostring("yyyy-MM-dd_HH-mm-ss") 

$source | ?{$dest -contains $_} | ForEach-Object {
    $name=$_.split(".")[0]
    $ext=$_.split(".")[1]
    Write-Host "Already $_ file found in destination. Will be moved with new name $name-$date_name.$ext"
    Move-Item -Path "$source_folder\$_" -Destination "$destination_folder\$name-$date_name.$ext"
}

$source | ?{$dest -notcontains $_} | ForEach-Object {
    Write-Host "Moving $_ file to destination folder"
    Move-Item -Path "$source_folder\$_" -Destination "$destination_folder\$_"
}

