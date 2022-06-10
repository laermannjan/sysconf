function la --wraps='exa --group-directories-first --color-scale --git --header --group --classify --long --all' --description 'exa directory list view with hidding files'
  if command -s exa
      exa --group-directories-first --color-scale --git --header --group --classify --long --all $argv; 
  else
      ll $argv;
  end
end
