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
ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}%B %F{magenta}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f%b"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}%B 󰈸"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{blue}%B "

#git Info Status
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}%B 󰝒"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}%B 󱪡"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{magenta}%B 󱇧"
ZSH_THEME_GIT_PROMPT_MERGED="%F{cyan}%B Merge %F{blue}%B "
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}%B UNMerge %F{cyan}% "
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{cyan}%B "
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%F{cyan}%B "
ZSH_THEME_GIT_PROMPT_RENAMED="%F{blue}%B "
ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS="%F{black}%B "
ZSH_THEME_GIT_PROMPT_REMOTE_MISSING="%F{red}%B 󱓎"

# git commits ahead/behind
ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX="%F{black}%B "
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX="%f%b"
ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX="%F{black}%B "
ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX="%f%b"

# user names
function users_name() {
  local git_info=$(git_prompt_info)
  local user_name=$(git_current_user_name)

  if [[ -z $git_info || -z $user_name ]]; then
    echo "%F{white}%n%f"
  else
    echo "%F{white}% $user_name%f"
  fi
}

# directory
function get_directory() {
  local git_info=$(git_prompt_info)

  if [[ -z $git_info ]]; then
    echo "%F{cyan}%   %c%f"
  else
    echo "%F{cyan}%   %c%f"
  fi
}

# node version
function node_prompt_version {
  # local options files
  if [[ -f package.json || -f yarn.lock || -f pnpm-lock.yaml || -f tsconfig.json ]]; then
    if command -v node >/dev/null 2>&1; then
      local color="%F{cyan}% "
      local node_v="  $(node -v)"
      echo "${color}${node_v}%f"
    fi
  else
    echo ""
  fi
}

# docker
function docker_prompt {
  local color="%F{blue}% "
  local icon=""

  if is_dock_project; then
    icon="󰡨"
  fi

  local docker_prompt="${icon} $(dock_status)"
  echo "${color}${docker_prompt}%f"
}

# time
function real_time() {
  local color="%F{blue}% "
  local time="󰥔 $(date +%H:%M)"
  echo "${color}${time}%f"
}

# line
function init_line() {
  local color="%F{black}% "
  local simbol="󱞬 "
  echo "${color}${simbol}%f"
}

function init_second_line() {
  local color="%F{black}% "
  local simbol="󱞪 "
  echo "${color}${simbol}%f"
}

# final line
function final_line() {
  local color="%F{magenta}%B "
  local simbol="󰔚"
  echo "${color}${simbol}$1%f"
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
  local color_reset="%f%b"
  local reset_font="%F{white}% "

  if $1; then
    user_icon="%F{yellow}%B"
    arrow="%F{green}%B"
  else
    user_icon="%F{red}%B"
    arrow="%F{red}%B"
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

#PROMPTS
PROMPT='$(init_line)$(command_status) $(get_directory) $(git_prompt_info)$(git_prompt_status)$_linestop'
RPROMPT='%{${_lineup}%} $(docker_prompt) $(node_prompt_version) $(real_time) $(final_line ${timer_show}) %{${_linedown}%}'
PROMPT+='$(init_second_line)'
