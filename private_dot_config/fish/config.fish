﻿## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low
set -Ux DIFFPROG (which lvim)
export EDITOR=(which lvim)
export LC_MESSAGES="C"
export LANG="en_US.UTF-8"
export QT_QPA_PLATFORM="wayland"
#export ORG_OVERRIDE="catppuccin-rfc"
## Environment setup
# Apply .profile
#source ~/.profile
export BAT_THEME="Catppuccin-mocha"
# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

if test -d ~/go/bin/ 
  if not contains -- ~/go/bin $PATH
    set -p PATH ~/go/bin 
    end 
end
if [ $XDG_SESSION_TYPE = "wayland" ]
  export MOZ_ENABLE_WAYLAND=1
else
  export MOZ_USE_XINPUT2=1
end
# function fish_prompt
#     # Setup colors
#     #Bold Colors
#     set -l bnormal (set_color -o normal)
#     set -l bblack (set_color -o brblack)
#     set -l bred (set_color -o brred)
#     set -l bgreen (set_color -o brgreen)
#     set -l byellow (set_color -o bryellow)
#     set -l bblue (set_color -o brblue)
#     set -l bmagenta (set_color -o brmagenta)
#     set -l bcyan (set_color -o brcyan)
#     set -l bwhite (set_color -o brwhite)

#     #Normal Colors
#     set -l normal (set_color normal)
#     set -l black (set_color black)
#     set -l red (set_color red)
#     set -l green (set_color green)
#     set -l yellow (set_color yellow)
#     set -l blue (set_color blue)
#     set -l magenta (set_color magenta)
#     set -l cyan (set_color cyan)
#     set -l white (set_color white)

#     set -g fish_prompt_pwd_dir_length 0
#     # Cache exit status
#     set -l last_status $status

#     # Just calculate these once, to save a few cycles when displaying the prompt
#     if not set -q __fish_prompt_hostname
#         set -g __fish_prompt_hostname (hostnamectl --static)
#     end
#     if not set -q __fish_prompt_char
#         switch (id -u)
#             case 0
#                 set -g __fish_prompt_char \u276f\u276f
#             case '*'
#                 set -g __fish_prompt_char $bgreen''$bmagenta''$bred''$byellow''$bblue''$bcyan''
#         end
#     end

#     # Configure __fish_git_prompt
#     set -g __fish_git_prompt_show_informative_status true
#     set -g __fish_git_prompt_showcolorhints true
#     set -g __fish_git_prompt_showupstream auto
#     # Color prompt char red for non-zero exit status
#     set -l pcolor $bpurple
#     if [ $last_status -ne 0 ]
#     set pcolor $bred
#     end

#     # Top
#     echo -n $bred"["$byellow"$USER"$bgreen"@"$bblue"$__fish_prompt_hostname"$bred"]"$bnormal $bred(prompt_pwd) $normal(fish_vcs_prompt)

#     # Bottom
#     echo -e "\n$__fish_prompt_char $normal"
# end
## Starship prompt
if status --is-interactive
# # ##   source ("/usr/bin/starship" init fish --print-full-init | psub)
  starship init fish | source
end

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# if test -n "$DESKTOP_SESSION"
#   set -x (gnome-keyring-daemon --start | string split "=")
# end


# Replace ls with exa
alias ls='exa  -l --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
# Common use
alias ..='cd ..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias listpkg="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
# Get fastest mirrors 
alias mirrorf="sudo reflector --verbose --latest 200 --country India --country 'South Korea' --country Australia --country Germany --country Sweden --threads 20 --sort rate --save /etc/pacman.d/mirrorlist"
alias mirrorx='sudo reflector --age 6 --latest 200 --fastest 20 --threads 20 --sort rate --protocol https --verbose --save /etc/pacman.d/mirrorlist'
# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"
# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias nv="lvim"
function circles 
     # Setup colors
    #Bold Colors
    set -l bred (set_color -o brred)
    set -l bgreen (set_color -o brgreen)
    set -l byellow (set_color -o bryellow)
    set -l bblue (set_color -o brblue)
    set -l bmagenta (set_color -o brmagenta)
    set -l bcyan (set_color -o brcyan)
    echo $bred" "$byellow" "$bgreen" "$bmagenta" "$bblue" "$bcyan" " 
end
if status --is-interactive
  circles
  # echo \n
end

