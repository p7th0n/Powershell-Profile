@{
    RootModule        = 'Get-ChildItemColor.psm1'
    ModuleVersion      = '1.0.0'
    GUID               = 'b4f5b4d0-8b7d-4c0e-9d1e-6c7a5a5e6f1a'
    Author             = 'Dave Kurman'
    Description        = 'Colorized Get-ChildItem output for ls/dir, aliased over the built-in cmdlet.'
    PowerShellVersion  = '5.1'
    FunctionsToExport  = @('Get-ChildItemColor', 'Get-ChildItemColorFormatWide')
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
}
