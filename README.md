# Private Key Space Wallet - Deployment Scripts

Deployment scripts for wallet service.

## Usage

Setting up:
  * install [git](https://git-scm.com/) - version control system 
  * install [docker](https://www.docker.com/) - containerization platform
  * install [docker-compose](https://docs.docker.com/compose/) - tool for defining and running multi-container Docker applications


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
