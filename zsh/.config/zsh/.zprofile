# [[ $OSTYPE == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
# Speed things up not having to run brew each time zsh starts

# Check if the system is macOS (Darwin)
if [[ $OSTYPE == "darwin"* ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"

    # Prepend Homebrew paths and ensure PATH and MANPATH are updated
    path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" "$path[@]")
    # export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$HOME/.local/bin:$HOME/.nvm/versions/node/v20.17.0/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/MacGPG2/bin:/Library/TeX/texbin"

    # Adjust MANPATH
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"

    # Set INFOPATH for Homebrew
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
fi
