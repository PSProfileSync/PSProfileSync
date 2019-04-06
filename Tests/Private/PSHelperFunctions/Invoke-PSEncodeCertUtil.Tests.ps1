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
    Context "Invoke-PSPEncodeCertUtil" {
        It "Encodes a file to a certificate" {
            $Sourcepath = "Sourcepath"
            $Targetpath = "Targetpath"
            Mock -CommandName "Start-Process" -MockWith {}
            $returnvalue = Invoke-PSPEncodeCertUtil -SourcePath $Sourcepath -TargetPath $Targetpath
            {$returnvalue} | Should -Not -Throw
            Assert-MockCalled -CommandName "Start-Process" -Exactly 1
        }
    }
}