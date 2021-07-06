Import-Module "Oh-My-Posh" -DisableNameChecking -NoClobber
Import-Module posh-git
Import-Module PSReadLine
Import-Module git-aliases -DisableNameChecking
Import-Module Pscx
Set-PSReadLineOption -EditMode vi
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+o -Function ClearScreen
Set-PSReadLineKeyHandler -Chord Ctrl+w BackwardDeleteWord
Set-Theme robbyrussell
$Env:LESSCHARSET="utf-8"
