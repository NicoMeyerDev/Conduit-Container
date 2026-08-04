# Conduit Container

## Table of Contents

* [Prerequisites](#prerequisites)
* [Quickstart](#quickstart)
* [Usage](#usage)
    * [Data Persistence](#data-persistence)
    * [Container Restart Policy](#container-restart-policy)
    * [Secrets Management](#secrets-management)


## Prerequisites

To install and run this environment, make sure the following software is installed on your system:

- Docker (latest version)


## Quickstart

### Clone the repository

```bash
git clone --recurse-submodules github.com/NicoMeyerDev/Conduit-Container.git
```

### Initialize submodules

```bash
git submodule update --init --recursive
```

### Navigate to the project

```bash
cd Conduit-Container
```

### Configure the application

Rename the provided example configuration file:

```bash
cp example.env .env
```
> [!NOTE]
> Edit the `.env` file and configure the required environment variables.

At minimum you should set:

- `DJANGO_SECRET_KEY`
- `POSTGRES_PASSWORD`
- `DJANGO_ALLOWED_HOSTS` (add your server's IP address if deploying to a VM)

### Build the Docker images

```bash
docker compose build
```

### Start the application

```bash
docker compose up -d
```

### Open the application
http://<HOST_IP>:8282


## Usage

### Data Persistence

The PostgreSQL data is stored in a named Docker volume (`postgres_data`), which is mounted to `/var/lib/postgresql/data` inside the database container. This ensures that your data survives container restarts. Running `docker compose down` keeps the volume intact, while `docker compose down -v` removes it permanently, resetting the database.

### Container Restart Policy

All services are configured with `restart: unless-stopped`. This means containers automatically restart after a crash or system reboot, but will not restart if they were stopped manually.

### Secrets Management

Sensitive configuration (database credentials, Django secret key) is never stored in the codebase. Instead, values are provided via a `.env` file, which is excluded from version control via `.gitignore`. Copy `example.env` to `.env` and fill in your own values before starting the application.