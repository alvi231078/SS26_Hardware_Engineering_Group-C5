-- =============================================================================
-- Testbench: Full Adder
-- Tests all 8 input combinations (A, B, Cin) -> 100% coverage
-- Lab 02 - Exercise 01
-- =============================================================================

entity full_adder_tb is
end entity full_adder_tb;

architecture testbench of full_adder_tb is

    -- Component under test
    component full_adder is
        port (
            A    : in  BIT;
            B    : in  BIT;
            Cin  : in  BIT;
            S    : out BIT;
            Cout : out BIT
        );
    end component full_adder;

    -- Stimulus signals
    signal tb_A    : BIT := '0';
    signal tb_B    : BIT := '0';
    signal tb_Cin  : BIT := '0';

    -- Observed outputs
    signal tb_S    : BIT;
    signal tb_Cout : BIT;

begin

    -- Instantiate the Design Under Test (DUT)
    DUT : full_adder
        port map (
            A    => tb_A,
            B    => tb_B,
            Cin  => tb_Cin,
            S    => tb_S,
            Cout => tb_Cout
        );

    -- -------------------------------------------------------------------------
    -- Stimulus process: apply all 8 combinations, each for 20 ns
    -- Truth Table:
    --  A  B  Cin | S  Cout
    --  0  0   0  | 0   0
    --  0  0   1  | 1   0
    --  0  1   0  | 1   0
    --  0  1   1  | 0   1
    --  1  0   0  | 1   0
    --  1  0   1  | 0   1
    --  1  1   0  | 0   1
    --  1  1   1  | 1   1
    -- -------------------------------------------------------------------------
    stimulus : process
    begin

        -- Test 0: A=0, B=0, Cin=0 -> S=0, Cout=0
        tb_A <= '0'; tb_B <= '0'; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = '0' and tb_Cout = '0')
            report "FAIL: A=0 B=0 Cin=0 => expected S=0 Cout=0" severity error;

        -- Test 1: A=0, B=0, Cin=1 -> S=1, Cout=0
        tb_A <= '0'; tb_B <= '0'; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = '1' and tb_Cout = '0')
            report "FAIL: A=0 B=0 Cin=1 => expected S=1 Cout=0" severity error;

        -- Test 2: A=0, B=1, Cin=0 -> S=1, Cout=0
        tb_A <= '0'; tb_B <= '1'; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = '1' and tb_Cout = '0')
            report "FAIL: A=0 B=1 Cin=0 => expected S=1 Cout=0" severity error;

        -- Test 3: A=0, B=1, Cin=1 -> S=0, Cout=1
        tb_A <= '0'; tb_B <= '1'; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = '0' and tb_Cout = '1')
            report "FAIL: A=0 B=1 Cin=1 => expected S=0 Cout=1" severity error;

        -- Test 4: A=1, B=0, Cin=0 -> S=1, Cout=0
        tb_A <= '1'; tb_B <= '0'; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = '1' and tb_Cout = '0')
            report "FAIL: A=1 B=0 Cin=0 => expected S=1 Cout=0" severity error;

        -- Test 5: A=1, B=0, Cin=1 -> S=0, Cout=1
        tb_A <= '1'; tb_B <= '0'; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = '0' and tb_Cout = '1')
            report "FAIL: A=1 B=0 Cin=1 => expected S=0 Cout=1" severity error;

        -- Test 6: A=1, B=1, Cin=0 -> S=0, Cout=1
        tb_A <= '1'; tb_B <= '1'; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = '0' and tb_Cout = '1')
            report "FAIL: A=1 B=1 Cin=0 => expected S=0 Cout=1" severity error;

        -- Test 7: A=1, B=1, Cin=1 -> S=1, Cout=1
        tb_A <= '1'; tb_B <= '1'; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = '1' and tb_Cout = '1')
            report "FAIL: A=1 B=1 Cin=1 => expected S=1 Cout=1" severity error;

        -- All tests passed
        assert false
            report "INFO: Full Adder testbench complete - all 8 combinations tested (100% coverage)"
            severity note;

        wait; -- stop simulation
    end process stimulus;

end architecture testbench;
