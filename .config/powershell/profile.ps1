Write-Host "Boo!"
$Env:PY_COLORS = "1"

function Get-Process-From-Prefix {
    [CmdletBinding()]param(
        [string]$Prefix = $Env:CONDA_PREFIX
    )
    Get-Process | Where-Object { ($null -ne $_.Path) -and $_.Path.StartsWith($Prefix) } | Format-Table -Property Id, CommandLine
}
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


function findntid {
    [CmdletBinding()] param($ntid)
    (
        ([adsisearcher]"(samaccountname=$ntid*)").FindAll()
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

function adgroups {
    [CmdletBinding()] param($ntid)

    ([adsisearcher]"(samaccountname=$ntid*)").FindAll() | ForEach-Object {
        $_.GetDirectoryEntry().memberOf |  ForEach-Object {
            Write-Host $_.split("=").split(",")[1]
        }
    }
}

# Invoke-Expression "$(direnv hook pwsh)"
Write-Host "Yah!"