# What is NGen?
#
#   NGen precompiles dotNet Common Intermediate Language code into machine code.
#   This reduces startup times
#
# https://stackoverflow.com/questions/20620348/how-and-when-does-ngen-exe-work
# https://docs.microsoft.com/en-us/dotnet/framework/tools/ngen-exe-native-image-generator
#

$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
  if (! $_.location) {continue}
  $Name = Split-Path $_.location -leaf
  Write-Host -ForegroundColor Yellow "NGENing : $Name"
  ngen install $_.location | ForEach-Object {"`t$_"}
}