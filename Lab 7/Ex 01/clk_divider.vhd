library IEEE;
-- NOTE: only standard library, no std_logic (professor's rule)

entity clk_divider is
    generic ( N : positive := 4 );   -- division factor
    port (
        CLK   : in  BIT;             -- fast input clock
        CLK_N : out BIT              -- slow output clock
    );
end entity clk_divider;

architecture behavioral of clk_divider is
begin
    process(CLK)
        variable count : integer := 0;
        variable temp  : BIT := '0';
    begin
        if CLK'event and CLK = '1' then       -- on each rising edge
            if count = (N/2 - 1) then          -- half period reached
                temp  := not temp;             -- flip the slow clock
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
        CLK_N <= temp;
    end process;
end architecture behavioral;