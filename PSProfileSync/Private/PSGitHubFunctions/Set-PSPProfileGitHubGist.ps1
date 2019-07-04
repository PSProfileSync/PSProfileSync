function Set-PSPProfileGitHubGist
{
    param
    (
        # the GitHubUserName
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    # Get all Config Values
    $EncodedPSGalleryPath = Get-PSFConfigValue -FullName "PSProfileSync.repository.encodedpsgallerypath"
    $PSPProfileSyncModulesFolderSizePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.profilesyncmodulesfoldersizepath"
    $EncodedPSModulePath = Get-PSFConfigValue -FullName "PSProfileSync.modules.encodedpsmodulepath"
    $EncodedPSModuleArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.modules.encodedpsmodulearchivefolderpathzip"
    $PSPProfileSyncProfileFolderSizePath = Get-PSFConfigValue -FullName "PSProfileSync.profile.profilesyncprofilefoldersizepath"
    $EncodedPSProfilePathWPS = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathwps"
    $EncodedPSProfilePathPSCore = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathpscore"
    $EncodedPSProfilePathDevEnv = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedprofilepathdevenv"
    $EncodedPSProfileWPSArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofilewpsarchivefolderpathzip"
    $EncodedPSProfilePSCoreArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofilepscorearchivefolderpathzip"
    $EncodedPSProfileDevEnvArchiveFolderPathZip = Get-PSFConfigValue -FullName "PSProfileSync.profile.encodedpsprofiledevenvarchivefolderpathzip"

    # Get the GitHub Gist
    $GistId = Get-PSPGitHubGistId -UserName $UserName -PATToken $PATToken

    # Add all the needed Files to the GitHub Gist
    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $PSPProfileSyncProfileFolderSizePath
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $PSPProfileSyncModulesFolderSizePath
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSGalleryPath
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSModulePath
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSModuleArchiveFolderPathZip
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfilePathWPS
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfilePathPSCore
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfilePathDevEnv
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfileWPSArchiveFolderPathZip
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfilePSCoreArchiveFolderPathZip
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat

    $editPSPGitHubGistSplat = @{
        UserName = $UserName
        GistId   = $GistId
        PATToken = $PATToken
        FilePath = $EncodedPSProfileDevEnvArchiveFolderPathZip
    }
    Edit-PSPGitHubGist @editPSPGitHubGistSplat
}