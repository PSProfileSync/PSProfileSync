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
    $UserName = "testuser"
    $PatToken = "00000"
    $GistId = "3467834879589764235897"

    Context "Get-PSPGitHubGistId" {
        It "Returns a gistid" {

            $obj = [PSCustomObject]@{
                AllUserGists    = [PSCustomObject]@{
                    description = "..PSProfileSync"
                }
                GistDescription = "..PSProfileSync"
            }

            Mock -CommandName Get-PSFConfigValue -MockWith {"..PSProfileSync"}
            Mock -CommandName Invoke-PSPGitHubApiGET -MockWith {return $obj}
            Mock -CommandName Search-PSPGitHubGist -MockWith {
                [PSCustomObject]@{
                    id = "3467834879589764235897"
                }
            }

            $result = Get-PSPGitHubGistId -UserName $UserName -PATToken $PatToken
            $result | Should -Be $GistId
        }
    }
}