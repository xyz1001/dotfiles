Import-Module Oh-My-Posh -DisableNameChecking -NoClobber
Import-Module posh-git
Import-Module PSReadLine
Import-Module git-aliases -DisableNameChecking
Import-Module VSSetup
Import-Module Pscx

Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+o -Function ClearScreen
Set-PSReadLineKeyHandler -Chord Ctrl+w BackwardDeleteWord
Set-Theme robbyrussell

$Env:LESSCHARSET="utf-8"
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$zlua_path = Join-Path $HOME "Documents\Powershell\Modules\z.lua"
$zlua_url = "https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua"
if (!(Test-Path($zlua_path)))
{
    Invoke-WebRequest $zlua_url -OutFile $zlua_path
}

Invoke-Expression (& { (lua $HOME/Documents/Powershell/Modules/z.lua --init powershell) -join "`n" })
