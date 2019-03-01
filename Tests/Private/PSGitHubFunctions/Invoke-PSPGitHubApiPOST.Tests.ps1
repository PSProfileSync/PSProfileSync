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

    Context "Invoke-PSPGitHubApiPOST" {
        It "Invoke-RestMethod POST/PATCH Case works as expected" {
            $Method = "POST"
            $body = @{Test = "Test"}
            $ApiBody = ConvertTo-Json -InputObject $body -Compress
            Mock -CommandName Invoke-RestMethod -MockWith {"Success"}

            $invokePSPGitHubApiPOSTSplat = @{
                UserName = $UserName
                PATToken = $PatToken
                Method   = $Method
                ApiBody  = $ApiBody
                Uri      = $Uri
            }
            $result = Invoke-PSPGitHubApiPOST @invokePSPGitHubApiPOSTSplat

            $result | Should -Be "Success"
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1
        }
    }
}