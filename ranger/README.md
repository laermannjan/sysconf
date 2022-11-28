# Ranger
In order to have images displayed, we use `kitty` and set the appropriate settings in ranger's `rc.conf`.
Additionally, on mac, we need `Pillow` to be installed in the used python installation.
This is not necessarily asdf or system python.
Start `ranger` and run `eval import sys; print(sys.executable)` to find the used python.
Then use `pip` in that same directory to install `Pillow`
