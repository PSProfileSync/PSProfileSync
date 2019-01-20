function Invoke-PSPEncodeCertUtil
{
    <#
        .SYNOPSIS
        Executes certutil to create an encoded file

        .DESCRIPTION
        Executes certutil to create an encoded file

        .PARAMETER SourePath
        The file that needs to be encoded

        .PARAMETER TargetPath
        The path were the encoded file will be stored

        .EXAMPLE
        PS C:\> Invoke-PSPEncodeCertUtil -SourePath $SourcePath -TargetPath $TargetPath
        Encodes the file that is in $SourcePath and creates a new file with the encoded content in $TargetPath

        .NOTES
        Author: Constantin Hager, Johannes Kuemmel
        Date: 20.01.2019
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $SourePath,

        [Parameter(Mandatory)]
        [string]
        $TargetPath
    )

    Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-encode", $SourePath, $TargetPath
}