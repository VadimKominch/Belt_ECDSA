library ieee;
use ieee.std_logic_1164.all;

entity reg is
generic(
WIDTH:integer
);
port(
input:in std_logic_vector(WIDTH-1 downto 0);
clk:in std_logic;
output:out std_logic_vector(WIDTH-1 downto 0)
);
end reg;

architecture beh of reg is
begin

process(clk)
begin
	if(rising_edge(clk)) then
		output<=input;
	end if;
end process;

end beh;