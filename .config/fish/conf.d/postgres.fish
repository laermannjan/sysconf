switch (uname)
    case Darwin
        # We currently need this on the apple arm chips to install the python pscyopg2-binary package
        fish_add_path -g /Applications/Postgres.app/Contents/Versions/14/bin
end
