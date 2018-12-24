$functionFolders = @('Private\Enums', 'Private\Classes', 'Public' )
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $FunctionFiles = Get-ChildItem -Path $folderPath -Filter '*.ps1' -Recurse
        ForEach ($FunctionFile in $FunctionFiles)
        {
            Write-Verbose -Message "  Importing $($FunctionFile.BaseName)"
            . $($FunctionFile.FullName)
        }
    }
}