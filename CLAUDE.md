# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains KiCAD PCB designs for the **mobmon fold** project (medical monitoring device) developed by Kallows Engineering India Pvt Ltd. The repository includes hardware revisions and associated tooling for PCB panelization and BOM management.

## Repository Structure

The repository is now organized into a hierarchical structure:

```
/home/user/fold-hardware/
├── hardware/              # Active hardware projects
│   └── fold/             # Main fold board revisions
│       ├── rev01a/       # Initial fold board revision
│       └── latest/       # Symlink to current revision
├── manufacturing/        # Manufacturing outputs and documentation
├── .claude/skills/      # Claude Code skills
│   └── bom-generator/  # BOM generation and distributor sourcing
├── config/              # Project configuration files
├── docs/                # Documentation
├── archive/             # Archived/legacy projects
│   └── pre_restructure/ # Original manually managed mobmon-fold project
└── docker/              # Docker configuration for KiCAD environment
    └── kicad-config/    # KiCAD container settings (gitignored)
```

### Active Projects (in hardware/)
- **hardware/fold/** - Main fold board with ECG, audio, and wireless capabilities
  - Latest: `rev01a`
  - Features: ADS1294 ECG AFE, TLV320ADC6140 audio codec, nRF52840 wireless MCU
  - 6-layer PCB design

### Archived Projects
- **archive/pre_restructure/** - Original manually managed mobmon-fold project before migration
  - Contains: Original mobmon-fold files with schematics, PCB, and manufacturing outputs

### Key Components Within Each Revision
- **Kallows.pretty/** - Custom footprint library specific to this project
- **SamacSys_Parts.pretty/** - Third-party component footprints
- **footprints/** - Additional component footprints
- **bom/** - Bill of Materials outputs (includes ibom.html interactive BOM)
- **gerbers_*/** - Gerber files for manufacturing
- **Production/** - Production outputs and logs
- **schematic/** - Exported schematic documentation
- **models/** - 3D models for components

### Hierarchical Schematics
The fold board uses hierarchical schematic design with multiple sheets:
- `mobmon fold.kicad_sch` - Top-level schematic
- `ECG.kicad_sch` - ECG signal acquisition (ADS1294)
- `Audio.kicad_sch` - Audio signal processing (TLV320ADC6140)
- `MCU.kicad_sch` - Wireless microcontroller (nRF52840) and IMU (BMX160)

## KiCAD Version

This project uses **KiCAD 9** (version 20250114 format). Files are not compatible with earlier versions.

## Docker Development Environment

This repository includes a Docker-based KiCAD environment for consistent development across platforms.

**Setup:** See `README-Docker.md` for complete instructions.

**Quick Start:**
```bash
# Start KiCAD container
./kicad-docker.sh start

# Access KiCAD at: http://localhost:3000
# Projects are mounted at /projects/ in the container
```

**Benefits:**
- Fixed KiCAD version (9.0.2) for reproducibility
- No system-wide KiCAD installation needed
- Works seamlessly in WSL environments
- Web-based GUI access

**Configuration:** `docker-compose.yml`

## Working with Schematics and PCBs

### Opening Projects
Projects are located in `hardware/fold/[revision]/`.

Example:
- Fold rev01a: `hardware/fold/rev01a/mobmon fold.kicad_pro`

Open the `.kicad_pro` file in each revision directory to load the complete project with all schematics and PCB layouts.

If using Docker, projects are accessible at `/projects/hardware/fold/[revision]/` in the container.

### Custom Libraries
- Custom footprints are stored in `Kallows.pretty/` within each project
- Symbol libraries are typically embedded in schematic files
- When creating new components, add footprints to the appropriate `.pretty/` directory

## PCB Panelization

### Using KiKit for Panelization
The repository includes custom panelization scripts using KiKit (v1.1.0+).

**Location:** `tools/panelize/` or `archive/pre_restructure/kicad_panelize/`

**Purpose:** Creates manufacturing panels from multiple different board designs (not just copies of the same board).

**Usage:**
1. Install KiKit: Follow KiKit installation instructions for your platform
2. Edit `panelize_multiple.py` to update:
   - `board1_path` and `board2_path` - Input PCB files (use new hardware/ paths)
   - `output_path` - Output panel file
   - `board_spacing` - Spacing between boards
   - Framing, tabs, cuts, and tooling parameters
3. Run from KiCAD command prompt:
   ```bash
   python panelize_multiple.py
   ```

**Configuration:** The script supports:
- Rails on top/bottom (railslr)
- Mouse bites for board separation
- Tab placement between boards
- 3-hole tooling pattern
- Custom spacing and dimensions

**Note:** Update paths in panelization scripts to reference new `hardware/` directory structure.

## BOM Management

**All BOM tools are now located in the BOM Generator Skill:**
`.claude/skills/bom-generator/`

### Quick Reference

**Generate BOMs:**
```bash
.claude/skills/bom-generator/scripts/generate_boms_docker.sh --copy-to-manufacturing
```

**Search for parts (Multi-Distributor - Mouser → Digikey):**
```bash
python .claude/skills/bom-generator/scripts/multi_supplier_search.py \
    hardware/fold/rev01a/bom/mobmon_fold_rev01a.csv \
    -o hardware/fold/rev01a/bom/multi_supplier_results.json \
    --csv-summary hardware/fold/rev01a/bom/sourcing_summary.csv
```

**For complete documentation, see:**
- `.claude/skills/bom-generator/SKILL.md` - Claude Code skill definition and comprehensive documentation
- `.claude/skills/bom-generator/scripts/DIGIKEY_SETUP.md` - Digikey OAuth2 setup guide

### Available Scripts

All scripts are in `.claude/skills/bom-generator/scripts/`:
- `generate_all_boms.py` - Generate CSV BOMs from KiCAD projects
- `generate_boms_docker.sh` - Docker wrapper for BOM generation
- `multi_supplier_search.py` - Multi-distributor search (DEFAULT: Mouser → Digikey)
- `mouser_search.py` - Mouser-only search
- `mouser_summary.py` - Mouser results analysis
- `digikey_search.py` - Digikey-only search
- `digikey_oauth_setup.py` - Digikey OAuth2 authorization
- `kallows_csv_grouped_by_value_with_fp.py` - KiCAD BOM plugin

### Output Files

BOMs are generated in each project's `bom/` directory:
- `[project].csv` - CSV BOM with MPN, Manufacturer, Quantity, etc.
- `ibom.html` - Interactive HTML BOM for assembly
- `multi_supplier_results.json` - Multi-distributor search results
- `sourcing_summary.csv` - Human-readable sourcing summary

### API Credentials

Create a `.env` file in the project root:
```bash
MOUSER_API_KEY=your-mouser-key
DIGIKEY_CLIENT_ID=your-digikey-client-id
DIGIKEY_CLIENT_SECRET=your-digikey-client-secret
```

**Get credentials:**
- Mouser: https://www.mouser.com/api-hub/
- Digikey: https://developer.digikey.com/ (requires OAuth2 setup)

## Manufacturing Outputs

### Gerber Generation
Manufacturing files are exported to project-specific directories:
- `gerbers_prototype_revXXa_jlcpcb/` - JLCPCB-specific format
- `gerbers_prototype_revXXa_drawing/` - Documentation/drawing layers

### Interactive BOM
Each revision includes an interactive BOM at `bom/ibom.html` for assembly reference.

## 3D Models

FreeCAD files (.FCStd) in root directory contain:
- USB connector covers
- D-SUB connector covers
- Corresponding STL exports for 3D printing

## Design Conventions

### Naming
- Revisions follow format: `mobmon_fold_rev[XX][letter]` (e.g., rev01a)
- Main project file: `mobmon fold.kicad_pro`
- Backup files use `-backups` suffix directories

### File Organization
- Each major revision is a self-contained directory
- Shared libraries are copied into each project (not symlinked)
- Production outputs stay within their respective project directories

## Common Workflows

### Creating a New Revision
1. Navigate to the fold board directory
2. Copy the latest revision directory:
   ```bash
   cd hardware/fold/
   cp -r rev01a/ rev01b/
   ```
3. Update the revision directory contents:
   - Update title block in root schematic file with new revision and date
   - Update any hardcoded paths or references
   - Update `DESIGN_NOTES.md` with changes
4. Update the `latest` symlink:
   ```bash
   rm latest
   ln -s rev01b latest
   ```

### Generating Manufacturing Files
1. Open project `.kicad_pro` file from `hardware/fold/[revision]/`
2. Use File → Fabrication Outputs → Gerbers for PCB manufacturing
3. Generate drill files separately
4. Generate BOM using InteractiveHtmlBom plugin (outputs to `bom/ibom.html`)
5. Export manufacturing files to `manufacturing/fold/[revision]/` for version control
6. For panelization, update paths in `panelize_multiple.py` and run the script

### Working with Custom Footprints
1. Open Footprint Editor in KiCAD
2. Set library path to `Kallows.pretty/` in current revision
3. Create or modify footprints
4. Save to library (footprints are stored per-project, not globally)
