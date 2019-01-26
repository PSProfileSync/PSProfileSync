function Test-PSForGitAuthFile
{
    [CmdletBinding()]
    param
    (
        # the path to the Git Authfile that should exist
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