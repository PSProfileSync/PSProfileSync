function New-PSGitAuthFile
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
    $PSProfileGitAuthFilePath = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"
    $PSProfileSyncPath = "$env:APPDATA\PSProfileSync"

    If (-not(Test-Path -Path $PSProfileGitAuthFilePath))
    {
        New-Item -ItemType Directory -Force -Path $PSProfileSyncPath
    }

    $AuthFileObject = New-PSAuthFileObject -GistId $GistId -PATToken $PATToken -UserName $UserName
    $AuthFileObject | Export-Clixml -Path $PSProfileGitAuthFilePath -Force
}