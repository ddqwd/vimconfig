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
## vim-plugs ##

[YCM](https://github.com/ycm-core/YouCompleteMe)



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
