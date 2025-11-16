# [Board Name] [Revision] Design Notes

**Board:** [Board Type - mainboard/yoke/defib]
**Revision:** [revXXa]
**Date Created:** YYYY-MM-DD
**Designer:** [Name]
**Status:** [development/prototype/released/obsolete]

---

## Revision Summary

Brief overview of this revision and its purpose.

---

## Changes from Previous Revision

### Major Changes
- [Change 1 - brief description]
- [Change 2 - brief description]

### Minor Changes
- [Change 1]
- [Change 2]

### Bug Fixes
- [Fix 1 - reference ECO number if applicable]
- [Fix 2]

### Related ECOs
- ECO-XXX: [Description]
- ECO-YYY: [Description]

---

## Design Decisions

### 1. [Design Decision Title]

**Decision:** [What was decided]

**Rationale:** [Why this decision was made]

**Alternatives Considered:**
- Option A: [Description] - Rejected because [reason]
- Option B: [Description] - Rejected because [reason]

**Impact:**
- Cost: [impact on cost]
- Performance: [impact on performance]
- Risk: [impact on safety/risk]

**References:**
- [Link to calculation, analysis, or external document]

### 2. [Another Design Decision]

...

---

## Critical Design Elements

### Power Supply

**Architecture:** [Description of power architecture]

**Key Components:**
- U1 (Regulator): [MPN] - [Rationale]
- C1 (Bulk cap): [Value] - [Rationale]

**Design Calculations:**
- Power budget: See `docs/design/calculations/power_budget.xlsx`
- Thermal analysis: See `docs/design/calculations/thermal_analysis.xlsx`

**Compliance:**
- IEC 60601-1 requirements: [How met]

### Signal Path

**ECG Analog Frontend:**
- Architecture: [Description]
- Key components: [List]
- Noise performance: [Specification]

**Critical Parameters:**
- Gain: [Value]
- Bandwidth: [Value]
- Input impedance: [Value]

### Isolation

**Isolation Barriers:**
- Primary isolation: [Component] - [Rating]
- Reinforced isolation: [Component] - [Rating]

**Creepage/Clearance:**
- Basic: [Distance] per IEC 60601-1
- Reinforced: [Distance] per IEC 60601-1

**Verification:** See `docs/verification/test_reports/[revision]/isolation_test_report.md`

### EMC Design

**Shielding:**
- [Description of shielding approach]

**Filtering:**
- Power line filtering: [Components]
- Signal filtering: [Components]

**PCB Layout Considerations:**
- Ground plane strategy: [Description]
- Signal routing: [Description]

---

## Design Calculations

### Power Budget

| Component | Current (mA) | Power (mW) | Notes |
|-----------|--------------|------------|-------|
| MCU | 50 | 165 | @3.3V |
| Analog Frontend | 25 | 82.5 | |
| Display | 100 | 330 | |
| **Total** | **175** | **577.5** | |

**Detailed calculation:** `docs/design/calculations/power_budget.xlsx`

### Thermal Analysis

- Ambient temperature: [Value]
- Max component temperature: [Value]
- Thermal resistance: [Value]
- Heat sink required: [Yes/No]

**Detailed analysis:** `docs/design/calculations/thermal_analysis.xlsx`

### Signal Integrity

- Critical signals: [List]
- Impedance requirements: [Values]
- Simulation results: `docs/design/calculations/signal_integrity/`

---

## Component Selection

### Critical Components

| Designator | Component | MPN | Rationale |
|------------|-----------|-----|-----------|
| U1 | Microcontroller | MSP432E401Y | Medical-grade, adequate processing power |
| U3 | Isolation Amp | ISO124 | 2xMOPP isolation, low noise |
| U5 | LDO | LM317 | Low dropout, stable |

**Detailed rationale:** `docs/design/component_selection/critical_components_rationale.md`

### Approved Parts List

All components are on the approved parts list: `docs/design/component_selection/approved_parts_list.xlsx`

### Obsolescence

- All components checked for lifecycle status
- No NRND (Not Recommended for New Design) parts used
- See: `docs/design/component_selection/obsolescence_plan.md`

---

## PCB Specifications

### Stack-up

- **Layers:** 4
- **Thickness:** 1.6mm
- **Material:** FR-4, Tg 170°C
- **Copper weight:** 1oz outer, 0.5oz inner

**Details:** `manufacturing/[board]/[revision]/fabrication/stackup.pdf`

### Design Rules

- **Minimum trace width:** 0.15mm
- **Minimum spacing:** 0.15mm
- **Minimum drill:** 0.3mm
- **Via size:** 0.6mm drill, 1.0mm pad

### Controlled Impedance

- USB differential pairs: 90Ω ± 10%
- [Other controlled impedance traces]

**Specifications:** `manufacturing/[board]/[revision]/fabrication/impedance_requirements.pdf`

---

## Standards Compliance

### IEC 60601-1 (Electrical Safety)

- [x] Isolation requirements met
- [x] Creepage/clearance verified
- [x] Protective earth connection
- [ ] Pending: [Any pending items]

**Checklist:** `docs/design/standards_compliance/IEC_60601-1_design_checklist.md`

### IEC 60601-1-2 (EMC)

- [x] Filtering on all I/O
- [x] PCB layout per EMC guidelines
- [ ] Pending: Full EMC testing

**Design notes:** `docs/design/standards_compliance/IEC_60601-1-2_emc_design.md`

### IEC 60601-2-27 (ECG Specific)

- [x] Input impedance requirements met
- [x] Defibrillator protection
- [x] ESU (electrosurgery) immunity design

---

## Known Issues

### Issue 1: [Description]

**Severity:** [Low/Medium/High]

**Impact:** [What is affected]

**Workaround:** [If available]

**Plan:** [How will be addressed - ECO number if planned]

### Issue 2: [Description]

...

**No known issues at time of release** ✓

---

## Design Verification Status

| Verification Activity | Status | Report Link |
|----------------------|--------|-------------|
| Electrical Safety | [ ] Not Started / [x] Pass / [ ] Fail | [Link] |
| Functional Testing | [ ] Not Started / [x] Pass / [ ] Fail | [Link] |
| EMC Pre-compliance | [ ] Not Started / [x] Pass / [ ] Fail | [Link] |
| Environmental | [ ] Not Started / [ ] Pass / [ ] Fail | [Link] |

**Summary:** See `VERIFICATION_SUMMARY.md`

---

## Risk Management

**Hazards Addressed:**
- HW-001: Electric shock - Mitigated by 2xMOPP isolation
- HW-002: EMI interference - Mitigated by filtering and shielding
- HW-003: Component failure - Mitigated by derating and redundancy

**Risk Analysis:** `docs/risk/hardware_hazard_analysis.xlsx`

---

## Manufacturing Notes

**PCB Fabrication:**
- Manufacturer: [Name]
- IPC Class: 3 (Medical device)
- Special requirements: [List]

**Assembly:**
- Assembly house: [Name]
- Special assembly requirements: [List]

**Release:** See `manufacturing/[board]/[revision]/RELEASE_MANIFEST.md`

---

## References

### Internal Documents
- [Link to related design document]
- [Link to calculation]
- [Link to test report]

### External References
- Datasheet: [Component] - [Link]
- Application note: [Title] - [Link]
- Standard: IEC 60601-1 Ed. 3.1

---

## Approval

**Design Review Date:** ___________

**Participants:**
- [ ] Engineering: ___________
- [ ] Quality: ___________
- [ ] Regulatory: ___________

**Approved for:** [ ] Prototype / [ ] Production

**Signatures:**
- Engineering Lead: ___________ Date: ___________
- Quality Manager: ___________ Date: ___________

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| YYYY-MM-DD | 1.0 | [Name] | Initial version |
| YYYY-MM-DD | 1.1 | [Name] | Added [what was added] |
