# Hardware Design Files

This directory contains all KiCAD PCB design files for the MobMon12 project boards.

## Directory Structure

```
hardware/
├── mainboard/          # Main monitoring board (mobmon12_mainboard)
│   ├── latest -> rev06a/
│   ├── rev04/
│   ├── rev05a/
│   ├── rev05b/
│   ├── rev06a/
│   └── rev06b/
│
├── yoke/               # Yoke/connector board (mobmon12_yoke)
│   ├── latest -> rev02c/
│   ├── rev01a/
│   ├── rev01b/
│   └── rev02c/
│
└── defib/              # Defibrillator interface board
    ├── latest -> rev01a/
    └── rev01a/
```

## Board Types

### Mainboard
**Purpose:** Main patient monitoring unit
**Features:**
- ECG signal acquisition and conditioning
- MSP432E401Y microcontroller
- USB interface
- Power supply management
- JTAG programming interface

**Current Production:** rev06a
**Active Development:** rev06b

### Yoke
**Purpose:** Connector/interface board for patient connections
**Features:**
- ECG electrode connectors
- Signal conditioning
- Patient isolation

**Current Production:** rev02c

### Defib
**Purpose:** Defibrillator interface module
**Features:**
- Defibrillator pulse detection
- Isolation and protection

**Current Production:** rev01a

## Revision Naming Convention

Format: `rev[NN][letter]`
- **NN**: Major revision number (00-99)
- **letter**: Minor revision letter (a, b, c...)

Examples:
- `rev06a` - Revision 6, variant A
- `rev06b` - Revision 6, variant B (iterative improvement)

### When to Increment
- **Major number (06 → 07)**: Significant design changes, new features
- **Letter (a → b)**: Bug fixes, minor improvements, ECO changes

## Files in Each Revision Directory

### Required Files
- `mobmon12_[board].kicad_pro` - Project file
- `mobmon12_[board].kicad_sch` - Top-level schematic
- `mobmon12_[board].kicad_pcb` - PCB layout
- `DESIGN_NOTES.md` - Design documentation
- `VERIFICATION_SUMMARY.md` - Test results summary
- `metadata.json` - Machine-readable metadata

### Optional Files
- `*.kicad_sch` - Hierarchical schematic sheets (ECG, POWER, etc.)
- `fp-lib-table` - Footprint library table (if custom libraries)
- `sym-lib-table` - Symbol library table (if custom libraries)

### Generated/Ignored Files
- `*.kicad_prl` - Project local settings (gitignored)
- `*-backups/` - KiCAD auto-backups (gitignored)
- `fp-info-cache` - Footprint cache (gitignored)

## Working with Revisions

### Opening a Design
```bash
cd hardware/mainboard/latest/
kicad mobmon12_mainboard.kicad_pro
```

### Creating a New Revision

1. **Determine revision number:**
   - Minor changes? Increment letter (rev06a → rev06b)
   - Major changes? Increment number (rev06a → rev07a)

2. **Copy from previous revision:**
   ```bash
   cd hardware/mainboard/
   cp -r rev06a rev06b
   ```

3. **Update documentation:**
   - Edit `metadata.json` → change revision field
   - Edit `DESIGN_NOTES.md` → add "Changes from Previous Revision" section
   - Clear `VERIFICATION_SUMMARY.md` → tests need to be re-run

4. **Make your design changes in KiCAD**

5. **Update symlink when ready:**
   ```bash
   ln -sfn rev06b latest
   ```

### Archiving Old Revisions
Revisions that are obsolete and no longer in use can be moved to `archive/`:
```bash
mv hardware/mainboard/rev01 ../archive/old_revisions/mainboard_rev01
```

## Hierarchical Schematics

Mainboard designs use hierarchical schematics with multiple sheets:

| Sheet | Purpose |
|-------|---------|
| `mobmon12_mainboard.kicad_sch` | Top-level (connects all sheets) |
| `ECG.kicad_sch` | ECG analog frontend |
| `ECG_CONNECTOR.kicad_sch` | ECG connector interface |
| `POWER_SUPPLY.kicad_sch` | Power supply circuitry |
| `STELLARIS_MCU.kicad_sch` | Microcontroller (MSP432E401Y) |
| `USB_INTERFACE.kicad_sch` | USB connectivity |
| `JTAG.kicad_sch` | JTAG programming interface |

## Libraries

All designs reference shared libraries in `libraries/`:
- Symbols: `libraries/symbols/`
- Footprints: `libraries/footprints/`
- 3D Models: `libraries/3dmodels/`

Library paths are configured via:
- `config/kicad/sym-lib-table`
- `config/kicad/fp-lib-table`

**Important:** Do NOT copy libraries into individual revision directories. Use the shared libraries only.

## Design Validation

Before committing changes, validate your design:

```bash
cd tools/fabrication
python validate_design.py --board mainboard --revision rev06b
```

This runs:
- ✅ Electrical Rules Check (ERC)
- ✅ Design Rules Check (DRC)
- ✅ Library reference check
- ✅ Metadata validation

## Release Process

When a revision is ready for manufacturing:

1. **Complete verification testing**
   - Update `VERIFICATION_SUMMARY.md`
   - Ensure all tests pass

2. **Generate manufacturing outputs**
   ```bash
   cd tools/fabrication
   python generate_manufacturing_outputs.py --board mainboard --revision rev06a
   ```

3. **Create release manifest**
   - Complete `manufacturing/mainboard/rev06a/RELEASE_MANIFEST.md`

4. **Tag in Git**
   ```bash
   git tag -a mainboard-rev06a-v1.0 -m "Mainboard Rev06a Release v1.0"
   git push origin mainboard-rev06a-v1.0
   ```

5. **Update CHANGELOG.md** at repository root

## Troubleshooting

### "Missing library" errors
- Check that `config/kicad/sym-lib-table` and `fp-lib-table` are in place
- Verify libraries exist in `libraries/` directory
- Try "Preferences → Manage Symbol/Footprint Libraries → Add" and point to shared tables

### "File not found" errors
- Verify all file paths use forward slashes `/` (even on Windows)
- Check that library paths are relative, not absolute

### Design rules errors after copying
- Check if design rules changed between revisions
- Verify stackup settings in Board Setup

---

## See Also
- [Libraries Documentation](../libraries/README.md)
- [Manufacturing Outputs](../manufacturing/README.md)
- [Design Documentation](../docs/design/README.md)
