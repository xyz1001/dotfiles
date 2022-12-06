set-ExecutionPolicy RemoteSigned
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
Install-Module posh-git -Scope CurrentUser -AllowClobber
Install-Module oh-my-posh -Scope CurrentUser -AllowClobber -RequiredVersion 2.0.496
Install-Module git-aliases -Scope CurrentUser -AllowClobber
Install-Module VSSetup -Scope CurrentUser -AllowClobber
Install-Module Pscx -Scope CurrentUser -AllowClobber
Install-Module Terminal-Icons -Scope CurrentUser -AllowClobber

