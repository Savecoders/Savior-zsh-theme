# directory
function directory() {
    echo "%{$fg_bold[magenta]%} %c%{$reset_color%}";
}
# time
function real_time() {
    local color="%{$fg_no_bold[cyan]%}";                   
    local time=" $(date +%H:%M:%S)";
    local reset_color="%{$reset_color%}";
    echo "${color}${time}${reset_color}";
}
# git Info 
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}%{$fg_bold[red]%}  ";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%} 🔥";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%} Commit %{$fg_bold[cyan]%} ";
#git Info Status 
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[red]%} ";
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}- ";
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[magenta]%} %{$fg_bold[cyan]%} ";
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[blue]%}Merge %{$fg_bold[cyan]%} ";

function update_git_status() {
    GIT_STATUS=$(git_prompt_status);
    
}
function update_git_info() {
    GIT_INFO=$(git_prompt_info);
}
function git_status() {
    echo "${GIT_STATUS}"
}
function git_info() {
    echo "${GIT_INFO}"
}
username() {
   echo "%{$fg_bold[white]%}%n%{$reset_color%}"
}

# command
function update_command_status() {
    local user="";
    local line="";
    local default="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";

    if $1;
    then
        user="%{$fg_bold[cyan]%} ";
        line="%{$fg_bold[green]%} ";
    else
        user="%{$fg_bold[red]%} ";
        line="%{$fg_bold[red]%} ";
    fi
    default="${user}$(username)${line}";
    COMMAND_STATUS="${default}${reset_font}${color_reset}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}

current_time_millis() {
    local time_millis;
    if [[ "$OSTYPE" == "linux-gnu" ]]; 
        then
        time_millis="$(date +%s.%3N)";
    elif [[ "$OSTYPE" == "darwin"* ]]; 
        then
        time_millis="$(gdate +%s.%3N)";
    else
        # Unknown.
    fi
    echo $time_millis;
}
preexec() {
    COMMAND_TIME_BEIGIN="$(current_time_millis)";
}
precmd() {
    # last_cmd
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi
    # update_git_status
    update_git_status;
     # update_git_info
    update_git_info;
    # update_command_status
    update_command_status $last_cmd_result;
}
# set option
setopt PROMPT_SUBST;
TMOUT=1;

TRAPALRM() {
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}

PROMPT='$(command_status) $(directory) $(git_info)$(git_status)';
RPROMPT='$(real_time)';