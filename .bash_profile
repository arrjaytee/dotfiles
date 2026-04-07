if [[ -v SSH_ORIGINAL_COMMAND ]]; then
    echo "Running SSH wrapper command, ignoring profile."
    exit 0
fi

if [ "${ENVSET}" != "true" ] ; then
    [ -f "$HOME/.bashrc" ] && . $HOME/.bashrc
fi
