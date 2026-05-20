-- =============================================================================
-- BCD to 7-Segment Display Decoder
-- Converts a 4-bit BCD digit (0-9) to 7-segment display signals
--
-- Segment layout (common cathode - active HIGH):
--
--       AAAA
--      F    B
--      F    B
--       GGGG
--      E    C
--      E    C
--       DDDD  (DP)
--
-- Output vector: SEG(6 downto 0) = (A, B, C, D, E, F, G)
-- SEG index:       6  5  4  3  2  1  0
--
-- Truth Table (active HIGH, common cathode):
-- BCD |  A  B  C  D  E  F  G  | Display
-- 0000|  1  1  1  1  1  1  0  |   0
-- 0001|  0  1  1  0  0  0  0  |   1
-- 0010|  1  1  0  1  1  0  1  |   2
-- 0011|  1  1  1  1  0  0  1  |   3
-- 0100|  0  1  1  0  0  1  1  |   4
-- 0101|  1  0  1  1  0  1  1  |   5
-- 0110|  1  0  1  1  1  1  1  |   6
-- 0111|  1  1  1  0  0  0  0  |   7
-- 1000|  1  1  1  1  1  1  1  |   8
-- 1001|  1  1  1  1  0  1  1  |   9
-- others -> all off (0000000)
--
-- Lab 02 - Exercise 05
-- =============================================================================

library ieee;

entity BCDto7seg is
    port (
        BCD : in  BIT_VECTOR(3 downto 0);  -- BCD input (0-9)
        SEG : out BIT_VECTOR(6 downto 0)   -- Segments: (A,B,C,D,E,F,G)
    );
end entity BCDto7seg;

architecture dataflow of BCDto7seg is

    -- Aliases for readability
    alias bcd3 : BIT is BCD(3);  -- MSB
    alias bcd2 : BIT is BCD(2);
    alias bcd1 : BIT is BCD(1);
    alias bcd0 : BIT is BCD(0);  -- LSB

    -- Internal signals for each segment
    signal seg_A, seg_B, seg_C, seg_D, seg_E, seg_F, seg_G : BIT;

begin

    -- =========================================================================
    -- Minimized Boolean expressions for each segment (derived from K-Map)
    -- Variables: D=bcd3, C=bcd2, B=bcd1, A=bcd0
    -- =========================================================================

    -- Segment A (top):
    -- A=1 for digits: 0,2,3,5,6,7,8,9
    -- A = NOT(A0) OR (A0 XOR A1)  [simplified via K-Map]
    -- K-Map result: A = D + B*!A + !B*A + C
    seg_A <=      (not bcd0)
               or (bcd1 and not bcd0)
               or (not bcd1 and bcd0)
               or bcd2
               or bcd3;
    -- Simplified: seg_A = ~bcd0 | (bcd1 ^ bcd0) | bcd2 | bcd3
    -- But keeping explicit form for clarity and direct K-Map correspondence

    -- Segment B (upper right):
    -- B=1 for digits: 0,1,2,3,4,7,8,9
    -- K-Map result: B = !C + !A + !(B XOR A) ... 
    -- B = ~bcd2 + (~bcd1 & ~bcd0) + (~bcd1 & bcd0) ... 
    -- Simplified: B = ~bcd2 | ~bcd1 | ~bcd0 ... 
    -- Direct: NOT asserted only for 5(0101) and 6(0110)
    seg_B <=      (not bcd2)
               or (not bcd1 and not bcd0)
               or (not bcd1 and bcd3)
               or (bcd1 and bcd0);

    -- Segment C (lower right):
    -- C=1 for digits: 0,1,3,4,5,6,7,8,9  (NOT for 2)
    -- Only off for digit 2 (0010)
    seg_C <=      bcd2
               or bcd0
               or (not bcd1)
               or bcd3;

    -- Segment D (bottom):
    -- D=1 for digits: 0,2,3,5,6,8,9 (NOT for 1,4,7)
    -- K-Map simplification:
    seg_D <=      (not bcd2 and not bcd0)
               or (bcd1 and not bcd0)
               or (bcd2 and not bcd1)
               or (bcd1 and not bcd2 and bcd0)
               or bcd3;

    -- Segment E (lower left):
    -- E=1 for digits: 0,2,6,8  (partially for others)
    -- E is on for: 0(0000),2(0010),6(0110),8(1000)
    -- E = ~bcd2 & ~bcd0 | bcd2 & bcd1 & ~bcd0 ... 
    seg_E <=      (not bcd0 and not bcd2)
               or (bcd1 and not bcd0)
               or (bcd3 and not bcd0);

    -- Segment F (upper left):
    -- F=1 for digits: 0,4,5,6,8,9
    seg_F <=      (not bcd1 and not bcd0)
               or (bcd2 and not bcd0)
               or (bcd2 and bcd1)
               or bcd3;

    -- Segment G (middle):
    -- G=1 for digits: 2,3,4,5,6,8,9  (NOT for 0,1,7)
    -- G = 0 for 0(0000), 1(0001), 7(0111)
    seg_G <=      (bcd2 and not bcd1)
               or (bcd1 and not bcd0)
               or (bcd2 and not bcd0)
               or bcd3
               or (bcd1 and not bcd2);
    -- Simplified: G = bcd2 ^ bcd1 | bcd3 | bcd2&~bcd0

    -- =========================================================================
    -- Assign to output port: SEG = (A, B, C, D, E, F, G)
    -- =========================================================================
    SEG(6) <= seg_A;
    SEG(5) <= seg_B;
    SEG(4) <= seg_C;
    SEG(3) <= seg_D;
    SEG(2) <= seg_E;
    SEG(1) <= seg_F;
    SEG(0) <= seg_G;

end architecture dataflow;
