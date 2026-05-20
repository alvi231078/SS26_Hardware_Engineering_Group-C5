--------------------------------------------------------------------------------
-- File        : half_subtractor.vhd
-- Description : 1-bit Half Subtractor using the built-in BIT type.
--               Computes A - B and produces Difference and Borrow.
--
--               Diff   = A XOR B
--               Borrow = (NOT A) AND B
--
-- Truth Table:
--   A | B | Diff | Borrow
--   --+---+------+--------
--   0 | 0 |  0   |   0
--   0 | 1 |  1   |   1
--   1 | 0 |  1   |   0
--   1 | 1 |  0   |   0
--------------------------------------------------------------------------------

entity half_subtractor is
    port (
        A      : in  bit;   -- Minuend
        B      : in  bit;   -- Subtrahend
        Diff   : out bit;   -- Difference output
        Borrow : out bit    -- Borrow output
    );
end entity half_subtractor;

--------------------------------------------------------------------------------
-- Dataflow architecture using concurrent signal assignments
--------------------------------------------------------------------------------
architecture dataflow of half_subtractor is
begin
    Diff   <= A xor B;
    Borrow <= (not A) and B;
end architecture dataflow;
