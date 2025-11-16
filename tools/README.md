# Tools and Scripts

This directory contains automation scripts and utilities for hardware development workflows.

## Directory Structure

```
tools/
├── bom/                    # BOM management and sourcing
├── panelization/           # PCB panelization scripts
├── fabrication/            # Manufacturing output generation
└── traceability/           # Traceability and compliance tools
```

---

## BOM Tools (`bom/`)

### kallows_bom_search.py
**Purpose:** Search Mouser API for parts and pricing using MPN from BOM

**Usage:**
```bash
cd tools/bom
python kallows_bom_search.py --bom ../../manufacturing/fold/rev01a/assembly/bom_rev01a.csv
```

**Configuration:**
- API key should be moved to `config.yaml` (not hardcoded)
- See `config.example.yaml` for format

**Output:**
- Part availability
- Pricing (breaks at different quantities)
- Stock levels
- Alternate suppliers

### bom_validator.py
**Purpose:** Validate BOM against approved parts list and design rules

**Usage:**
```bash
python bom_validator.py --bom ../../manufacturing/fold/rev01a/assembly/bom_rev01a.xlsx
```

**Checks:**
- All components have MPN
- All components on approved parts list
- No obsolete/NRND parts
- Lifecycle status check
- Duplicate designators
- Missing datasheets

**Output:**
```
BOM Validation Report
=====================
✓ All components have MPNs
✓ No duplicate designators
⚠ Warning: R15 (MPN: RC0805FR-0710KL) is NRND (Not Recommended for New Designs)
✗ Error: U5 (MPN: LM324XYZ) not found on approved parts list

Summary:
- Total components: 125
- Passed: 123
- Warnings: 1
- Errors: 1
```

### Installation
```bash
cd tools/bom
pip install -r requirements.txt
```

**requirements.txt:**
```
requests>=2.28.0
pandas>=1.5.0
openpyxl>=3.0.10  # For Excel file support
pyyaml>=6.0
```

---

## Panelization Tools (`panelization/`)

### panelize_multiple.py
**Purpose:** Create manufacturing panels from multiple board designs using KiKit

**Features:**
- Combine different boards on one panel (e.g., mainboard + yoke)
- Add rails, mouse bites, tooling holes
- Optimize panel size for manufacturer

**Usage:**
```bash
cd tools/panelization
python panelize_multiple.py --config panelize_config.yaml
```

**Configuration: panelize_config.yaml**
```yaml
panel:
  output: "../../manufacturing/panels/fold_panel_v1/panel.kicad_pcb"
  size: [200, 150]  # mm

boards:
  - path: "../../hardware/fold/rev01a/mobmon fold.kicad_pcb"
    count: 4
    spacing: 5  # mm

framing:
  type: "railstb"  # rails top/bottom
  width: 5  # mm

tabs:
  type: "mousebites"
  width: 3
  spacing: 10

tooling:
  type: "3hole"
  size: 3  # mm
  hoffset: 5
  voffset: 5
```

**Installation:**
```bash
# Install KiKit
pip install kikit

# Or use KiCAD's built-in Python
# On Linux:
/usr/share/kicad/bin/python3 -m pip install kikit
```

### Manual Panelization
For simple single-board panelization:

```bash
kikit panelize \
  --layout 'grid; rows: 2; cols: 3; space: 2mm' \
  --tabs 'fixed; width: 3mm; vcount: 2' \
  --cuts 'mousebites; drill: 0.5mm; spacing: 1mm; offset: 0.2mm' \
  --framing 'railstb; width: 5mm' \
  input.kicad_pcb output_panel.kicad_pcb
```

---

## Fabrication Tools (`fabrication/`)

### generate_manufacturing_outputs.py
**Purpose:** Automated generation of all manufacturing outputs from KiCAD project

**Usage:**
```bash
cd tools/fabrication
python generate_manufacturing_outputs.py --board fold --revision rev01a
```

**Generates:**
1. Gerber files (all layers)
2. Drill files (Excellon format)
3. BOM (CSV and XLSX)
4. Component placement list (CPL)
5. Interactive BOM (HTML)
6. Schematic PDF (all sheets)
7. Assembly drawings (PDF)
8. Checksums (MD5)

**Output Location:**
```
manufacturing/[board]/[revision]/
├── gerbers/
├── assembly/
└── documentation/
```

**Requirements:**
```bash
pip install -r requirements.txt
```

**requirements.txt:**
```
kicad-python>=0.2.0
pandas>=1.5.0
openpyxl>=3.0.10
```

### validate_design.py
**Purpose:** Run design validation checks before committing or releasing

**Usage:**
```bash
python validate_design.py --board fold --revision rev01a
```

**Checks:**
1. **Electrical Rules Check (ERC):**
   - Unconnected pins
   - Missing power connections
   - Conflicting drivers

2. **Design Rules Check (DRC):**
   - Clearance violations
   - Track width violations
   - Unconnected traces

3. **Library Checks:**
   - All symbols found
   - All footprints found
   - 3D models present

4. **Metadata Validation:**
   - metadata.json exists and valid
   - Required fields present
   - Revision numbers match

**Output:**
```
Design Validation Report: Fold Rev01a
==========================================

Electrical Rules Check:
  ✓ No unconnected pins
  ✓ All power nets connected
  ⚠ Warning: Pin 7 of U3 not connected (NC pin)

Design Rules Check:
  ✓ No clearance violations
  ✓ All track widths within limits
  ✓ No unconnected copper

Library Check:
  ✓ All symbols found (125/125)
  ✓ All footprints found (125/125)
  ⚠ Missing 3D model: U12

Metadata Check:
  ✓ metadata.json exists
  ✓ All required fields present
  ✓ Revision matches directory name

Summary:
  Errors: 0
  Warnings: 2
  Status: PASS (warnings acceptable)
```

### generate_release_package.py
**Purpose:** Create complete release package for manufacturing

**Usage:**
```bash
python generate_release_package.py --board fold --revision rev01a --output fold_rev01a_release_v1.0.zip
```

**Package Contents:**
- All manufacturing outputs
- RELEASE_MANIFEST.md
- Checksums
- README with file descriptions

---

## Traceability Tools (`traceability/`)

### generate_bom_traceability.py
**Purpose:** Generate traceability matrix linking BOM to requirements and risks

**Usage:**
```bash
cd tools/traceability
python generate_bom_traceability.py --board fold --revision rev01a
```

**Output:** `bom_traceability_rev01a.xlsx`

| Component | MPN | Function | Related Requirement | Related Risk | Verification |
|-----------|-----|----------|---------------------|--------------|--------------|
| U1 | NRF52840-QIAA-R | Wireless MCU | REQ-SYS-001 | RISK-SW-001 | VER-FUNC-001 |
| U2 | ADS1294 | ECG AFE | REQ-ECG-001 | RISK-HW-001 | VER-ECG-001 |

**Purpose:** For regulatory submissions showing how hardware implements safety requirements.

---

## General Tool Guidelines

### Configuration Management

**DO NOT hardcode sensitive information:**
- ❌ API keys in source code
- ❌ Absolute paths
- ❌ Usernames/passwords

**DO use configuration files:**
```yaml
# config.yaml (gitignored)
mouser_api_key: "your-key-here"
output_directory: "../../manufacturing"

# config.example.yaml (committed)
mouser_api_key: "YOUR_API_KEY_HERE"
output_directory: "../../manufacturing"
```

Add to `.gitignore`:
```
tools/*/config.yaml
tools/*/*.env
```

### Python Virtual Environments

Create virtual environment per tool directory:

```bash
cd tools/bom
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows

pip install -r requirements.txt
```

Add to `.gitignore`:
```
tools/*/venv/
tools/*/__pycache__/
```

### Error Handling

All scripts should:
- Check for file existence before processing
- Provide clear error messages
- Exit with appropriate codes (0 = success, non-zero = error)
- Log operations for debugging

**Example:**
```python
import sys
import logging

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

try:
    # ... do work ...
    logging.info("Manufacturing outputs generated successfully")
    sys.exit(0)
except FileNotFoundError as e:
    logging.error(f"File not found: {e}")
    sys.exit(1)
except Exception as e:
    logging.error(f"Unexpected error: {e}")
    sys.exit(2)
```

---

## Creating New Tools

### Template Structure

```
tools/new_tool/
├── README.md                  # Tool-specific documentation
├── requirements.txt           # Python dependencies
├── config.example.yaml        # Example configuration
├── main_script.py             # Main script
└── tests/                     # Unit tests (optional)
    └── test_main.py
```

### README Template

```markdown
# Tool Name

## Purpose
Brief description of what this tool does.

## Usage
\`\`\`bash
python script_name.py --arg1 value1 --arg2 value2
\`\`\`

## Arguments
- `--arg1`: Description of argument 1
- `--arg2`: Description of argument 2

## Configuration
Copy `config.example.yaml` to `config.yaml` and fill in values.

## Installation
\`\`\`bash
pip install -r requirements.txt
\`\`\`

## Examples
[Examples of common use cases]

## Troubleshooting
[Common issues and solutions]
```

---

## Continuous Integration

### Running Tools in CI/CD

Example GitHub Actions workflow:

```yaml
name: Validate Design

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install dependencies
        run: |
          cd tools/fabrication
          pip install -r requirements.txt

      - name: Validate design
        run: |
          cd tools/fabrication
          python validate_design.py --board fold --revision rev01a
```

---

## See Also
- [Manufacturing Outputs](../manufacturing/README.md)
- [Hardware Design Files](../hardware/README.md)
- [KiCAD Python API](https://docs.kicad.org/doxygen-python/namespaces.html)
- [KiKit Documentation](https://github.com/yaqwsx/KiKit)
