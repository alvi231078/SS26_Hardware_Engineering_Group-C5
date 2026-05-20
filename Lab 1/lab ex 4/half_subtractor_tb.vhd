--------------------------------------------------------------------------------
-- File        : half_subtractor_tb.vhd
-- Description : Testbench for the 1-bit Half Subtractor.
--               Exhaustively tests all 4 possible input combinations
--               (00, 01, 10, 11) to achieve 100% functional coverage.
--               The testbench self-checks every output against the
--               expected values and reports pass/fail.
--------------------------------------------------------------------------------

entity half_subtractor_tb is
    -- Testbench entities have no ports
end entity half_subtractor_tb;

architecture sim of half_subtractor_tb is

    ----------------------------------------------------------------------------
    -- Component declaration of the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    component half_subtractor
        port (
            A      : in  bit;
            B      : in  bit;
            Diff   : out bit;
            Borrow : out bit
        );
    end component;

    ----------------------------------------------------------------------------
    -- Internal signals to drive and observe the DUT
    ----------------------------------------------------------------------------
    signal A_tb      : bit := '0';
    signal B_tb      : bit := '0';
    signal Diff_tb   : bit;
    signal Borrow_tb : bit;

    -- Stimulus period
    constant PERIOD : time := 10 ns;

    ----------------------------------------------------------------------------
    -- Record type to hold one stimulus / expected response vector
    ----------------------------------------------------------------------------
    type test_vector_t is record
        a          : bit;
        b          : bit;
        exp_diff   : bit;
        exp_borrow : bit;
    end record;

    -- Exhaustive test vector array covering all 2^2 = 4 input combinations
    type test_vector_array_t is array (natural range <>) of test_vector_t;
    constant TEST_VECTORS : test_vector_array_t := (
        -- A    B    Diff Borrow
        ('0', '0', '0', '0'),
        ('0', '1', '1', '1'),
        ('1', '0', '1', '0'),
        ('1', '1', '0', '0')
    );

begin

    ----------------------------------------------------------------------------
    -- Instantiate the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    DUT : half_subtractor
        port map (
            A      => A_tb,
            B      => B_tb,
            Diff   => Diff_tb,
            Borrow => Borrow_tb
        );

    ----------------------------------------------------------------------------
    -- Stimulus and self-checking process
    ----------------------------------------------------------------------------
    stimulus : process
        variable error_count : natural := 0;
    begin
        report "=== Starting Half Subtractor testbench ===" severity note;

        -- Loop through all stimulus vectors
        for i in TEST_VECTORS'range loop
            -- Apply inputs
            A_tb <= TEST_VECTORS(i).a;
            B_tb <= TEST_VECTORS(i).b;

            -- Wait for outputs to settle
            wait for PERIOD;

            -- Check Difference
            assert Diff_tb = TEST_VECTORS(i).exp_diff
                report "MISMATCH on Diff: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " expected Diff=" & bit'image(TEST_VECTORS(i).exp_diff) &
                       " got Diff=" & bit'image(Diff_tb)
                severity error;

            -- Check Borrow
            assert Borrow_tb = TEST_VECTORS(i).exp_borrow
                report "MISMATCH on Borrow: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " expected Borrow=" & bit'image(TEST_VECTORS(i).exp_borrow) &
                       " got Borrow=" & bit'image(Borrow_tb)
                severity error;

            -- Count any mismatches
            if (Diff_tb /= TEST_VECTORS(i).exp_diff) or
               (Borrow_tb /= TEST_VECTORS(i).exp_borrow) then
                error_count := error_count + 1;
            else
                report "PASS: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " -> Diff=" & bit'image(Diff_tb) &
                       " Borrow=" & bit'image(Borrow_tb)
                severity note;
            end if;
        end loop;

        -- Final summary
        if error_count = 0 then
            report "=== Half Subtractor testbench PASSED (4/4 vectors) ==="
                severity note;
        else
            report "=== Half Subtractor testbench FAILED with " &
                   integer'image(error_count) & " error(s) ==="
                severity failure;
        end if;

        -- End simulation cleanly
        wait;
    end process stimulus;

end architecture sim;
