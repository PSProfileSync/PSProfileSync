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

    Context "Get-PSPGitHubApiGET" {
        It "Invoke-RestMethod GET Case works as expected in PowerShell 6" {

            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
            Mock -CommandName Get-PSPMajorPSVersion -MockWith {6}

            $invokePSPGitHubApiGETSplat = @{
                UserName = $UserName
                Method   = $Method
                PATToken = $PatToken
                Uri      = $Uri
            }
            $result = Invoke-PSPGitHubApiGET @invokePSPGitHubApiGETSplat

            $result | Should -Be "Success"
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
        }

        It "Invoke-RestMethod GET Case works as expected in PowerShell 5" {

            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
            Mock -CommandName Get-PSPMajorPSVersion -MockWith {5}

            $invokePSPGitHubApiGETSplat = @{
                UserName = $UserName
                Method   = $Method
                PATToken = $PatToken
                Uri      = $Uri
            }
            $result = Invoke-PSPGitHubApiGET @invokePSPGitHubApiGETSplat

            $result | Should -Be "Success"
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 2
        }
    }
}