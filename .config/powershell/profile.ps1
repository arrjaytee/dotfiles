$Env:PY_COLORS = "1"

function Get-Process-From-Prefix {
    [CmdletBinding()]param(
        [string]$Prefix = $Env:CONDA_PREFIX
    )
    Get-Process | Where-Object { ($null -ne $_.Path) -and $_.Path.StartsWith($Prefix) } | Format-Table -Property Id, CommandLine
}

Set-Alias trash Remove-ItemSafely -Option AllScope


function which {
    [CmdletBinding()]
    param([string]$command)
    Get-Command -All -ShowCommandInfo $command | Format-Table -Property CommandType, Definition -AutoSize
}

function whois {
    [CmdletBinding()] param($userid)
    ([adsisearcher]"(samaccountname=$userid)").FindOne().Properties | Format-Table
}

function findfolk {
    [CmdletBinding()] param($name)
    (
        ([adsisearcher]"(displayName=$name*)").FindAll()
        | Select-Object -Property @{
            Label      = "NTID"
            Expression = { $_.Properties['samaccountname'] }
        },
        @{  Label      = "DisplayName"
            Expression = { $_.Properties['displayName'] }
        },
        @{  Label      = "department"
            Expression = { $_.Properties['department'] }
        },
        @{  Label      = "userprincipalname"
            Expression = { $_.Properties['userprincipalname'] }
        } | Format-Table
    )
}


# this is pretty quick
Invoke-Expression (& starship init powershell --print-full-init | Out-String)
