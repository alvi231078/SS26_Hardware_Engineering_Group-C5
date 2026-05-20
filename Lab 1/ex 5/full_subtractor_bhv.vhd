--------------------------------------------------------------------------------
-- File        : full_subtractor_bhv.vhd
-- Description : 1-bit Full Subtractor (behavioral modelling).
--               Computes A - B - Bin and produces Diff and Bout.
--
--               Diff = A XOR B XOR Bin
--               Bout = ((NOT A) AND B) OR (Bin AND (NOT (A XOR B)))
--
-- Truth Table:
--   A | B | Bin | Diff | Bout
--   --+---+-----+------+------
--   0 | 0 |  0  |  0   |  0
--   0 | 0 |  1  |  1   |  1
--   0 | 1 |  0  |  1   |  1
--   0 | 1 |  1  |  0   |  1
--   1 | 0 |  0  |  1   |  0
--   1 | 0 |  1  |  0   |  0
--   1 | 1 |  0  |  0   |  0
--   1 | 1 |  1  |  1   |  1
--------------------------------------------------------------------------------

entity full_subtractor_bhv is
    port (
        A    : in  bit;   -- Minuend
        B    : in  bit;   -- Subtrahend
        Bin  : in  bit;   -- Borrow input
        Diff : out bit;   -- Difference output
        Bout : out bit    -- Borrow output
    );
end entity full_subtractor_bhv;

--------------------------------------------------------------------------------
-- Behavioral architecture using a process and a case statement
--------------------------------------------------------------------------------
architecture behavioral of full_subtractor_bhv is
begin

    process (A, B, Bin)
        variable inputs : bit_vector(2 downto 0);
    begin
        inputs := A & B & Bin;

        case inputs is
            when "000" => Diff <= '0'; Bout <= '0';
            when "001" => Diff <= '1'; Bout <= '1';
            when "010" => Diff <= '1'; Bout <= '1';
            when "011" => Diff <= '0'; Bout <= '1';
            when "100" => Diff <= '1'; Bout <= '0';
            when "101" => Diff <= '0'; Bout <= '0';
            when "110" => Diff <= '0'; Bout <= '0';
            when "111" => Diff <= '1'; Bout <= '1';
        end case;
    end process;

end architecture behavioral;
