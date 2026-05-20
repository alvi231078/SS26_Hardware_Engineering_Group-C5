--------------------------------------------------------------------------------
-- File        : half_adder.vhd
-- Description : 1-bit Half Adder using the built-in BIT type.
--               Sum     = A XOR B
--               Carry   = A AND B
--
-- Truth Table:
--   A | B | Sum | Carry
--   --+---+-----+------
--   0 | 0 |  0  |   0
--   0 | 1 |  1  |   0
--   1 | 0 |  1  |   0
--   1 | 1 |  0  |   1
--------------------------------------------------------------------------------

entity half_adder is
    port (
        A     : in  bit;   -- First input bit
        B     : in  bit;   -- Second input bit
        Sum   : out bit;   -- Sum output
        Carry : out bit    -- Carry output
    );
end entity half_adder;

--------------------------------------------------------------------------------
-- Dataflow architecture using concurrent signal assignments
--------------------------------------------------------------------------------
architecture dataflow of half_adder is
begin
    Sum   <= A xor B;
    Carry <= A and B;
end architecture dataflow;
