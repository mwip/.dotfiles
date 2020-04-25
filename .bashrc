#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias ..='cd ..'
alias ll='ls -alh --color=auto'


export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nano

alias pacman-autoremove='sudo pacman -Rsn $(pacman -Qdtq)'
alias t='echo "" && todo.sh'
alias ct="clear && t"

# coloring
# export TERM=xterm-color
# export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
# export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad


# powerline
#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#. /usr/share/powerline/bindings/bash/powerline.sh



source /opt/OTB-7.0.0-Linux64/otbenv.profile
