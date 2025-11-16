# Component Libraries

This directory contains all shared component libraries used across MobMon Fold hardware designs.

## Directory Structure

```
libraries/
├── symbols/           # Schematic symbol libraries (.kicad_sym)
├── footprints/        # PCB footprint libraries (.pretty directories)
└── 3dmodels/          # 3D models (.step, .wrl files)
```

## Library Types

### Symbols (`symbols/`)
Schematic symbols for component representation in schematics.

**Format:** `.kicad_sym` files (KiCAD 6+ format)

**Libraries:**
- `Kallows_Symbols.kicad_sym` - Custom company symbols
- Additional third-party libraries as needed

### Footprints (`footprints/`)
PCB footprints for component placement and soldering pads.

**Format:** `.kicad_mod` files inside `.pretty` directories

**Libraries:**
- `Kallows.pretty/` - Custom company footprints (mainboard-specific)
- `KallowsYoke.pretty/` - Custom footprints for yoke board
- `SamacSys_Parts.pretty/` - Third-party component footprints from SamacSys

### 3D Models (`3dmodels/`)
3D models for visualization and mechanical clearance checking.

**Formats:** `.step`, `.wrl` (VRML)

**Libraries:**
- `Kallows.3dshapes/` - Custom 3D models
- `SamacSys_Parts.3dshapes/` - Third-party 3D models

## Library Configuration

Libraries are registered in KiCAD via library tables in `config/kicad/`:

- **Symbol Library Table:** `config/kicad/sym-lib-table`
- **Footprint Library Table:** `config/kicad/fp-lib-table`

These files use **relative paths** to ensure portability across different machines and operating systems.

### Example sym-lib-table
```
(sym_lib_table
  (version 7)
  (lib (name "Kallows_Symbols")(type "KiCad")(uri "${KIPRJMOD}/../../libraries/symbols/Kallows_Symbols.kicad_sym")(options "")(descr "Kallows custom symbols"))
)
```

### Example fp-lib-table
```
(fp_lib_table
  (version 7)
  (lib (name "Kallows")(type "KiCad")(uri "${KIPRJMOD}/../../libraries/footprints/Kallows.pretty")(options "")(descr "Kallows custom footprints"))
  (lib (name "SamacSys_Parts")(type "KiCad")(uri "${KIPRJMOD}/../../libraries/footprints/SamacSys_Parts.pretty")(options "")(descr "Third-party parts from SamacSys"))
)
```

## Adding New Components

### 1. Add Symbol

1. Open KiCAD Symbol Editor
2. File → Open Library → Select `libraries/symbols/Kallows_Symbols.kicad_sym`
3. Create new symbol or copy from existing
4. Save library
5. Update `libraries/symbols/CHANGELOG.md`

### 2. Add Footprint

1. Open KiCAD Footprint Editor
2. File → New Library → Select `libraries/footprints/Kallows.pretty/`
3. Create new footprint:
   - Add pads, silkscreen, courtyard
   - Follow IPC-7351 naming standards
   - Add 3D model if available
4. Save footprint
5. Update `libraries/footprints/CHANGELOG.md`

### 3. Add 3D Model (Optional)

1. Obtain or create `.step` file for component
2. Copy to `libraries/3dmodels/Kallows.3dshapes/[component_name].step`
3. In footprint editor, associate 3D model with footprint
4. Verify scale and position in 3D viewer

## Library Management

### Version Control
All library files are tracked in Git. When modifying libraries:

1. **Document changes** in `CHANGELOG.md`
2. **Test changes** by opening affected designs
3. **Commit with clear message:**
   ```bash
   git add libraries/footprints/Kallows.pretty/NEW_PART.kicad_mod
   git commit -m "Add footprint for TI LM358 op-amp"
   ```

### Changelog Format
Update the appropriate `CHANGELOG.md` file:

```markdown
## [Unreleased]

### Added
- MSP432E401Y microcontroller symbol
- USB-C connector footprint (USB_C_Receptacle_HRO_TYPE-C-31-M-12)

### Modified
- Updated LM358 footprint to include thermal pad

### Removed
- Obsolete LM324 footprint (replaced by LM358)

## [2024-03-15]
...
```

### Breaking Changes
If you modify an existing component that's already used in designs:

1. **Create new variant instead** (e.g., `CAPACITOR_0805` → `CAPACITOR_0805_v2`)
2. **Document breaking change** in CHANGELOG
3. **Update all affected designs** in same commit
4. **Run validation** on all boards

## Library Standards

### Naming Conventions

#### Symbols
Format: `[Manufacturer]_[PartNumber]`

Examples:
- `TI_LM358`
- `STM32F407VGT6`
- `GENERIC_OPAMP_DUAL`

#### Footprints
Follow IPC-7351 standards:

Examples:
- `SOIC-8_3.9x4.9mm_P1.27mm`
- `QFN-48-1EP_7x7mm_P0.5mm`
- `C_0805_2012Metric`

#### 3D Models
Match footprint name:
```
Kallows.3dshapes/
├── SOIC-8_3.9x4.9mm_P1.27mm.step
└── QFN-48-1EP_7x7mm_P0.5mm.step
```

### Design Rules for Footprints

1. **Courtyard Layer (F.CrtYd):**
   - 0.25mm minimum clearance from pads
   - Use 0.05mm line width
   - Must be closed polygon

2. **Silkscreen Layer (F.Silkscreen):**
   - No silkscreen on pads
   - 0.15mm minimum clearance from pads
   - Reference designator (REF**) on every footprint
   - Value field optional

3. **Fabrication Layer (F.Fab):**
   - Exact component outline
   - Pin 1 indicator
   - Courtyard outline

4. **Pads:**
   - Follow IPC-7351 calculations
   - Use appropriate pad types (SMD, THT)
   - NPTH holes where needed

5. **3D Models:**
   - Position (0, 0, 0) = center of component
   - Verify orientation matches footprint

## Medical Device Considerations

For components used in medical devices (ISO 13485, IEC 60601):

### Component Selection
- Prefer components from approved manufacturers
- Document rationale in `docs/design/component_selection/`
- Track obsolescence and lifecycle

### Critical Components
Mark critical components in library (use fields):
- **Critical:** Yes/No
- **Safety_Classification:** Basic/Supplementary/Reinforced
- **Lifecycle_Status:** Active/NRND/Obsolete

### Custom Fields
Add custom fields to symbols for traceability:

| Field | Description | Example |
|-------|-------------|---------|
| `Manufacturer` | Component manufacturer | "Texas Instruments" |
| `MPN` | Manufacturer Part Number | "LM358DR" |
| `Datasheet` | Link to datasheet | "https://..." |
| `Lifecycle` | Lifecycle status | "Active" |
| `Approved` | Approved for medical use | "Yes" |
| `Notes` | Special notes | "Reinforced isolation" |

## Library Validation

### Before Committing
Run library validation:

```bash
cd tools/traceability
python validate_libraries.py
```

Checks:
- ✅ All footprints have 3D models
- ✅ All symbols have required fields
- ✅ Naming conventions followed
- ✅ No duplicate entries
- ✅ Changelog updated

## Sourcing Third-Party Libraries

### SamacSys Component Search Engine
1. Visit https://componentsearchengine.com/
2. Search for part number
3. Download KiCAD library
4. Extract to `libraries/footprints/SamacSys_Parts.pretty/`
5. Extract 3D models to `libraries/3dmodels/SamacSys_Parts.3dshapes/`
6. Document in CHANGELOG

### KiCAD Built-in Libraries
For standard components, use KiCAD built-in libraries when possible:
- Resistors, capacitors: `Device` library
- Connectors: `Connector`, `Connector_Generic`
- ICs: Manufacturer-specific libraries

**Note:** Do not copy built-in libraries to this repository. Reference them from KiCAD installation.

## Troubleshooting

### "Symbol not found" in schematic
1. Check `config/kicad/sym-lib-table` exists
2. Verify path to `libraries/symbols/` is correct
3. Open symbol library manager: Preferences → Manage Symbol Libraries
4. Ensure library is loaded and path is correct

### "Footprint not found" in PCB
1. Check `config/kicad/fp-lib-table` exists
2. Verify path to `libraries/footprints/` is correct
3. Check footprint exists in `.pretty` directory
4. Update footprint cache: Tools → Update Footprints from Library

### 3D model not appearing
1. Verify `.step` file exists in `3dmodels/` directory
2. Check footprint properties → 3D Models tab
3. Verify path to 3D model is correct
4. Check scale and offset values

---

## See Also
- [Hardware Design Files](../hardware/README.md)
- [Component Selection Documentation](../docs/design/component_selection/README.md)
- [KiCAD Library Conventions](https://klc.kicad.org/)
