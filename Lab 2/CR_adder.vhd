-- =============================================================================
-- 4-bit Ripple Carry Adder (Structural Model)
-- Uses four Full Adder instances chained together
-- Carry ripples from bit 0 (LSB) to bit 3 (MSB)
--
-- Enhancement: A generic N allows any bit-width to be instantiated.
--              Default is N=4. Change generic map value to scale.
--
-- Lab 02 - Exercise 02
-- =============================================================================

library ieee;

-- -----------------------------------------------------------------------------
-- Full Adder - re-declared here so this file is self-contained
-- (In real project, keep each entity in its own file and reference it)
-- -----------------------------------------------------------------------------
entity full_adder is
    port (
        A    : in  BIT;
        B    : in  BIT;
        Cin  : in  BIT;
        S    : out BIT;
        Cout : out BIT
    );
end entity full_adder;

architecture structural of full_adder is

    component half_adder is
        port (
            A : in  BIT;
            B : in  BIT;
            S : out BIT;
            C : out BIT
        );
    end component half_adder;

    signal ha1_sum   : BIT;
    signal ha1_carry : BIT;
    signal ha2_carry : BIT;

begin
    HA1 : half_adder port map (A => A,       B => B,   S => ha1_sum,   C => ha1_carry);
    HA2 : half_adder port map (A => ha1_sum, B => Cin, S => S,         C => ha2_carry);
    Cout <= ha1_carry or ha2_carry;
end architecture structural;

-- (Half Adder must be compiled/available in the same library)
entity half_adder is
    port (
        A : in  BIT;
        B : in  BIT;
        S : out BIT;
        C : out BIT
    );
end entity half_adder;

architecture dataflow of half_adder is
begin
    S <= A xor B;
    C <= A and B;
end architecture dataflow;


-- =============================================================================
-- Ripple Carry Adder - 4-bit (Structural, scalable via generic)
-- =============================================================================
entity CR_adder is
    generic (
        N : positive := 4   -- Bit width: change to 8, 16, etc. for wider adders
    );
    port (
        A    : in  BIT_VECTOR(N-1 downto 0);  -- Operand A
        B    : in  BIT_VECTOR(N-1 downto 0);  -- Operand B
        Cin  : in  BIT;                        -- Carry in (for cascading)
        S    : out BIT_VECTOR(N-1 downto 0);  -- Sum
        Cout : out BIT                         -- Carry out (overflow)
    );
end entity CR_adder;

architecture structural of CR_adder is

    -- Component declaration for Full Adder
    component full_adder is
        port (
            A    : in  BIT;
            B    : in  BIT;
            Cin  : in  BIT;
            S    : out BIT;
            Cout : out BIT
        );
    end component full_adder;

    -- Internal carry chain: carry(0) = Cin, carry(N) = Cout
    -- carry(i) is the carry OUT of bit position i-1, feeding INTO bit position i
    signal carry : BIT_VECTOR(N downto 0);

begin

    -- Connect the external Cin to the first carry position
    carry(0) <= Cin;

    -- Generate N full adder instances
    -- FA_i computes: S(i) = A(i) XOR B(i) XOR carry(i)
    --                carry(i+1) = majority(A(i), B(i), carry(i))
    GEN_FA : for i in 0 to N-1 generate
        FA_i : full_adder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => carry(i),
                S    => S(i),
                Cout => carry(i+1)
            );
    end generate GEN_FA;

    -- Final carry out
    Cout <= carry(N);

end architecture structural;
