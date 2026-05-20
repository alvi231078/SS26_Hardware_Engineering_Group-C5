-- =============================================================================
-- Full Adder (Structural Model)
-- Uses two Half Adder instances + OR gate
-- Inputs/Outputs: BIT type
-- Lab 02 - Exercise 01
-- =============================================================================

library ieee;

-- -----------------------------------------------------------------------------
-- Half Adder Component (from Lab 01 Ex02) - defined here for completeness
-- -----------------------------------------------------------------------------
entity half_adder is
    port (
        A : in  BIT;
        B : in  BIT;
        S : out BIT;   -- Sum
        C : out BIT    -- Carry
    );
end entity half_adder;

architecture dataflow of half_adder is
begin
    S <= A xor B;
    C <= A and B;
end architecture dataflow;


-- -----------------------------------------------------------------------------
-- Full Adder - Structural Model
-- FA = HA1(A,B) -> HA2(HA1.S, Cin) -> Cout = HA1.C OR HA2.C
-- -----------------------------------------------------------------------------
entity full_adder is
    port (
        A    : in  BIT;
        B    : in  BIT;
        Cin  : in  BIT;
        S    : out BIT;   -- Sum
        Cout : out BIT    -- Carry out
    );
end entity full_adder;

architecture structural of full_adder is

    -- Component declaration for Half Adder
    component half_adder is
        port (
            A : in  BIT;
            B : in  BIT;
            S : out BIT;
            C : out BIT
        );
    end component half_adder;

    -- Internal signals
    signal ha1_sum   : BIT;  -- Sum output of first Half Adder
    signal ha1_carry : BIT;  -- Carry output of first Half Adder
    signal ha2_carry : BIT;  -- Carry output of second Half Adder

begin

    -- First Half Adder: adds A and B
    HA1 : half_adder
        port map (
            A => A,
            B => B,
            S => ha1_sum,
            C => ha1_carry
        );

    -- Second Half Adder: adds result of HA1 with Cin
    HA2 : half_adder
        port map (
            A => ha1_sum,
            B => Cin,
            S => S,
            C => ha2_carry
        );

    -- Final Carry: OR of both half adder carries
    -- (both carries can never be '1' simultaneously -> OR = XOR here, OR is correct)
    Cout <= ha1_carry or ha2_carry;

end architecture structural;
