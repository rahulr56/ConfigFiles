# Prompt — zsh equivalent of __setprompt from .bashrc.rrachapa
# Shows: exit_code (jobs) (user:dir) ->
# SKIPPED if OMZ is active with a theme (ZSH_THEME != "")
# To use this prompt with OMZ: set ZSH_THEME="" in omz-config.zsh

[[ -n "$ZSH" ]] && [[ -n "$ZSH_THEME" ]] && return

autoload -Uz add-zsh-hook vcs_info

setopt PROMPT_SUBST
PROMPT_DIRTRIM=3   # not a zsh built-in — handled via %3~ below

# Capture exit status before precmd runs
_ps_status=0
_capture_exit() { _ps_status=$?; }
add-zsh-hook precmd _capture_exit

# Format exit code as 3 digits (mirrors bash __setprompt)
_fmt_exit() {
    local s=$_ps_status
    printf '%03d' "$s"
}

# Build prompt — mirrors: LIGHTMAGENTA exit WHITE (j:jobs) (LIGHTRED user YELLOW : GREEN dir WHITE) ->
PROMPT='%B%F{magenta}$(_fmt_exit)%F{white}(%F{red}j:%j%F{white})(%F{red}%n%F{yellow}:%F{green}%3~%F{white})%f%b->'
PS2='%F{gray}>%f '

# Flush history before each prompt (mirrors history -a)
_flush_history() { fc -W 2>/dev/null || true; }
add-zsh-hook precmd _flush_history
