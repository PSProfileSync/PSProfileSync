$ModuleManifestName = 'PSProfileSync.psd1'
$Root = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
$ModuleManifestPath = Join-Path $Root -ChildPath "PSProfileSync\$ModuleManifestName"

if (Get-Module PSProfileSync)
{
    Remove-Module PSProfileSync
    Import-Module $ModuleManifestPath
}
else
{
    Import-Module $ModuleManifestPath
}

InModuleScope PSProfileSync {
    Context "Search-PSPGitHubGist" {

        $GistExist = [System.Object]@{
            Description = "..PSProfileSync"
        }

        $GistDescription = "..PSProfileSync"

        It "Git Gist exists" {
            $return = Search-PSPGitHubGist -AllUserGists $GistExist -GistDescription $GistDescription
            $return | Should -BeOfType System.Object
        }

        It "Git Gist does not exist" {
            $return = Search-PSPGitHubGist -AllUserGists $GistExist -GistDescription "test"
            $return | Should -BeNullOrEmpty
        }
    }
}