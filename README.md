# thomas_docker

## How to build
`cd dockerfiles && ./build.sh [DIR]`, where DIR can be `core` or `dev`.

## How to use
- `./start.sh`: start (continue exited container or start a new container)
- `./stop.sh`: stop (do not remove container)
- `./remove.sh`: remove container
- `./pause.sh`: pause the container; do not stop
- `./unpause.sh`: unpause
- `./into.sh`: go into the container

You can also run `./thomas_steup.sh` or put it in `~/.zshrc` (zsh is used by default). It will ask to whether start or go into docker.
