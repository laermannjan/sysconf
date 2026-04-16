function savid-retag --description "Re-tag MP4 files in a directory using metadata parsed from savid filenames"
    argparse 'T/no-artist-title' 'h/help' -- $argv
    or return 1

    if set -q _flag_help
        echo "savid-retag — re-tag MP4 files from savid-style filenames."
        echo
        echo "Parses filenames matching the pattern:"
        echo "  Show - S{year}E{episode} - Artist - Title.mp4"
        echo
        echo "and writes matching metadata tags via exiftool."
        echo
        echo "Usage: savid-retag [OPTIONS] FILE..."
        echo
        echo "Options:"
        echo "  -T, --no-artist-title  Don't prefix title tag with artist name"
        echo "  -h, --help             Show this help"
        echo
        echo "Examples:"
        echo "  savid-retag /path/to/videos/*.mp4"
        echo "  savid-retag 'Cool Show - S2026E03 - John Doe - My Episode.mp4'"
        return 0
    end

    if not command -q exiftool
        echo "Error: exiftool is required but not found." >&2
        return 1
    end

    if test (count $argv) -eq 0
        echo "Error: no files specified." >&2
        echo "Run with --help for usage." >&2
        return 1
    end

    set -l count 0
    set -l exif_args

    for file in $argv
        # glob returns the pattern literally when nothing matches
        if not test -f "$file"
            continue
        end

        set -l name (string replace -r '\.mp4$' '' (path basename "$file"))

        # Split on " - "
        set -l parts (string split " - " "$name")

        if test (count $parts) -lt 4
            echo "Skipping (unexpected format): "(path basename "$file") >&2
            continue
        end

        set -l show $parts[1]
        set -l tag $parts[2]
        set -l artist $parts[3]
        # Title may contain " - " so rejoin remaining parts
        set -l title (string join " - " $parts[4..])

        # Parse S{year}E{episode} from tag
        set -l year ""
        set -l episode ""
        if string match -rq '^S(\d+)E(\d+)$' "$tag"
            set year (string match -r '^S(\d+)E(\d+)$' "$tag")[2]
            set episode (string match -r '^S(\d+)E(\d+)$' "$tag")[3]
        else
            echo "Skipping (cannot parse season/episode from '$tag'): "(path basename "$file") >&2
            continue
        end

        # Separate batched commands with -execute
        if test $count -gt 0
            set -a exif_args -execute
        end

        set -a exif_args -overwrite_original

        if not set -q _flag_no_artist_title
            set -a exif_args -Title="$artist: $title"
        else
            set -a exif_args -Title="$title"
        end

        set -a exif_args -Artist="$artist"
        set -a exif_args -TVShow="$show"
        set -a exif_args -Year="$year"
        set -a exif_args -TVSeason="$year"
        set -a exif_args -TVEpisode="$episode"
        set -a exif_args "$file"

        echo "Tagging: "(path basename "$file")
        set count (math $count + 1)
    end

    if test $count -eq 0
        echo "No files to tag."
        return 0
    end

    exiftool $exif_args

    if test $status -ne 0
        echo "Warning: exiftool tagging failed." >&2
    end

    echo
    echo "Done: $count file(s) tagged."
end
