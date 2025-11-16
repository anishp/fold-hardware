# Manufacturing Outputs

This directory contains all production-ready manufacturing outputs (gerbers, BOMs, assembly files) for each board revision.

## Directory Structure

```
manufacturing/
└── fold/
    └── rev01a/
        ├── gerbers/              # Gerber files
        ├── assembly/             # BOM, placement, assembly docs
        ├── fabrication/          # Fab notes, stackup
        ├── panels/               # Panelized design (if applicable)
        ├── documentation/        # Schematic PDFs, assembly drawings
        └── RELEASE_MANIFEST.md   # Release documentation
```

---

## File Organization

### Gerbers Directory (`gerbers/`)

**Contents:**
- `fold_[revision]_gerbers.zip` - Complete gerber package
- `checksum.md5` - MD5 checksum for verification
- Individual gerber files (optional, usually zipped)

**Gerber Files Included:**
- Copper layers: `*.GTL, *.G1, *.G2, *.GBL`
- Soldermask: `*.GTS, *.GBS`
- Silkscreen: `*.GTO, *.GBO`
- Paste: `*.GTP, *.GBP`
- Edge cuts: `*.GKO`
- Drill files: `*.TXT, *.DRL`

### Assembly Directory (`assembly/`)

**Contents:**
- `bom_[revision].xlsx` - Master Bill of Materials (Excel format)
- `bom_[revision].csv` - BOM in CSV format for manufacturers
- `bom_jlcpcb.csv` - JLCPCB-specific BOM format (if used)
- `cpl_[revision].csv` - Component Placement List (centroid file)
- `ibom.html` - Interactive BOM for assembly reference
- `assembly_drawings.pdf` - Visual assembly guide

#### BOM Format

**Master BOM (Excel)** includes all columns:
| Column | Description |
|--------|-------------|
| Designator | Component reference (R1, C5, U3, etc.) |
| Quantity | Number of components |
| Manufacturer | Component manufacturer |
| MPN | Manufacturer Part Number |
| Description | Component description |
| Value | Component value (if applicable) |
| Footprint | KiCAD footprint name |
| Datasheet | Link to datasheet |
| Notes | Special assembly notes |

**Manufacturer BOM (CSV)** is simplified for fabrication house:
- Designator, Quantity, MPN, Description, Value

#### Component Placement List (CPL)

CSV format with component positions:
```
Designator,X,Y,Rotation,Layer,Value
C1,10.5,20.3,0,Top,100nF
R1,15.2,22.1,90,Top,10k
U1,50.0,50.0,0,Top,NRF52840-QIAA-R
```

**Coordinate System:**
- Origin: Typically board center or lower-left
- Units: Millimeters
- Rotation: Degrees (0-360)

### Fabrication Directory (`fabrication/`)

**Contents:**
- `stackup.pdf` - PCB stackup specification
- `impedance_requirements.pdf` - Controlled impedance requirements
- `fab_notes.md` - Special fabrication instructions

**Example fab_notes.md:**
```markdown
# Fabrication Notes: Fold Rev01a

## PCB Specifications
- **Layers:** 6
- **Thickness:** 1.6mm ± 10%
- **Material:** FR-4, Tg 170°C
- **Copper Weight:** 1oz (35µm) outer, 0.5oz (17.5µm) inner
- **Surface Finish:** ENIG (Electroless Nickel Immersion Gold)
- **Minimum Trace/Space:** 0.15mm / 0.15mm
- **Minimum Drill:** 0.3mm

## Controlled Impedance
- See impedance_requirements.pdf
- USB differential pairs: 90Ω ± 10%
- Verify with TDR after fabrication

## Special Requirements
- Medical device: IPC Class 3
- No halogen materials
- UL94 V-0 flammability rating

## Finish Requirements
- Gold thickness: 0.05-0.10µm over 3-6µm Ni
- No leadcovering in test point areas
```

### Panels Directory (`panels/`)

Panelized PCB designs for manufacturing efficiency.

**Contents:**
- `panel_design.kicad_pcb` - KiCAD panelized layout
- `panel_gerbers.zip` - Gerbers for full panel
- `panel_notes.md` - Panel configuration notes

### Documentation Directory (`documentation/`)

Human-readable documentation for manufacturing.

**Contents:**
- `schematic_[revision].pdf` - Complete schematic (all sheets)
- `layout_assembly_top.pdf` - Top side assembly drawing
- `layout_assembly_bottom.pdf` - Bottom side assembly drawing
- `bom_summary.pdf` - Printable BOM

### RELEASE_MANIFEST.md

Documents what was released and manufacturing details.

**Template:**
```markdown
# Manufacturing Release: [Board] [Revision]

## Release Information
- **Release Number:** Fold-Rev01a-Release-v1.0
- **Release Date:** YYYY-MM-DD
- **Released By:** [Name]
- **Approved By:** [Name]
- **Release Package:** [filename].zip
- **Package Checksum (MD5):** [hash]

## Board Information
- **Board:** Fold
- **Revision:** rev01a
- **PCB Part Number:** FOLD-01A-001
- **Assembly Part Number:** FOLD-01A-001-ASSY

## Design Files
- **KiCAD Version:** 9.0
- **Source Location:** hardware/fold/rev01a/
- **Git Commit:** [commit hash]
- **Git Tag:** fold-rev01a-release-v1.0

## Manufacturing Outputs
- ✓ Gerbers: fold_rev01a_gerbers.zip
- ✓ BOM: bom_rev01a.xlsx, bom_rev01a.csv
- ✓ CPL: cpl_rev01a.csv
- ✓ Interactive BOM: ibom.html
- ✓ Stackup: stackup.pdf
- ✓ Schematics: schematic_rev01a.pdf
- ✓ Assembly Drawings: layout_assembly_top/bottom.pdf

## Changes from Previous Revision
- See ECO-015: Changed C15 from 10µF to 22µF
- See ECO-016: Added R23 pull-down on RESET
- See ECO-017: Moved U5 for better thermal performance

## Verification Status
- ✓ Electrical Safety: PASSED (report: docs/verification/test_reports/fold_rev01a/electrical_safety_report.md)
- ✓ Functional Test: PASSED
- ✓ EMC Pre-test: PASSED with notes

## Manufacturing Information

### PCB Fabrication
- **Manufacturer:** JLCPCB
- **Order Date:** 2024-03-05
- **PO Number:** PO-2024-001
- **Quantity:** 50 boards
- **Lead Time:** 7-10 days
- **Cost:** $XXX

### Assembly
- **Assembly House:** [Name]
- **Order Date:** [Date]
- **Quantity:** [Number]
- **Consigned Parts:** [List]

## Known Issues
- None at time of release

## Special Instructions
- IPC Class 3 (medical device)
- Functional test required before shipment
- See fabrication/fab_notes.md for additional requirements

## Approvals
- **Engineering:** ___________ Date: ___________
- **Quality:** ___________ Date: ___________
- **Manufacturing:** ___________ Date: ___________

## Post-Release Notes
[Add notes about production issues, yields, etc.]
```

---

## Generating Manufacturing Outputs

### Automated Generation

Use the provided script:

```bash
cd tools/fabrication
python generate_manufacturing_outputs.py --board fold --revision rev01a
```

This script:
1. Opens KiCAD project
2. Generates gerbers and drill files
3. Exports BOM from schematic
4. Generates CPL from layout
5. Creates Interactive BOM
6. Exports schematic PDFs
7. Creates assembly drawings
8. Packages everything into release structure

### Manual Generation

#### 1. Gerbers (KiCAD PCB Editor)
1. File → Fabrication Outputs → Gerbers
2. Configure layers:
   - All copper layers
   - F.Silkscreen, B.Silkscreen
   - F.Mask, B.Mask
   - F.Paste, B.Paste
   - Edge.Cuts
3. General Options:
   - Plot format: Gerber
   - Use Protel filename extensions
   - Coordinate format: 4.6, unit mm
4. Generate Drill Files:
   - Format: Excellon
   - Mirror Y axis: No
   - Minimal header: Yes

#### 2. BOM (KiCAD Schematic Editor)
1. Tools → Generate BOM
2. Use InteractiveHtmlBom plugin for ibom.html
3. Export to CSV for manufacturer
4. Create master BOM in Excel with all fields

#### 3. Component Placement (KiCAD PCB Editor)
1. File → Fabrication Outputs → Component Placement (.pos)
2. Format: CSV
3. Units: Millimeters
4. Files: Combined file
5. Include:
   - Front and back
   - Reference, X, Y, Rotation, Layer

#### 4. PDFs
- Schematic: File → Print → Print to PDF (all sheets)
- Assembly: File → Print → Print to PDF (F.Silkscreen + F.Cu or B.Silkscreen + B.Cu)

---

## Manufacturer-Specific Formats

### JLCPCB
- BOM: CSV with columns: Designator, Footprint, Quantity, MPN
- CPL: CSV with columns: Designator, Mid X, Mid Y, Layer, Rotation
- Gerbers: RS-274X format, zipped

### PCBWay
- Similar to JLCPCB
- Accepts standard gerber format
- BOM in Excel or CSV

### Assembly Houses
Vary by manufacturer. Common requirements:
- BOM with MPN
- CPL with rotation reference
- Assembly drawings (top/bottom)
- Any special assembly instructions

---

## Quality Checks

### Before Release

**Gerber Verification:**
```bash
# Recommended: Use Gerber viewer
gerbv gerbers/*.gbr
# Or use online viewer: https://www.gerber-viewer.com/
```

Check:
- [ ] All layers present
- [ ] No missing features
- [ ] Board outline correct
- [ ] Drill holes aligned
- [ ] Text readable

**BOM Verification:**
```bash
cd tools/bom
python bom_validator.py --bom manufacturing/fold/rev01a/assembly/bom_rev01a.xlsx
```

Check:
- [ ] All components have MPN
- [ ] No "DNP" (Do Not Place) confusion
- [ ] Quantities correct
- [ ] All parts available from distributor

**CPL Verification:**
- [ ] All components have X,Y positions
- [ ] Rotation values reasonable (0, 90, 180, 270)
- [ ] Top/bottom designation correct

---

## Revision Control

### Versioning Manufacturing Releases

Format: `[Board]-[Revision]-Release-v[X.Y]`

Examples:
- `Fold-rev01a-Release-v1.0` - Initial release
- `Fold-rev01a-Release-v1.1` - Corrected BOM (no design change)
- `Fold-rev01b-Release-v1.0` - New board revision

**When to increment:**
- **Major (v1.0 → v2.0):** New board revision
- **Minor (v1.0 → v1.1):** Corrected BOM/gerbers, same design

### Git Tags
Tag each manufacturing release:
```bash
git tag -a fold-rev01a-release-v1.0 -m "Fold Rev01a Manufacturing Release v1.0"
git push origin fold-rev01a-release-v1.0
```

---

## Manufacturing Package Checklist

Before releasing to manufacturer:

- [ ] Gerbers generated and verified in viewer
- [ ] Drill files included
- [ ] BOM complete with all MPNs
- [ ] CPL generated and spot-checked
- [ ] Interactive BOM created
- [ ] Schematic PDF generated (all sheets)
- [ ] Assembly drawings created
- [ ] Fabrication notes documented
- [ ] Stackup and impedance requirements documented
- [ ] RELEASE_MANIFEST.md completed
- [ ] All files checksummed
- [ ] Release package zipped
- [ ] Git tagged
- [ ] Approvals obtained

---

## See Also
- [Hardware Design Files](../hardware/README.md)
- [Fabrication Tools](../tools/fabrication/README.md)
- [Panelization Guide](../tools/panelization/README.md)
