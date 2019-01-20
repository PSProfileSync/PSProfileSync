function Invoke-PSPDecodeCertUtil
{
    <#
        .SYNOPSIS
        Decodes a file that was before encodes with certutil

        .DESCRIPTION
        Decodes a file that was before encodes with certutil

        .PARAMETER SourcePath
        The file that needs to be decoded

        .PARAMETER TargetPath
        The path were the decoded file will be stored

        .EXAMPLE
        PS C:\> Invoke-PSPDecodeCertUtil -SourePath $SourcePath -TargetPath $TargetPath
        Encodes the file in $SourcePath and stores the encrypted content in a new file $TargetPath

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
        [string]
        $TargetPath
    )

    Start-Process -FilePath "$env:windir\System32\certutil.exe" -ArgumentList "-decode", $SourcePath, $TargetPath -Wait
}