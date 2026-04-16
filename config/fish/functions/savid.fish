function savid --description "Save an HLS stream, name it nicely, and tag metadata"
    argparse 'r/referer=' 'c/cookie=' 's/show=' 'y/year=' 'e/episode=' 'a/artist=' 't/title=' 'f/force' 'T/no-artist-title' 'h/help' -- $argv
    or return 1

    if set -q _flag_help
        echo "savid — save an HLS stream, name it nicely, and tag metadata."
        echo
        echo "Downloads a video from an .m3u8 playlist URL using yt-dlp, builds a"
        echo "clean filename from the show/season/episode/artist/title you provide,"
        echo "and writes matching metadata tags via exiftool."
        echo
        echo "Usage: savid [OPTIONS] URL"
        echo
        echo "Options:"
        echo "  -r, --referer   Referer URL"
        echo "  -c, --cookie    Cookie header string (or set DLCOOKIE env var)"
        echo "  -t, --title     Episode title"
        echo "  -s, --show      Show name"
        echo "  -y, --year      Year / season"
        echo "  -e, --episode   Episode number"
        echo "  -a, --artist    Artist name"
        echo "  -f, --force     Ignore yt-dlp download cache (re-download)"
        echo "  -T, --no-artist-title  Don't prefix title tag with artist name"
        echo "  -h, --help      Show this help"
        echo
        echo "Required: URL (positional), --title. All others are optional."
        echo
        echo "Examples:"
        echo "  savid 'https://example.com/playlist.m3u8' -t 'My Episode' \\"
        echo "      -r 'https://example.com/watch' -s 'Cool Show' -y 2026 -e 3 -a 'John Doe'"
        echo
        echo "  savid 'https://example.com/playlist.m3u8' -t 'My Episode'"
        echo
        echo "  DLCOOKIE='session=abc123' savid 'https://example.com/playlist.m3u8' -t 'My Episode'"
        echo
        echo "Finding the .m3u8 URL:"
        echo "  Open your browser's developer tools (F12) and go to the Network tab."
        echo "  Filter by 'm3u8'. Start playing the video — the playlist request will"
        echo "  appear in the list. Right-click it and copy the URL. While you're there,"
        echo "  you can also grab the Referer from the request headers."
        echo "  This works the same in both Chrome and Firefox."
        echo
        echo "Getting a cookie value:"
        echo "  Some sites require authentication cookies to serve the stream. In the"
        echo "  Network tab, click the .m3u8 request, find the 'Cookie' header under"
        echo "  Request Headers, and copy its value. You can also find cookies under"
        echo "  Application > Cookies (Chrome) or Storage > Cookies (Firefox)."
        echo "  Pass the value via -c/--cookie or the DLCOOKIE environment variable."
        echo "  The env var is handy when downloading multiple episodes from the same"
        echo "  site so you don't have to repeat the cookie each time."
        echo
        echo "See also:"
        echo "  savid-retag — re-tag existing MP4 files from savid-style filenames."
        echo "  Run 'savid-retag --help' for details."
        return 0
    end

    # --- URL is the positional argument ---
    if test (count $argv) -lt 1
        echo "Error: missing playlist URL." >&2
        echo "Run with --help for usage." >&2
        return 1
    end
    set -l url $argv[1]

    # --- Validate required flags ---
    if not set -q _flag_title
        echo "Error: missing required argument: --title" >&2
        echo "Run with --help for usage." >&2
        return 1
    end

    # --- Check for yt-dlp ---
    if not command -q yt-dlp
        echo "Error: yt-dlp is required but not found." >&2
        return 1
    end

    # --- Resolve cookie: flag takes precedence over env var ---
    set -l cookie
    if set -q _flag_cookie
        set cookie "$_flag_cookie"
    else if set -q DLCOOKIE; and test -n "$DLCOOKIE"
        set cookie "$DLCOOKIE"
    end

    # --- Build filename ---
    # Pattern: [Show - ][S{year}][E{episode}][ - ][Artist - ]Title.mp4
    # Show/year/episode tag only appears when show or year is present.
    # Episode alone (no show, no year) goes to exif only.

    set -l parts

    if set -q _flag_show
        set -a parts (_savid_sanitize "$_flag_show")

        # Build S{year}E{episode} tag
        set -l tag ""
        if set -q _flag_year
            set tag "S$_flag_year"
        end
        if set -q _flag_episode
            set tag "$tag"E(string pad -w 2 --char 0 "$_flag_episode")
        end
        if test -n "$tag"
            set parts[-1] "$parts[-1] - $tag"
        end
    else if set -q _flag_year
        # No show — use year plainly
        set -a parts "$_flag_year"
    end

    if set -q _flag_artist
        set -a parts (_savid_sanitize "$_flag_artist")
    end

    set -a parts (_savid_sanitize "$_flag_title")

    set -l filename (string join " - " $parts).mp4

    echo
    echo "Downloading → $filename"
    echo

    # --- Build yt-dlp command ---
    set -l yt_args \
        --no-warnings \
        -o "$filename" \
        --merge-output-format mp4

    if set -q _flag_referer
        set -a yt_args --referer "$_flag_referer"
    end

    if test -n "$cookie"
        set -a yt_args --add-header "Cookie: $cookie"
    end

    if set -q _flag_force
        set -a yt_args --no-download-archive --force-overwrites
    end

    yt-dlp $yt_args -- "$url"

    if test $status -ne 0
        echo "Error: yt-dlp download failed." >&2
        return 1
    end

    # --- Write metadata with exiftool (if available) ---
    if command -q exiftool
        set -l exif_args -overwrite_original

        if set -q _flag_artist; and not set -q _flag_no_artist_title
            set -a exif_args -Title="$_flag_artist: $_flag_title"
        else
            set -a exif_args -Title="$_flag_title"
        end

        if set -q _flag_artist
            set -a exif_args -Artist="$_flag_artist"
        end
        if set -q _flag_show
            set -a exif_args -TVShow="$_flag_show"
        end
        if set -q _flag_year
            set -a exif_args -Year="$_flag_year"
            set -a exif_args -TVSeason="$_flag_year"
        end
        if set -q _flag_episode
            set -a exif_args -TVEpisode=(string pad -w 2 --char 0 "$_flag_episode")
        end

        exiftool $exif_args "$filename"

        if test $status -ne 0
            echo "Warning: exiftool tagging failed." >&2
        else
            echo
            echo "Metadata written with exiftool."
        end
    else
        echo
        echo "Note: exiftool not found — metadata not written."
    end

    echo
    echo "Done: $filename"
end
