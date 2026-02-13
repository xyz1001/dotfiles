Import-Module Oh-My-Posh -DisableNameChecking -NoClobber
Import-Module posh-git
Import-Module PSReadLine
Import-Module git-aliases -DisableNameChecking
Import-Module VSSetup
Import-Module Pscx
Import-Module Terminal-Icons

Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+o -Function ClearScreen
Set-PSReadLineKeyHandler -Chord Ctrl+w BackwardDeleteWord
Set-Theme Agnoster

Set-PSReadLineOption -Colors @{ "Parameter" = "`e[97;2;3m"; "Operator" = "`e[97;2;3m" }

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

if (Get-Process -Name "Clash-Verge" -ErrorAction SilentlyContinue) {
    $env:HTTP_PROXY = "http://127.0.0.1:7890"
    $env:HTTPS_PROXY = "http://127.0.0.1:7890"
    $env:NO_PROXY = "localhost,127.0.0.1"
}
