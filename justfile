_default:
    just --list

[positional-arguments]
[private]
parallog +args:
    #!/usr/bin/env bash
    trap "kill 0" EXIT SIGINT SIGTERM
    align=$((1 + `printf "%s\n" "$@" | wc -L`))
    while (("$#")); do
        color=$((31 + ("$#" % 6)))
        prefix=`printf "\033[${color};m%+${align}s\033[0m" "$1"`
        FORCE_COLOR=1 just $1 2>&1 | sed "s/^/${prefix} │ /;" &
        shift
    done
    wait -n

[private]
main-typst:
    typst watch neverdeck.typ

[private]
main-zathura:
    zathura neverdeck.pdf

[private]
diff-zathura:
    zathura diff.pdf

diff:
    watchexec -w neverdeck.pdf 'nix run nixpkgs#diff-pdf -- -g --output-diff=diff.pdf ../a4frontp1p2.pdf neverdeck.pdf'

main:
    just parallog main-typst main-zathura diff diff-zathura

