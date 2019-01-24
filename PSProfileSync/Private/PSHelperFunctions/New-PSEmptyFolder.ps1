function New-PSEmptyFolder
{
    <#
        .SYNOPSIS
        Creates an empty Folder.

        .DESCRIPTION
        Creates an empty Folder if the folder does not exist

        .PARAMETER Path
        The path were the folder will be created.

        .PARAMETER FolderName
        The name of the folder that will be created if the folder not already exists

        .EXAMPLE
        PS C:\> New-PSPEmptyFolder -Path $Path -FolderName $FolderName
        Creates a Folder in $Path with the name $FolderName if the folder does not exist.

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [string]
        $FolderName
    )

    $FullPath = Join-Path -Path $Path -ChildPath $FolderName

    if ( -not (Test-Path -Path $FullPath) )
    {
        New-Item -ItemType Directory -Path $Path -Name $FolderName
    }
}