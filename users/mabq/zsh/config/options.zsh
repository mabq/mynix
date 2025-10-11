# --- General options ---

# - Don't beep on error
setopt no_beep

# - Allow comments even in interactive shells
setopt interactive_comments

# - Show completion menu on successive tab press (needs unsetop menu_complete to work)
setopt auto_menu

# - Do not autoselect the first completion entry
unsetopt menu_complete

# - Allow completion from within a word/phrase
setopt complete_in_word

# - Spelling correction for commands
# setopt correct

# - Extended globbing, awesome!
setopt extendedGlob

# - Disable pause/resume output (Ctrl-s/Ctrl-q)
unsetopt flowcontrol


# --- History options ---

# None of this is necessary anymore. Atuin is used for history.

# - Share history file accross all zsh instances
# setopt share_history

# - Write each new command to the history file as soon as it's entered, rather than waiting until the end of the session
# setopt inc_append_history

# - Save timestamp and command duration
# setopt extended_history

# - Ignore all duplicate commands, regardless of whether they are consecutive or not
# setopt hist_ignore_all_dups

# - Loose oldest duplicates first
# setopt hist_expire_dups_first

# - Any command that starts with a space character will not be recorded in the command history --- useful to prevent accidentally storing sensitive or irrelevant commands in your history
# setopt hist_ignore_space

# - Remove extra blanks from each command line being added to history
# setopt hist_reduce_blanks

# - Show the recalled command on the command line for you to review
# setopt hist_verify

