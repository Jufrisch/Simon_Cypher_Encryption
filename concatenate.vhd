library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity concatenate is
    generic (
        WIDTH : positive
    );
    port (
        input1 :in  std_logic_vector(WIDTH-1 downto 0);
        input2  :in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH*2-1 downto 0)
    );
end concatenate;

architecture BHV of concatenate is

begin  -- BHV1
  process (input1, input2)
    
  begin
  
    output <= input1 & input2;
    
  end process;
end BHV;