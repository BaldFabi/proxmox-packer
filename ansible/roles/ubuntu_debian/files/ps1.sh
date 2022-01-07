if [[ $EUID -ne 0 ]]; then
	UC="15"
else
	UC="196"
fi

PS1="\n\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;208m\][\[$(tput sgr0)\]\[\033[38;5;${UC}m\]\u\[$(tput sgr0)\]\[\033[38;5;250m\]@\h\[$(tput sgr0)\]\[\033[38;5;208m\]]\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;250m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;250m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]\n\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;208m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
