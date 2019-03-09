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
    Context "Import-PSPGitAuthFile" {

        $UserName = "testuser"
        $PatToken = "00000"
        $GistId = "3467834879589764235897"

        $testcred = New-MockObject -Type 'System.Management.Automation.PSCredential'
        $AddMemberParams = @{
            MemberType = 'ScriptMethod'
            Name       = 'GetNetworkCredential'
            Value      = {
                @{
                    'Password' = $PatToken
                }
            }
            Force      = $true
        }

        $testcred | Add-Member @AddMemberParams
        $testcred | Add-Member -MemberType NoteProperty -Name 'UserName' -Value $UserName -Force

        $obj = [PSCustomObject]@{
            GistId           = $GistId
            GitHubCredential = $testcred
        }
        $obj | Export-Clixml -Path "TestDrive:\Test.xml"

        It "Returns PSCustomObject" {
            mock -CommandName 'Import-Clixml' -MockWith {return $obj}
            mock -CommandName "Get-PSFConfigValue" -MockWith {"TestDrive:\Test.xml"}
            $returnvalue = Import-PSPGitAuthFile($XmlPath)
            $returnvalue | Should -BeOfType System.Management.Automation.PSCustomObject
            $returnvalue.GistId | Should -BeExactly $GistId
            $returnvalue.UserName | Should -BeExactly $UserName
            $returnvalue.PATToken | Should -BeExactly $PatToken
        }
    }
}