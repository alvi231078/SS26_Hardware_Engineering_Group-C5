-- =============================================================================
-- 4-bit Adder / Subtractor (Structural Model)
-- Uses the 4-bit Ripple Carry Adder (CR_adder) as a component.
--
-- Principle (Two's complement subtraction):
--   A - B  =  A + (~B) + 1
--
--   Control signal: Mode
--     Mode = '0'  ->  Addition:    S = A + B       (Cin = 0)
--     Mode = '1'  ->  Subtraction: S = A - B = A + NOT(B) + 1  (Cin = 1)
--
--   Each bit of B is XOR'd with Mode:
--     Mode='0': B_i XOR 0 = B_i       (pass through)
--     Mode='1': B_i XOR 1 = NOT(B_i)  (invert)
--   Cin is tied to Mode, so subtraction automatically adds the +1.
--
--   Overflow flag (V): detects signed overflow
--     V = Cout(N-1) XOR Cout(N)  (carry into MSB XOR carry out of MSB)
--
-- Lab 02 - Exercise 03
-- =============================================================================

library ieee;

-- =============================================================================
-- CR_adder component (same as Exercise 02, self-contained here)
-- =============================================================================

entity half_adder is
    port (A : in BIT; B : in BIT; S : out BIT; C : out BIT);
end entity half_adder;
architecture dataflow of half_adder is
begin
    S <= A xor B;
    C <= A and B;
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
-- 4-bit Adder/Subtractor
-- =============================================================================
entity CR_add_sub is
    generic (N : positive := 4);
    port (
        A        : in  BIT_VECTOR(N-1 downto 0);  -- Operand A
        B        : in  BIT_VECTOR(N-1 downto 0);  -- Operand B
        Mode     : in  BIT;                        -- '0'=Add, '1'=Subtract
        S        : out BIT_VECTOR(N-1 downto 0);  -- Result
        Cout     : out BIT;                        -- Carry out / Borrow
        Overflow : out BIT                         -- Signed overflow flag
    );
end entity CR_add_sub;

architecture structural of CR_add_sub is

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

    -- B after selective inversion (XOR each bit with Mode)
    signal B_sel  : BIT_VECTOR(N-1 downto 0);

    -- Internal carry chain for overflow detection
    -- We need carry into and out of the MSB:
    -- Use two adders OR expose internal carry via a wider approach.
    -- Simpler approach: compute overflow as Cin_MSB XOR Cout_MSB
    -- We achieve this by splitting the adder into lower (N-1) bits
    -- and the MSB full adder, capturing both carries.
    signal S_int      : BIT_VECTOR(N-1 downto 0);
    signal carry_msb  : BIT;   -- carry INTO the MSB stage
    signal carry_out  : BIT;   -- carry OUT of the MSB stage (= Cout)

    -- Lower N-1 bits adder result
    signal S_low      : BIT_VECTOR(N-2 downto 0);

begin

    -- -------------------------------------------------------------------------
    -- XOR each bit of B with Mode:
    --   Mode=0 -> B_sel = B       (addition)
    --   Mode=1 -> B_sel = NOT(B)  (subtraction via two's complement)
    -- -------------------------------------------------------------------------
    GEN_XOR : for i in 0 to N-1 generate
        B_sel(i) <= B(i) xor Mode;
    end generate GEN_XOR;

    -- -------------------------------------------------------------------------
    -- Lower N-1 bits: bits 0 to N-2
    -- Cin of this block = Mode (0 for add, 1 for subtract)
    -- -------------------------------------------------------------------------
    ADDER_LOW : CR_adder
        generic map (N => N-1)
        port map (
            A    => A(N-2 downto 0),
            B    => B_sel(N-2 downto 0),
            Cin  => Mode,
            S    => S_low,
            Cout => carry_msb      -- carry INTO the MSB position
        );

    -- -------------------------------------------------------------------------
    -- MSB full adder (bit N-1): separate instance to capture carry_out
    -- -------------------------------------------------------------------------
    ADDER_MSB : CR_adder
        generic map (N => 1)
        port map (
            A(0)    => A(N-1),
            B(0)    => B_sel(N-1),
            Cin     => carry_msb,
            S(0)    => S_int(N-1),
            Cout    => carry_out
        );

    -- -------------------------------------------------------------------------
    -- Assemble final sum output
    -- -------------------------------------------------------------------------
    S(N-2 downto 0) <= S_low;
    S(N-1)          <= S_int(N-1);

    -- -------------------------------------------------------------------------
    -- Carry out / Borrow
    -- -------------------------------------------------------------------------
    Cout <= carry_out;

    -- -------------------------------------------------------------------------
    -- Signed Overflow Detection:
    --   Overflow occurs when carry into MSB differs from carry out of MSB
    --   V = carry_msb XOR carry_out
    -- -------------------------------------------------------------------------
    Overflow <= carry_msb xor carry_out;

end architecture structural;
