$OriginalForegroundColor = $Host.UI.RawUI.ForegroundColor
if (-not [System.Enum]::IsDefined([System.ConsoleColor], 1)) { $OriginalForegroundColor = "Gray" }

$CompressedList = @(".7z", ".gz", ".rar", ".tar", ".zip", ".xz", ".zst", ".bz2")
$ExecutableList = @(".exe", ".bat", ".cmd", ".py", ".pl", ".ps1",
                    ".psm1", ".psd1", ".vbs", ".rb", ".reg", ".fsx", ".sh",
                    ".go", ".rs", ".ts", ".tsx")
$DllPdbList = @(".dll", ".pdb")
$TextList = @(".csv", ".log", ".markdown", ".md", ".rst", ".txt")
$ConfigsList = @(".cfg", ".conf", ".config", ".ini", ".json", ".yml", ".yaml", ".toml", ".tf")

$ColorTable = @{}

$ColorTable.Add('Default', $OriginalForegroundColor) 
$ColorTable.Add('Directory', "Green") 

ForEach ($Extension in $CompressedList) {
    $ColorTable.Add($Extension, "Yellow")
}

ForEach ($Extension in $ExecutableList) {
    $ColorTable.Add($Extension, "Blue")
}

ForEach ($Extension in $TextList) {
    $ColorTable.Add($Extension, "Cyan")
}

ForEach ($Extension in $DllPdbList) {
    $ColorTable.Add($Extension, "DarkGreen")
}

ForEach ($Extension in $ConfigsList) {
    $ColorTable.Add($Extension, "DarkYellow")
}


Function Get-Color($Item) {
    $Key = 'Default'

    If ($Item.PSIsContainer) {
        $Key = 'Directory'
    } else {
        If ($Item.PSobject.Properties.Name -contains "Extension") {
            If ($ColorTable.ContainsKey($Item.Extension)) {
                $Key = $Item.Extension
            }
        }
    }

    $Color = $ColorTable[$Key]
    Return $Color
}


Function Get-ChildItemColor {
    Param(
        [string]$Path = ""
    )
    if ($Path) {
        $Items = Get-ChildItem -LiteralPath $Path @Args
    } else {
        $Items = Get-ChildItem @Args
    }

    ForEach ($Item in $Items) {
        $Color = Get-Color $Item

        try {
            $Host.UI.RawUI.ForegroundColor = $Color
            $Item
        } finally {
            $Host.UI.RawUI.ForegroundColor = $OriginalForegroundColor
        }
    }
}

Function Get-ChildItemColorFormatWide {
    Param(
        [string]$Path = "",
        [switch]$Force
    )

    $nnl = $True

    $gciParams = @{}
    if ($Force) { $gciParams['Force'] = $true }

    if ($Path) {
        $Items = Get-ChildItem -LiteralPath $Path @Args @gciParams
    } else {
        $Items = Get-ChildItem @Args @gciParams
    }

    $lnStr = $Items | Select-Object Name | Sort-Object { "$_".Length } -Descending | Select-Object -First 1
    $len = if ($lnStr) { $lnStr.Name.Length } else { 0 }
    $width = $Host.UI.RawUI.WindowSize.Width
    $cols = If ($len) {($width + 1) / ($len + 2)} Else {1}
    $cols = [math]::Floor($cols)
    if (!$cols) {$cols=1}

    $i = 0
    $pad = [math]::Ceiling(($width + 2) / $cols) - 3
    if ($pad -lt 3) { $pad = 3 }

    ForEach ($Item in $Items) {
        If ($Item.PSobject.Properties.Name -contains "PSParentPath") {
            If ($Item.PSParentPath -match "FileSystem") {
                $ParentType = "Directory"
                $ParentName = $Item.PSParentPath.Replace("Microsoft.PowerShell.Core\FileSystem::", "")
            }
            ElseIf ($Item.PSParentPath -match "Registry") {
                $ParentType = "Hive"
                $ParentName = $Item.PSParentPath.Replace("Microsoft.PowerShell.Core\Registry::", "")
            }
        } else {
            $ParentType = ""
            $ParentName = ""
            $LastParentName = $ParentName
        }

        $Color = Get-Color $Item

        if ($LastParentName -ne $ParentName) {
            if($i -ne 0 -AND $Host.UI.RawUI.CursorPosition.X -ne 0){  # conditionally add an empty line
                Write-Host ""
            }
            Write-Host -Fore $OriginalForegroundColor ("`n   $($ParentType): $ParentName`n")
        }

        $nnl = ++$i % $cols -ne 0

        # truncate the item name
        $toWrite = $Item.Name
        if ($toWrite.length -gt $pad) {
            $toWrite = $toWrite.Substring(0, $pad - 3) + "..."
        }

        Write-Host ("{0,-$pad}" -f $toWrite) -Fore $Color -NoNewLine:$nnl

        if ($nnl) {
            Write-Host "  " -NoNewLine
        }

        $LastParentName = $ParentName
    }

    if ($nnl) {  # conditionally add an empty line
        Write-Host ""
        Write-Host ""
    }
}

Export-ModuleMember -Function 'Get-ChildItemColor', 'Get-ChildItemColorFormatWide'
