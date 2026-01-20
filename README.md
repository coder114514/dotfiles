# dotfiles

### Neovim
```lua
local scriptpath = vim.fn.expand("dotfiles/vim/neovim.lua")
dofile(scriptpath)
```

### Vim
```vim
so dotfiles/vim/vim.vim
```

### Alacritty
```toml
import = [
    "dotfiles/alacritty.toml"
]
```

### Tmux
```tmux
source-file dotfiles/tmux.conf
```
