function cat --wraps='bat --plain' --description 'alias cat bat --plain'
    if command -s bat  
        bat --plain $argv; 
    else if command -s batcat
        batcat --plain $argv;
    else
        cat $argv;
    end
end
