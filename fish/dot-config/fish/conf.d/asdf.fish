# if test -f $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish
#     if status --is-interactive
#         source $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish
#     else if test -n "$INTELLIJ_ENVIRONMENT_READER"
#         # intellj terminal and programms called by the IDE
#         # need access to the bins installed via ASDF
#         # however, loading the usual asdf.fish causes problems and will result in no environment being loaded at all
#         # so here we only add the shims specifically when we know, we're inside the IDE
#         # maybe other paths, like ~/.asdf/installs/.../bins/...  need to be added if things don't work
#         fish_add_path $HOME/.asdf/shims
#     end
# end
