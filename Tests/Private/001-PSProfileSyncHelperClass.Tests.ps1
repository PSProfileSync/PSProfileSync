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
    Context "ConverttoZipArchive" {
        It "Converts the files to a zip archive" {
            $Sourcepath = "Sourcepath"
            $Targetpath = "Targetpath"
            Mock -CommandName "Compress-Archive" -MockWith {}
            $returnvalue = $PSProfileSyncClass.ConverttoZipArchive($Sourcepath, $Targetpath)
            {$returnvalue} | Should -Not -Throw
            Assert-MockCalled -CommandName "Compress-Archive" -Exactly 1
        }
    }
}