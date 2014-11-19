autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh
# colors
typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {000..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done


ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}

# Show all 256 colors with color number
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}$ZSH_SPECTRUM_TEXT%f"
  done
}

# Show all 256 colors where the background is set to specific color
function spectrum_bls() {
  for code in {000..255}; do
    print -P -- "$BG[$code]$code: $ZSH_SPECTRUM_TEXT %{$reset_color%}"
  done
}
#COLOR END


if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo " ($(git_prompt_info)%{$fg_bold[green]%} ●%{$reset_color%}$(need_push))"
    else
      echo " ($(git_prompt_info)%{$fg_bold[red]%} ●%{$reset_color%}$(need_push))"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo "╌unpushed%{$reset_color%}"
  fi
}



directory_name(){
  echo "%{$reset_color%}$FG[111]%~%{$reset_color%}"
}

export PROMPT=$'\n%n@%m $(directory_name)$(git_dirty)\n%{$fg_bold[grey]%}$%{$reset_color%} '
set_prompt () {
  export RPROMPT='%{$(echotc UP 1)%}%{$FG[111]%}%}%D{%a %H:%M}%{$reset_color%}%{$(echotc DO 1)%}%{$reset_color%}'
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
