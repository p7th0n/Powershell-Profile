
fabric --listpatterns | fzf | ForEach-Object { 
    if ($_ -ne $null) { 
        Write-Out $_ 
    }
}