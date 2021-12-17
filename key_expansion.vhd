library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity key_expansion is
    port(
	key_in	: in std_logic_vector(2*BLOCK_SIZE-1 downto 0); -- {round_key[i+3], round_key[i+2], round_key[i+1], round_key[i]}
	round_count : in std_logic_vector(4 downto 0); -- current round
	key_out	: out std_logic_vector(WORD_SIZE-1 downto 0) -- round_key[i+4]
    );

end key_expansion;

architecture BHV of key_expansion is
----------- your signals here -----------


begin

    process(key_in, round_count)
	  constant c : std_logic_vector(WORD_SIZE-1 downto 0) := X"0003"; -- Constant C
      constant z : std_logic_vector(61 downto 0) := "01100111000011010100100010111110110011100001101010010001011111";
	  ----------- your variables here -----------
	  variable temp1,temp2,temp3,temp4,round_key0,round_key1,round_key2,round_key3,round_key4,zcalc : std_logic_vector(WORD_SIZE-1 downto 0);
    begin
       round_key0 := key_in(15 downto 0);
       round_key1 := key_in(31 downto 16);
       round_key2 := key_in(47 downto 32);
       round_key3 := key_in(63 downto 48);


    
       
    ------z=1-------
    temp1 := std_logic_vector(rotate_right(unsigned(round_key3), 3)) xor round_key1;
    temp2 := (temp1 xor std_logic_vector(rotate_right(unsigned(temp1),1))) xor (not round_key0);

    zcalc := "000000000000000" & z(((to_integer(unsigned(round_count)))-4) mod 62);
    round_key4 := temp2  xor zcalc xor c;

    key_out <= round_key4;

    ----------- your code here -----------
    end process;


end BHV;
