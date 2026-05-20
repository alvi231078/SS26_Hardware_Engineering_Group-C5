-- =============================================================================
-- Testbench: BCD to 7-Segment Decoder
-- Tests all 10 valid BCD digits (0-9)
-- SEG output format: (A,B,C,D,E,F,G) -> SEG(6 downto 0)
-- Active HIGH (common cathode)
--
-- Expected SEG values per digit:
--  Digit | A B C D E F G | SEG(6:0) hex
--   0    | 1 1 1 1 1 1 0 | 0x7E
--   1    | 0 1 1 0 0 0 0 | 0x30
--   2    | 1 1 0 1 1 0 1 | 0x6D
--   3    | 1 1 1 1 0 0 1 | 0x79
--   4    | 0 1 1 0 0 1 1 | 0x33
--   5    | 1 0 1 1 0 1 1 | 0x5B
--   6    | 1 0 1 1 1 1 1 | 0x5F
--   7    | 1 1 1 0 0 0 0 | 0x70
--   8    | 1 1 1 1 1 1 1 | 0x7F
--   9    | 1 1 1 1 0 1 1 | 0x7B
--
-- Lab 02 - Exercise 05
-- =============================================================================

entity BCDto7seg_tb is
end entity BCDto7seg_tb;

architecture testbench of BCDto7seg_tb is

    component BCDto7seg is
        port (
            BCD : in  BIT_VECTOR(3 downto 0);
            SEG : out BIT_VECTOR(6 downto 0)
        );
    end component BCDto7seg;

    signal tb_BCD : BIT_VECTOR(3 downto 0) := "0000";
    signal tb_SEG : BIT_VECTOR(6 downto 0);

begin

    DUT : BCDto7seg
        port map (
            BCD => tb_BCD,
            SEG => tb_SEG
        );

    stimulus : process
    begin

        -- Digit 0: BCD=0000 -> SEG = ABCDEFG = 1111110 = "1111110"
        tb_BCD <= "0000"; wait for 20 ns;
        assert tb_SEG = "1111110"
            report "FAIL digit 0: expected 1111110, got " & BIT'image(tb_SEG(6))
                   & BIT'image(tb_SEG(5)) & BIT'image(tb_SEG(4)) & BIT'image(tb_SEG(3))
                   & BIT'image(tb_SEG(2)) & BIT'image(tb_SEG(1)) & BIT'image(tb_SEG(0))
            severity error;

        -- Digit 1: BCD=0001 -> SEG = ABCDEFG = 0110000 = "0110000"
        tb_BCD <= "0001"; wait for 20 ns;
        assert tb_SEG = "0110000"
            report "FAIL digit 1: expected 0110000" severity error;

        -- Digit 2: BCD=0010 -> SEG = ABCDEFG = 1101101 = "1101101"
        tb_BCD <= "0010"; wait for 20 ns;
        assert tb_SEG = "1101101"
            report "FAIL digit 2: expected 1101101" severity error;

        -- Digit 3: BCD=0011 -> SEG = ABCDEFG = 1111001 = "1111001"
        tb_BCD <= "0011"; wait for 20 ns;
        assert tb_SEG = "1111001"
            report "FAIL digit 3: expected 1111001" severity error;

        -- Digit 4: BCD=0100 -> SEG = ABCDEFG = 0110011 = "0110011"
        tb_BCD <= "0100"; wait for 20 ns;
        assert tb_SEG = "0110011"
            report "FAIL digit 4: expected 0110011" severity error;

        -- Digit 5: BCD=0101 -> SEG = ABCDEFG = 1011011 = "1011011"
        tb_BCD <= "0101"; wait for 20 ns;
        assert tb_SEG = "1011011"
            report "FAIL digit 5: expected 1011011" severity error;

        -- Digit 6: BCD=0110 -> SEG = ABCDEFG = 1011111 = "1011111"
        tb_BCD <= "0110"; wait for 20 ns;
        assert tb_SEG = "1011111"
            report "FAIL digit 6: expected 1011111" severity error;

        -- Digit 7: BCD=0111 -> SEG = ABCDEFG = 1110000 = "1110000"
        tb_BCD <= "0111"; wait for 20 ns;
        assert tb_SEG = "1110000"
            report "FAIL digit 7: expected 1110000" severity error;

        -- Digit 8: BCD=1000 -> SEG = ABCDEFG = 1111111 = "1111111"
        tb_BCD <= "1000"; wait for 20 ns;
        assert tb_SEG = "1111111"
            report "FAIL digit 8: expected 1111111" severity error;

        -- Digit 9: BCD=1001 -> SEG = ABCDEFG = 1111011 = "1111011"
        tb_BCD <= "1001"; wait for 20 ns;
        assert tb_SEG = "1111011"
            report "FAIL digit 9: expected 1111011" severity error;

        assert false
            report "INFO: BCDto7seg testbench complete - all 10 BCD digits verified"
            severity note;

        wait;
    end process stimulus;

end architecture testbench;
