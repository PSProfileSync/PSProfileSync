function Import-PSGitAuthFile
{
    # TODO: PSFramework settings entry (PSProfileGitAuthFilePath)
    $PSProfileGitAuthFilePath = "$env:APPDATA\PSProfileSync\GitAuthFile.xml"

    $XmlFile = Import-Clixml -Path $PSProfileGitAuthFilePath

    $returnObject = [PSCustomObject]@{
        UserName = $XmlFile.GitHubCredential.UserName
        PATToken = $XmlFile.GitHubCredential.GetNetworkCredential().Password
        GistId   = $XmlFile.GistId
    }

    return $returnObject
}