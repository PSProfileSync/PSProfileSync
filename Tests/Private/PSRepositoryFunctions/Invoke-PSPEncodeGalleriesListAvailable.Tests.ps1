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
    Context "Invoke-PSPEncodeGalleriesListAvailable" {
        It "Encodes all Galleries" {
            Mock -CommandName "Get-PSFConfigValue" -MockWith {
                return "somefile"
            }
            Mock -CommandName "Invoke-PSPEncodeCertUtil" -MockWith { }

            Invoke-PSPEncodeGalleriesListAvailable

            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 2
            Assert-MockCalled -CommandName "Invoke-PSPEncodeCertUtil" -Exactly 1
        }
    }
}