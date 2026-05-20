--------------------------------------------------------------------------------
-- File        : full_adder_bhv_tb.vhd
-- Description : Testbench for the 1-bit Full Adder.
--               Exhaustively tests all 8 possible input combinations
--               (2^3 = 8) to achieve 100% functional coverage.
--               The testbench self-checks every output against the
--               expected values and reports pass/fail.
--------------------------------------------------------------------------------

entity full_adder_bhv_tb is
    -- Testbench entities have no ports
end entity full_adder_bhv_tb;

architecture sim of full_adder_bhv_tb is

    ----------------------------------------------------------------------------
    -- Component declaration of the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    component full_adder_bhv
        port (
            A    : in  bit;
            B    : in  bit;
            Cin  : in  bit;
            Sum  : out bit;
            Cout : out bit
        );
    end component;

    ----------------------------------------------------------------------------
    -- Internal signals to drive and observe the DUT
    ----------------------------------------------------------------------------
    signal A_tb    : bit := '0';
    signal B_tb    : bit := '0';
    signal Cin_tb  : bit := '0';
    signal Sum_tb  : bit;
    signal Cout_tb : bit;

    -- Stimulus period
    constant PERIOD : time := 10 ns;

    ----------------------------------------------------------------------------
    -- Record type to hold one stimulus / expected response vector
    ----------------------------------------------------------------------------
    type test_vector_t is record
        a        : bit;
        b        : bit;
        cin      : bit;
        exp_sum  : bit;
        exp_cout : bit;
    end record;

    -- Exhaustive test vector array covering all 2^3 = 8 input combinations
    type test_vector_array_t is array (natural range <>) of test_vector_t;
    constant TEST_VECTORS : test_vector_array_t := (
        -- A    B    Cin  Sum  Cout
        ('0', '0', '0', '0', '0'),
        ('0', '0', '1', '1', '0'),
        ('0', '1', '0', '1', '0'),
        ('0', '1', '1', '0', '1'),
        ('1', '0', '0', '1', '0'),
        ('1', '0', '1', '0', '1'),
        ('1', '1', '0', '0', '1'),
        ('1', '1', '1', '1', '1')
    );

begin

    ----------------------------------------------------------------------------
    -- Instantiate the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    DUT : full_adder_bhv
        port map (
            A    => A_tb,
            B    => B_tb,
            Cin  => Cin_tb,
            Sum  => Sum_tb,
            Cout => Cout_tb
        );

    ----------------------------------------------------------------------------
    -- Stimulus and self-checking process
    ----------------------------------------------------------------------------
    stimulus : process
        variable error_count : natural := 0;
    begin
        report "=== Starting Full Adder testbench ===" severity note;

        -- Loop through all stimulus vectors
        for i in TEST_VECTORS'range loop
            -- Apply inputs
            A_tb   <= TEST_VECTORS(i).a;
            B_tb   <= TEST_VECTORS(i).b;
            Cin_tb <= TEST_VECTORS(i).cin;

            -- Wait for outputs to settle
            wait for PERIOD;

            -- Check Sum
            assert Sum_tb = TEST_VECTORS(i).exp_sum
                report "MISMATCH on Sum: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Cin=" & bit'image(TEST_VECTORS(i).cin) &
                       " expected Sum=" & bit'image(TEST_VECTORS(i).exp_sum) &
                       " got Sum=" & bit'image(Sum_tb)
                severity error;

            -- Check Cout
            assert Cout_tb = TEST_VECTORS(i).exp_cout
                report "MISMATCH on Cout: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Cin=" & bit'image(TEST_VECTORS(i).cin) &
                       " expected Cout=" & bit'image(TEST_VECTORS(i).exp_cout) &
                       " got Cout=" & bit'image(Cout_tb)
                severity error;

            -- Count any mismatches
            if (Sum_tb /= TEST_VECTORS(i).exp_sum) or
               (Cout_tb /= TEST_VECTORS(i).exp_cout) then
                error_count := error_count + 1;
            else
                report "PASS: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Cin=" & bit'image(TEST_VECTORS(i).cin) &
                       " -> Sum=" & bit'image(Sum_tb) &
                       " Cout=" & bit'image(Cout_tb)
                severity note;
            end if;
        end loop;

        -- Final summary
        if error_count = 0 then
            report "=== Full Adder testbench PASSED (8/8 vectors) ==="
                severity note;
        else
            report "=== Full Adder testbench FAILED with " &
                   integer'image(error_count) & " error(s) ==="
                severity failure;
        end if;

        -- End simulation cleanly
        wait;
    end process stimulus;

end architecture sim;
