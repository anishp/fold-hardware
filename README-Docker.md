# KiCAD v9 Docker Setup

This directory uses Docker to run KiCAD v9.0.2 in a containerized environment.

## Benefits

- **Consistent environment**: Same KiCAD version across different machines
- **Isolation**: No system-wide KiCAD installation needed
- **Easy upgrades**: Change docker image version to upgrade/downgrade
- **Web access**: Access KiCAD through browser at `http://localhost:3000`

## Prerequisites

- Docker and Docker Compose installed
- Ports 3000 and 3001 available

## Quick Start

```bash
# Start KiCAD container
docker-compose up -d

# Access KiCAD at: http://localhost:3000
# Username: anishp (configured in docker-compose.yml)
# Password: (set on first access)

# View logs
docker-compose logs -f kicad

# Stop KiCAD
docker-compose down
```

## Directory Structure

```
/home/anishp/KiCADv9/
├── docker-compose.yml          # Docker configuration
├── docker/
│   └── kicad-config/          # KiCAD settings (auto-created)
├── mobmon12_prototype_rev06a/  # Your projects (mounted as /projects in container)
├── mobmon12_yoke_rev02c/
└── ... (other project directories)
```

## Volume Mounting

- **Host path**: `/home/anishp/KiCADv9` → **Container path**: `/projects`
- **Host path**: `./docker/kicad-config` → **Container path**: `/config`

Your project files stay on the host and are accessible to the container.

## Git Workflow

**Recommended**: Use Git on the HOST, not inside the container.

```bash
# On your host machine (WSL)
cd /home/anishp/KiCADv9

# Track changes
git add .
git commit -m "Updated ECG schematic in rev06a"

# The Docker container only runs KiCAD, not Git
```

## Changing KiCAD Version

Edit `docker-compose.yml`:

```yaml
services:
  kicad:
    image: lscr.io/linuxserver/kicad:9.0.2  # Change version here
```

Then restart:
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

## Troubleshooting

### Permission Issues

Ensure PUID/PGID match your user:
```bash
id -u  # Should be 1000
id -g  # Should be 1000
```

### Port Already in Use

If port 3000 is taken, edit `docker-compose.yml`:
```yaml
ports:
  - "3002:3000"  # Use port 3002 instead
```

### Container Won't Start

Check logs:
```bash
docker-compose logs -f kicad
```

### Files Not Visible in Container

Verify volume mount:
```bash
docker exec -it kicad_mobmon12 ls -la /projects
```

## Backing Up

Your project files are on the host at `/home/anishp/KiCADv9`.

KiCAD settings are in `./docker/kicad-config/`.

**Backup strategy**:
1. Git for version control (recommended)
2. Regular backups of entire directory
3. Optional: Export `docker/kicad-config` for settings backup

## Performance Notes

- GUI runs in browser (may have slight latency vs native)
- File I/O is direct (no performance penalty)
- Resource limits can be configured in `docker-compose.yml`
