<#
.SYNOPSIS
    Retrieves entries from the OpenSSH config file.
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-SshConfig
    Gets all configured hosts in the ssh config file residing at ~/.ssh/config
    PS C:\> Get-SshConfig 'foo'
    Gets the config entry with the name 'foo'
.PARAMETER SshHost
    The host name to look up. If not specified, will return all hosts.
.PARAMETER Path
    The path of the OpenSSH config file. If not specified, defaults to ~/.ssh/config
.PARAMETER Raw
    Indicates whether the function should return the configuration entries
    in their 'raw' form or their 'computed' form.

    In their 'raw' form a hierarchy of ConfigNode
    objects is returned that represent the lines in the config file. Each node has a name, a value,
    a separator and optionally a collection of child nodes (which in turn have the same properties).

    In their 'computed' form, the hierarchy is searched and wildcards are expanded.
    These are returned as a list of Hashtables, where the keys in the hashtable are the host's properties.
    Given the following config, only a single hashtable will be returned as the wildcard entry will be expanded
    and its properties appended to the first host.

    Host foo
      HostName example.com
      User jeremy

    Host *
      IdentityFile ~/.ssh/foo_id_rsa
#>
function Get-SshConfig {
    param(
        [Parameter(Position = 0)]
        [string]
        $SshHost,

        [Parameter()]
        [string]
        $Path = (Get-SshPath 'config'),

        [Parameter()]
        [switch]
        $Raw
    )

    if (! (Test-Path $Path)) {
        # If we've requested the entire config as a raw object and it doesn't exist
        # at that path, just return a new one.
        if ($Raw -and !$SshHost) {
            return [SshConfig]::new()
        }

        throw "'$Path' could not be found."
    }

    # Parse-SshConfig defined in ConfigParser.ps1
    $cfg = Parse-SshConfig (Get-Content $Path -Raw)

    if($SshHost -and $Raw) {
        # Find a speific host as the raw Node object.
        return $cfg.Find($SshHost);
    }
    elseif($SshHost) {
        # Specific host, parsed into a dictionary with computed properties.
        return $cfg.Compute($SshHost);
    }
    elseif($Raw) {
        # All raw nodes.
        return $cfg;
    }
    else {
        # All computed nodes.
        return $cfg.Nodes `
           | Where-Object { $_.Type -eq "Directive" -and $_.Param -eq "Host" } `
           | Where-Object { $_.Value -ne "*" -and !$_.Value.Contains("?") } `
           | Foreach-Object { $cfg.Compute($_.Value) } `

    }
}

<#
.SYNOPSIS
    Displays a list of available SSH connections and allows you to connect to one of them.
.PARAMETER Name
(Optional) the name of host to connect. If not specified, a list of connections is displayed.
.PARAMETER Path
(Optional) the path to the ssh config file. Defaults to ~/.ssh/config
.EXAMPLE
    PS C:\> Connect-Ssh
#>
function Connect-Ssh {
    param(
        [Parameter(Position = 0)]
        [string]
        $Name,

        [Parameter()]
        $Command = (Get-Command ssh),

        [Parameter(ValueFromRemainingArguments)]
        [psobject[]]
        $Params
    )

    # If a name is specified, then find the matching config entry
    if ($Name) {
        & $Command $Name $Params
        return
    }

    # No name specified. Print out a list of connections to choose from.

    $display = @()
    $config = @(Get-SshConfig) # Force array if there's only a single item.

    foreach ($entry in $config) {
        # Config entries may have "Host server.com" or they may have an alias:
        # Host server
        #   HostName server.com
        # If the former, then set the host entry to be the URI.
        # If the latter, use the hostname entry
        if (!$entry["HostName"]) {
            $entry["HostName"] = $entry["Host"]
            $entry["Host"] = ""
        }

        # Add a row to the output with a numeric index, name and URI.
        $properties = [PSCustomObject][ordered]@{
            "#" = ($config.IndexOf($entry) + 1)
            Name = $entry["Host"]
            Uri = $entry["HostName"]
            User = $entry["User"]
        }

        $display += $properties
    }

    $display | Format-Table -AutoSize

    $userInput = (Read-Host "Enter a connection (or leave blank to cancel)").Trim()
    $index = 0

    # If the user has entered an index, connect to that the connection at that location
    if([int]::TryParse($userInput, [ref]$index)) {
        if ($index) {
            $selected = $config[$index - 1]
            if ($selected) {
                $hostname = $selected["Host"]

                # Only prompt for username if there's no user name explicitly defined.
                if (!$selected['User']) {
                    do {
                        $username = Read-Host "Enter username"
                    } while (!$username)
                    $hostname = "$username@$hostname"
                }

                & $Command $hostname $Params
            }
        }
    }
    elseif($userInput) {
        # User entered a string. Find hostname instead.
        if($selected) {
            & $Command $userInput $Params
        }
    }
}

<#
.SYNOPSIS
    Adds an SSH connection
.DESCRIPTION
   Adds a new connection to the OpenSSH config file.
.EXAMPLE
    PS C:\> Add-SshConnection dev dev@example.com
    Adds a new ssh connection with the host alias 'Dev', which connects to 'dev@example.com'
.PARAMETER Name
    The name (alias) of the connection
.PARAMETER Uri
    The URI for the connection
.PARAMETER IdentityFile
    (Optional) The path to the IdentityFile to use for this connection
.PARAMETER User
    (Optional) The username for this connection
.PARAMETER LocalTunnelPort
    (Optional) Local port for SSH tunnel.
.PARAMETER RemoteTunnelPort
    (Optional) Remote port for SSH tunnel.
.PARAMETER TunnelHost
    (Optional) Host name for tunnel (defaults to localhost if not specified)
.PARAMETER AdditionalOptions
    (Optional) Hashtable of additional options for the connection
#>
function Add-SshConnection {
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [string]
        $Uri,

        [Parameter()]
        [string]
        $IdentityFile,

        [Parameter()]
        [string]
        $User,

        [Parameter()]
        [int]
        $LocalTunnelPort,

        [Parameter()]
        [int]
        $RemoteTunnelPort,

        [Parameter()]
        [string]
        $TunnelHost,

        [Parameter()]
        [hashtable]
        $AdditionalOptions = @{},

        [Parameter()]
        [string]
        $Path = (Get-SshPath 'config')
    )

    $parameters = @{}

    if ($Name) {
        $parameters["Host"] = $Name
    }

    if ($Uri) {
        # If the URI has a user@ prefix, then separate them out.
        # But allow an explicit username parameter to override.
        if ($Uri.Contains("@")) {
            $bits = $Uri.Split("@")
            if (! $User) {
                $User = $bits[0]
            }
            $Uri = $bits[1]
        }

        $parameters["HostName"] = $Uri
    }

    if ($User) {
        $parameters["User"] = $User
    }

    if ($IdentityFile) {
        $parameters["IdentityFile"] = $IdentityFile
    }

    if ($LocalTunnelPort -or $RemoteTunnelPort) {
        if (!$LocalTunnelPort) { $LocalTunnelPort = $RemoteTunnelPort }
        elseif (!$RemoteTunnelPort) { $RemoteTunnelPort = $LocalTunnelPort }

        if (!$TunnelHost) { $TunnelHost = "localhost" }

        $parameters["LocalForward"] = "$LocalTunnelPort ${TunnelHost}:${RemoteTunnelPort}"
    }

    $AdditionalOptions.Keys | ForEach-Object { $parameters[$_] = $AdditionalOptions[$_] }

    $config = Get-SshConfig -Raw -Path $Path
    $config.Add($parameters)

    # Don't use UTF8 as it always writes the BOM which breaks openssh.
    $config.Stringify() | Out-File $Path -Encoding ascii
}

<#
.SYNOPSIS
    Removes an SSH connection from the config file.
.EXAMPLE
    PS C:\> Remove-SshConnection 'dev'
    Removes the SSH connection from the config file with a Host (alias) of Dev.
.PARAMETER Name
    Name of the connection to remove.
#>
function Remove-SshConnection {
    param(
        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Path = (Get-SshPath 'config')
    )

    $config = Get-SshConfig -Raw -Path $Path
    $config.RemoveHost($Name)

    # Don't use UTF8 as it always writes the BOM which breaks openssh.
    $config.Stringify() | Out-File $Path -Encoding ascii
}

$script:originalSsh = $null
function Add-SshAlias {
    if (! $script:originalSsh) {
        # Take a copy of where "ssh" currently points to and create a function to invoke it
        $script:originalSsh = (Get-Command ssh)

        # Overwrite the ssh command with a wrapper
        function global:ssh {
            param(
                [Parameter(Position = 0)]
                [string]
                $Name
            )

            Connect-Ssh -Name $Name -Command $script:originalSsh $args
        }
    }
}
