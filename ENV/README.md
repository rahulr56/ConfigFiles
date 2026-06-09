# ENV — Portable Shell Environment                                                                                                    
                                                                                                                                      
Portable shell config for bash and zsh. Copy to any Linux machine, run one script, done.
                                                                   
---                                              
                                                                   
## Structure                                  
                                                                   
```                                                                                                                                   
ENV/                                                               
├── install.sh          # Installs tools + wires env.sh into shell rc
├── env.sh              # Entry point — auto-detects bash/zsh, sources rc/
├── rc/                 # Bash modules                                                                                                
│   ├── 00-modules.sh   # Environment Modules (module load/avail/unload)
│   ├── 01-path.sh      # PATH — ~/.local/bin, nvim, cargo, go, bob                                                                   
│   ├── 02-exports.sh   # EDITOR, TERM, LANG, history, shell opts, arrow-key search
│   ├── 03-colors.sh    # LS_COLORS, LESS_TERMCAP, GREP_COLOR
│   ├── 04-aliases.sh   # Navigation, ls, editor, git, system, python, dir stack
│   ├── 05-fzf.sh       # FZF config + keybindings
│   ├── 06-tools.sh     # bat, zoxide, ripgrep                     
│   ├── 07-functions.sh # cd (autopushd+auto-venv), mcd, up, extract, backup, myip
│   ├── 08-prompt.sh    # PS1: exit-code (jobs) (user:dir) ->                                                                         
│   └── 09-plugins.sh   # bash-preexec, REPORTTIME ≥5s, fastfetch on login
└── zsh/                # Zsh mirrors of rc/ (zsh-native equivalents)                                                                 
    ├── 00-modules.zsh                                             
    ├── 01-path.zsh     # typeset -U path (auto-dedup)                                                                                
    ├── 02-exports.zsh  # setopt equivalents, compinit, REPORTTIME, AUTO_PUSHD
    ├── 03-colors.zsh                                              
    ├── 04-aliases.zsh  # + numeric dir stack jumps (1-9)          
    ├── 05-fzf.zsh                    
    ├── 06-tools.zsh    # zoxide init zsh                          
    ├── 07-functions.zsh                       
    ├── 08-prompt.zsh   # precmd-based prompt (skipped if OMZ theme active)                                                           
    ├── 09-plugins.zsh  # zsh-autosuggestions, zsh-syntax-highlighting, fastfetch                                                     
    └── omz-config.zsh  # Oh My Zsh settings (theme, plugins) — sourced before OMZ
```                                                                                                                                   
                                                                                                                                      
---                                                     
                                                                                                                                      
## Quick Start                                           
                                                                   
### 1. Copy to new machine                      
                                                                                                                                      
```bash                                                            
scp -r ~/ENV user@newmachine:~/ENV                                 
```                                                                
                                                                   
Or clone if stored in git:                                         
                                                                   
```bash
git clone <your-repo-url> ~/ENV                                                                                                                                                                                                                           16:12:29 [133/186]
```

### 2. Run installer

```bash
bash ~/ENV/install.sh
```

The installer asks which shell to configure:

```
Which shell(s) should use this config?
  1) bash
  2) zsh  (plain)
  3) zsh  + Oh My Zsh
  4) both (bash + zsh plain)
  5) both (bash + zsh + Oh My Zsh)
```

### 3. Activate

```bash
source ~/.bashrc   # bash
source ~/.zshrc    # zsh
```

---

## What install.sh Does

Installs all tools to `~/.local/bin` — **no sudo required**.

| # | Tool | Purpose |
|---|------|---------|
| 1 | `nvim` | Neovim (latest stable) |
| 2 | `rg` | ripgrep — fast grep, used by Telescope |
| 3 | `fd` | fast find, used by Telescope |
| 4 | `fzf` | fuzzy finder |
| 5 | `ctags` | universal-ctags — Tagbar (`<F8>`) |
| 6 | `stylua` | Lua formatter |
| 7 | `bat` | syntax-highlighted cat |
| 8 | `zoxide` | frecency-based smart cd (`z foo`) |
| 9 | `tldr` | simplified man pages |
| 10 | `cheat` | community cheatsheets |
| 11 | `fastfetch` | system info on terminal open |
| 12 | `black` / `ruff` / `cpplint` | Python/C++ formatters via pip |
| 13 | `bash-preexec` | preexec/precmd hooks for bash |
| 14 | `zsh-autosuggestions` | fish-like inline history suggestions |
| 15 | `zsh-syntax-highlighting` | color commands before Enter |
| 16 | `vim-plug` | plugin manager for legacy vim config |
| 17 | `nvim-update` | script to update Neovim (`nvim-update`) |
| — | Oh My Zsh | if option 3 or 5 selected |

Also:                                                                                                                                                                                                                                                      16:12:29 [79/186]
- Sets `nvim`/`vim` as default editor system-wide (`update-alternatives` or `alternatives`)
- Sets `git config --global core.editor`
- Appends `source ~/ENV/env.sh` to `~/.bashrc` and/or `~/.zshrc`

Re-run anytime — skips already-installed tools, updates outdated ones.

---

## What env.sh Provides

### Shell features

| Feature | Bash | Zsh |
|---------|------|-----|
| Arrow key prefix history search | `bind '\e[A'` | `bindkey '^[[A'` |
| Autopushd (every cd pushes stack) | `cd()` uses `pushd` | `setopt AUTO_PUSHD` |
| Auto-venv activation on `cd` | `_auto_venv()` | same |
| REPORTTIME (show elapsed ≥5s) | via bash-preexec | `REPORTTIME=5` |
| Tab completion (case-insensitive) | `bind` | `zstyle` |
| Dir stack aliases (`pd` `pp` `d`) | yes | yes + `1`-`9` jumps |
| fastfetch on login shell | `SHLVL==1` | same |

### Key aliases

| Alias | Expands to |
|-------|-----------|
| `v` / `vi` / `vim` | `nvim` |
| `vd` | `nvim -d` (diff mode) |
| `cat` | `bat --paging=never` (if bat installed) |
| `gs` | `git status -sb` |
| `gl` | `git log --oneline --graph --decorate -20` |
| `gd` | `git diff` |
| `rg` | `rg --smart-case` |
| `pd` / `pp` / `d` | pushd / popd / dirs -v |
| `py` / `pip` | python3 / pip3 |
| `ll` / `la` / `lt` | ls variants |
| `reload` | source ~/.bashrc (or .zshrc) |

### Key functions

| Function | Does |
|----------|------|
| `cd` | change dir + auto-ls + auto-venv + push to stack |
| `z foo` | jump to most-used dir matching "foo" (zoxide) |
| `mcd dir` | mkdir -p + cd |
| `up 2` | go up 2 directories |
| `extract file` | auto-detect archive type and extract |
| `backup file` | copy with `.bak.YYYYMMDD_HHMMSS` suffix |
| `ff pattern` | find file by name recursively |
| `fv` | fzf → open in nvim |
| `myip` | public IP |
| `localip` | LAN IP |
| `serve` | python3 HTTP server on port 8000 |                                                                                                                                                                                                             16:12:29 [26/186]
| `topcpu` | top 10 CPU processes |
| `colors` | show all 256 terminal colors |

### Prompt

```
000(j:0)(/home/user/projects/foo)->
^^^                                   exit code (3 digits)
    ^^^                               job count
          ^^^^^^^^^^^^^^^^^^^^^^^^^   current dir (trimmed to 3 levels)
```

---

## Oh My Zsh

When OMZ is selected, the `.zshrc` structure becomes:

```zsh
source ~/ENV/zsh/omz-config.zsh    # our OMZ settings (theme, plugins)
source ~/.oh-my-zsh/oh-my-zsh.sh   # OMZ
source ~/ENV/env.sh                 # our customizations on top
```

OMZ plugins enabled by default (see `zsh/omz-config.zsh`):

```
git  zsh-autosuggestions  zsh-syntax-highlighting  fzf  z
python  pip  sudo  colored-man-pages  command-not-found
extract  history  dirhistory
```

**To switch themes** — edit `zsh/omz-config.zsh`:
```zsh
ZSH_THEME="agnoster"         # powerline-style
ZSH_THEME="robbyrussell"     # default OMZ
ZSH_THEME=""                 # use custom prompt from 08-prompt.zsh 
```

**Notable OMZ extras:**
- Double `ESC` → prepend `sudo` to last command
- `Alt+Left/Right` → navigate directory history
- 60+ git aliases (`gcmsg`, `grb`, `glog`, `gsta`...)

---

## Disabling Modules

Comment out any line in `env.sh` to disable that module:

```bash
# source "$_D/08-prompt.sh"    # disable custom prompt (use system default)
# source "$_D/09-plugins.sh"   # disable fastfetch / bash-preexec
```

---

## Updating Tools

```bash
nvim-update          # update Neovim to latest stable
bash install.sh      # re-run full installer (skips up-to-date tools)
tldr --update        # refresh tldr page cache
```

---

## Non-interactive Install

```bash
# Skip shell prompt, wire specific target:
SHELL_TARGET=bash     bash install.sh
SHELL_TARGET=zsh      bash install.sh
SHELL_TARGET=zsh-omz  bash install.sh
SHELL_TARGET=both     bash install.sh
SHELL_TARGET=both-omz bash install.sh
```
