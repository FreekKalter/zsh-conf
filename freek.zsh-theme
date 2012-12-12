# ZSH Theme emulating the Fish shell's default prompt.

local user_color='green';# [ $UID -eq 0 ] && user_color='red'
PROMPT='%{$fg_bold[blue]%}%n@%m%{$reset_color%} %{$fg[$user_color]%}\
%~%{$reset_color%}\
$(git_prompt_info)$(git_prompt_status)\
${$(vi_mode_prompt_info):-%(!.#.>)} '

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'

MODE_INDICATOR="%{$fg_bold[red]%}%(!.#.>)%{$reset_color%}"
RPS1='${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?%{$reset_color%}"
