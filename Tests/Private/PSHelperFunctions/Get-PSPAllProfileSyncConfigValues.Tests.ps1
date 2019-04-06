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
    Context "Get-PSPAllProfileSyncConfigValues" {
        It "Function runs" {
            Mock -CommandName Get-PSFConfig -MockWith { }

            Get-PSPAllProfileSyncConfigValues

            Assert-MockCalled -CommandName Get-PSFConfig -Exactly 1
        }
    }
}