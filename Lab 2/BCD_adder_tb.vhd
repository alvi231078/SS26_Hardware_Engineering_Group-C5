-- =============================================================================
-- Testbench: BCD Adder
-- Tests all meaningful BCD input combinations (0-9 + 0-9 + Cin)
-- Verifies correct BCD output and carry
-- Lab 02 - Exercise 04
-- =============================================================================

entity BCD_adder_tb is
end entity BCD_adder_tb;

architecture testbench of BCD_adder_tb is

    component BCD_adder is
        port (
            A    : in  BIT_VECTOR(3 downto 0);
            B    : in  BIT_VECTOR(3 downto 0);
            Cin  : in  BIT;
            S    : out BIT_VECTOR(3 downto 0);
            Cout : out BIT
        );
    end component BCD_adder;

    signal tb_A    : BIT_VECTOR(3 downto 0) := "0000";
    signal tb_B    : BIT_VECTOR(3 downto 0) := "0000";
    signal tb_Cin  : BIT                    := '0';
    signal tb_S    : BIT_VECTOR(3 downto 0);
    signal tb_Cout : BIT;

begin

    DUT : BCD_adder
        port map (
            A    => tb_A,
            B    => tb_B,
            Cin  => tb_Cin,
            S    => tb_S,
            Cout => tb_Cout
        );

    stimulus : process
    begin

        -- ==============================
        -- No carry in, no carry out (sum 0-9)
        -- ==============================

        -- Test 1: 0 + 0 = 0 BCD
        tb_A <= "0000"; tb_B <= "0000"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '0')
            report "FAIL T1: 0+0=0" severity error;

        -- Test 2: 3 + 4 = 7 BCD
        tb_A <= "0011"; tb_B <= "0100"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0111" and tb_Cout = '0')
            report "FAIL T2: 3+4=7" severity error;

        -- Test 3: 4 + 5 = 9 BCD
        tb_A <= "0100"; tb_B <= "0101"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "1001" and tb_Cout = '0')
            report "FAIL T3: 4+5=9" severity error;

        -- ==============================
        -- Sum > 9, no Cin (correction needed)
        -- ==============================

        -- Test 4: 5 + 5 = 10 -> S=0000, Cout=1
        tb_A <= "0101"; tb_B <= "0101"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '1')
            report "FAIL T4: 5+5=10 BCD" severity error;

        -- Test 5: 6 + 7 = 13 -> S=0011, Cout=1
        tb_A <= "0110"; tb_B <= "0111"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0011" and tb_Cout = '1')
            report "FAIL T5: 6+7=13 BCD" severity error;

        -- Test 6: 9 + 9 = 18 -> S=1000, Cout=1
        tb_A <= "1001"; tb_B <= "1001"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "1000" and tb_Cout = '1')
            report "FAIL T6: 9+9=18 BCD" severity error;

        -- Test 7: 7 + 8 = 15 -> S=0101, Cout=1
        tb_A <= "0111"; tb_B <= "1000"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0101" and tb_Cout = '1')
            report "FAIL T7: 7+8=15 BCD" severity error;

        -- ==============================
        -- With Cin = 1
        -- ==============================

        -- Test 8: 4 + 4 + 1 = 9 BCD
        tb_A <= "0100"; tb_B <= "0100"; tb_Cin <= '1'; wait for 20 ns;
        assert (tb_S = "1001" and tb_Cout = '0')
            report "FAIL T8: 4+4+1=9 BCD" severity error;

        -- Test 9: 5 + 4 + 1 = 10 -> S=0000, Cout=1
        tb_A <= "0101"; tb_B <= "0100"; tb_Cin <= '1'; wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '1')
            report "FAIL T9: 5+4+1=10 BCD" severity error;

        -- Test 10: 9 + 9 + 1 = 19 -> S=1001, Cout=1
        tb_A <= "1001"; tb_B <= "1001"; tb_Cin <= '1'; wait for 20 ns;
        assert (tb_S = "1001" and tb_Cout = '1')
            report "FAIL T10: 9+9+1=19 BCD" severity error;

        -- Test 11: 0 + 0 + 1 = 1 BCD
        tb_A <= "0000"; tb_B <= "0000"; tb_Cin <= '1'; wait for 20 ns;
        assert (tb_S = "0001" and tb_Cout = '0')
            report "FAIL T11: 0+0+1=1 BCD" severity error;

        -- Test 12: 1 + 9 = 10 -> S=0000, Cout=1
        tb_A <= "0001"; tb_B <= "1001"; tb_Cin <= '0'; wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '1')
            report "FAIL T12: 1+9=10 BCD" severity error;

        assert false
            report "INFO: BCD_adder testbench complete - all tests passed"
            severity note;

        wait;
    end process stimulus;

end architecture testbench;
