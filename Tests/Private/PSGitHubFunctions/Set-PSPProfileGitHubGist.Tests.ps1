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

    Context "Set-PSPProfileGitHubGist" {
        It "Upload is OK" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "EncodedPSGalleryPath"
            }
            Mock -CommandName "Get-PSPGitHubGistId" -MockWith {
                return "123223"
            }
            Mock -CommandName "Edit-PSPGitHubGist" -MockWith { }

            Set-PSPProfileGitHubGist -UserName $UserName -PATToken $PatToken

            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 11
            Assert-MockCalled -CommandName "Get-PSPGitHubGistId" -Exactly 1
        }
    }
}