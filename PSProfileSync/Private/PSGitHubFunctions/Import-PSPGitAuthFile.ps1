function Import-PSPGitAuthFile
{
    # TODO: PSFramework settings entry (PSProfileGitAuthFilePath)
    $PSProfileGitAuthFilePath = Get-PSFConfigValue -FullName "PSProfileSync.git.profilegitauthfilepath"

    $XmlFile = Import-Clixml -Path $PSProfileGitAuthFilePath

    $returnObject = [PSCustomObject]@{
        UserName = $XmlFile.GitHubCredential.UserName
        PATToken = $XmlFile.GitHubCredential.GetNetworkCredential().Password
        GistId   = $XmlFile.GistId
    }

    return $returnObject
}