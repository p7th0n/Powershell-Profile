$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
[AppDomain]::CurrentDomain.GetAssemblies() | % {
  if (! $_.location) {continue}
  $Name = Split-Path $_.location -leaf
  Write-Host -ForegroundColor Yellow "NGENing : $Name"
  ngen install $_.location | % {"`t$_"}
}