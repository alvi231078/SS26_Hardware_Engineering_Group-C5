Phase 1 — VHDL Implementation (now → ~June 28)
Write all 6 modules: coin_button, fsm_controller, balance_accumulator, bin2bcd, seg7_driver, top. Each in its own .vhd file with clean coding style (Prof. Hayek grades this explicitly).
Phase 2 — Verification (parallel with Phase 1)
Write testbenches for at least the FSM, accumulator, and display driver. 100% coverage not required, but key state transitions must be tested.
Phase 3 — FPGA Implementation (by ~June 30)
In Vivado: synthesize, implement, generate the XDC constraints file and bitstream. Save the synthesis report (resource usage, timing/frequency). Take screenshots of synthesis and implementation views.
Phase 4 — Hardware Validation (July 1)
Flash the bitstream onto the Nexys A7. Test all states: insert coins, select product, dispense, refund, insufficient funds. Record a short video — the slides explicitly recommend this.
Phase 5 — PCB Design (parallel, ideally done before July 2)
This is where Lab 08 becomes critical. The required steps are:

Analyze requirements — your vending machine needs: 4 push buttons (coins + cancel), 3 slide switches (product select), 1 reset button, 4-digit 7-seg display, 3 LEDs (vend/low/coin_ok), clock, power
Choose your FPGA — the slides give 3 options. Simplest: reuse the Artix-7 XC7A100T (you already know it). Check its datasheet for core voltage (~1.0V), I/O voltage (3.3V), and required power rails
Design schematic in Altium using multiple sheets:

Sheet 1: Power supply (LDO regulators for core + I/O, decoupling caps near FPGA power pins)
Sheet 2: FPGA + JTAG programming interface
Sheet 3: Clock oscillator (100 MHz)
Sheet 4: Peripherals (buttons with pull-downs, switches, LEDs with resistors, 7-seg display)


Run ERC and have a teammate review it
PCB Layout — place in this order: FPGA → power regulators → config memory → clock oscillator → connectors → LEDs/switches/buttons. Use continuous ground plane, wide power traces, short clock traces
Run DRC, verify FPGA pin assignments
Export deliverables: schematic PDF, PCB layout, 3D file, BOM, Gerber files

Phase 6 — Presentation (July 2)
Live demo on the board + slides covering concept, FSM, architecture, PCB design, and who did what.
Phase 7 — Final Documentation (July 9)
Package everything: concept doc, all VHDL source + testbenches, synthesis report + screenshots, XDC + bitstream, hardware validation evidence (video), and all PCB files.
