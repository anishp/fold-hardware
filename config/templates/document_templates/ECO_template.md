# ECO-NNN: [Brief Description]

**ECO Number:** ECO-NNN
**Date Created:** YYYY-MM-DD
**Created By:** [Name]
**Status:** Open | In Progress | Closed | Rejected | Deferred

---

## Problem Description

### Background
[Describe the context and background leading to this ECO]

### Issue
[Clearly describe the problem, deficiency, or improvement opportunity]

**Discovered During:**
- [ ] Design review
- [ ] Verification testing
- [ ] Validation testing
- [ ] Manufacturing
- [ ] Field use
- [ ] Other: ___________

**Evidence:**
- Test report: [Link to test report if applicable]
- Failure mode: [Description]
- Photos/screenshots: [Link to evidence]

---

## Root Cause Analysis

### Investigation
[Describe the investigation process]

### Root Cause
[What is the fundamental cause of the issue?]

**Root Cause Category:**
- [ ] Design error
- [ ] Component selection
- [ ] Manufacturing process
- [ ] Specification error
- [ ] Test procedure error
- [ ] Other: ___________

### Contributing Factors
- [Factor 1]
- [Factor 2]

---

## Proposed Solution

### Description
[Detailed description of the proposed change]

### Implementation

#### Schematic Changes
- [ ] No schematic changes
- [x] Schematic changes required:
  - Sheet: [Sheet name]
  - Change: [Description of change]
  - Components affected: [List]

#### PCB Layout Changes
- [ ] No layout changes required
- [x] Layout changes required:
  - Change: [Description]
  - Layers affected: [List]
  - Critical traces: [Description]

#### BOM Changes
- [ ] No BOM changes
- [x] BOM changes:

| Designator | Old Component | Old MPN | New Component | New MPN | Reason |
|------------|---------------|---------|---------------|---------|--------|
| R15 | 10kΩ 0805 | RC0805FR-0710KL | 22kΩ 0805 | RC0805FR-0722KL | Increase RC time constant |

#### Firmware Changes
- [ ] No firmware changes required
- [ ] Firmware changes required: [Description]

#### Documentation Changes
- [x] Update DESIGN_NOTES.md
- [x] Update test procedures: [Which ones]
- [ ] Update user manual
- [ ] Update risk analysis
- [ ] Other: ___________

---

## Impact Analysis

### Affected Boards
- [x] Mainboard (all revisions / specific revisions: _____)
- [ ] Yoke board
- [ ] Defib board

### Affected Revisions
**Implement in:**
- [x] rev07a (next revision)
- [ ] rev06b (current revision - requires rework)

**Retrofit existing boards?**
- [ ] Yes - retrofit required for [serial numbers/lot numbers]
- [x] No - apply to new production only

### Technical Impact
**Performance:**
- Improvement: [Describe]
- Degradation: [Describe if any]
- No change: [ ]

**Cost:**
- Cost increase: [Amount per unit]
- Cost decrease: [Amount per unit]
- No change: [x]

**Schedule:**
- Delay: [Duration if any]
- No impact: [x]

**Validation/Verification:**
- [x] Requires re-test: [Which tests]
- [ ] No re-test required

**Manufacturing:**
- [ ] Manufacturing process changes required
- [x] No manufacturing impact

### Regulatory Impact

**Design History File (DHF):**
- [x] DHF update required
- [ ] No DHF update

**Risk Management File (RMF):**
- [x] Risk analysis update required (new risk/control modified)
- [ ] No RMF update

**Regulatory Submission:**
- [ ] Requires regulatory notification (major change)
- [x] Does not require notification (minor change)

**Justification:**
[Explain why this change does/doesn't require regulatory submission]

---

## Risk Assessment

### Risk Before Change
**Hazard:** [Describe hazard if applicable]
**Severity:** [Catastrophic / Critical / Marginal / Negligible]
**Probability:** [Frequent / Probable / Occasional / Remote / Improbable]
**Risk Level:** [Unacceptable / Undesirable / Acceptable]

### Risk After Change
**Severity:** [After mitigation]
**Probability:** [After mitigation]
**Risk Level:** [After mitigation]

**Risk Benefit Analysis:**
[If change introduces new risk, justify benefit outweighs risk]

### New Risks Introduced
- [x] No new risks
- [ ] New risks introduced: [Describe]

---

## Verification Plan

### Verification Required
- [x] Schematic review
- [x] Layout DRC check
- [x] Prototype build and test
- [x] Specific tests: [List]

### Test Plan
| Test | Requirement | Acceptance Criteria |
|------|-------------|---------------------|
| Power supply ripple | <50mVpp | Measure with scope |
| Functional test | All pass | Run full test suite |

### Success Criteria
- [ ] All verification tests pass
- [ ] No new issues introduced
- [ ] Performance meets requirements

---

## Implementation

### Implementation Status
- [ ] Not started
- [x] Design changes made
- [ ] Prototype built
- [ ] Tested
- [ ] Approved for production

### Implemented In
**Revision:** rev07a
**Git Commit:** [commit hash]
**Date Implemented:** YYYY-MM-DD

### Files Changed
- `hardware/mainboard/rev07a/mobmon12_mainboard.kicad_sch` - Changed R15 value
- `hardware/mainboard/rev07a/POWER_SUPPLY.kicad_sch` - Updated circuit
- `hardware/mainboard/rev07a/mobmon12_mainboard.kicad_pcb` - Updated layout
- `manufacturing/mainboard/rev07a/assembly/bom_rev07a.xlsx` - Updated BOM

---

## Verification Results

### Prototype Testing
**Date:** YYYY-MM-DD
**Tested By:** [Name]

| Test | Result | Status |
|------|--------|--------|
| Power supply ripple | 18mVpp | ✓ PASS (req: <50mVpp) |
| Defib pulse recovery | 4.2 seconds | ✓ PASS (req: <5 seconds) |
| Functional test suite | 25/25 pass | ✓ PASS |

**Test Report:** `docs/verification/test_reports/rev07a/eco_042_verification.md`

### Issues Found
- [x] No issues
- [ ] Issues found: [Describe]

---

## Approvals

### Design Review
**Review Date:** YYYY-MM-DD
**Participants:**
- Design Engineer: [Name]
- Test Engineer: [Name]
- Quality Engineer: [Name]

**Decision:** [ ] Approve / [ ] Reject / [ ] Defer / [x] Approve with conditions

**Conditions:**
1. [Condition if any]

### Signatures

**Originator:** ___________ Date: ___________
(Confirms ECO is complete and accurate)

**Engineering Manager:** ___________ Date: ___________
(Approves technical solution)

**Quality Manager:** ___________ Date: ___________
(Approves from quality/regulatory perspective)

**Manufacturing Manager:** ___________ Date: ___________ [If manufacturing impact]
(Approves manufacturing feasibility)

---

## Closure

**Closed By:** [Name]
**Closure Date:** YYYY-MM-DD

**Closure Criteria Met:**
- [x] Change implemented in design
- [x] Verification testing passed
- [x] Documentation updated
- [x] Approvals obtained
- [x] No outstanding issues

**Verification:**
Effectiveness of change confirmed in:
- Test report: [Link]
- Production build: [Lot number / date]

**Lessons Learned:**
[What was learned from this issue and ECO process?]

---

## Related Items

### Related ECOs
- ECO-XXX: [Related change]

### Related Nonconformances
- NCR-XXX: [If this ECO addresses a nonconformance]

### Related CAPAs
- CAPA-XXX: [If this ECO is part of corrective action]

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| YYYY-MM-DD | 1.0 | [Name] | ECO created |
| YYYY-MM-DD | 1.1 | [Name] | Updated after design review |
| YYYY-MM-DD | 2.0 | [Name] | Implementation completed |
| YYYY-MM-DD | 2.1 | [Name] | Closed after verification |

---

## Attachments

### Documents
- [ ] Schematic PDF (before/after)
- [ ] Layout images (before/after)
- [ ] Test report
- [ ] Photos of issue
- [ ] Other: ___________

### Files
- [Link to test data]
- [Link to simulation results]
- [Link to calculation]
