#!/usr/bin/env bash
# Environment Modules (module command)
# Tries common init locations — no-op if not installed or already loaded

if ! command -v module &>/dev/null; then
    for _mod_init in \
        /usr/share/Modules/init/bash \
        /usr/share/lmod/lmod/init/bash \
        /usr/local/lmod/lmod/init/bash \
        /opt/modules/init/bash \
        /opt/lmod/lmod/init/bash \
        /etc/profile.d/modules.sh \
        /etc/profile.d/lmod.sh
    do
        if [ -f "$_mod_init" ]; then
            source "$_mod_init"
            break
        fi
    done
    unset _mod_init
fi

# Add site-specific module loads here (machine-dependent):
#   module use /path/to/modulefiles
#   module load python/3.9 gcc/12
