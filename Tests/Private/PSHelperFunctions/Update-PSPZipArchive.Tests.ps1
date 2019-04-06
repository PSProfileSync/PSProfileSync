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
    Context "Update-PSPZipArchive" {

        $ZipPath = "TestDrive:\SomeZip.zip"
        $SourcePath = "TestDrive:\SomeFile"

        It "It updates the Archive" {
            Mock -CommandName "Compress-Archive" -MockWith { }

            Update-PSPZipArchive -ZipPath $ZipPath -SourcePath $SourcePath

            Assert-MockCalled -CommandName "Compress-Archive" -Exactly 1
        }
    }
}