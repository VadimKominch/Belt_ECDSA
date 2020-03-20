library ieee;
use ieee.std_logic_1164.all;

--Block which receive some info from outer source.
--Got info as 32-bit vector and last block is padded with
--zeros. Output is always defined but correctness is established
--by ready signal. 

entity recieving_part is
port(
input_block:in std_logic_vector(31 downto 0);
dividing_part:in std_logic_vector(1 downto 0);
clk:in std_logic;
start: in std_logic;
ready:out std_logic;
output:out std_logic_vector(255 downto 0)
);
end recieving_part;

architecture beh of recieving_part is

signal inner_reg:std_logic_vector(255 downto 0);
signal input_word:std_logic_vector(31 downto 0);
signal chunks_amount:std_logic_vector(3 downto 0);
begin
--padding last zero bits if block is not full
process(dividing_part)
begin
	case dividing_part is
	when "00" =>
		input_word <= input_block;
	when "01" =>
		input_word <= input_block(23 downto 0) & x"00";
	when "10" =>
		input_word <= input_block(15 downto 0) & x"0000";
	when "11" =>
		input_word <= input_block(7 downto 0) & x"000000";
	end case;
end process;

--regular receiving chunk
process(clk)
begin
	if(start='1') then
		chunks_amount <= (others=>'0');
	elsif(rising_edge(clk)) then
		inner_reg(31 downto 0)<= input_word;
		chunks_amount <= chunks_amount + 1;
	end if;
end process;
--generating ready signal
process(chunks_amount)
begin
	if(start='1') then
		ready<='0';
	elsif(chunks_amount="111") then
		ready<='1';
	end if;
end process;

output<=inner_reg;

end beh;