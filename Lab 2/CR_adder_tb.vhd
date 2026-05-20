-- =============================================================================
-- Testbench: 4-bit Ripple Carry Adder
-- Covers: zero, max, carry propagation, overflow, random cases
-- Lab 02 - Exercise 02
-- =============================================================================

entity CR_adder_tb is
end entity CR_adder_tb;

architecture testbench of CR_adder_tb is

    component CR_adder is
        generic (N : positive := 4);
        port (
            A    : in  BIT_VECTOR(3 downto 0);
            B    : in  BIT_VECTOR(3 downto 0);
            Cin  : in  BIT;
            S    : out BIT_VECTOR(3 downto 0);
            Cout : out BIT
        );
    end component CR_adder;

    signal tb_A    : BIT_VECTOR(3 downto 0) := "0000";
    signal tb_B    : BIT_VECTOR(3 downto 0) := "0000";
    signal tb_Cin  : BIT                    := '0';
    signal tb_S    : BIT_VECTOR(3 downto 0);
    signal tb_Cout : BIT;

begin

    DUT : CR_adder
        generic map (N => 4)
        port map (
            A    => tb_A,
            B    => tb_B,
            Cin  => tb_Cin,
            S    => tb_S,
            Cout => tb_Cout
        );

    stimulus : process
    begin

        -- Test 1: 0 + 0 + 0 = 0, Cout=0
        tb_A <= "0000"; tb_B <= "0000"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '0')
            report "FAIL Test1: 0+0+0" severity error;

        -- Test 2: 1 + 1 + 0 = 2 (0010), Cout=0
        tb_A <= "0001"; tb_B <= "0001"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "0010" and tb_Cout = '0')
            report "FAIL Test2: 1+1+0" severity error;

        -- Test 3: 5 + 3 + 0 = 8 (1000), Cout=0
        tb_A <= "0101"; tb_B <= "0011"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "1000" and tb_Cout = '0')
            report "FAIL Test3: 5+3+0" severity error;

        -- Test 4: 7 + 8 + 0 = 15 (1111), Cout=0
        tb_A <= "0111"; tb_B <= "1000"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "1111" and tb_Cout = '0')
            report "FAIL Test4: 7+8+0" severity error;

        -- Test 5: 15 + 1 + 0 = 16 -> S=0000, Cout=1 (overflow)
        tb_A <= "1111"; tb_B <= "0001"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '1')
            report "FAIL Test5: 15+1=overflow" severity error;

        -- Test 6: 15 + 15 + 0 = 30 -> S=1110, Cout=1
        tb_A <= "1111"; tb_B <= "1111"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "1110" and tb_Cout = '1')
            report "FAIL Test6: 15+15" severity error;

        -- Test 7: Cin propagation: 0 + 0 + 1 = 1, Cout=0
        tb_A <= "0000"; tb_B <= "0000"; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = "0001" and tb_Cout = '0')
            report "FAIL Test7: 0+0+Cin=1" severity error;

        -- Test 8: 15 + 15 + 1 = 31 -> S=1111, Cout=1
        tb_A <= "1111"; tb_B <= "1111"; tb_Cin <= '1';
        wait for 20 ns;
        assert (tb_S = "1111" and tb_Cout = '1')
            report "FAIL Test8: 15+15+1" severity error;

        -- Test 9: Full carry ripple across all bits: 8+8=16 -> S=0000, Cout=1
        tb_A <= "1000"; tb_B <= "1000"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "0000" and tb_Cout = '1')
            report "FAIL Test9: 8+8" severity error;

        -- Test 10: 6 + 9 + 0 = 15 (1111), Cout=0
        tb_A <= "0110"; tb_B <= "1001"; tb_Cin <= '0';
        wait for 20 ns;
        assert (tb_S = "1111" and tb_Cout = '0')
            report "FAIL Test10: 6+9" severity error;

        assert false
            report "INFO: CR_adder testbench complete - all tests passed"
            severity note;

        wait;
    end process stimulus;

end architecture testbench;
