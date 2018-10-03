function Push-PSProfile
{
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $Username,

        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    $obj = [PSProfileSync]::new($Username, $PATToken)

    <# $PathAuthFile = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"

    if (Test-PSForGitAuthFile -PathAuthFile $PathAuthFile)
    {

    }
    else
    {

    } #>

    <# Write-Verbose -Message "Create GitHub Gist and return the Gist Id."

    $GistId = New-PSGitHubGist -UserName $UserName -PATToken $PATToken

    $FileObject = New-PSAuthFileObject -UserName $UserName -PATToken $PATToken -GistId $GistId

    New-PSGitAuthFile -AuthFileObject $FileObject #>
}