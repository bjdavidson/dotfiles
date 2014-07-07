function compute_host_completion
{
  local -a completions

  for i in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config; do
    if [ -r "$i" ]; then
      completions=(${(@)completions} ${(z)${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}})
    fi
  done

  for i in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts; do
    if [ -r "$i" ]; then
      completions=( \
        ${(@)completions} \
        ${${${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}#\[}%\]*} \
        )
    fi
  done

  zstyle ':completion:*:*:*' hosts "${(@u)completions}"
}
compute_host_completion

function reload
{
  for rcfile in zshenv zprofile zshrc zlogin; do
    if [[ -r ~/.${rcfile} ]]; then
      echo "reloading ${rcfile}..." 1>&2
      source ~/.${rcfile}
    fi
  done
  compute_host_completion
}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH/cache"
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH/cache"

setopt dvorak

unsetopt correctall
setopt correct

alias copy-last-command='fc -l -n -1 -1 | tr -d "\n" | pbcopy'

# EOF
