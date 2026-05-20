-- =============================================================================
-- 4-bit BCD Adder
-- Adds two BCD digits (0-9) and produces a BCD result with carry out.
--
-- Algorithm:
--   Step 1: Binary addition of A + B (+ Cin) using CR_adder
--   Step 2: If binary result > 9 (1001) OR carry out = '1':
--              Add correction value 6 (0110) to binary result
--              This "skips" the 6 invalid BCD codes (1010 to 1111)
--           Else: binary result is already valid BCD
--   Step 3: Cout_bcd = '1' if correction was needed
--
-- Valid BCD input range: 0000 (0) to 1001 (9)
-- Valid BCD output range: 0000 (0) to 1001 (9), with Cout for tens digit
--
-- Lab 02 - Exercise 04
-- =============================================================================

library ieee;

-- =============================================================================
-- Supporting entities (self-contained)
-- =============================================================================

entity half_adder is
    port (A : in BIT; B : in BIT; S : out BIT; C : out BIT);
end entity half_adder;
architecture dataflow of half_adder is
begin
    S <= A xor B; C <= A and B;
end architecture dataflow;

entity full_adder is
    port (A : in BIT; B : in BIT; Cin : in BIT; S : out BIT; Cout : out BIT);
end entity full_adder;
architecture structural of full_adder is
    component half_adder is
        port (A : in BIT; B : in BIT; S : out BIT; C : out BIT);
    end component;
    signal ha1_s, ha1_c, ha2_c : BIT;
begin
    HA1 : half_adder port map (A, B, ha1_s, ha1_c);
    HA2 : half_adder port map (ha1_s, Cin, S, ha2_c);
    Cout <= ha1_c or ha2_c;
end architecture structural;

entity CR_adder is
    generic (N : positive := 4);
    port (
        A    : in  BIT_VECTOR(N-1 downto 0);
        B    : in  BIT_VECTOR(N-1 downto 0);
        Cin  : in  BIT;
        S    : out BIT_VECTOR(N-1 downto 0);
        Cout : out BIT
    );
end entity CR_adder;
architecture structural of CR_adder is
    component full_adder is
        port (A : in BIT; B : in BIT; Cin : in BIT; S : out BIT; Cout : out BIT);
    end component;
    signal carry : BIT_VECTOR(N downto 0);
begin
    carry(0) <= Cin;
    GEN_FA : for i in 0 to N-1 generate
        FA_i : full_adder port map (A(i), B(i), carry(i), S(i), carry(i+1));
    end generate;
    Cout <= carry(N);
end architecture structural;


-- =============================================================================
-- BCD Adder
-- =============================================================================
entity BCD_adder is
    port (
        A       : in  BIT_VECTOR(3 downto 0);  -- BCD digit A (0-9)
        B       : in  BIT_VECTOR(3 downto 0);  -- BCD digit B (0-9)
        Cin     : in  BIT;                      -- Carry in from previous BCD stage
        S       : out BIT_VECTOR(3 downto 0);  -- BCD sum digit (0-9)
        Cout    : out BIT                       -- Carry out to next BCD stage (tens)
    );
end entity BCD_adder;

architecture structural of BCD_adder is

    component CR_adder is
        generic (N : positive := 4);
        port (
            A    : in  BIT_VECTOR(N-1 downto 0);
            B    : in  BIT_VECTOR(N-1 downto 0);
            Cin  : in  BIT;
            S    : out BIT_VECTOR(N-1 downto 0);
            Cout : out BIT
        );
    end component CR_adder;

    -- Step 1 intermediate results
    signal bin_sum   : BIT_VECTOR(3 downto 0);  -- Raw binary sum
    signal bin_cout  : BIT;                      -- Binary carry out

    -- Correction needed flag
    -- Need correction when: bin_cout='1' OR binary sum > 9 (i.e., >= 1010)
    -- Sum > 9 when: S3&S2=1 OR S3&S1=1  (S3=bit3, S2=bit2, S1=bit1)
    signal correction_needed : BIT;

    -- Correction value is 6 (0110) when needed, 0 (0000) otherwise
    signal correction : BIT_VECTOR(3 downto 0);

begin

    -- -------------------------------------------------------------------------
    -- Step 1: Binary addition A + B + Cin
    -- -------------------------------------------------------------------------
    ADDER1 : CR_adder
        generic map (N => 4)
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            S    => bin_sum,
            Cout => bin_cout
        );

    -- -------------------------------------------------------------------------
    -- Step 2: Detect if correction is needed
    -- Binary sum > 9 means sum is 10-15 (1010 to 1111):
    --   sum >= 10 iff  (bit3 AND bit1) OR (bit3 AND bit2)
    --   i.e., S3 and (S2 or S1)
    -- Correction needed if binary carry OR sum > 9
    -- -------------------------------------------------------------------------
    correction_needed <= bin_cout
                      or (bin_sum(3) and bin_sum(2))
                      or (bin_sum(3) and bin_sum(1));

    -- Build correction vector: 0110 if needed, 0000 otherwise
    correction(0) <= '0';
    correction(1) <= correction_needed;   -- bit 1 of 6 = 1
    correction(2) <= correction_needed;   -- bit 2 of 6 = 1
    correction(3) <= '0';

    -- -------------------------------------------------------------------------
    -- Step 3: Add correction to binary sum
    -- The carry out of this adder contributes to BCD Cout
    -- -------------------------------------------------------------------------
    ADDER2 : CR_adder
        generic map (N => 4)
        port map (
            A    => bin_sum,
            B    => correction,
            Cin  => '0',
            S    => S,
            Cout => open    -- carry from correction adder not needed separately
        );

    -- -------------------------------------------------------------------------
    -- BCD carry out: asserted whenever correction was needed
    -- (correction_needed already encodes the carry from step 1)
    -- -------------------------------------------------------------------------
    Cout <= correction_needed;

end architecture structural;
