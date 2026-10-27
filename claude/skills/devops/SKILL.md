---
name: devops
description: Nemanja's DevOps practices — GitOps with Argo CD, monorepo layout for apps and infra, Kubernetes manifests (Kustomize/Helm), infrastructure as code, CI pipelines, secrets, environments. Use for deployment, infra, CI/CD, Kubernetes, Terraform/Pulumi or Coolify work. A repo's own decisions win.
---

# DevOps

Concepts: `~/.dotfiles/claude/rules/engineering.md`.

## Default shape
- **GitOps with Argo CD** for Kubernetes: the cluster state is what is in git. Changes go through a commit or PR, never `kubectl apply` by hand (read-only `kubectl get/describe/logs` is fine).
- **Monorepo:** apps and their deploy config together — `apps/<name>`, `deploy/<env>/` (Kustomize overlays or Helm values), `infra/` (Terraform/Pulumi). One PR changes code and its deploy config together.
- **Environments as overlays:** `base` + `dev`/`staging`/`prod`; promote by changing an image tag or overlay in git.

## Infrastructure as code
- Terraform or Pulumi, whichever the repo uses; remote state with locking; plan in CI, apply after review.
- Small VMs and side projects: Coolify on sensei (`sensei` CLI), not hand-made servers.

## CI/CD
- CI builds, tests, scans (gitleaks, image scan) and publishes an image with an immutable tag; Argo CD deploys it.
- Pipelines use the project's own commands (`make check`, `pnpm build`), so local and CI run the same thing.

## Secrets and access
- Secrets from 1Password or the platform's secret store (External Secrets on Kubernetes); never in git, values files or CI logs.
- Least privilege for CI tokens and service accounts.

## Safety
- Anything that changes production, cost or access goes to a human first.
