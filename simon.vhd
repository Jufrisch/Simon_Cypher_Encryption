
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity simon is
    port(
	clk	: in std_logic;
	rst	: in std_logic;	
	key_in	: in std_logic_vector(2*BLOCK_SIZE-1 downto 0); --key input
	input	: in std_logic_vector(BLOCK_SIZE-1 downto 0); --plaintext or ciphertext
	round_count : in std_logic_vector(4 downto 0); -- current round count
	mux_x_sel, mux_y_sel : in std_logic_vector(1 downto 0); --control for muxes
	ff_key_en, ff_x_en, ff_y_en : in std_logic; --enable for FFs
	output	: out std_logic_vector(BLOCK_SIZE-1 downto 0)); --final plaintext or ciphertext
end simon;

architecture datapath of simon is
----------- your signals here -----------
type KEY_EXPANSION_ARR is array (0 to N_ROUNDS) of std_logic_vector(WORD_SIZE-1 downto 0);
type ROUND_COUNT_ARR is array (0 to N_ROUNDS) of std_logic_vector(4 downto 0);
signal round_key : KEY_EXPANSION_ARR; --round keys
signal round_count_index : ROUND_COUNT_ARR; --index for round keys
	signal x : std_logic_vector(WORD_SIZE-1 downto 0);
    signal y : std_logic_vector(WORD_SIZE-1 downto 0);
    signal round_out : std_logic_vector(BLOCK_SIZE-1 downto 0);
    signal reg_x_out : std_logic_vector(WORD_SIZE-1 downto 0);
    signal reg_y_out : std_logic_vector(WORD_SIZE-1 downto 0);


    signal key_expansion_in : std_logic_vector(2*BLOCK_SIZE-1 downto 0);
	signal current_round_key : std_logic_vector(WORD_SIZE-1 downto 0);
begin

	

-----initialize round keys taken from input here-------

--round count array for key expansion
round_count_index <= ("00000","00001","00010", "00011","00100","00101","00110","00111",
                "01000","01001","01010","01011","01100");
--round_key(0 to 3) <= (key_in(63 downto 48), key_in(47 downto 32),key_in(31 downto 16), key_in(15 downto 0));
round_key(0 to 3) <= (key_in(15 downto 0), key_in(31 downto 16), key_in(47 downto 32), key_in(63 downto 48));
current_round_key <= round_key(to_integer(unsigned(round_count)));

-- generate round keys
GEN_ROUND_KEYS: for i in 4 to N_ROUNDS generate
----------- your code here -----------
	U_KEY_EXPANSION: entity work.key_expansion
		port map (
			key_in(63 downto 48)    => round_key(i-1),
			key_in(47 downto 32)    => round_key(i-2),
			key_in(31 downto 16)    => round_key(i-3),
			key_in(15 downto 0)    => round_key(i-4),
			round_count  => round_count_index(i),
			key_out     => round_key(i)
		);
	--Not sure if ROUND should be in this generate--
	
	
	
end generate GEN_ROUND_KEYS;


U_ROUND : entity work.round
	port map(
		x => reg_x_out,
		y => reg_y_out,
		round_key => current_round_key,
		round_out => round_out
	);


U_MUX_X: entity work.mux_4x1
generic map (
	WIDTH => word_size
)
port map (
	sel    => mux_x_sel,
	in0    => input(31 downto 16),
	in1    => input(15 downto 0),
	in2 => round_out(31 downto 16),
	in3 => round_out(15 downto 0),
	output => x
);

U_MUX_Y: entity work.mux_4x1
generic map (
	WIDTH => word_size
)
port map (
	sel    => mux_y_sel,
	in0    => input(31 downto 16),
	in1    => input(15 downto 0),
	in2 => round_out(31 downto 16),
	in3 => round_out(15 downto 0),
	output => y
);

U_REG_X: entity work.reg
generic map (
	WIDTH => word_size
)
port map (
	clk    => clk,
	rst    => rst,
	en     => ff_x_en,
	input  => x,
	output => reg_x_out
);

U_REG_Y: entity work.reg
generic map (
	WIDTH => word_size
)
port map (
	clk    => clk,
	rst    => rst,
	en     => ff_y_en,
	input  => y,
	output => reg_y_out
);



U_REG_KEY_IN: entity work.reg
generic map (
	WIDTH => 2*block_size
)
port map (
	clk    => clk,
	rst    => rst,
	en     => ff_key_en,
	input  => key_in,
	output => key_expansion_in
);



output <= reg_x_out & reg_y_out;

  


 	
----------- your code here -----------


end datapath;

