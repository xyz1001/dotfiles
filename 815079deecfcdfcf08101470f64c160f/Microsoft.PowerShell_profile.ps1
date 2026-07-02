# =====================================================================
# 1. 通用环境配置 (适用于交互式和非交互式)
# =====================================================================
$Env:LESSCHARSET = "utf-8"
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# 加载密钥/环境变量
$apiKeyFile = Join-Path $HOME ".config\secret.env"
if (Test-Path $apiKeyFile) {
    try {
        Get-Content $apiKeyFile | ForEach-Object {
            if ($_ -notmatch '^\s*#' -and $_ -match '=') {
                $name, $value = $_.Split('=', 2)
                Set-Content "env:\$name" $value
            }
        }
    } catch {}
}

$Env:OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true"

# Pscx: 懒加载，首次调用 Import-VisualStudioVars 时才加载
function Import-VisualStudioVars { Import-Module Pscx -Global; Import-VisualStudioVars @args }

# =====================================================================
# 2. 交互式状态检测 (检测是否为交互式终端)
# =====================================================================
$isInteractive = $null -ne $Host.UI.RawUI -and $null -eq $PSSenderInfo
if ($isInteractive) {
    # 检查命令行参数是否包含非交互式、单命令或脚本执行标志
    # 匹配 -Command, -EncodedCommand, -File, -NonInteractive 及其缩写（如 -c, -e, -f, -noni 等）
    foreach ($arg in [Environment]::GetCommandLineArgs()) {
        if ($arg -match '^-(.+)$') {
            $paramName = $Matches[1].ToLower()
            if (
                ("command".StartsWith($paramName) -and $paramName.Length -ge 1) -or
                ("encodedcommand".StartsWith($paramName) -and $paramName.Length -ge 1) -or
                ("file".StartsWith($paramName) -and $paramName.Length -ge 1) -or
                ("noninteractive".StartsWith($paramName) -and $paramName.Length -ge 3)
            ) {
                $isInteractive = $false
                break
            }
        }
    }
}

# 如果是非交互式，直接退出，跳过后续所有仅交互式需要的繁重配置
if (-not $isInteractive) {
    return
}

# =====================================================================
# 3. 仅交互式配置 (模块导入、提示符定制、按键绑定、补全等)
# =====================================================================
Import-Module PSReadLine
Import-Module git-aliases -DisableNameChecking
Remove-Item Alias:gcb -Force -ErrorAction SilentlyContinue
Import-Module posh-git -ArgumentList $false,$false,$true  # EnableProxyFunctionExpansion

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

if ($Host.Name -eq 'ConsoleHost' -and -not [Console]::IsOutputRedirected) {
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
}

Remove-Item Alias:rm -Force -ErrorAction SilentlyContinue

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function Get-EnvironmentVariablesDialog {
  sudo rundll32 sysdm.cpl,EditEnvironmentVariables
}

Set-Alias envgui Get-EnvironmentVariablesDialog

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    . ([ScriptBlock]::Create((& scoop-search --hook | Out-String)))
}

# git commit --fixup tab completion: show recent commits
$ctx = $ExecutionContext.GetType().GetField('_context', [System.Reflection.BindingFlags]'NonPublic,Instance').GetValue($ExecutionContext)
$poshGitCompleter = $ctx.GetType().GetProperty('NativeArgumentCompleters', [System.Reflection.BindingFlags]'NonPublic,Instance').GetValue($ctx)['git']

$gitCompleterScript = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $tokens = $commandAst.ToString() -split '\s+'
    $hasFixup = $tokens | Where-Object { $_ -match '^--fixup' }
    if ($hasFixup) {
        $prefix = if ($wordToComplete -match '^--fixup=(.*)') { $Matches[1] } elseif ($tokens[-2] -match '^--fixup') { $wordToComplete } else { '' }
        $isEqForm = $wordToComplete -match '^--fixup='
        git log --oneline -30 2>$null | ForEach-Object {
            if ($_ -match '^([0-9a-f]+)\s+(.*)$') {
                $hash = $Matches[1]; $msg = $Matches[2]
                if (-not $prefix -or $hash.StartsWith($prefix) -or $msg -like "*$prefix*") {
                    $val = if ($isEqForm) { "--fixup=$hash" } else { $hash }
                    [System.Management.Automation.CompletionResult]::new($val, "$hash $msg", 'ParameterValue', ' ')
                }
            }
        }
    } elseif ($poshGitCompleter) {
        & $poshGitCompleter $wordToComplete $commandAst $cursorPosition
    }
}.GetNewClosure()

Register-ArgumentCompleter -CommandName git -Native -ScriptBlock $gitCompleterScript

# ==========================================
# !! and !$ History Expansion (Bash-like)
# ==========================================
function Expand-HistoryToken {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    
    $beforeCursor = $line.Substring(0, $cursor)
    
    # Expand !! (last command)
    if ($beforeCursor.EndsWith("!!")) {
        $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()
        if ($history.Count -gt 0) {
            $lastCommand = $history[-1].CommandLine
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor - 2, 2, $lastCommand)
            return $true
        }
    } 
    # Expand !$ (last argument of last command)
    elseif ($beforeCursor.EndsWith("!$")) {
        $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems()
        if ($history.Count -gt 0) {
            $lastCommand = $history[-1].CommandLine
            $errors = $null
            $tokens = [System.Management.Automation.PSParser]::Tokenize($lastCommand, [ref]$errors)
            $lastToken = if ($tokens.Count -gt 0) { $tokens[-1].Content } else {
                $parts = $lastCommand.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
                if ($parts.Length -gt 0) { $parts[-1] }
            }
            if ($lastToken) {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor - 2, 2, $lastToken)
                return $true
            }
        }
    }
    return $false
}

# Bind Tab key: expand if !! or !$, else fallback to original MenuComplete
Set-PSReadLineKeyHandler -Key Tab -BriefDescription "ExpandHistoryOrTabComplete" -ScriptBlock {
    if (-not (Expand-HistoryToken)) {
        [Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
    }
}

# Bind Enter key: expand if !! or !$, then accept line
Set-PSReadLineKeyHandler -Key Enter -BriefDescription "ExpandHistoryOnEnter" -ScriptBlock {
    $null = Expand-HistoryToken
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
