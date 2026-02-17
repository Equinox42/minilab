## Goals

This repository has several purposes. First, it acts as a showcase of the technologies and practices I’m currently experimenting with, learning, and deploying in my homelab. 

It also serves as a structured place to document what I build and how I build it, it is a complement to my Obsidian vault, but in a format I can easily share and reference publicly. Ultimately, this repo is both a learning space and a long-term knowledge base for my tooling.

## Infrastructure

My current homelab is built around a single physical node: a Minisforum UM870 equipped with 96GB of RAM, a AMD Ryzen 7 8745H and 1 TB SSD. 

The host typically runs severals Debian VMs provisioned from cloud-ready images, which serve as the foundation for my Kubernetes environments (usually deploying k0s or standard k8s via Kubespray).

In the future i'd like to invest in a dedicated NAS. This will allow me to decouple my persistent data from the compute node and introduce much-needed storage redundancy.


![infra_sketch](./images/cluster_provisioning.png)


 