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
    $Uri = "http://test.io"
    $Method = "Get"

    Mock -CommandName "Get-PSFConfigValue" -MockWith {"desc"}

    Context "New-PSPGitHubGist" {
        It "New-PSPGitHubGist: Creates a GitHub gist successfully" {
            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}

            $invokePSPGitHubApiGETSplat = @{
                UserName = $UserName
                Method   = $Method
                PATToken = $PatToken
                Uri      = $Uri
            }
            $result = Invoke-PSPGitHubApiGET @invokePSPGitHubApiGETSplat

            $result | Should -Be "Success"

            Mock -CommandName "Write-PSFMessage" -MockWith {}

            $newPSPGitHubGistSplat = @{
                UserName = $UserName
                PATToken = $PatToken
            }
            $result = New-PSPGitHubGist @newPSPGitHubGistSplat
        }

        It "New-PSPGitHubGist: GitHub gist exists already and returns a valid gist id" {
            Mock -CommandName Invoke-RestMethod -MockWith {return @{
                    description = "..PSProfileSync"
                    id          = "00000"
                }
            }

            $invokePSPGitHubApiGETSplat = @{
                UserName = $UserName
                Method   = $Method
                PATToken = $PatToken
                Uri      = $Uri
            }
            $result = Invoke-PSPGitHubApiGET @invokePSPGitHubApiGETSplat
            $result | Should -Be $true

            Mock -CommandName "Write-PSFMessage" -MockWith {}
            Mock -CommandName "Invoke-PSPGitHubApiPOST" -MockWith {return [PSCustomObject]@{
                    id = "00000"
                }
            }

            $newPSPGitHubGistSplat = @{
                UserName = $UserName
                PATToken = $PatToken
            }
            $result = New-PSPGitHubGist @newPSPGitHubGistSplat

            $result | Should -Be "00000"
        }
    }
}