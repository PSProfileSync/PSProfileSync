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

    Context "Initialize-PSPAuthentication" {
        It "There is a Git Auth File" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith { return "C:\Temp" }
            Mock -CommandName "Test-PSPForGitAuthFile" -MockWith { return $true }
            Mock -CommandName "Import-PSPGitAuthFile" -MockWith { }

            Initialize-PSPAuthentication -UserName $UserName -PATToken $PatToken

            Assert-MockCalled -CommandName "Test-PSPForGitAuthFile" -Exactly 1
            Assert-MockCalled -CommandName "Import-PSPGitAuthFile" -Exactly 1
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 1
        }

        It "There is no Git Auth File and Gist ID is null" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith { return "AnyGistDescription" }
            Mock -CommandName "Test-PSPForGitAuthFile" -MockWith { return $false }
            Mock -CommandName "Invoke-PSPGitHubApiGET" -MockWith {
                return [PSCustomObject]@{
                    Description = "Anything"
                }
            }
            Mock -CommandName "Search-PSPGitHubGist" -MockWith { return $null }
            Mock -CommandName "New-PSPGitHubGist" -MockWith { return "this is a gist id" }
            Mock -CommandName "New-PSPGitAuthFile" -MockWith { }

            Initialize-PSPAuthentication -UserName $UserName -PATToken $PatToken

            Assert-MockCalled -CommandName "Test-PSPForGitAuthFile" -Exactly 2
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 3
            Assert-MockCalled -CommandName "Invoke-PSPGitHubApiGET" -Exactly 1
            Assert-MockCalled -CommandName "Search-PSPGitHubGist" -Exactly 1
            Assert-MockCalled -CommandName "New-PSPGitHubGist" -Exactly 1
            Assert-MockCalled -CommandName "New-PSPGitAuthFile" -Exactly 1
        }

        It "There is no Git Auth File and Gist ID is not null" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith { return "AnyGistDescription" }
            Mock -CommandName "Test-PSPForGitAuthFile" -MockWith { return $false }
            Mock -CommandName "Invoke-PSPGitHubApiGET" -MockWith {
                return [PSCustomObject]@{
                    Description = "Anything"
                }
            }
            Mock -CommandName "Search-PSPGitHubGist" -MockWith { return "this is a gist id" }
            Mock -CommandName "New-PSPGitAuthFile" -MockWith { }

            Initialize-PSPAuthentication -UserName $UserName -PATToken $PatToken

            Assert-MockCalled -CommandName "Test-PSPForGitAuthFile" -Exactly 3
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 5
            Assert-MockCalled -CommandName "Invoke-PSPGitHubApiGET" -Exactly 2
            Assert-MockCalled -CommandName "Search-PSPGitHubGist" -Exactly 2
            Assert-MockCalled -CommandName "New-PSPGitAuthFile" -Exactly 2
        }
    }
}