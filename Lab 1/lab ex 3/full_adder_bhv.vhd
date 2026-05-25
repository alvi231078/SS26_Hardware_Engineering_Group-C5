--------------------------------------------------------------------------------
-- File        : full_adder_bhv.vhd
-- Description : 1-bit Full Adder (behavioral modelling).
--               Adds A + B + Cin and produces Sum and Cout.
--
--               Sum  = A XOR B XOR Cin
--               Cout = (A AND B) OR (Cin AND (A XOR B))
--
-- Truth Table:
--   A | B | Cin | Sum | Cout
--   --+---+-----+-----+------
--   0 | 0 |  0  |  0  |  0
--   0 | 0 |  1  |  1  |  0
--   0 | 1 |  0  |  1  |  0
--   0 | 1 |  1  |  0  |  1
--   1 | 0 |  0  |  1  |  0
--   1 | 0 |  1  |  0  |  1
--   1 | 1 |  0  |  0  |  1
--   1 | 1 |  1  |  1  |  1
--------------------------------------------------------------------------------

entity full_adder_bhv is
    port (
        A    : in  bit;   -- First input bit
        B    : in  bit;   -- Second input bit
        Cin  : in  bit;   -- Carry input
        Sum  : out bit;   -- Sum output
        Cout : out bit    -- Carry output
    );
end entity full_adder_bhv;

--------------------------------------------------------------------------------
-- Behavioral architecture using a process and a case statement
--------------------------------------------------------------------------------
architecture behavioral of full_adder_bhv is
begin

    process (A, B, Cin)
        variable inputs : bit_vector(2 downto 0);
    begin
        inputs := A & B & Cin;

        case inputs is
            when "000" => Sum <= '0'; Cout <= '0';
            when "001" => Sum <= '1'; Cout <= '0';
            when "010" => Sum <= '1'; Cout <= '0';
            when "011" => Sum <= '0'; Cout <= '1';
            when "100" => Sum <= '1'; Cout <= '0';
            when "101" => Sum <= '0'; Cout <= '1';
            when "110" => Sum <= '0'; Cout <= '1';
            when "111" => Sum <= '1'; Cout <= '1';
        end case;
    end process;

end architecture behavioral;
