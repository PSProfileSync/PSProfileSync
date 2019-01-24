function Remove-PSEmptyFolder
{
    <#
        .SYNOPSIS
        Removes a folder

        .DESCRIPTION
        Removes a folder

        .EXAMPLE
        PS C:\> Remove-PSPEmptyFolder -FolderName $FolderName
        Removes the folder $FolderName

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FolderName
    )

    Remove-Item -Path $FolderName -Force
}