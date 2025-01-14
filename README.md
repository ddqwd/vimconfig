




# vimconfig
[ctags](https://github.com/universal-ctags/ctags)

[ctags_referece](https://docs.ctags.io/en/latest/man/ctags.1.html)

[win32vim](https://www.vim.org/download.php)

[unixVim](https://www.vim.org/git.php)

[cmake](https://cmake.org/download/)

[python]()

[go](https://go.dev/dl/)

[node](https://nodejs.org/en/download/)

[git-vim](https://github.com/vim/vim.git)

[YCM](https://github.com/ycm-core/YouCompleteMe)

[clang-power-tools](https://www.clangpowertools.com/)

[clang-uml](https://github.com/bkryza/clang-uml)

[java] (https://www.oracle.com/java/technologies/downloads/?er=221886#jdk23-windows)

[graphviz](https://graphviz.org/download/)

[plantuml jar](https://sourceforge.net/projects/plantuml.mirror/files/v1.2024.6/plantuml-1.2024.6.jar/download)

[everything es](https://www.voidtools.com/zh-cn/downloads/)
[ccls]()
[clangd]()


# 关于coc ccls/clangd lsp插件配置

首先使用clangd进行配置， 只有clangd配置可以使用，才能使用ccls, 因为ccls是基于clangd, 同时 ccls的输出不如clangd配置直观 

## 安装clangd
coc-install coc-clangd

## 观察输出
Coccommand workspace.showoutput
如果发现compile_commands.json无法加载
则进行clangd测试
clangd --compile-dri =. -check=xx.cpp
如果加载正常
观察compile_commands.json是否在正确的路径上， 一般放到到根目录的路径上


# Linux

rigprep
libgstreamer*
inventor-dev
libsdl2-dev
gtk2
Jasper
cmake
gettext

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/neovim/neovim.git

make && sudo make install 

echo "export PATH=/usr/local/bin:$PATH" >> .bashrc

.bashrc

[sudo apt install nodejs npm](https://nodejs.org/en/download) 下载最新的node 

autojump

##  安装FSearch

sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
sudo apt install fsearch

## python包

vtk
tk


# Windows

## 安装必要软件

choco
wsl 
ubuntu22.04
ripgrep
clink
autojump
neovim
win32yank (choco install win32yank)
git 升级git : `git update-git-for-windows`
graphviz 
java
everything [es]




## windows terminal配置

### post-git
https://github.com/dahlbyk/posh-git

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
```

### jump

https://github.com/vors/ZLocation

Install-Module ZLocation -Scope CurrentUser; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts

### powershell toys
https://github.com/microsoft/PowerToys/releases/tag/v0.84.1

### PSReadLine
https://github.com/PowerShell/PSReadLine
Install-Module -Name PowerShellGet -Force
## neovim Coc-Install

CocInstall coc-pyright
CocInstall coc-clangd



## VisualStudio 插件配置

### Clang Power Tools
### VisualLint

## plantuml jar包使用

java -jar plantuml.jar -h 
打印帮助信息

java -jar plantuml.jar -tsvg xx.puml


## windows11 scripts
```












```




