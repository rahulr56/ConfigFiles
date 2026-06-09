# Environment Modules (module command)
# Tries zsh init locations first, then bash fallback

if ! (( $+commands[module] )); then
    for _mod_init in \
        /usr/share/Modules/init/zsh \
        /usr/share/lmod/lmod/init/zsh \
        /usr/local/lmod/lmod/init/zsh \
        /opt/modules/init/zsh \
        /opt/lmod/lmod/init/zsh \
        /etc/profile.d/modules.sh \
        /etc/profile.d/lmod.sh
    do
        if [[ -f "$_mod_init" ]]; then
            source "$_mod_init"
            break
        fi
    done
    unset _mod_init
fi

# Add site-specific module loads here:
#   module use /path/to/modulefiles
#   module load python/3.9 gcc/12
