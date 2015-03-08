#!/bin/bash

PROMPTER_PLUGS_DIR="${HOME}/prompter/plugs"
PROMPTER_CONFS_DIR="${HOME}/prompter/confs"
PROMPTER_PROMPTS_DIR="${HOME}/prompter/prompts"

declare -A PROMPTER_COLS
PROMPTER_COLS[OFF]="\e[0m"
PROMPTER_COLS[LIGHT]="\e[1m"
PROMPTER_COLS[UNDERLINE]="\e[4m"
# foregrounds
PROMPTER_COLS[GRAY]="\e[30m"
PROMPTER_COLS[RED]="\e[31m"
PROMPTER_COLS[GREEN]="\e[32m"
PROMPTER_COLS[YELLOW]="\e[33m"
PROMPTER_COLS[BLUE]="\e[34m"
PROMPTER_COLS[MAGENTA]="\e[35m"
PROMPTER_COLS[CYAN]="\e[36m"
PROMPTER_COLS[WHITE]="\e[37m"
# backgrounds
PROMPTER_COLS[GRAYBG]="\e[40m"
PROMPTER_COLS[REDBG]="\e[41m"
PROMPTER_COLS[GREENBG]="\e[42m"
PROMPTER_COLS[YELLOWBG]="\e[43m"
PROMPTER_COLS[BLUEBG]="\e[44m"
PROMPTER_COLS[MAGENTABG]="\e[45m"
PROMPTER_COLS[CYANBG]="\e[46m"
PROMPTER_COLS[WHITEBG]="\e[47m"

declare -A PROMPTER_PLUGINS

function _prompter_read_plugins
{
    local filename
    for filename in $PROMPTER_PLUGS_DIR/*.plug; do
        source $filename
        PROMPTER_PLUGINS[$NAME]=$OUT
        unset NAME DESC OUT
    done
}

function prompter_apply
{
    local name=$(cat $PROMPTER_CONFS_DIR/current 2> /dev/null)
    if [ ! -e $PROMPTER_PROMPTS_DIR/${name}.prompt ]; then
        echo "No prompt selected, please run: prompter_select"
        return
    fi
    source "$PROMPTER_PROMPTS_DIR/${name}.prompt"
    local prompt=$PROMPT
    unset NAME DESC PROMPT
    for name in "${!PROMPTER_PLUGINS[@]}"; do
        prompt=${prompt//#${name}#/${PROMPTER_PLUGINS[$name]}}
    done
    for name in "${!PROMPTER_COLS[@]}"; do
        prompt=${prompt//_${name}_/${PROMPTER_COLS[$name]}}
    done
    export PS1="${prompt}${PROMPTER_COLS[OFF]}"
}

function prompter_select
{
    echo "Available prompts:"
    local prompts=()
    local i=1
    local filename
    local current=$(cat $PROMPTER_CONFS_DIR/current 2> /dev/null)
    local cur
    for filename in $PROMPTER_PROMPTS_DIR/*.prompt; do
        source $filename
        prompts[$i]=$NAME
        [ "${prompts[$i]}" == "$current" ] && cur="*" || cur=" "
        echo -e "$i) ${cur}${prompts[$i]} \t$DESC"
        let i++
        unset NAME DESC PROMPT
    done
    # echo "[Create Delete Modify]"
    read -p "Make your choice: "
    case $REPLY in
        # c|C) echo "CREATE";;
        # d|D) echo "DELETE";;
        # m|M) echo "MODIFY";;
        *)
            echo ${prompts[$REPLY]} > $PROMPTER_CONFS_DIR/current
            prompter_apply
        ;;
    esac
}

# main
_prompter_read_plugins
prompter_apply
