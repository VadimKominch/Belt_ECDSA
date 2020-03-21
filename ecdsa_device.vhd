library ieee;
use ieee.std_logic_1164.all;


--ECDSA entity.
--Computing eletronic sign.
--Use document STB 34.101.45-2013.

entity ecdsa_device is
port(
x:in std_logic_vector(31 downto 0); -- change to full block or add some addtitional signals
dividing_part:in std_logic_vector(1 downto 0);
clk:in std_logic;
reset:in std_logic;
start: in std_logic;
output:out std_logic_vector(383 downto 0)
);
end ecdsa_device;

architecture beh of ecdsa_device is

component recieving_part
port(
input_block:in std_logic_vector(31 downto 0);
dividing_part:in std_logic_vector(1 downto 0);
clk:in std_logic;
start: in std_logic;
ready:out std_logic;
output:out std_logic_vector(255 downto 0)
);
end component;

--add transmitting
--input_hashing - process of hashing input message
--k_multiplying - multiplying base point by constant K
--inner_message_hashing - process of hashing inner message(S0)
--counting S1
--ready
type state is (input_hashing,k_multiplying,inner_message_hashing,counting_s0,counting_s1,ready);
signal current_state:state;


signal inner_message:std_logic_vector(255 downto 0);
signal finish_hashing,finish_multiplying,block_ready:std_logic;
signal recieved_block,output_hash:std_logic_vector(255 downto 0);
signal input_reg_1:std_logic_vector(255 downto 0);
signal input_hash_block:std_logic_vector(255 downto 0);

begin

--control unit
process(clk,reset)
begin
	if(reset='1') then
	--initial state
		current_state<=ready;
	elsif(rising_edge(clk)) then
			case current_state is
			when ready =>
					if(start='1') then
						current_state <= input_hashing;
					end if;
			--handle signals of message end
			when input_hashing =>
					if(finish_input_hashing='1') then
						input_reg_1<= output_inner_hash;
						current_state <= inner_message_hashing;
					end if;
			when inner_message_hashing =>
						current_state <= counting_s0;
			when counting_s0 =>
					current_state <= counting_s1;
			when counting_s1 =>
					current_state <= ready;
			end case;
	end if;
end process;

--belt_hash
--1)must have input signal for end recieved block
--2)gets only for 256 bit blocks for hashing
--3)don't count length of message

recieve:recieving_part port map(x,dividing_part,clk,start,block_ready,last_block,recieved_block);
belt_hash1:belt_hash port map(input_hash_block,last_block,clk,output_hash);

--multiplier
--1)must have some handling signals such as finishing work or something else
--2)must be reset after certain signal
--3)get only one coordinate, x is zero in the start of this block

mult1:k_means_multiplier port map(start_multiplying,output_mult_x,output_mult_Y,finish_multiplying);

--S1 calculating block--

reg1:reg generic map(256) port map(input_reg_1,clk,output_reg1);
reg2:reg generic map(256) port map(input_reg_2,clk,output_reg2);

reg3:reg generic map(256) port map();
reg4:reg generic map(256) port map();

end beh;
