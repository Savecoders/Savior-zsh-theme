# !Savior ZSH Theme

# time module load
setopt PROMPT_SUBST
zmodload zsh/datetime

#The new Line
_linestop=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'
timer_show=" 0ms"

# git Info
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[black]%}   %{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} 󰈸"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%}  "

#git Info Status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[yellow]%}󰊢 "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[magenta]%} "
ZSH_THEME_GIT_PROMPT_MERGED="%{$fg_bold[cyan]%}Merge %{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}UNMerge %{$fg_no_bold[blue]%} "

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
    echo "%{$fg_no_bold[cyan]%} %c%{$reset_color%}"
  fi
}

# node version
function node_prompt_version {

  # local options files
  if [[ -f package.json || -f yarn.lock || -f pnpm-lock.yaml || -f tsconfig.json ]]; then
    if command -v node >/dev/null 2>&1; then
      local color="%{$fg_no_bold[cyan]%}"
      local node_v="  $(node -v)"
      echo "${color}${node_v}%{$reset_color%}"
    fi
  fi
}

# docker
function docker_prompt {
  local color="%{$fg_no_bold[blue]%}"
  local docker_v="󰡨  $(dock_status)"
  echo "${color}${docker_v}%{$reset_color%}"
}

# time
function real_time() {
  local color="%{$fg_no_bold[blue]%}"
  local time="󰥔  $(date +%H:%M)"
  echo "${color}${time}%{$reset_color%}"
}

# line
function init_line() {
  local color="%{$fg_no_bold[black]%}"
  local simbol="󱞬 "
  echo "${color}${simbol}%{$reset_color%}"
}

function init_second_line() {
  local color="%{$fg_no_bold[black]%}"
  local simbol="󱞪 "
  echo "${color}${simbol}%{$reset_color%}"
}

# final line
function final_line() {
  local color="%{$fg_bold[magenta]%}"
  local simbol="󰔚"
  echo "${color}${simbol}$1%{$reset_color%}"
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
  GIT_INFO=$(git_prompt_info)
}

function git_status() {
  echo "${GIT_STATUS}"
}

function git_info() {
  echo "${GIT_INFO}"
}

# command
function update_command_status() {
  local user_icon=""
  local arrow=""
  local default=""
  local color_reset="%{$reset_color%}"
  local reset_font="%{$fg_no_bold[white]%}"

  if $1; then
    user_icon="%{$fg_bold[yellow]%}"
    arrow="%{$fg_bold[green]%}"
  else
    user_icon="%{$fg_bold[red]%}"
    arrow="%{$fg_bold[red]%}"
  fi
  default="${user_icon} $(users_name) ${arrow}"
  COMMAND_STATUS="${default}${reset_font}${color_reset}"
}

update_command_status true

function command_status() {
  echo "${COMMAND_STATUS}"
}

function preexec() {
  typeset -g _savior_cmd_start=$EPOCHREALTIME
}

function calculate_execution_time() {
  integer elapsed
  local precision_diff

  if [[ -n $_savior_cmd_start ]]; then
    # Calculate difference using native Zsh arithmetic
    precision_diff=$((EPOCHREALTIME - _savior_cmd_start))

    # Convert to ms or seconds to display
    if ((precision_diff > 1)); then
      printf -v timer_show " %.2fs" $precision_diff
    else
      integer ms=$((precision_diff * 1000))
      timer_show=" ${ms}ms"
    fi
    unset _savior_cmd_start
  else
    timer_show=" 0ms"
  fi
}

function precmd() {
  # last_cmd
  local last_cmd_return_code=$?
  local last_cmd_result=true

  if [ "$last_cmd_return_code" = "0" ]; then
    last_cmd_result=true
  else
    last_cmd_result=false
  fi

  calculate_execution_time

  # update_git_status
  update_git_status
  # update_git_info
  update_git_info
  # update_command_status
  update_command_status $last_cmd_result
}

# TODO: refactor TIME RENDER TRAPALRM
# # set option
# setopt PROMPT_SUBST;
# TMOUT=1;

# function TRAPALRM() {
#     if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
#         zle reset-prompt;
#     fi
# }

#PROMPTS
PROMPT='$(init_line)$(command_status) $(get_directory) $(git_prompt_info)$(git_prompt_status)$_linestop'
RPROMPT='%{${_lineup}%} $(docker_prompt) $(node_prompt_version) $(real_time) $(final_line ${timer_show} ) %{${_linedown}%}'
PROMPT+='$(init_second_line)'
