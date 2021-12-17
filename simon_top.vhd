library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity simon_top is
    port(
	clk	: in std_logic;
	rst	: in std_logic;	
	go	: in std_logic;
	valid : out std_logic; --denotes output is valid.
	done : out std_logic);

end simon_top;

architecture STR of simon_top is

signal simon_out : std_logic_vector(BLOCK_SIZE-1 downto 0); -- map to output of your simon cipher instance. DO NOT TOUCH
----------- your signals here -----------
signal x : std_logic_vector(15 downto 0);
signal y : std_logic_vector(15 downto 0);
signal round_out : std_logic_vector(31 downto 0);
signal reg_x_out : std_logic_vector(15 downto 0);
signal reg_y_out : std_logic_vector(15 downto 0);
signal output : std_logic_vector(31 downto 0);
signal key_expansion_in : std_logic_vector(63 downto 0);
signal round_count : std_logic_vector(4 downto 0);
signal mux_x_sel : std_logic_vector(1 downto 0);
signal mux_y_sel : std_logic_vector(1 downto 0);
signal ff_key_en : std_logic;
signal ff_x_en : std_logic;
signal ff_y_en : std_logic;
signal out_ram_wren : std_logic;
signal INPUT_RAM_ADDR_IN : std_logic_vector(4 downto 0);
signal OUTPUT_RAM_ADDR_OUT : std_logic_vector(4 downto 0);
signal INPUT_RAM_OUT : std_logic_vector(31 downto 0);
signal en : std_logic;
signal wren: std_logic;
signal data : STD_LOGIC_VECTOR (31 DOWNTO 0);
signal address : STD_LOGIC_VECTOR (0 DOWNTO 0);



begin
----------- your code here -----------


U_Controller : entity work.controller

port map(
	clk	=> clk,
	rst	=> rst,
	go	=> go,
	round_count => round_count,
	done	=> done,
	mux_x_sel => mux_x_sel,
	mux_y_sel => mux_y_sel,
	ff_key_en => ff_key_en,
	ff_x_en   => ff_x_en,
	ff_y_en   => ff_y_en,
	addr_in	=> INPUT_RAM_ADDR_IN,
	valid	  => en,
	out_ram_wren => out_ram_wren
);


U_datapath: entity work.simon

port map (
    clk	=> clk,
	rst	=> rst,
	key_in	=> key_expansion_in,
	input	=> INPUT_RAM_OUT,
	round_count => round_count,
	mux_x_sel => mux_x_sel,
    mux_y_sel => mux_y_sel,
	ff_key_en  => ff_key_en,
    ff_x_en  =>  ff_x_en,
    ff_y_en => ff_y_en,
	output	=> output
);



U_INPUT_RAM_ADDR_GEN: entity work.counter

port map(
    clk	=> clk,
	rst	=> rst,
    valid => en,
    output => INPUT_RAM_ADDR_IN
);

U_OUTPUT_RAM_ADDR_GEN: entity work.counter

port map(
    clk	=> clk,
	rst	=> rst,
    valid => en,
    output => OUTPUT_RAM_ADDR_OUT
);

U_INPUT_RAM: entity work.inram

port map(
    address		=> INPUT_RAM_ADDR_IN,
    clock		=> clk,
    data		=> data,
    wren		=> wren,
    q		    => INPUT_RAM_OUT
);

U_OUTPUT_RAM: entity work.outram

port map(
    address		=> OUTPUT_RAM_ADDR_OUT,
    clock		=> clk,
    data		=> output,
    wren		=> out_ram_wren,
    q		    => open
);

U_KEY_ROM: entity work.keyrom

port map(
    address		=> address,
	clock		=> clk,
	q		    => key_expansion_in
);


sp_simon_out <= simon_out; --for testbench to work, this signal assignment is needed. DO NOT TOUCH

valid <= en;



end STR;