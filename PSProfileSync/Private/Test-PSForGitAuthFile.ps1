function Test-PSForGitAuthFile
{
    <#
    .SYNOPSIS
        Test if the Git Hub Authfile exists
    .DESCRIPTION
        Test if the Git Hub Authfile exists.
        If it does we return $true.
        If not we return $false

    .PARAMETER PathAuthFile

    .EXAMPLE
        PS C:\> Test-PSForGitAuthFile -PathAuthFile C:\Temp\GitAuthFile.xml
        Test if the GitAuthFile C:\Temp\GitAuthFile.xml exists

    .OUTPUTS
        System.Boolean
    .NOTES
        Author: Constantin Hager, Johannes Kümmel
        Date: 29.09.2018
    #>

    [CmdletBinding()]
    param
    (
        # The path of the Authfile that we need to test
        [Parameter(Mandatory)]
        [string]
        $PathAuthFile
    )

    if (Test-Path -Path $PathAuthFile)
    {
        return $true
    }
    else
    {
        return $false
    }
}