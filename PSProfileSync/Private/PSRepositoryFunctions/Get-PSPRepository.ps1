function Get-PSPRepository
{
    [CmdletBinding()]
    param
    (
        # all the excluded repositories
        [Parameter(Mandatory)]
        [string[]]
        $ExcludedRepositories
    )

    $repositories = Get-PSRepository | Where-Object {$_.Name -ne $ExcludedRepositories}
    return $repositories
}