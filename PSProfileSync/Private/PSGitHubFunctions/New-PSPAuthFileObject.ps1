function New-PSPAuthFileObject
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

    # Build the credential object
    $PATTokenSecure = ConvertTo-SecureString -String $PATToken -AsPlainText -Force
    $GitHubCredential = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $PATTokenSecure)

    # Create the object for the file
    $FileObject = [PSCustomObject]@{
        GitHubCredential = $GitHubCredential
        GistId           = $GistId
    }
    return $FileObject
}