param
(
    [Parameter(Mandatory = $true)]
    [string]
    $FileToTest
)

$FileToTest = Resolve-Path $FileToTest
$fileName = Split-Path $FileToTest -leaf
if ($FileName -like "*.tests.ps1")
{
    $filename = $fileName -replace "tests\.ps1$", "ps1"
    $sourceDir = Join-Path $PSScriptRoot "PSProfileSync"
    $functionFile = Get-ChildItem $sourceDir -Filter $fileName -Recurse | Select-Object -First 1 -ExpandProperty FullName
    $testFile = $FileToTest
}
else
{
    $fileName = $fileName -replace ".ps1$", ".tests.ps1"
    $testFile = (Join-Path $PSScriptRoot "/Tests/Private/$fileName")
    $functionFile = $FileToTest
}

Invoke-Pester -Script $testFile -CodeCoverage $functionFile -CodeCoverageOutputFile "$PSScriptRoot\cov.xml"