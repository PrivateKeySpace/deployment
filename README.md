# Private Key Space Wallet - Deployment Scripts

Deployment scripts for wallet service.

## Usage

### TL;DR

Set up your system:
  * install [git](https://git-scm.com/)
  * install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/)

Download, build & run Private Key Space:
```bash
curl -sSL https://github.com/PrivateKeySpace/deployment/raw/master/binscripts/run.sh | bash -s demo develop
```

### Commands

Following commands, as well as configuration files and scripts in `flavors` directory, are available for building, deploying and running Private Key Space manually.

Create build (must specify flavor with `FLAVOR`, must specify branch with `BRANCH`):
```bash
$ FLAVOR=demo BRANCH=develop make build
```

Run created build (must specify flavor with `FLAVOR`):
```bash
$ FLAVOR=demo make run
```

## Flavors

### Demo

Demo deployment flavor has all application code and dependencies packed into single Docker image.

On run, [web](https://github.com/PrivateKeySpace/core) will be launched at `http://127.0.0.1:3000/`
and [core](https://github.com/PrivateKeySpace/core) will be launched at `http://127.0.0.1:3100/`.
