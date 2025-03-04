# Swarm Wars TO DO List


## Shared (Swai.Core)

### Facts
- [ ] LicenseReserved fact

### Hopes
- [ ] ReserveLicense hope


## Backend

### Edges Service

### Scapes Service

### Arenas Service

### Hives Service
- [x] Implement Hives.Service to maintain the state of the hives cache
- [ ] Add commands as to propagate hive occupation changes into the process

### Particles Service
- [ ] Implement Particles.Service to maintain the state of the particles cache

### License Service
- [ ] Refactor licenses_service into smaller services (it is getting too big)

### TrainSwarm Process
- [ ] Implement ReserveLicense command


## Edge

### Backend Edge Integration
- [ ] Implement 'present_license' mechanism
- [ ] TODO: Priority One! In order to maintain the state of the hive auction, the Hub application must be able to register which licenses are present in the edge. This is necessary to avoid the edge from starting the same license multiple times on different hives.

### Game Mechanics

## Frontend

### Scapes Overview Page

- [ ] Implement Scapes Overview Page


## Command Shortcuts

### Backend

```bash
# Start the backend
cd ~/work/github.com/beam-campus/swai/system/apps/swai_web/
iex --sname swai_web -S mix phx.server
```

### Edge

```bash
# Start the edge
cd ~/work/github.com/beam-campus/swai/system/apps/swai_aco/
SWAI_EDGE_API_KEY="john-lennon" SWAI_EDGE_LAT=51.5074 SWAI_EDGE_LON=0.1278 iex --sname swai_aco0 -S mix 
``` 


