# Tools

Bash install / setup scripts for an Ubuntu-based development environment, with a
focus on Kubernetes and container tooling. Each script targets a single tool or
step and is safe to re-run.

All scripts assume Ubuntu and bail out otherwise.

## Layout

### Top-level (system basics)
- `upgrade-ubuntu.sh` — `apt update && upgrade && autoremove`
- `install-net-tools.sh` — `net-tools`, `iproute2`, `iputils-ping`
- `install-nfs-client.sh` — `nfs-common`, `cifs-utils`

### `desktop/`
GUI / desktop bits for headless or minimal installs.
- `install-ubuntu-desktop.sh`, `install-xrdp.sh`, `install-chrome.sh`, `install-hangul.sh`

### `virtualization/`
Hypervisors and Vagrant.
- `install-virtualbox.sh`, `install-vagrant.sh`, `install-kvm.sh`, `install-vagrant-libvirt.sh`

### `languages/`
Toolchains.
- `install-gcc.sh`, `install-java.sh`, `install-golang.sh`, `install-rust.sh`

### `containers/`
Container runtimes.
- `install-docker.sh` — Docker CE + compose / buildx plugins (use `docker compose ...`)
- `install-containerd.sh` — containerd with `SystemdCgroup = true`

### `kubernetes/`
Cluster installers and add-ons.

Cluster installers (pick one):
- `install-minikube.sh` — single-node, requires a hypervisor
- `install-microk8s.sh` — snap-based
- `install-k3s.sh` — lightweight, ships with flannel
- `install-kubeadm.sh` — production-style; pairs with `initialize-kubeadm.sh` and `deploy-cni.sh`

kubeadm flow:
```bash
# install (latest stable, or pin a version)
./install-kubeadm.sh
VERSION=1.33 ./install-kubeadm.sh            # latest patch of 1.33
VERSION=1.33.0 ./install-kubeadm.sh          # specific patch

# bring up the control plane (single-node by default)
./initialize-kubeadm.sh
MULTI=true ./initialize-kubeadm.sh           # keep the control-plane taint

# deploy a CNI
CNI=cilium ./deploy-cni.sh                   # flannel | calico | cilium
```

Helpers:
- `enable-bridge-nf-call-iptables.sh` — fix for worker nodes failing `kubeadm join`
- `install-helm.sh`, `install-kubebuilder.sh`, `install-cilium-cli.sh`

Add-ons (each in its own directory):
- `metrics-server/` — `kubectl top` support
- `metallb/` — bare-metal LoadBalancer
- `istio/` — service mesh (download, install, namespace injection toggles)
- `cilium-hubble/` — observability for Cilium
- `tetragon/` — eBPF runtime security
