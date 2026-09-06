function split-audiobook --description 'Split m4b into per-chapter files; album-split so no track value exceeds 255 (Garmin 8-bit overflow workaround)'
    set -l input $argv[1]
    set -l outdir (string replace -r '\.m4b$' '' $input)

    # Album name from source tags; fall back to filename (sans extension)
    set -l album (ffprobe -v error -show_entries format_tags=album \
        -of default=noprint_wrappers=1:nokey=1 $input)
    test -z "$album"; and set album (basename $outdir)

    # Warn (but continue) if artist / album_artist are missing or disagree —
    # the Garmin player splits albums apart when they differ.
    set -l artist (ffprobe -v error -show_entries format_tags=artist \
        -of default=noprint_wrappers=1:nokey=1 $input)
    set -l albumartist (ffprobe -v error -show_entries format_tags=album_artist \
        -of default=noprint_wrappers=1:nokey=1 $input)
    if test -z "$artist" -o -z "$albumartist"
        echo "WARNING: artist or album_artist is empty — Garmin may split the album." >&2
    else if test "$artist" != "$albumartist"
        echo "WARNING: artist ('$artist') != album_artist ('$albumartist') — Garmin may split the album." >&2
    end

    # Split losslessly into a dir named after the input file
    m4b-tool split --no-conversion -o $outdir $input; or return 1

    # Album-split: every 255 chapters becomes a new "(Teil N)" album,
    # track restarts at 1 per part so it never overflows 8 bit.
    set -l total (count $outdir/*.m4b)
    set -l multipart (test $total -gt 255; and echo 1; or echo 0)
    for f in $outdir/*.m4b
        set -l n (math (string match -r '[0-9]+' (basename $f)))
        set -l track (math "($n - 1) % 255 + 1")
        if test $multipart -eq 1
            set -l part (math "floor(($n - 1) / 255) + 1")
            mp4tags -album "$album (Teil $part)" -track $track $f
        else
            mp4tags -album "$album" -track $track $f
        end
    end
end
