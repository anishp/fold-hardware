# Mechanical CAD Files

This directory contains mechanical CAD files for enclosures, covers, and mechanical components.

## Directory Structure

```
mechanical/
├── enclosure/                # Main device enclosure
│   ├── freecad/             # FreeCAD source files
│   ├── step/                # STEP files for interchange
│   ├── stl/                 # STL files for 3D printing
│   ├── drawings/            # Engineering drawings (PDF)
│   └── README.md
│
└── connectors/              # Connector covers and accessories
    ├── freecad/
    │   ├── usb_cover.FCStd
    │   └── dsub_cover.FCStd
    ├── stl/
    │   ├── usb_cover.stl
    │   └── dsub_cover.stl
    ├── step/
    └── README.md
```

---

## File Formats

### FreeCAD (.FCStd)
**Purpose:** Source CAD files for parametric modeling

**Software:** FreeCAD 0.20 or later
**Why:** Open-source, version-controllable, parametric modeling

**Recommended Workflow:**
1. Design in FreeCAD
2. Export STEP for interchange
3. Export STL for prototyping/printing
4. Export PDF drawings for documentation

### STEP (.step, .stp)
**Purpose:** Industry-standard 3D format for interchange

**Uses:**
- Import into other CAD software (SolidWorks, Fusion360)
- Mechanical clearance checking in KiCAD
- Manufacturing (CNC, injection molding)

### STL (.stl)
**Purpose:** 3D printing and rapid prototyping

**Uses:**
- FDM 3D printing
- SLA/resin printing
- Visualization

**Note:** STL is mesh-based (not parametric). Always keep FreeCAD source files.

### Engineering Drawings (.pdf)
**Purpose:** Manufacturing documentation

**Contents:**
- Dimensions with tolerances
- Material specifications
- Surface finish requirements
- Assembly notes

---

## Connectors

### USB Cover
**File:** `connectors/freecad/usb_cover.FCStd`

**Purpose:** Protective cover for USB connector

**Specifications:**
- Material: ABS or PLA (for prototypes)
- Wall thickness: 2mm
- Snap-fit attachment
- Clearance: 0.5mm around connector

**Manufacturing:**
- **Prototype:** 3D print using `usb_cover.stl`
- **Production:** Injection molding using `usb_cover.step`

### D-SUB Cover
**File:** `connectors/freecad/dsub_cover.FCStd`

**Purpose:** Protective cover for D-SUB connector

**Specifications:**
- Material: ABS
- Wall thickness: 2mm
- Screw mounting

---

## Working with FreeCAD Files

### Opening Files
```bash
freecad connectors/freecad/usb_cover.FCStd
```

### Exporting to STEP
1. Open FreeCAD file
2. Select part body to export
3. File → Export → Select "STEP with colors (*.step)"
4. Save to `mechanical/connectors/step/usb_cover.step`

### Exporting to STL
1. Select part body
2. File → Export → Select "STL Mesh (*.stl)"
3. Settings:
   - Deviation: 0.1mm (lower = higher quality)
   - Angular deflection: 15° (lower = smoother curves)
4. Save to `mechanical/connectors/stl/usb_cover.stl`

### Exporting Drawings
1. Switch to TechDraw workbench
2. Create drawing page
3. Add views (front, top, side, isometric)
4. Add dimensions
5. File → Export PDF
6. Save to `mechanical/connectors/drawings/usb_cover.pdf`

---

## Integration with PCB Design

### Importing to KiCAD for Clearance Checking

1. **Open KiCAD 3D Viewer**
   - In PCB Editor: View → 3D Viewer

2. **Add Mechanical Component:**
   - In 3D Viewer: Preferences → Manage 3D Shapes Paths
   - Add path to `mechanical/enclosure/step/`

3. **Place Model on PCB:**
   - Edit → Add 3D Model
   - Select STEP file
   - Position relative to board

4. **Check Clearances:**
   - Verify components don't interfere with enclosure
   - Check connector accessibility
   - Verify mounting holes align

---

## Design Guidelines

### Medical Device Considerations

**Material Requirements (IEC 60601-1):**
- Flammability: UL94 V-0 or better
- Biocompatibility: ISO 10993 (for patient-contact parts)
- Cleanable: Smooth surfaces, no sharp edges

**Enclosure Requirements:**
- IP Rating: Typically IP21 or better for medical devices
- Ventilation: Required for heat dissipation
- Access: Easy access to serviceable parts
- Labeling: Space for regulatory labels

### 3D Printing for Prototypes

**FDM Settings (PLA/ABS):**
- Layer height: 0.2mm
- Infill: 20% (prototypes), 100% (functional parts)
- Wall thickness: 3 perimeters minimum
- Support: Enable for overhangs >45°

**Post-Processing:**
- Sand with 220+ grit sandpaper
- Vapor smoothing (ABS only): Acetone vapor
- Painting: Prime, sand, paint

### Design for Manufacturing (DFM)

**Injection Molding:**
- Draft angle: 2-5° on all vertical walls
- Wall thickness: 1.5-3mm (uniform if possible)
- Ribs: 50-60% of nominal wall thickness
- Avoid undercuts (or design for side actions)

**CNC Machining:**
- Avoid sharp internal corners (use radius)
- Standard tool sizes (e.g., 3mm, 6mm endmills)
- Minimize setups (design for 2-axis or 3-axis)

---

## Revision Control

### Versioning Mechanical Parts

Include version in filename or FreeCAD metadata:
- `usb_cover_v1.FCStd`
- `usb_cover_v2.FCStd`

**When to create new version:**
- Dimensional changes
- Material changes
- Functional changes

### Documenting Changes

Create a `CHANGELOG.md` in each directory:
```markdown
# Mechanical Parts Changelog

## USB Cover

### v2.0 - 2024-03-15
- Increased wall thickness from 1.5mm to 2mm for durability
- Added snap-fit tabs for easier assembly
- Material changed from PLA to ABS

### v1.0 - 2023-11-10
- Initial design
```

### Git Workflow

**FreeCAD files are binary** - Git can track them but diff/merge is not meaningful.

**Best practices:**
1. Commit frequently with clear messages
2. Don't commit temp files (`*.FCStd1`, `*.FCStd#`)
3. Tag releases: `mechanical-usb-cover-v2.0`
4. Keep STEP and STL exports synchronized with source

---

## Manufacturing

### 3D Printing (Prototypes)

**Internal Prototyping:**
1. Export STL from FreeCAD
2. Import to slicer (Cura, PrusaSlicer)
3. Configure settings
4. Print

**External Services:**
- Shapeways
- Sculpteo
- i.materialise

Upload STL files and specify:
- Material (PLA, ABS, Nylon, etc.)
- Finish (raw, sanded, painted)
- Quantity

### Injection Molding (Production)

**Requirements:**
- STEP file of part
- Engineering drawing with tolerances
- Material specification
- Surface finish requirements
- Quantity (typically 1000+ for cost effectiveness)

**Process:**
1. Send STEP and drawings to moldmaker
2. Review mold design and DFM feedback
3. Approve mold (T0 samples)
4. First article inspection
5. Production run

### CNC Machining

**Requirements:**
- STEP file
- Engineering drawing
- Material specification (e.g., Aluminum 6061-T6)
- Quantity

**Good for:**
- Low volume (<100 parts)
- Metal parts
- High precision requirements

---

## Enclosure Design Checklist

For main device enclosure:

**Mechanical:**
- [ ] PCB mounting provisions (standoffs, holes)
- [ ] Connector cutouts with clearance
- [ ] Display window/cutout
- [ ] Button access
- [ ] Ventilation holes (if needed)
- [ ] Assembly screws accessible
- [ ] Cable management

**Electrical:**
- [ ] Shielding (if required for EMC)
- [ ] Grounding provisions
- [ ] Wire routing channels

**Medical Device:**
- [ ] Material: UL94 V-0 rated
- [ ] Cleanable surfaces
- [ ] No sharp edges
- [ ] Labeling areas:
  - Device name and model
  - Regulatory marks (CE, FDA, etc.)
  - Serial number
  - Warnings and symbols

**User Interface:**
- [ ] Ergonomic access to controls
- [ ] Clear visibility of display
- [ ] Tactile feedback on buttons
- [ ] Accessible battery compartment (if applicable)

---

## Tools and Software

### Recommended Software

**FreeCAD** (Open Source)
- Download: https://www.freecadweb.org/
- Used for: Primary CAD design

**Blender** (Open Source, optional)
- For: Rendering, visualization
- STL cleanup and modification

**MeshLab** (Open Source)
- For: STL inspection, repair, analysis

### Online Tools

**STL Viewers:**
- https://www.viewstl.com/
- https://www.3dviewer.net/

**STEP Viewers:**
- FreeCAD (local)
- https://www.sharecad.org/ (online)

---

## See Also
- [Hardware Design Files](../hardware/README.md) - For PCB mechanical dimensions
- [KiCAD 3D Viewer Guide](https://docs.kicad.org/master/en/pcbnew/pcbnew.html#3d-viewer)
- [FreeCAD Documentation](https://wiki.freecadweb.org/)
