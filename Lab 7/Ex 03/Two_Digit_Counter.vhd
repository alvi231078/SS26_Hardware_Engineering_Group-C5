library IEEE;

entity Two_Digit_Counter is
    port (
        CLK       : in  BIT;
        StartStop : in  BIT;
        Clear     : in  BIT;
        SEG       : out BIT_VECTOR(6 downto 0);
        AN        : out BIT_VECTOR(7 downto 0)
    );
end entity Two_Digit_Counter;


architecture behavioral of Two_Digit_Counter is

    ------------------------------------------------------------------
    -- clk_divider component
    -- This declaration exactly matches your clk_divider.vhd
    ------------------------------------------------------------------
    component clk_divider is
        generic (
            N : positive := 4
        );
        port (
            CLK   : in  BIT;
            CLK_N : out BIT
        );
    end component;


    ------------------------------------------------------------------
    -- Divided clock signals
    ------------------------------------------------------------------
    signal slow_clk : BIT := '0';
    signal mux_clk  : BIT := '0';


    ------------------------------------------------------------------
    -- Counter digits
    ------------------------------------------------------------------
    signal ones_digit : integer range 0 to 9 := 0;
    signal tens_digit : integer range 0 to 9 := 0;


    ------------------------------------------------------------------
    -- Select active display
    -- '0' = rightmost display
    -- '1' = second display from the right
    ------------------------------------------------------------------
    signal digit_select : BIT := '0';

begin

    ------------------------------------------------------------------
    -- 1 Hz clock for counting
    --
    -- 100 MHz / 100,000,000 = 1 Hz
    ------------------------------------------------------------------
    COUNT_DIVIDER_INSTANCE : clk_divider
        generic map (
            N => 100000000
        )
        port map (
            CLK   => CLK,
            CLK_N => slow_clk
        );


    ------------------------------------------------------------------
    -- 1 kHz clock for display multiplexing
    --
    -- 100 MHz / 100,000 = 1 kHz
    ------------------------------------------------------------------
    MUX_DIVIDER_INSTANCE : clk_divider
        generic map (
            N => 100000
        )
        port map (
            CLK   => CLK,
            CLK_N => mux_clk
        );


    ------------------------------------------------------------------
    -- Two-digit counting process
    --
    -- StartStop = '1' → count
    -- StartStop = '0' → pause
    -- Clear     = '1' → reset to 00
    ------------------------------------------------------------------
    COUNTING_PROCESS : process(slow_clk, Clear)
    begin

        if Clear = '1' then

            ones_digit <= 0;
            tens_digit <= 0;

        elsif slow_clk'event and slow_clk = '1' then

            if StartStop = '1' then

                ------------------------------------------------------
                -- Ones digit: 0 to 9
                ------------------------------------------------------
                if ones_digit = 9 then

                    ones_digit <= 0;

                    --------------------------------------------------
                    -- Increment tens when ones changes 9 → 0
                    --------------------------------------------------
                    if tens_digit = 9 then
                        tens_digit <= 0;
                    else
                        tens_digit <= tens_digit + 1;
                    end if;

                else

                    ones_digit <= ones_digit + 1;

                end if;

            end if;

        end if;

    end process COUNTING_PROCESS;


    ------------------------------------------------------------------
    -- Multiplexing process
    --
    -- Do not reset this process using Clear.
    -- It must continue switching while the counter displays 00.
    ------------------------------------------------------------------
    MULTIPLEXING_PROCESS : process(mux_clk)
    begin

        if mux_clk'event and mux_clk = '1' then
            digit_select <= not digit_select;
        end if;

    end process MULTIPLEXING_PROCESS;


    ------------------------------------------------------------------
    -- Display selection and seven-segment decoder
    ------------------------------------------------------------------
    DISPLAY_PROCESS : process(
        digit_select,
        ones_digit,
        tens_digit
    )

        variable displayed_digit : integer range 0 to 9;

    begin

        --------------------------------------------------------------
        -- Select active display
        -- Nexys A7 anodes are active-low
        --------------------------------------------------------------
        if digit_select = '0' then

            -- Rightmost display shows the ones digit
            displayed_digit := ones_digit;
            AN <= "11111110";

        else

            -- Second display from right shows the tens digit
            displayed_digit := tens_digit;
            AN <= "11111101";

        end if;


        --------------------------------------------------------------
        -- Seven-segment decoder
        --
        -- SEG(6 downto 0) corresponds to:
        -- G F E D C B A
        --
        -- Segments are active-low:
        -- '0' = segment ON
        -- '1' = segment OFF
        --------------------------------------------------------------
        case displayed_digit is

            when 0 =>
                SEG <= "1000000";

            when 1 =>
                SEG <= "1111001";

            when 2 =>
                SEG <= "0100100";

            when 3 =>
                SEG <= "0110000";

            when 4 =>
                SEG <= "0011001";

            when 5 =>
                SEG <= "0010010";

            when 6 =>
                SEG <= "0000010";

            when 7 =>
                SEG <= "1111000";

            when 8 =>
                SEG <= "0000000";

            when 9 =>
                SEG <= "0010000";

            when others =>
                SEG <= "1111111";

        end case;

    end process DISPLAY_PROCESS;

end architecture behavioral;