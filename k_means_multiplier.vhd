library ieee;
use ieee.std_logic_1164.all;

entity k_means_multiplier is
--add generic to specify length of vector
port(
k:in std_logic_vector(127 downto 0);
x_in:in std_logic_vector(127 downto 0);
y_in:in std_logic_vector(127 downto 0);
clk:in std_logic;
reset:in std_logic;
start:in std_logic;
x_out:out std_logic_vector(127 downto 0);
y_out:out std_logic_vector(127 downto 0)
);
end k_means_multiplier;

architecture beh of k_means_multiplier is

component reg
generic(
WIDTH:integer
);
port(
input:in std_logic_vector(WIDTH-1 downto 0);
clk:in std_logic;
output:out std_logic_vector(WIDTH-1 downto 0)
);
end component;

component adder_substractor
generic(
WIDTH:integer
);
port(
a:in std_logic_vector(WIDTH-1 downto 0);
b:in std_logic_vector(WIDTH-1 downto 0);
op:in std_logic;
c:in std_logic_vector(WIDTH downto 0)
);
end component;

type state is (waiting,,ready);
signal current_state:state;
signal current_operation:std_logic;
signal X,Y,Z:in std_logic_vector(255 downto 0);

--input state
begin
process(clk,reset)
begin
	if(reset='1') then
	--initial state
		current_state<=waiting;
	elsif(rising_edge(clk)) then
			case current_state is
			when input_hashing =>
					if(finish_hash='1') then
						current_state<= k_multiplying;
					end if;
			when k_multiplying =>
					if(finish_multiplying='1') then
						current_state<= inner_message_hashing;
					end if;
			when inner_message_hashing =>
					if(finish_hash='1') then
						current_state<= counting_s0;
					end if;
			when counting_s0 =>
					current_state <= counting_s1;
			when counting_s1 =>
					current_state <= ready;
			when ready =>
					current_state <=waiting;
			when waiting =>
					current_state <=input_hashing;
			end case;
	end if;
end process;

--use algorithm of Montgomery
--analyze each digit of k to solve if it need to calculate or only double

--adder
add1:adder_substractor generic map() port map();

--todo
--1) develop some modules with modular arithmetic
--2) improve multiplication
reg_X:reg generic map() port map(,clk,output_X);
reg_Y:reg generic map() port map(,clk,output_Y);
reg_Z:reg generic map() port map(,clk,output_Z);
end beh;