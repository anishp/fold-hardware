# Configuration and Templates

This directory contains configuration files, templates, and shared settings for the hardware repository.

## Directory Structure

```
config/
├── kicad/                      # KiCAD configuration
│   ├── sym-lib-table          # Symbol library table
│   ├── fp-lib-table           # Footprint library table
│   └── README.md
│
├── templates/                  # Document and project templates
│   ├── revision_template/      # Template for new hardware revision
│   └── document_templates/     # Document templates
│
└── git/                        # Git configuration
    └── .gitignore
```

---

## KiCAD Configuration (`kicad/`)

### Symbol Library Table (`sym-lib-table`)

Defines which symbol libraries are available to all projects.

**Format:**
```lisp
(sym_lib_table
  (version 7)
  (lib
    (name "Kallows_Symbols")
    (type "KiCad")
    (uri "${KIPRJMOD}/../../libraries/symbols/Kallows_Symbols.kicad_sym")
    (options "")
    (descr "Kallows custom symbols")
  )
)
```

**Path Variables:**
- `${KIPRJMOD}` - Path to the currently open KiCAD project directory
- Relative paths ensure portability across different machines

**Usage in Projects:**
Copy this file to each hardware revision directory, or reference it globally via KiCAD preferences.

### Footprint Library Table (`fp-lib-table`)

Defines which footprint libraries are available.

**Format:**
```lisp
(fp_lib_table
  (version 7)
  (lib
    (name "Kallows")
    (type "KiCad")
    (uri "${KIPRJMOD}/../../libraries/footprints/Kallows.pretty")
    (options "")
    (descr "Kallows custom footprints for mainboard")
  )
  (lib
    (name "KallowsYoke")
    (type "KiCad")
    (uri "${KIPRJMOD}/../../libraries/footprints/KallowsYoke.pretty")
    (options "")
    (descr "Kallows custom footprints for yoke board")
  )
  (lib
    (name "SamacSys_Parts")
    (type "KiCad")
    (uri "${KIPRJMOD}/../../libraries/footprints/SamacSys_Parts.pretty")
    (options "")
    (descr "Third-party footprints from SamacSys")
  )
)
```

### Setting Up Library Tables

#### Option 1: Per-Project (Recommended)
Copy library tables into each hardware revision directory:

```bash
cp config/kicad/sym-lib-table hardware/mainboard/rev06a/
cp config/kicad/fp-lib-table hardware/mainboard/rev06a/
```

**Pros:**
- Each project is self-contained
- Can customize libraries per project if needed

**Cons:**
- Changes need to be propagated to all projects

#### Option 2: Global
Configure KiCAD to use a global library table:

1. Preferences → Manage Symbol Libraries
2. Add libraries from `libraries/symbols/`
3. Preferences → Manage Footprint Libraries
4. Add libraries from `libraries/footprints/`

**Pros:**
- Configure once, applies to all projects

**Cons:**
- Not portable to other machines without setup
- Less explicit about project dependencies

---

## Templates (`templates/`)

### Revision Template (`templates/revision_template/`)

Template directory structure for creating new hardware revisions.

**Contents:**
```
revision_template/
├── DESIGN_NOTES.md
├── VERIFICATION_SUMMARY.md
└── metadata.json
```

**Usage:**
```bash
# Create new revision
cp -r config/templates/revision_template hardware/mainboard/rev07a

# Copy KiCAD files from previous revision
cp hardware/mainboard/rev06a/*.kicad_* hardware/mainboard/rev07a/

# Update metadata
cd hardware/mainboard/rev07a
# Edit metadata.json, DESIGN_NOTES.md
```

#### DESIGN_NOTES.md Template

See `templates/revision_template/DESIGN_NOTES.md` for full template.

**Sections:**
- Revision information
- Changes from previous revision
- Critical design decisions
- Known issues
- Design calculations
- Compliance notes

#### VERIFICATION_SUMMARY.md Template

See `templates/revision_template/VERIFICATION_SUMMARY.md` for full template.

**Sections:**
- Tests completed (table)
- Test results
- Outstanding issues
- Approval signatures

#### metadata.json Template

Machine-readable metadata about the revision.

**Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "board_name": {"type": "string"},
    "revision": {"type": "string", "pattern": "^rev\\d{2}[a-z]$"},
    "date_created": {"type": "string", "format": "date"},
    "created_by": {"type": "string"},
    "kicad_version": {"type": "string"},
    "status": {
      "type": "string",
      "enum": ["development", "prototype", "released", "obsolete"]
    },
    "compliance": {
      "type": "object",
      "properties": {
        "iec_60601_1": {"type": "string"},
        "iec_60601_1_2": {"type": "string"},
        "iec_60601_2_27": {"type": "string"}
      }
    },
    "verification_status": {
      "type": "string",
      "enum": ["not_started", "in_progress", "complete"]
    },
    "manufacturing_status": {
      "type": "string",
      "enum": ["not_released", "prototype", "in_production", "discontinued"]
    }
  },
  "required": ["board_name", "revision", "date_created", "status"]
}
```

**Example:**
```json
{
  "board_name": "mobmon12_mainboard",
  "revision": "rev07a",
  "date_created": "2024-04-01",
  "created_by": "John Doe",
  "kicad_version": "9.0",
  "status": "development",
  "compliance": {
    "iec_60601_1": "designed_for",
    "iec_60601_1_2": "designed_for",
    "iec_60601_2_27": "designed_for"
  },
  "verification_status": "not_started",
  "manufacturing_status": "not_released",
  "notes": "New power supply architecture"
}
```

### Document Templates (`templates/document_templates/`)

Templates for common documentation files.

**Contents:**
- `ECO_template.md` - Engineering Change Order template
- `test_report_template.md` - Verification test report template
- `test_plan_template.md` - Test plan template
- `test_procedure_template.md` - Detailed test procedure template

**Usage:**
```bash
# Create new ECO
cp config/templates/document_templates/ECO_template.md docs/changes/ECO_042_description.md

# Edit and fill in details
```

---

## Git Configuration (`git/`)

### .gitignore

Defines which files should NOT be tracked in version control.

**Categories:**

#### KiCAD Generated Files
```gitignore
# KiCAD temporary files
*.kicad_prl              # Project local settings
*-backups/               # Auto-backup directories
fp-info-cache            # Footprint cache
*.bak                    # Backup files
*.bck                    # Backup files
*.kicad_pcb-bak          # PCB backup
*.sch-bak                # Schematic backup
```

#### Manufacturing Outputs (Conditionally)
```gitignore
# Generated manufacturing files (regenerate from source)
manufacturing/*/gerbers/*.gbr
manufacturing/*/gerbers/*.drl
manufacturing/*/assembly/ibom.html

# Keep release packages
!manufacturing/*/gerbers/*.zip
!manufacturing/*/RELEASE_MANIFEST.md
```

#### Python
```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
*.egg-info/
```

#### Configuration (with secrets)
```gitignore
# Configuration files with secrets
tools/*/config.yaml
tools/*/.env
*.secret
*.key
```

#### OS Files
```gitignore
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# Linux
*~
.directory
```

#### IDEs
```gitignore
# VSCode
.vscode/
*.code-workspace

# PyCharm
.idea/

# Vim
*.swp
*.swo
```

### .gitattributes

Defines how Git handles different file types.

```gitattributes
# KiCAD files are text
*.kicad_sch text
*.kicad_pcb text
*.kicad_pro text
*.kicad_sym text
*.kicad_mod text

# Gerber files are text
*.gbr text
*.gbl text
*.gtl text
*.gbs text
*.gts text
*.gko text
*.drl text

# Documentation
*.md text
*.txt text

# Binary files
*.pdf binary
*.png binary
*.jpg binary
*.step binary
*.stl binary
*.FCStd binary
*.zip binary

# Line endings: LF for all text files
* text=auto eol=lf

# Excel files
*.xlsx binary
*.xls binary
```

---

## Configuration Best Practices

### 1. Relative Paths
Always use relative paths in configuration files:

✅ Good:
```
../../libraries/symbols/Kallows_Symbols.kicad_sym
```

❌ Bad:
```
/home/user/KiCADv9/libraries/symbols/Kallows_Symbols.kicad_sym
C:\Users\User\KiCADv9\libraries\symbols\Kallows_Symbols.kicad_sym
```

### 2. Environment Variables
Use KiCAD environment variables where possible:

- `${KIPRJMOD}` - Project directory
- `${KICAD7_SYMBOL_DIR}` - KiCAD symbol library directory
- `${KICAD7_FOOTPRINT_DIR}` - KiCAD footprint library directory

### 3. Separation of Secrets
Never commit secrets to Git:

- API keys → environment variables or config files (gitignored)
- Passwords → external password manager
- Certificates → secure vault

**Example: Using environment variables**
```python
import os

API_KEY = os.getenv('MOUSER_API_KEY')
if not API_KEY:
    raise ValueError("MOUSER_API_KEY environment variable not set")
```

### 4. Template Versioning
When updating templates, document changes:

```markdown
# Template Changelog

## metadata.json

### v2.0 - 2024-03-15
- Added `compliance` field
- Added `verification_status` field

### v1.0 - 2023-11-10
- Initial template
```

---

## Maintaining Configuration

### Updating Library Tables

When adding a new library:

1. Add library files to `libraries/`
2. Update `config/kicad/sym-lib-table` or `fp-lib-table`
3. Propagate to existing projects:
   ```bash
   # Update all mainboard revisions
   for rev in hardware/mainboard/rev*/; do
       cp config/kicad/fp-lib-table "$rev"
   done
   ```

### Template Updates

When updating templates:

1. Update template in `config/templates/`
2. Document changes in template changelog
3. Notify team
4. DON'T automatically update existing documents (preserve historical record)

### Version Control

Configuration files should be:
- ✅ Tracked in Git (except secrets)
- ✅ Reviewed before merging
- ✅ Tested before deployment
- ✅ Documented when changed

---

## Troubleshooting

### "Library not found" errors

1. Check library table paths are correct
2. Verify library files exist in `libraries/`
3. Check `${KIPRJMOD}` resolves correctly (should be revision directory)
4. Try absolute path temporarily to debug

### Git ignoring files that should be tracked

Check `.gitignore` patterns. Use `git check-ignore`:
```bash
git check-ignore -v path/to/file
```

This shows which .gitignore rule is matching the file.

### Metadata validation failures

Validate metadata.json:
```bash
cd tools/fabrication
python validate_metadata.py ../../hardware/mainboard/rev06a/metadata.json
```

---

## See Also
- [KiCAD Library Tables Documentation](https://docs.kicad.org/master/en/kicad/kicad.html#library_tables)
- [Git Documentation](https://git-scm.com/doc)
- [JSON Schema](https://json-schema.org/)
