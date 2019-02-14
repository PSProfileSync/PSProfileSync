function New-PSPGitAuthFile
{
    [CmdletBinding()]
    param
    (
        # the id of the gist of the user
        [Parameter(Mandatory)]
        [string]
        $GistId,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken,

        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName

    )

    # TODO: PSFramework settings entry (PSProfileGitAuthFilePath, PSProfileSyncPath)
    $PSProfileGitAuthFilePath = Get-PSFConfigValue -FullName "PSProfileSync.git.profilegitauthfilepath"
    $PSProfileSyncPath = Get-PSFConfigValue -FullName "PSProfileSync.modules.psprofilesyncpath"

    If (-not(Test-Path -Path $PSProfileGitAuthFilePath))
    {
        New-Item -ItemType Directory -Force -Path $PSProfileSyncPath
    }

    $AuthFileObject = New-PSPAuthFileObject -GistId $GistId -PATToken $PATToken -UserName $UserName
    $AuthFileObject | Export-Clixml -Path $PSProfileGitAuthFilePath -Force
}