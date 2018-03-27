# Private Key Space Wallet - Deployment Scripts
Deployment scripts for wallet service.

## Usage

Setting up:
  * install [git](https://git-scm.com/) - version control system 
  * install [docker](https://www.docker.com/) - containerization platform
  * install [docker-compose](https://docs.docker.com/compose/) - tool for defining and running multi-container Docker applications


Create build (specify flavor with `FLAVOR`, specify branch with `BRANCH`):
```bash
$ FLAVOR=demo BRANCH=develop make build
```
