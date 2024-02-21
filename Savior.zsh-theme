# !Savior ZSH Theme

#The new Line
_linestop=$'\n';
_lineup=$'\e[1A';
_linedown=$'\e[1B';
timer_show=" 0ms";

# git Info 
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}  %{$fg_bold[red]%}  ";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%}";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[yellow]%} Commit %{$fg_bold[cyan]%}" ;
#git Info Status 
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[red]%} ";
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}  "; #%{$fg_bold[magenta]%}🔥
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%} ";
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}Merge %{$fg_bold[cyan]%} ";

# user names
function users_name() {
    local git_info=$(git_prompt_info)
    local user_name=$(git_current_user_name)
    
    if [[ -z $git_info || -z $user_name ]]; then
        echo "%{$fg_bold[white]%}%n%{$reset_color%}"
    else        
        echo "%{$fg_bold[white]%}% $user_name%{$reset_color%}"
    fi
}

# directory
function get_directory() {
    local git_info=$(git_prompt_info)
    
    if [[ -z $git_info ]]; then
        echo "%{$fg_no_bold[cyan]%} %c%{$reset_color%}"
    else 
        echo "%{$fg_no_bold[cyan]%} %c%{$reset_color%}";  
    fi     
}

# time
function real_time() {
    local color="%{$fg_no_bold[blue]%}";                   
    local time="󰥔 $(date +%H:%M:%S)";
    echo "${color}${time}%{$reset_color%}";
}

# line
function init_line(){
    local color="%{$fg_no_bold[black]%}"; 
    local simbol="󱞬 ";
    echo "${color}${simbol}%{$reset_color%}";
}

function init_second_line(){
    local color="%{$fg_no_bold[black]%}"; 
    local simbol="󱞪 ";
    echo "${color}${simbol}%{$reset_color%}";
}
# final line
function final_line(){
    local color="%{$fg_bold[magenta]%}"; 
    local simbol="󱦟";
    echo "${color}${simbol}$1%{$reset_color%}";    
}

# update git status
function update_git_status() {
    if command -v git >/dev/null 2>&1; then
        GIT_STATUS=$(git_prompt_status)
    else
        GIT_STATUS="Git not found"
    fi
}
# update git info
function update_git_info() {
    GIT_INFO=$(git_prompt_info);
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
        user="%{$fg_bold[yellow]%} ";
        line="%{$fg_bold[green]%} ";# 
    else
        user="%{$fg_bold[red]%} ";
        line="%{$fg_bold[red]%} ";#
    fi
    default="${user}$(users_name)${line}";
    COMMAND_STATUS="${default}${reset_font}${color_reset}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}

function current_time_millis() {
    local time_millis;
    if [[ "$OSTYPE" == "linux-gnu" ]]; 
        then
        time_millis="$(date +%s.%3N)";
    elif [[ "$OSTYPE" == "darwin"* ]]; 
        then
        time_millis="$(gdate +%s.%3N)";
    else
        echo "Unknown OS"
    fi
    echo $time_millis;
}
function preexec() {
    timer=$(($(date +%s%0N)/1000000))
    COMMAND_TIME_BEIGIN="$(current_time_millis)";
}
function precmd() {
    # last_cmd
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    if [ $timer ]; then
        now=$(($(date +%s%0N)/1000000))
        elapsed=$(($now-$timer))
        if [ $elapsed -ge 1000 ]; then
            elapsed=$(($elapsed/1000))
            timer_show=" ${elapsed}s"
        else
            timer_show=" ${elapsed}ms"
        fi
        unset timer
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

function TRAPALRM() {
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}

#PROMPTS
PROMPT='$(init_line)$(command_status) $(get_directory)${GIT_INFO}${GIT_STATUS}$_linestop';
RPROMPT='%{${_lineup}%}$(real_time) $(final_line ${timer_show} ) %{${_linedown}%}';
PROMPT+='$(init_second_line)';
