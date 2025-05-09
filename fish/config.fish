if status is-interactive
    # Commands to run in interactive sessions can go here
    #

    starship init fish | source
end



# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Created by `pipx` on 2025-04-09 20:15:03
set PATH $PATH /home/thw/.local/bin


alias l="exa -l --icons --grid --classify --colour=auto --sort=type --group-directories-first --header --modified --created --git --binary --group"
