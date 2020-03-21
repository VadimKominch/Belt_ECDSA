library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity belt_hash is
port(
Xi:std_logic_vector(127 downto 0);
clk:in std_logic;
reset:in std_logic;
last_block:in std_logic;   --signal for detecting last input block
finish:out std_logic;
output:out std_logic_vector(255 downto 0)
);
end belt_hash;

architecture beh of belt_hash is

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

component belt_block

end component;

component belt_block
port(
input:in std_logic_vector(127 downto 0);
key:in std_logic_vector(255 downto 0);
clk:in std_logic;
start:in std_logic;
ready:out std_logic;
output:out std_logic_vector(127 downto 0));
end component;


signal output_h:std_logic_vector(255 downto 0);
signal output_s:std_logic_vector(127 downto 0);

begin
--design with attempt of getting maximum performance

reg_h:reg generic map(256) port map(x"B194BAC80A08F53B366D008E584A5DE48504FA9D1BB6C7AC252E72C202FDCE0D",clk,output_h);
reg_s:reg generic map(128) port map(x"00000000000000000000000000000000",clk,output_s);

belt_block1:belt_block port map();
end beh;