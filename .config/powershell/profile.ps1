$Env:PY_COLORS = "1"

$Env:PIP_NO_PYTHON_VERSION_WARNING = "1"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = "1"

# TODO we want automatic .venv/ activation

If ($IsWindows) {
    $Env:HOME = "$Env:USERPROFILE"
}

function pt {
    & pytest --stepwise --maxfail 1 -s -l -rN --tb=native --log-cli-level=DEBUG --log-level=ERROR -p no:cov --disable-warnings
}

function act {
    .venv/Scripts/activate.ps1 || conda activate .venv/
}


function deact {
    if (Test-Path Env:VIRTUAL_ENV) {
        deactivate
    }
    else {
        conda deactivate
    }
}

function Get-Process-From-Prefix {
    [CmdletBinding()]param(
        [string]$Prefix = $Env:CONDA_PREFIX
    )
    Get-Process | Where-Object { ($null -ne $_.Path) -and $_.Path.StartsWith($Prefix) } | Format-Table -Property Id, CommandLine
}

Set-Alias trash Remove-ItemSafely -Option AllScope

function Install-My-Stuff {
    Install-Module -Name Recycle -RequiredVersion 1.0.2
}


function rmrf {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    Remove-Item -Force -Recurse -Path $Path
}

function tox3 {
    uvx --from "tox<4" tox @Args
}

function tox4 {
    uvx --from "tox>=4" tox @Args
}
function tox4uv {
    uvx --from "tox>=4" --with tox-uv tox @Args
}

function cfg {
    git --git-dir $Env:HOME/.cfg --work-tree=$Env:HOME $Args
}

function excel {
    $Excel = "$Env:ProgramFiles\Microsoft Office\Root\Office16\EXCEL.EXE"
    Start-Process -FilePath $Excel -ArgumentList @Args
}

function setx {
    [CmdletBinding()]
    param(
        [string]$name,
        [string]$value
    )
    [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::User)
}

function which {
    [CmdletBinding()]
    param([string]$command)
    Get-Command -All -ShowCommandInfo $command | Format-Table -Property CommandType, Definition -AutoSize
}

function whois {
    [CmdletBinding()] param($userid)
    [adsisearcher]"(samaccountname=$userid)".FindOne().Properties | Format-Table
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
