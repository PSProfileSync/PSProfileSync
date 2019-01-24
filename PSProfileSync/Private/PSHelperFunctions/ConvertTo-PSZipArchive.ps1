function ConvertTo-PSZipArchive
{
    <#
        .SYNOPSIS
        Converts a Folder to a Zip Archive

        .DESCRIPTION
        Converts a Folder to a Zip Archive.
        If the Zip Archive already exists the Zip File will get updated.

        .PARAMETER SourcePath
        The folder that needs to be Ziped

        .PARAMETER TargetPath
        The path were the Zip - File is stored

        .EXAMPLE
        PS C:\> ConvertTo-PSPZipArchive -SourcePath $SourcePath -TargetPath $TargetPath
        Converts the Sourcepath folder into a Zip Archive. If the archive exists Update the ZipArchive

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $SourcePath,

        [Parameter(Mandatory)]
        [String]
        $TargetPath
    )

    if (-not( Test-Path -Path $TargetPath ) )
    {
        Compress-Archive -Path $SourcePath -DestinationPath $TargetPath -CompressionLevel Optimal
    }
    else
    {
        Update-PSPZipArchive -ZipPath $TargetPath -SourcePath $SourcePath
    }
}