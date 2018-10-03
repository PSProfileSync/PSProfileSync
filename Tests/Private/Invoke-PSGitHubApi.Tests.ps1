$ModuleManifestName = 'PSProfileSync.psd1'
$Root = (Get-Item $PSScriptRoot).Parent.Parent.FullName
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
    Describe "Invoke-PSGitHubApi" {

        It "Invoke-RestMethod works as expected" {
            $UserName = "Test"
            $PersonalAccessToken = "88888888888888888888"
            $Method = "Get"
            $Uri = "http://test.io"
            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}
            $result = Invoke-PsGitHubApi -UserName $UserName -PersonalAccessToken $PersonalAccessToken -Method $Method -Uri $Uri
            $result | Should -Be "Success"
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
        }
    }
}

