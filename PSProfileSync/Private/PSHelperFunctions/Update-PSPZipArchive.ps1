function Update-PSPZipArchive
{
    <#
        .SYNOPSIS
        Updates an existing ZIP Archive

        .DESCRIPTION
        Updates an existing ZIP Archive

        .PARAMETER ZipPath
        The Path to the Zip - File

        .PARAMETER SourePath
        The Folder that you want to add to the Zip -File

        .EXAMPLE
        PS C:\> Update-PSPZipArchive -ZipPath $ZipPath -SourcePath $SourcePath
        Updates a zip archive that is in $ZipPath with the folder $SourcePath

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $ZipPath,

        [Parameter(Mandatory)]
        [string]
        $SourePath
    )

    Compress-Archive -Path $SourePath -Update -DestinationPath $ZipPath
}