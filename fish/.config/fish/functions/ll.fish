function ll --wraps='exa --group-directories-first --color-scale --git --header --group --classify --long' --description 'exa directory list view'
  if command -s exa
      exa --group-directories-first --color-scale --git --header --group --classify --long $argv; 
  else
      ll $argv;
  end
end
