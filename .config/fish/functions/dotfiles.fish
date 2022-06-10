function dotfiles --wraps='git --git-dir=/home/flabber/.dotfiles/ --work-tree=/home/flabber' --description 'alias dotfiles git --git-dir=/home/flabber/.dotfiles/ --work-tree=/home/flabber'
  git --git-dir=/home/flabber/.dotfiles/ --work-tree=/home/flabber $argv; 
end
