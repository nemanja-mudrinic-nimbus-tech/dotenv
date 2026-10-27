---
name: sensei-deploy
description: Deploy or share something on Nemanja's personal server "sensei" (DigitalOcean VM running Coolify) at <name>.sensei.internal.nimbus-tech.io — static pages, small Node/Express or other apps, demos, with or without basic auth, with or without git. Use when the user wants to deploy, host, expose, share a link to, preview, or take down a small project/page, or asks where something could run.
---

# Deploying to sensei

Use the `sensei` CLI (`sensei help`); the manual recipes below are the fallback. `sensei share <dir>` does recipe A plus basic auth end to end, `sensei ls|logs|restart|down` manage resources over the Coolify API, `sensei ps|df|ssh` inspect the VM. The API commands need the token item "Coolify sensei API" in 1Password; without it they stop with the setup hint. `sensei share` and `sensei down` are interactive (prompts, y/N) — run them only after the user confirms, or give the user the command.

## What exists
- **Server**: `sensei` — DigitalOcean team "nimbus", fra1, 2 vCPU / 4 GB, Ubuntu 24.04. `ssh sensei` (user `nemanja`, key-only, passwordless sudo; not in the docker group → `sudo docker …`).
- **Coolify v4** at https://coolify.sensei.internal.nimbus-tech.io — builds and runs containers, Traefik (`coolify-proxy`) routes domains and issues Let's Encrypt certs.
- **DNS**: wildcard `*.sensei.internal.nimbus-tech.io` → sensei. Any new subdomain works immediately; never create DNS records for it.
- **Coolify layout**: team "Root Team" → project **quick-shares** (env `production`) for short-lived things; create a new project per real app. Server = `localhost` (sensei itself).
- **Templates**: `~/Documents/sensei-sites/curve-survey/` (nginx.conf with multi-user basic auth + open `/favicon.ico`, Dockerfile variant).
- **Infra as code**: `~/Documents/sensei-infra` (droplet, firewall, `dns/`) — Terraform, remote state in S3 (bucket and AWS account: that repo's README). Needs `DIGITALOCEAN_TOKEN="$(doctl auth token --context sensei)"` + AWS creds.
- **Deep docs** (read when you need detail): `~/vault/projects/homelab/concepts/coolify.md` (recipes A–F), `~/vault/projects/homelab/working-notes/quick-shares.md` (live list), `~/vault/projects/homelab/lessons-learned/coolify.md` (gotchas).

## Rules
- **Confirm before exposing anything**: say what will be public at which URL, with or without auth, and wait for a yes. Same for taking something down.
- Coolify UI needs the user logged in — you cannot type passwords. With the Chrome extension you can click through the UI once they are logged in; otherwise give them the exact clicks.
- Secrets: never in git, compose text, or chat logs you write to files. Runtime secrets → Coolify Environment Variables. Generated passwords → `~/vault/projects/homelab/sensitive/<name>-users.md` (gitignored) and offer 1Password.
- doctl: always `--context sensei`. Never the default context (it's a client account).
- Firewall/size/DNS changes go through Terraform in `sensei-infra`, not the DO console or Coolify.
- After a deploy or takedown, update the "Live" table in `quick-shares.md`.

## Pick the route
| Situation | Route |
|---|---|
| One-off page/demo, lives days–weeks | **No git**: files on host + Coolify *Docker Compose* resource (A/D below) |
| Real project, teammates, needs history/rollback | **Git**: Coolify *Git Repository (GitHub App)*, auto-deploy on push. Needs a private GitHub repo + the Coolify GitHub App (one-time; ask the user before creating repos or granting app access) |
| Needs a database | Coolify one-click Postgres/Redis in the same environment; use its internal URL as an env var |

## A. Static HTML, no git
```sh
N=<name>                                   # → https://$N.sensei.internal.nimbus-tech.io
cp ~/Documents/sensei-sites/curve-survey/nginx.conf .     # drop the auth_basic lines for a public page
scp index.html nginx.conf htpasswd sensei:/tmp/           # htpasswd only if protected
ssh sensei "D=/data/sites/$N; sudo mkdir -p \$D/html && sudo install -m644 /tmp/index.html \$D/html/ && sudo install -m644 /tmp/nginx.conf \$D/ && sudo install -m640 -g101 /tmp/htpasswd \$D/ && rm -f /tmp/{index.html,nginx.conf,htpasswd}"
```
Coolify → quick-shares → production → + New Resource → **Docker Compose** → paste ONE line (the editor auto-indents multi-line YAML):
```yaml
services: {<name>: {image: 'nginx:1.27-alpine', volumes: ['/data/sites/<name>/html:/usr/share/nginx/html:ro', '/data/sites/<name>/nginx.conf:/etc/nginx/conf.d/default.conf:ro', '/data/sites/<name>/htpasswd:/etc/nginx/.htpasswd:ro']}}
```
→ Create → General: name `<name>` → Save → Domains → Add Domain: `https`, `<name>.sensei.internal.nimbus-tech.io`, port `80` → Save → Actions → Deploy.
Update content: copy new files into `html/` (live instantly). Changed nginx.conf/htpasswd: single-file mounts pin the old inode → Coolify Restart (or `sudo docker restart <container>`).

## Basic auth users
```sh
p=$(openssl rand -base64 18 | tr -d '/+=' | cut -c1-20)            # per user
printf '%s:%s\n' <user> "$(openssl passwd -apr1 "$p")" >> htpasswd
```
Keep `/favicon.ico` auth-exempt (Coolify's Domains page loads it and would pop a login prompt). For git-based *Applications*, Coolify has General → HTTP Basic Authentication (single user); multiple users → nginx inside, Traefik basicauth label, or app-level auth.

## D. Small Node/Express app, no git
App must listen on `process.env.PORT || 3000`; ship `package-lock.json`, not `node_modules`.
```sh
scp -r ./app sensei:/tmp/$N && ssh sensei "sudo mkdir -p /data/sites/$N && sudo rm -rf /data/sites/$N/app && sudo mv /tmp/$N /data/sites/$N/app"
```
Compose (one line): `services: {<name>: {image: 'node:22-alpine', working_dir: /app, command: 'sh -c "npm ci --omit=dev && node server.js"', volumes: ['/data/sites/<name>/app:/app']}}` → domain port `3000` → Deploy. Code change → copy → Restart.

## B/C. With git
Coolify → + New Resource → Git Repository (GitHub App) → repo/branch → Build Pack: *Static* for HTML, *Nixpacks* for Node (runs `npm ci` + `npm start`), *Dockerfile* if the repo has one → Ports Exposes → Domain → Deploy. Env vars in the resource's Environment Variables. Push = redeploy.

## Verify (always)
```sh
curl -s -o /dev/null -w '%{http_code}\n' https://<name>.sensei.internal.nimbus-tech.io        # 401 if protected, 200 if public
curl -s -o /dev/null -w '%{http_code}\n' -u <user>:<pass> https://<name>.sensei.internal.nimbus-tech.io
```
First request can take a few seconds (certificate issuance).

## Take down
Resource → Danger Zone → Delete → `ssh sensei sudo rm -r /data/sites/<name>` → remove the row from quick-shares.md. No DNS cleanup.

## Troubleshoot
- Logs: resource → Runtime Logs, or `ssh sensei 'sudo docker ps; sudo docker logs <container>'`.
- 404 from Traefik = no container claims that Host → check the domain on the resource and that it's running.
- Proxy/certs: Servers → localhost → Proxy (config at `/data/coolify/proxy/`).
- Server too small (builds OOM): resize via `size` in `sensei-infra` (`s-4vcpu-8gb`), confirm cost with the user first.
