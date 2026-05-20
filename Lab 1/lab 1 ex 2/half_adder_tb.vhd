--------------------------------------------------------------------------------
-- File        : half_adder_tb.vhd
-- Description : Testbench for the 1-bit Half Adder using BIT type.
--               Exhaustively tests all 4 possible input combinations
--               (00, 01, 10, 11) to achieve 100% functional coverage.
--               The testbench self-checks every output against the
--               expected values and reports pass/fail.
--------------------------------------------------------------------------------

entity half_adder_tb is
    -- Testbench entities have no ports
end entity half_adder_tb;

architecture sim of half_adder_tb is

    ----------------------------------------------------------------------------
    -- Component declaration of the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    component half_adder
        port (
            A     : in  bit;
            B     : in  bit;
            Sum   : out bit;
            Carry : out bit
        );
    end component;

    ----------------------------------------------------------------------------
    -- Internal signals to drive and observe the DUT
    ----------------------------------------------------------------------------
    signal A_tb     : bit := '0';
    signal B_tb     : bit := '0';
    signal Sum_tb   : bit;
    signal Carry_tb : bit;

    -- Stimulus period
    constant PERIOD : time := 10 ns;

    ----------------------------------------------------------------------------
    -- Record type to hold one stimulus / expected response vector
    ----------------------------------------------------------------------------
    type test_vector_t is record
        a         : bit;
        b         : bit;
        exp_sum   : bit;
        exp_carry : bit;
    end record;

    -- Exhaustive test vector array covering all 2^2 = 4 input combinations
    type test_vector_array_t is array (natural range <>) of test_vector_t;
    constant TEST_VECTORS : test_vector_array_t := (
        -- A    B    Sum  Carry
        ('1', '1', '0', '1'),
('1', '0', '1', '0'),
('0', '1', '1', '0'),
('0', '0', '0', '0')
    );

begin

    ----------------------------------------------------------------------------
    -- Instantiate the Device Under Test (DUT)
    ----------------------------------------------------------------------------
    DUT : half_adder
        port map (
            A     => A_tb,
            B     => B_tb,
            Sum   => Sum_tb,
            Carry => Carry_tb
        );

    ----------------------------------------------------------------------------
    -- Stimulus and self-checking process
    ----------------------------------------------------------------------------
    stimulus : process
        variable error_count : natural := 0;
    begin
        report "=== Starting Half Adder testbench ===" severity note;

        -- Loop through all stimulus vectors
        for i in TEST_VECTORS'range loop
            -- Apply inputs
            A_tb <= TEST_VECTORS(i).a;
            B_tb <= TEST_VECTORS(i).b;

            -- Wait for outputs to settle
            wait for PERIOD;

            -- Check Sum
            assert Sum_tb = TEST_VECTORS(i).exp_sum
                report "MISMATCH on Sum: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " expected Sum=" & bit'image(TEST_VECTORS(i).exp_sum) &
                       " got Sum=" & bit'image(Sum_tb)
                severity error;

            -- Check Carry
            assert Carry_tb = TEST_VECTORS(i).exp_carry
                report "MISMATCH on Carry: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " expected Carry=" & bit'image(TEST_VECTORS(i).exp_carry) &
                       " got Carry=" & bit'image(Carry_tb)
                severity error;

            -- Count any mismatches
            if (Sum_tb /= TEST_VECTORS(i).exp_sum) or
               (Carry_tb /= TEST_VECTORS(i).exp_carry) then
                error_count := error_count + 1;
            else
                report "PASS: A=" & bit'image(TEST_VECTORS(i).a) &
                       " B=" & bit'image(TEST_VECTORS(i).b) &
                       " -> Sum=" & bit'image(Sum_tb) &
                       " Carry=" & bit'image(Carry_tb)
                severity note;
            end if;
        end loop;

        -- Final summary
        if error_count = 0 then
            report "=== Half Adder testbench PASSED (4/4 vectors) ==="
                severity note;
        else
            report "=== Half Adder testbench FAILED with " &
                   integer'image(error_count) & " error(s) ==="
                severity failure;
        end if;

        -- End simulation cleanly
        wait;
    end process stimulus;

end architecture sim;
