Import-Module PSReadLine
Import-Module git-aliases -DisableNameChecking
Import-Module posh-git -ArgumentList $false,$false,$true  # EnableProxyFunctionExpansion
Import-Module gsudoModule

# Pscx: 懒加载，首次调用 Import-VisualStudioVars 时才加载
function Import-VisualStudioVars { Import-Module Pscx -Global; Import-VisualStudioVars @args }

# Prompt state
$global:_isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Custom prompt (Agnoster style)
function prompt {
    $lastOk = $?
    $sep = "`u{E0B0}"  # Powerline separator 

    $path = $executionContext.SessionState.Path.CurrentLocation.Path
    $home_ = $HOME.TrimEnd('\')
    if ($path.StartsWith($home_, [StringComparison]::OrdinalIgnoreCase)) {
        $path = "~" + $path.Substring($home_.Length)
    }

    # path segment: blue(44) on success, red(41) on error
    $pathBg = if ($lastOk) { 44 } else { 41 }
    $seg = "`e[97;${pathBg}m $path `e[0m"

    # git segment (uses posh-git Get-GitStatus for tab completion compatibility)
    $global:GitStatus = Get-GitStatus
    $branch = $global:GitStatus.Branch
    if ($branch) {
        $dirty = $global:GitStatus.HasWorking -or $global:GitStatus.HasIndex
        $ahead = $global:GitStatus.AheadBy
        $behind = $global:GitStatus.BehindBy
        if ($dirty) {
            $gitBg = 43; $gitFg = 30
            $info = "`u{E0A0} $branch `u{00B1}"
        } else {
            $gitBg = 42; $gitFg = 30
            $info = "`u{E0A0} $branch"
        }
        if ([int]$ahead -gt 0)  { $info += " `u{2191}$ahead" }
        if ([int]$behind -gt 0) { $info += " `u{2193}$behind" }
        $seg += "`e[$((${pathBg} - 10));${gitBg}m$sep`e[${gitFg};${gitBg}m $info `e[0m"
        $seg += "`e[$((${gitBg} - 10))m$sep`e[0m"
    } else {
        $seg += "`e[$((${pathBg} - 10))m$sep`e[0m"
    }

    $char = if ($global:_isAdmin) { '#' } else { '$' }
    "$seg $char "
}

Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
function ls { lsd @args }
function ll { lsd -la @args }

Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler {
    if ($args[0] -eq 'Command') {
        [Console]::Write("`e[2 q")
    } else {
        [Console]::Write("`e[6 q")
    }
}
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+o -Function ClearScreen
Set-PSReadLineKeyHandler -Chord Ctrl+w BackwardDeleteWord

Set-PSReadLineOption -Colors @{ "Parameter" = "`e[97;2;3m"; "Operator" = "`e[97;2;3m" }

Remove-Item Alias:rm -Force -ErrorAction SilentlyContinue

$Env:LESSCHARSET="utf-8"
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$zlua_path = Join-Path $HOME "Documents\Powershell\Modules\z.lua"
$zlua_url = "https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua"
if (!(Test-Path($zlua_path)))
{
    Invoke-WebRequest $zlua_url -OutFile $zlua_path
}

Invoke-Expression (& { (lua $HOME/Documents/Powershell/Modules/z.lua --init powershell) -join "`n" })

function Get-EnvironmentVariablesDialog {
  sudo rundll32 sysdm.cpl,EditEnvironmentVariables
}

Set-Alias envgui Get-EnvironmentVariablesDialog

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    . ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))
}

$apiKeyFile = Join-Path $HOME ".config\secret.env"
if (Test-Path $apiKeyFile) {
    try {
        Get-Content $apiKeyFile | ForEach-Object {
            if ($_ -notmatch '^\s*#' -and $_ -match '=') {
                $name, $value = $_.Split('=', 2)
                Set-Content "env:\$name" $value
            }
        }
    } catch {
    }
}

if (Get-Process -Name "Clash-Verge" -ErrorAction SilentlyContinue) {
    $env:HTTP_PROXY = "http://127.0.0.1:7890"
    $env:HTTPS_PROXY = "http://127.0.0.1:7890"
    $env:NO_PROXY = "localhost,127.0.0.1"
}
