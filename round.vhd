library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity round is
    port(
        x	: in std_logic_vector(WORD_SIZE-1 downto 0); --most significant word of input
        y	: in std_logic_vector(WORD_SIZE-1 downto 0); -- least signficant word of input
	round_key : in std_logic_vector(WORD_SIZE-1 downto 0); 
	round_out : out std_logic_vector(BLOCK_SIZE-1 downto 0)
    );

end round;

architecture BHV of round is


begin
    process(x,y,round_key)
	----------- your variables here -----------
    variable op_1_s : std_logic_vector(WORD_SIZE-1 downto 0);
	variable op_2_s : std_logic_vector(WORD_SIZE-1 downto 0);
	variable op_8_s : std_logic_vector(WORD_SIZE-1 downto 0);
	
    begin
	----------- your code here -----------
    op_1_s := std_logic_vector(rotate_left(unsigned(x), 1));
	op_2_s := std_logic_vector(rotate_left(unsigned(x), 2));
	op_8_s := std_logic_vector(rotate_left(unsigned(x), 8));
    
    round_out <= ((op_1_s and op_8_s) xor op_2_s xor y xor round_key) & x;

	
    end process;
end BHV;
