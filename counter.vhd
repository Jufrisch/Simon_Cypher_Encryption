library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        valid : in std_logic;
        output : out std_logic_vector(4 downto 0));
end counter;

architecture BHV_UNSIGNED of counter is
    -- use a 4 bit unsigned instead of an integer
signal count : std_logic_vector(4 downto 0);
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            count <= "00000";
        elsif (rising_edge(clk)) then
            if (valid='1') then             
                count <= std_logic_vector(unsigned(count) + 1);
            end if;
        end if;
    end process;
output <= count;
end BHV_UNSIGNED;


