# SSH

The private ssh key is encrypted with `age`, see README.md there for more info.

Always name your key `id_ed25519`, the script that decrypts secret files expects to find a key with that name.

## Outside configurations

A shell environment variable called `SSH_AUTH_SOCK` is required for applications to know how to talk to the agent. The content of this variable depends on the Linux distro.
