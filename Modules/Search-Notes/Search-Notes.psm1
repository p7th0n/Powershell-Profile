
function Search-Notes($search_term) {

    $notes = '~\Dropbox\Notes\'
    $notes_path = Resolve-Path $notes
    $search_command = 'ag ' + $search_term + ' ' + $notes_path
    # Write-Host $Args

    # Write-Host $search_command

    Invoke-Expression $search_command
}
