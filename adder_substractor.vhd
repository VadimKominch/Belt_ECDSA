library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity adder_substractor is
generic(
WIDTH:integer
);
port(
a:in std_logic_vector(WIDTH-1 downto 0);
b:in std_logic_vector(WIDTH-1 downto 0);
op:in std_logic;
c:in std_logic_vector(WIDTH downto 0)
);
end adder_substractor;

architecture beh of adder_substractor is
begin
	process(op)
	begin
		if(op='1') then
		c<=a+b;
		else
		c<=a-b;
		end if;
	end process;
end beh;