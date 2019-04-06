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
    Context "Initialize-PSPProfileSyncSettings" {
        It "All values are initialized" {
            Mock -CommandName "Set-PSFConfig" -MockWith { }
            Mock -CommandName "Get-PSFConfigValue" -MockWith { }

            Initialize-PSPProfileSyncSettings

            Assert-MockCalled -CommandName "Set-PSFConfig" -Exactly 34
            Assert-MockCalled -CommandName "Get-PSFConfigValue" -Exactly 1
        }
    }
}