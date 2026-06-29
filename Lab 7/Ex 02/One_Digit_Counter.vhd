library IEEE;

entity One_Digit_Counter is
    port (
        CLK    : in  BIT;                      -- 100 MHz board clock
        StartStop : in BIT;                    -- 1 = count, 0 = pause
        Clear  : in  BIT;                      -- 1 = reset to 0
        SEG    : out BIT_VECTOR(6 downto 0);   -- 7-seg bars
        AN     : out BIT_VECTOR(7 downto 0)    -- digit enables
    );
end entity One_Digit_Counter;

architecture behavioral of One_Digit_Counter is

    component clk_divider is
        generic ( N : positive := 4 );
        port ( CLK : in BIT; CLK_N : out BIT );
    end component;

    signal slow_clk : BIT;
    signal digit    : integer range 0 to 9 := 0;
begin

    -- slow the clock down so we can see counting (~1 Hz)
    DIV : clk_divider
        generic map ( N => 100000000 )   -- use 100000000 on board, 4 for sim
        port map ( CLK => CLK, CLK_N => slow_clk );

    -- the counting process
    process(slow_clk)
    begin
        if slow_clk'event and slow_clk = '1' then
            if Clear = '1' then
                digit <= 0;
            elsif StartStop = '1' then
                if digit = 9 then
                    digit <= 0;
                else
                    digit <= digit + 1;
                end if;
            end if;
        end if;
    end process;

    AN <= "11111110";   -- only rightmost display ON

    -- number -> 7-seg bars (active-low)
    process(digit)
    begin
        case digit is
            when 0 => SEG <= "1000000";
            when 1 => SEG <= "1111001";
            when 2 => SEG <= "0100100";
            when 3 => SEG <= "0110000";
            when 4 => SEG <= "0011001";
            when 5 => SEG <= "0010010";
            when 6 => SEG <= "0000010";
            when 7 => SEG <= "1111000";
            when 8 => SEG <= "0000000";
            when 9 => SEG <= "0010000";
            when others => SEG <= "1111111";
        end case;
    end process;
end architecture behavioral;