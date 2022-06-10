function dotfiles --wraps='git --git-dir=/Users/jan/.dotfiles/ --work-tree=/Users/jan' --description 'alias dotfiles git --git-dir=/Users/jan/.dotfiles/ --work-tree=/Users/jan'
  git --git-dir=/Users/jan/.dotfiles/ --work-tree=/Users/jan $argv; 
end
