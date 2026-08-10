# Conduit Container

## Table of Contents
* [Prerequisites](#prerequisites)
* [Quickstart](#quickstart)
* [Usage](#usage)
    * [Data Persistence](#data-persistence)
    * [Container Restart Policy](#container-restart-policy)
    * [Secrets Management](#secrets-management)
    * [Automatic deployments](#automatic-deployment)


## Prerequisites
To install and run this environment, make sure the following software is installed on your system:

- Docker (latest version)


## Quickstart

### Clone the repository
```bash
git clone git@github.com:NicoMeyerDev/Conduit-Container.git
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

## Automatic Deployments

Automate your rollout using **GitHub Actions** — no manual SSH login required.

---

### 1. Create the Workflow File

Create the following folder structure in your project:

```
.github/
└── workflows/
    └── deployment.yaml
```

> **Common mistake:** The folder must be named `workflows` (plural), otherwise GitHub Actions won't detect it.

Inside `deployment.yaml`, define these four sections:

| Section | Purpose |
|---|---|
| **Name** | The name of the workflow |
| **Trigger** (`on:`) | The event that starts the deployment (e.g. push to a branch) |
| **Jobs** | The tasks to run, and on which environment (e.g. `ubuntu-latest`) |
| **Steps** | The individual actions executed one after another |

---

### 2. Secrets and Variables

| Type | Encrypted? | Example |
|---|---|---|
| **Secret** | Yes — never shown in plain text | SSH private key, password |
| **Variable** | No — visible in the UI | GitHub username |

> **Don't mix these up.** Sensitive login data belongs in **Secrets**, not in a plain `.env` file committed to the repo.

---

### 3. Adding GitHub Secrets

1. Go to your repository on GitHub
2. Click **Settings**
3. In the left sidebar: **Security** → **Secrets and variables**
4. Select **Actions** from the dropdown
5. Add the following secrets:

| Secret | Description |
|---|---|
| `SSH_PRIVATE_KEY` | Private key to authenticate with the server |
| `SSH_USER` | Username on the SSH server |
| `SSH_HOST` | Server address (IP or domain) |

---

### 4. Adding a Variable

Add a **variable** (not a secret) so image names resolve to your GitHub profile:

- **Name:** `IMAGE_OWNER`
- **Value:** your GitHub username

---

### 5. Triggering the Deployment

| Method | How | Requirement |
|---|---|---|
| **Automatic** | Push a commit to the trigger branch | None — works out of the box |
| **Manual** | Go to the **Actions** tab → **Run workflow** | Requires `workflow_dispatch:` under `on:` |

> **Tip:** If the "Run workflow" button is missing, check that `workflow_dispatch:` is included in your trigger config.

After triggering, open the **Actions** tab to watch the run live, step by step, including logs for each stage.