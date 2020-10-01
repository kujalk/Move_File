<#
Purpose - 
 - To Move files from folder A to B
 - If file already there in destination, it will be renamed to <file name>-<date>.extension
 - If file is not already there, it will be moved with same name
 - In destination folder, it will create sub directories as it is in Source folder

Examples
    Move-File -source "C:\FolderA" -destination "C:\FolderB" -extension ".txt"

Date - 9/9/2020
Developer - K.Janarthanan
Version - 2
#>

[CmdletBinding()]
param(
        [Parameter(Mandatory=$true)]
        [string]$source,

        [Parameter(Mandatory=$true)]
        [string]$destination,

        [Parameter(Mandatory=$true)]
        [string]$extension
    )

try    
{
    (Get-ChildItem -Path $source -Recurse -File | where-object {$_.extension -eq $extension }).FullName | ForEach-Object{

        if($_ -eq $null)
        {
            Write-Host "No any matching files found"
            exit
        }
        
        $file_name=$_.split("\")[-1]
        $folder_structure=$_.replace($source,"").replace($file_name,"")

        $dest_folder=$destination+$folder_structure
        $dest_file=$dest_folder+$file_name

        if(Test-Path -Path $dest_folder)
        {
            if(Test-Path -Path $dest_file -PathType Leaf)
            {
                Write-Host "$dest_file File is already present in destination"
                $date_name=(Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
                $name=$file_name.split(".")[0]
                Move-Item -Path $_ -Destination "$dest_folder\$name-$date_name$extension" -EA Stop
                Write-Host "$dest_file File is moved to destination as $dest_folder\$name-$date_name$extension"
            }
            else
            {
                Move-Item -Path $_ -Destination $dest_file -EA Stop
                Write-Host "$dest_file File is not already present in destination, therefore moved it"
            }
        }
        else 
        {
            Write-Host "Destination Folder $dest_folder is not present. Therefore will create it"
            New-Item -Path $dest_folder -Type Directory -EA Stop
            Move-Item -Path $_ -Destination $dest_file -EA Stop
            Write-Host "$dest_file File is not already present in destination, therefore moved it"
        }
    }
}

catch
{
    Write-Host "Error occured : $_"
}
