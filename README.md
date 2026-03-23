# Docker-Pi Setup

Run [pi-coding-agent](https://pi.dev/) inside a docker container every time.

## How to use

```bash
git clone https://github.com/foertel/docker-pi-coding-agent.git
cd ~/projects/yourFolder/somewhere
~/docker-pi-coding-setup/dock.sh
```

The script will build an image, containing the current pi-coding-agent. It will start a container for each project, it is run in. Bind-Mount that folder and your `~/.pi` configuration, so you can share your config amongst all your containers.

### Upgrade to new version

```bash
cd ~/docker-pi-coding-agent
./dock.sh upgrade
```

Does not stop running containers, so you would have to `dock.sh stop && dock.sh attach`.

@TODO pi, why is this not a feature to check if the container is running on the latest image?

## Features

### Bind Mount $(pwd)

The directory you run the script in is mounted to the same path inside the container. This makes pi use the same session paths all the time and you can switch between pi on the host, pi in the continer and pi everywhere and still have one shared history, branches, forking, etc.

### Bind Mount ~/.pi

Only login once and use that config plus AGENTS.md, plugins, etc pp in all your containers.

### Env File ~/.pi/.env

All the stuff you put in `~/.pi/.env` will be env variable inside your container. Use this to set UIDs, different home directories or maybe set API keys (you probably shouldn't do that. I do. What do I know?).

# License

I don't care. Do whatever you want ...