library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity controller is
	port(
		clk: in std_logic;
		rst: in std_logic;
		go: in std_logic;
		round_count: out std_logic_vector(4 downto 0);
		done: out std_logic;
		mux_x_sel: out std_logic_vector(1 downto 0);
		mux_y_sel: out std_logic_vector(1 downto 0);
		ff_x_en: out std_logic;
		ff_y_en: out std_logic;
		ff_key_en: out std_logic;
		addr_in: in std_logic_vector(4 downto 0);
		valid: out std_logic;
		out_ram_wren: out std_logic);
end controller;

architecture BHV of controller is
	type state_type is (start, Key_Rom_Load, load, check_round_count, do_the_maths, WRITE_OUTRAM, Check_ADDRESS, round_done_valid, wait_for_ram_to_load, Done_Loop);
	signal state: state_type;
	signal next_state: state_type;
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			state <= start;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;
	
	process(go, state, addr_in)
		variable count_round: std_logic_vector(4 downto 0);
	begin
		next_state <= state;
		round_count <= count_round;
		mux_x_sel <= "00";
		mux_y_sel <= "01";
		ff_x_en <= '0';
		ff_y_en <= '0';
		ff_key_en <= '0';
		valid <= '0';
		out_ram_wren <= '0';
		done <= '0';
		
		case state is
			when start =>
				if(go = '0') then
					next_state <= start;
				else
					next_state <= Key_Rom_Load;
				end if;
				
			when Key_Rom_Load =>
				ff_key_en <= '1';
				next_state <= load;

			when load =>
				count_round := "00000";
				mux_x_sel <= "00";
				mux_y_sel <= "01";
				ff_x_en <= '1';
				ff_y_en <= '1';
				next_state <= check_round_count;

			when check_round_count =>
			
				if(count_round = "01100") then
					next_state <= WRITE_OUTRAM;
				else
					next_state <= do_the_maths;
				end if;

			when do_the_maths =>
				mux_x_sel <= "10";
				mux_y_sel <= "11";
				ff_x_en <= '1';
				ff_y_en <= '1';
				count_round := std_logic_vector(unsigned(count_round) + 1);
				next_state <= check_round_count;

			when WRITE_OUTRAM =>
				out_ram_wren <= '1';
				next_state <= Check_ADDRESS;

			when Check_ADDRESS =>
				if(addr_in = "11111") then
					next_state <= Done_Loop;
				else
					next_state <= round_done_valid;
				end if;

			when round_done_valid =>
				valid <= '1';
				next_state <= wait_for_ram_to_load;

			when wait_for_ram_to_load =>
				next_state <= load;

			when Done_Loop =>
				done <= '1';
				
				if(go = '0') then
					valid <= '1';
					next_state <= start;
				else
					next_state <= Done_Loop;
				end if;
			when others => null;
		end case;
	end process;
end BHV;