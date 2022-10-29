#!/usr/bin/env bash
case $- in
    *i*) ;;
      *) return;;
esac

unset MAILCHECK
export BASH_IT="/home/coder/.bash_it"
export SCM_CHECK=true
export BASH_IT_THEME='powerline-multiline'
export POWERLINE_CWD_COLOR=240
export POWERLINE_CLOCK_COLOR=0
export POWERLINE_RUBY_COLOR=0
export POWERLINE_PYTHON_VENV_COLOR=52
export POWERLINE_LEFT_PROMPT='user_info scm  cwd'
export POWERLINE_RIGHT_PROMPT='k8s_context hostname clock '

export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1
export BASH_IT_RELOAD_LEGACY=1
source "$BASH_IT"/bash_it.sh
