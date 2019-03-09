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
    Describe "PSProfileSyncClassTests" {

        $UserName = "testuser"
        $PatToken = "00000"
        $GistId = "3467834879589764235897"
        $Uri = "http://test.io"
        $PSProfileSyncClass = [PSProfileSync]::new($UserName, $PatToken)

        Context "GetPSRepository" {
            It "Gets an object back" {
                $obj = New-MockObject -Type System.Object
                Mock -CommandName "Get-PSRepository" -MockWith {
                    return $obj
                }

                $returnvalue = $PSProfileSyncClass.GetPSRepository()
                $returnvalue | Should -BeOfType System.Object
                Assert-MockCalled -CommandName "Get-PSRepository" -Exactly 1
            }
        }

        Context "SavePSRepositoriesToFile" {

            Mock -CommandName "ConvertTo-Json" -MockWith {}
            Mock -CommandName "Out-File" -MockWith {}

            It "Method returns no errors" {
                $returnvalue = $PSProfileSyncClass.SavePSRepositoriesToFile()
                { $returnvalue } | Should -Not -Throw
                if ($returnvalue)
                {
                    Assert-MockCalled -CommandName ConvertTo-Json -Exactly 1
                }
            }
        }

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

        Context "ExecuteEncodeCertUtil" {
            It "Encodes a file to a certificate" {
                $Sourcepath = "Sourcepath"
                $Targetpath = "Targetpath"
                Mock -CommandName "Start-Process" -MockWith {}
                $returnvalue = $PSProfileSyncClass.ExecuteEncodeCertUtil($Sourcepath, $Targetpath)
                {$returnvalue} | Should -Not -Throw
                Assert-MockCalled -CommandName "Start-Process" -Exactly 1
            }
        }

        Context "ExecuteDecodeCertUtil" {
            It "Decodes a file back to the original" {
                $Sourcepath = "Sourcepath"
                $Targetpath = "Targetpath"
                Mock -CommandName "Start-Process" -MockWith {}
                $returnvalue = $PSProfileSyncClass.ExecuteDecodeCertUtil($Sourcepath, $Targetpath)
                {$returnvalue} | Should -Not -Throw
                Assert-MockCalled -CommandName "Start-Process" -Exactly 1
            }
        }
    }
}