function Measure-PSPFolderFileSizes
{
    <#
        .SYNOPSIS
        Calculates all Foldersizes in a folder

        .DESCRIPTION
        Calculates all Foldersizes in a folder.

        The functions measures the size of all subfolders that are in that folder
        and sum them up.

        .PARAMETER FolderPath
        An array of folder path to calculate the size.

        .EXAMPLE
        PS C:\> Measure-PSPFolderFileSizes -FolderPath $FolderPath
        Calculates the sum of $FolderPath

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]
        $FolderPath
    )

    [uint64]$Foldersize = 0
    foreach ($Folder in $FolderPath)
    {
        $Foldersize += ((Get-ChildItem -Path $Folder -Recurse | Measure-Object -Property length -Sum).sum)
    }
    return $Foldersize
}