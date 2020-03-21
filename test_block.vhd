library ieee;
use ieee.std_logic_1164.all;

entity test_block is
end test_block;

architecture beh of test_block is
component belt_block
port(
input:in std_logic_vector(127 downto 0);
key:in std_logic_vector(255 downto 0);
clk:in std_logic;
start:in std_logic;
ready:out std_logic;
output:out std_logic_vector(127 downto 0));
end component;

signal input:std_logic_vector(127 downto 0);
signal clk:std_logic:='0';
signal start,ready:std_logic;
signal output:std_logic_vector(127 downto 0);
signal key:std_logic_vector(255 downto 0);
begin

clk  <= not clk after 10 ns;

start<= '0',
	'1' after 20 ns,
	'0' after 40 ns;
input<=x"B194BAC80A08F53B366D008E584A5DE4";
key<=x"E9DEE72C8F0C0FA62DDB49F46F73964706075316ED247A3739CBA38303A98BF6";

block1:belt_block port map(input,key,clk,start,ready,output);
end beh;