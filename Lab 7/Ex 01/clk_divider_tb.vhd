library IEEE;

entity clk_divider_tb is
end entity clk_divider_tb;

architecture sim of clk_divider_tb is
    component clk_divider is
        generic ( N : positive := 4 );
        port ( CLK : in BIT; CLK_N : out BIT );
    end component;

    signal CLK   : BIT := '0';
    signal CLK_N : BIT;
begin
    UUT : clk_divider generic map (N => 4) port map (CLK => CLK, CLK_N => CLK_N);

    -- make a fake clock: flip every 5 ns
    clk_gen : process
    begin
        CLK <= '0'; wait for 5 ns;
        CLK <= '1'; wait for 5 ns;
    end process;

    -- stop after a while
    stop : process
    begin
        wait for 500 ns;
        assert false report "Simulation finished" severity failure;
    end process;
end architecture sim;