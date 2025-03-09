# Macula

![Macula Container Diagram](architecture/macula-container.png)

## TL;DR

_Macula_ is Latin for "spot", referring to the nature of the kind of infrastructure this project is targeting: a decentralized and distributed mesh of tiny-node, low-cost, low-power clusters.

Recent world events have shown once more that nothing is certain: decades-old alliances we took for granted seem to be prone to collapse at the drop of a hat and prove to be vulnerable to personal agendas of political and economic madmen.

This project aims at building a democratic, open-source and crowdsourced platform, outside of the influence of Big Tech and Big Politics, that is still capable of running meaningful workloads.

It is a radical departure from the current industry mindset of moving towards centralized, big cloud platforms, which in essence comes down to giving up control over data to institutions and corporations we don't control or even trust.

## OUTLINE

- [Macula](#macula)
  - [TL;DR](#tldr)
  - [OUTLINE](#outline)
  - [CHALLENGES](#challenges)
    - [Energy](#energy)
    - [Hardware](#hardware)
    - [Networking](#networking)
    - [Security](#security)
    - [Workloads](#workloads)
    - [Administration](#administration)
    - [Governance](#governance)
    - [Commercial Mindsets](#commercial-mindsets)
  - [Architecture](#architecture)
    - [Edge Nodes](#edge-nodes)
    - [Hub Nodes](#hub-nodes)
    - [Macula Ring](#macula-ring)

## CHALLENGES

It is important to understand that in order to build a truly decentralized and autonomous platform, the foundations of such a system must also be decentralized and autonomous, starting with power provisioning all the way up to the administration and governance of that system.

In practice, this means that platforms like _Macula_ must be built on top of a decentralized network of nodes, which must be able to communicate with each other, these nodes must be able to run workloads, which are themselves decentralized and autonomous.

### Energy

Decentralization of power provisioning is not an unknown field. Solar, wind or even small hydro generators can be used to power the nodes of a decentralized network, but they all suffer from the same problems as large-scale solutions: energy storage.  
Initiatives like [EnergyVision](https://energyvision.be), that offer investment-free consumer oriented solutions, would be an important pillar in serious attempts to decentralize power provisioning.

### Hardware

Single-board computers (SBCs), such as Raspberry Pi, Odroid, and NanoPC devices, are compact, energy-efficient systems that leverage ARM or x86 architectures to deliver modest computational power at minimal energy costs. These devices, often consuming under 15W per unit, are increasingly explored for building tiny-node clusters, enabling distributed computing for lightweight workloads like web servers, edge computing, IoT data aggregation, or prototyping scalable architectures. While SBC clusters offer advantages in power efficiency, physical footprint, and upfront cost—ideal for small businesses or startups with budget constraints—their commercial feasibility for mainstream enterprise operations remains limited.

Businesses requiring high-performance computing, low-latency processing, or heavy data workloads (e.g., AI training, large-scale databases) would struggle with SBC clusters due to hardware bottlenecks in CPU/GPU capabilities, storage speed, and network throughput. Additionally, scaling such clusters introduces logistical challenges in cooling, node synchronization, and maintenance, which may offset initial savings.-

However, niche applications like educational labs, localized edge networks, or low-traffic microservices could benefit from SBC clusters, provided operational demands align with their inherent constraints. Ultimately, while SBCs present innovative, cost-effective solutions for specific use cases, most enterprises would still require hybrid models blending traditional servers with SBC nodes to balance efficiency and performance.

### Networking

### Infrastructure

### Security

### Workloads

### Administration

### Governance

### Commercial Mindsets

## ARCHITECTURE

_Macula_ is intended to run on a fractal topology network of tiny-node clusters, of single-board computers (SBC). The network is designed to be highly decentralized, with no central authority or control, and to be self-healing and self-organizing.

### Edge Clusters

_Edge Nodes_ are the most basic unit of the network, and are responsible for running workloads, which should be hot-swappable and self-healing.

### Hub Clusters

_Hub Nodes_ provide local centralized services such as portals, dashboards, near-edge aggregation and -processing and are responsible for managing the edge nodes of their network.

### Macula Ring

WebRTC is a technology that enables peer-to-peer communication between devices, and it is the foundation of _Macula Rings_. Commonly used for peer-to-peer video and audio calls, it could also used to build temporary peer-to-peer networks for sharing data, or online collaboration, without putting extra load on Edge- or Hub Clusters.

## IDEAS

- [BEAM stack (AI generated)](ideas/analysis/root-beam.md)
