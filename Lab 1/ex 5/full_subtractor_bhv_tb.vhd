--------------------------------------------------------------------------------
-- File        : full_subtractor_bhv_tb.vhd
-- Description : Testbench for the 1-bit Full Subtractor.
--               Exhaustively tests all 8 possible input combinations
--               (2^3 = 8) to achieve 100% functional coverage.
--               The testbench self-checks every output against the
--               expected values and reports pass/fail.
--------------------------------------------------------------------------------

entity full_subtractor_bhv_tb is
    -- Testbench entities have no ports
end entity full_subtractor_bhv_tb;

architecture sim of full_subtractor_bhv_tb is

    ----------------------------------------------------------------------------
    -- Component declaration of the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    component full_subtractor_bhv
        port (
            A    : in  bit;
            B    : in  bit;
            Bin  : in  bit;
            Diff : out bit;
            Bout : out bit
        );
    end component;

    ----------------------------------------------------------------------------
    -- Internal signals to drive and observe the DUT
    ----------------------------------------------------------------------------
    signal A_tb    : bit := '0';
    signal B_tb    : bit := '0';
    signal Bin_tb  : bit := '0';
    signal Diff_tb : bit;
    signal Bout_tb : bit;

    -- Stimulus period
    constant PERIOD : time := 10 ns;

    ----------------------------------------------------------------------------
    -- Record type to hold one stimulus / expected response vector
    ----------------------------------------------------------------------------
    type test_vector_t is record
        a        : bit;
        b        : bit;
        bin      : bit;
        exp_diff : bit;
        exp_bout : bit;
    end record;

    -- Exhaustive test vector array covering all 2^3 = 8 input combinations
    type test_vector_array_t is array (natural range <>) of test_vector_t;
    constant TEST_VECTORS : test_vector_array_t := (
        -- A    B    Bin  Diff Bout
        ('0', '0', '0', '0', '0'),
        ('0', '0', '1', '1', '1'),
        ('0', '1', '0', '1', '1'),
        ('0', '1', '1', '0', '1'),
        ('1', '0', '0', '1', '0'),
        ('1', '0', '1', '0', '0'),
        ('1', '1', '0', '0', '0'),
        ('1', '1', '1', '1', '1')
    );

begin

    ----------------------------------------------------------------------------
    -- Instantiate the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    DUT : full_subtractor_bhv
        port map (
            A    => A_tb,
            B    => B_tb,
            Bin  => Bin_tb,
            Diff => Diff_tb,
            Bout => Bout_tb
        );

    ----------------------------------------------------------------------------
    -- Stimulus and self-checking process
    ----------------------------------------------------------------------------
    stimulus : process
        variable error_count : natural := 0;
    begin
        report "=== Starting Full Subtractor testbench ===" severity note;

        -- Loop through all stimulus vectors
        for i in TEST_VECTORS'range loop
            -- Apply inputs
            A_tb   <= TEST_VECTORS(i).a;
            B_tb   <= TEST_VECTORS(i).b;
            Bin_tb <= TEST_VECTORS(i).bin;

            -- Wait for outputs to settle
            wait for PERIOD;

            -- Check Difference
            assert Diff_tb = TEST_VECTORS(i).exp_diff
                report "MISMATCH on Diff: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Bin=" & bit'image(TEST_VECTORS(i).bin) &
                       " expected Diff=" & bit'image(TEST_VECTORS(i).exp_diff) &
                       " got Diff=" & bit'image(Diff_tb)
                severity error;

            -- Check Borrow output
            assert Bout_tb = TEST_VECTORS(i).exp_bout
                report "MISMATCH on Bout: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Bin=" & bit'image(TEST_VECTORS(i).bin) &
                       " expected Bout=" & bit'image(TEST_VECTORS(i).exp_bout) &
                       " got Bout=" & bit'image(Bout_tb)
                severity error;

            -- Count any mismatches
            if (Diff_tb /= TEST_VECTORS(i).exp_diff) or
               (Bout_tb /= TEST_VECTORS(i).exp_bout) then
                error_count := error_count + 1;
            else
                report "PASS: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " Bin=" & bit'image(TEST_VECTORS(i).bin) &
                       " -> Diff=" & bit'image(Diff_tb) &
                       " Bout=" & bit'image(Bout_tb)
                severity note;
            end if;
        end loop;

        -- Final summary
        if error_count = 0 then
            report "=== Full Subtractor testbench PASSED (8/8 vectors) ==="
                severity note;
        else
            report "=== Full Subtractor testbench FAILED with " &
                   integer'image(error_count) & " error(s) ==="
                severity failure;
        end if;

        -- End simulation cleanly
        wait;
    end process stimulus;

end architecture sim;
