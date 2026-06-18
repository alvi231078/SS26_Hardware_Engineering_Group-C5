# Vending Machine Controller — Project Roadmap
**Course:** Hardware Engineering Lab (SS 2026) · Prof. Dr.-Ing. Ali Hayek
**Platform:** Nexys A7-100T (Artix-7 XC7A100T) · VHDL

---

## Phase 1 — VHDL Implementation
**Timeline: Now → ~June 28**

Write all 6 modules, each in its own `.vhd` file with clean coding style (Prof. Hayek grades this explicitly).

| Module | Role |
|---|---|
| `coin_button` | Synchronise + debounce a button, emit one pulse per press |
| `fsm_controller` | Five-state control logic |
| `balance_accumulator` | 14-bit running balance in cents |
| `bin2bcd` | Binary balance → four BCD digits (double-dabble) |
| `seg7_driver` | Time-multiplexed 4-digit scan + BCD-to-segment decode |
| `top` | Wiring and I/O mapping |

---

## Phase 2 — Verification
**Timeline: Parallel with Phase 1**

Write testbenches for at least the FSM, accumulator, and display driver. 100% coverage is not required, but key state transitions must be tested.

---

## Phase 3 — FPGA Implementation
**Timeline: By ~June 30**

In Vivado: synthesize, implement, generate the XDC constraints file and bitstream.

- Save the synthesis report (resource usage, timing/frequency)
- Take screenshots of synthesis and implementation views

---

## Phase 4 — Hardware Validation
**Timeline: July 1**

Flash the bitstream onto the Nexys A7. Test all states:

- Insert coins (€0.50 / €1.00 / €2.00)
- Select product
- Dispense + show change
- Refund / cancel
- Insufficient funds signal

> **Record a short video** — the lab slides explicitly recommend this as evidence.

---

## Phase 5 — PCB Design
**Timeline: Parallel, ideally complete before July 2**

### Step 1 — Analyze Requirements
Your vending machine PCB needs:

- 4 push buttons (3× coin denominations + cancel)
- 1 reset button
- 3 slide switches (product select)
- 4-digit 7-segment display
- 3 status LEDs (`vend`, `low`, `coin_ok`)
- 100 MHz clock source
- Power supply

### Step 2 — Choose Your FPGA
Three options per the lab guidance:

| Option | FPGA | Notes |
|---|---|---|
| 1 | Artix-7 XC7A100T (same as Nexys A7) | Recommended — already familiar |
| 2 | Smaller FPGA | Easier design, but unknown device |
| 3 | Custom FPGA component | More learning, more work |

**Recommended: Option 1.** Check the Artix-7 datasheet for:
- Core voltage: ~1.0 V
- I/O voltage: 3.3 V
- All required power rails and JTAG pin requirements

### Step 3 — Design Schematic in Altium (Multi-Sheet)

| Sheet | Contents |
|---|---|
| Sheet 1 | Power supply — LDO regulators for core + I/O, decoupling caps near FPGA power pins |
| Sheet 2 | FPGA + JTAG programming interface |
| Sheet 3 | Clock oscillator (100 MHz) |
| Sheet 4 | Peripherals — buttons with pull-downs, switches, LEDs with resistors, 7-seg display |

### Step 4 — Run ERC
- Perform Electrical Rule Check in Altium
- Have a teammate review the schematic independently

### Step 5 — PCB Layout
Place components in this order:

1. FPGA
2. Power regulators
3. Configuration memory
4. Clock oscillator
5. Connectors
6. LEDs, switches, buttons

**Layout rules:**
- Decoupling capacitors placed very close to FPGA power pins
- Continuous ground plane — no splits
- Wide traces for power nets
- Short, clean clock traces
- Minimize unnecessary vias

### Step 6 — Run DRC
- Complete Design Rule Check
- Verify all FPGA pin assignments against XDC file

### Step 7 — Export Manufacturing Files
- Schematic PDF
- PCB layout file
- 3D board file
- Bill of Materials (BOM)
- Gerber files

---

## Phase 6 — Final Presentation
**Date: July 2, 2026**

Live demo on the Nexys A7 board + slides covering:

- Project concept and requirements
- FSM design and state diagram
- System architecture (block diagram)
- PCB design overview
- Who did what (documented team contributions)

---

## Phase 7 — Final Documentation Submission
**Due: July 9, 2026**

Package and submit all of the following:

- Concept document (already submitted June 11)
- All VHDL source files + libraries
- VHDL testbenches
- Synthesis report + screenshots (Vivado)
- XDC constraints file + bitstream
- Hardware validation evidence (video recommended)
- PCB: schematic, layout, 3D file, BOM, Gerber files
- Project management log — **"who did what"**

---

## Summary Timeline

| Phase | Task | Deadline |
|---|---|---|
| 1 | VHDL modules | ~June 28 |
| 2 | Testbenches | ~June 28 |
| 3 | Vivado synthesis + bitstream | ~June 30 |
| 4 | Hardware validation + video | July 1 |
| 5 | PCB schematic + layout + Gerbers | ~July 1 |
| 6 | Final presentation | **July 2** |
| 7 | Full documentation submission | **July 9** |
