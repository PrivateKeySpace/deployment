# Private Key Space Wallet - Deployment Scripts

Deployment scripts for wallet service.

## Usage

### TL;DR

1. Set up your system:
    * install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/)
2. Set up environment:
```bash
export PKS_AUTH_SECRET=$(openssl rand -hex 32)
export PKS_DB_PASSWORD=$(openssl rand -hex 8)
```
3. Download & run Private Key Space:
```bash
curl -sSL https://github.com/PrivateKeySpace/deployment/raw/develop/binscripts/run.sh | bash -s develop regtest
```
4. Open `http://127.0.0.1:3000/` in your browser

### Commands

Preparations:
  * install [git](https://git-scm.com/)
  * install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/)
  * clone repository

Following commands, as well as configuration files and scripts in `config` directory, are available for building, deploying and running Private Key Space Wallet manually.

Pull images from Docker Hub (must specify `FLAVOR` - flavor):
```bash
FLAVOR=demo make pull
```

Build images (must specify `FLAVOR` - flavor):
```bash
FLAVOR=regtest make build
```

Push built images to Docker Hub (must specify `FLAVOR` - flavor):
```bash
FLAVOR=regtest make push
```

Run built/pulled images (must specify `FLAVOR` - flavor, `PKS_AUTH_SECRET` - authentication secret, `PKS_DB_PASSWORD` - database password):
```bash
PKS_AUTH_SECRET=$(openssl rand -hex 32) PKS_DB_PASSWORD=$(openssl rand -hex 8) FLAVOR=regtest make run
```
Example uses [openssl](https://www.openssl.org/) to generate secret and password. 
We strongly recommend to save them in secure location to be able to relaunch the application in future.
View the values:
```bash
env | grep PKS
```

By default, [web](https://github.com/PrivateKeySpace/web) launches at `http://127.0.0.1:3000/`
and [core](https://github.com/PrivateKeySpace/core) launches at `http://127.0.0.1:3100/`.

