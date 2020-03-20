library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
--scheme used for implementing regular pipeline scheme
--key1 key(255 downto 224)
--key2 key(223 downto 182)
--key3 key(181 downto 160)
--key4 key(159 downto 128)
--key5 key(127 downto 96)
--key6 key(95 downto 64)
--key7 key(63 downto 32)
--key8 key(31 downto 0)
entity belt_block is
port(
input:in std_logic_vector(127 downto 0);
key:in std_logic_vector(255 downto 0);
clk:in std_logic;
start:in std_logic;
ready:out std_logic;
output:out std_logic_vector(127 downto 0));
end belt_block;

--
--cyclic sequential block architecture
--
--architecture cyclic of belt_block is
--
--component one_cycle_iter_belt_block
--port(
--a_input:in std_logic_vector(31 downto 0);
--b_input:in std_logic_vector(31 downto 0);
--c_input:in std_logic_vector(31 downto 0);
--d_input:in std_logic_vector(31 downto 0);
--key1:in std_logic_vector(31 downto 0);
--key2:in std_logic_vector(31 downto 0);
--key3:in std_logic_vector(31 downto 0);
--key4:in std_logic_vector(31 downto 0);
--key5:in std_logic_vector(31 downto 0);
--key6:in std_logic_vector(31 downto 0);
--key7:in std_logic_vector(31 downto 0);
--clk:in std_logic;
--output_a:out std_logic_vector(31 downto 0);
--output_b:out std_logic_vector(31 downto 0);
--output_c:out std_logic_vector(31 downto 0);
--output_d:out std_logic_vector(31 downto 0));
--end component;
--
--component convert_endian
--port(
--a:in std_logic_vector(31 downto 0);
--b:out std_logic_vector(31 downto 0)
--);
--end component;
--
--signal converted_a,converted_b,converted_c,converted_d:std_logic_vector(31 downto 0);
--
--begin
----converted
--c1:convert_endian port map(input(127 downto 96),converted_a);
--c2:convert_endian port map(input(95 downto 64),converted_b);
--c3:convert_endian port map(input(63 downto 32),converted_c);
--c4:convert_endian port map(input(31 downto 0),converted_d);
----insert mux for getting new data or some new info
----cycle:one_cycle_iter_belt_block port map(
----a_input=>converted_a,
----b_input=>converted_b,
----c_input=>converted_c,
----d_input=>converted_d,
----a_input=>key1,
----a_input=>key2,
----a_input=>key3,
----a_input=>key4,
----a_input=>key5,
----a_input=>key6,
----a_input=>key7,
----a_input=>clk,
----a_input=>start,
----a_input=>ready,
----a_input=>output_a,
----a_input=>output_b,
----a_input=>output_c,
----a_input=>output_d);
------ scheme for input again
--
--end cyclic;

--
--start of pipeline block
--
architecture pipeline of belt_block is

component convert_endian
port(
a:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end component;

component one_cycle_iter_belt_block
port(
iteration:std_logic_vector(31 downto 0);
a_input:in std_logic_vector(31 downto 0);
b_input:in std_logic_vector(31 downto 0);
c_input:in std_logic_vector(31 downto 0);
d_input:in std_logic_vector(31 downto 0);
key1:in std_logic_vector(31 downto 0);
key2:in std_logic_vector(31 downto 0);
key3:in std_logic_vector(31 downto 0);
key4:in std_logic_vector(31 downto 0);
key5:in std_logic_vector(31 downto 0);
key6:in std_logic_vector(31 downto 0);
key7:in std_logic_vector(31 downto 0);
clk:in std_logic;
output_a:out std_logic_vector(31 downto 0);
output_b:out std_logic_vector(31 downto 0);
output_c:out std_logic_vector(31 downto 0);
output_d:out std_logic_vector(31 downto 0));
end component;

signal converted_a,converted_b,converted_c,converted_d:std_logic_vector(31 downto 0);

signal iter1_a,iter1_b,iter1_c,iter1_d:std_logic_vector(31 downto 0);
signal iter2_a,iter2_b,iter2_c,iter2_d:std_logic_vector(31 downto 0);
signal iter3_a,iter3_b,iter3_c,iter3_d:std_logic_vector(31 downto 0);
signal iter4_a,iter4_b,iter4_c,iter4_d:std_logic_vector(31 downto 0);
signal iter5_a,iter5_b,iter5_c,iter5_d:std_logic_vector(31 downto 0);
signal iter6_a,iter6_b,iter6_c,iter6_d:std_logic_vector(31 downto 0);
signal iter7_a,iter7_b,iter7_c,iter7_d:std_logic_vector(31 downto 0);
signal iter8_a,iter8_b,iter8_c,iter8_d:std_logic_vector(31 downto 0);

signal key1,key2,key3,key4,key5,key6,key7,key8:std_logic_vector(31 downto 0);
signal output_a,output_b,output_c,output_d:std_logic_vector(31 downto 0);

begin
--convetred input
c1:convert_endian port map(input(127 downto 96),converted_a);
c2:convert_endian port map(input(95 downto 64),converted_b);
c3:convert_endian port map(input(63 downto 32),converted_c);
c4:convert_endian port map(input(31 downto 0),converted_d);
--converted keys
c_key1:convert_endian port map(key(255 downto 224),key1);
c_key2:convert_endian port map(key(223 downto 192),key2);
c_key3:convert_endian port map(key(191 downto 160),key3);
c_key4:convert_endian port map(key(159 downto 128),key4);
c_key5:convert_endian port map(key(127 downto 96),key5);
c_key6:convert_endian port map(key(95 downto 64),key6);
c_key7:convert_endian port map(key(63 downto 32),key7);
c_key8:convert_endian port map(key(31 downto 0),key8);


block1:one_cycle_iter_belt_block port map(x"00000001",converted_a,converted_b,converted_c,converted_d,key1,key2,key3,key4,key5,key6,key7,clk,iter1_a,iter1_b,iter1_c,iter1_d);
block2:one_cycle_iter_belt_block port map(x"00000002",iter1_a,iter1_b,iter1_c,iter1_d,key8,key1,key2,key3,key4,key5,key6,clk,iter2_a,iter2_b,iter2_c,iter2_d);
block3:one_cycle_iter_belt_block port map(x"00000003",iter2_a,iter2_b,iter2_c,iter2_d,key7,key8,key1,key2,key3,key4,key5,clk,iter3_a,iter3_b,iter3_c,iter3_d);
block4:one_cycle_iter_belt_block port map(x"00000004",iter3_a,iter3_b,iter3_c,iter3_d,key6,key7,key8,key1,key2,key3,key4,clk,iter4_a,iter4_b,iter4_c,iter4_d);
block5:one_cycle_iter_belt_block port map(x"00000005",iter4_a,iter4_b,iter4_c,iter4_d,key5,key6,key7,key8,key1,key2,key3,clk,iter5_a,iter5_b,iter5_c,iter5_d);
block6:one_cycle_iter_belt_block port map(x"00000006",iter5_a,iter5_b,iter5_c,iter5_d,key4,key5,key6,key7,key8,key1,key2,clk,iter6_a,iter6_b,iter6_c,iter6_d);
block7:one_cycle_iter_belt_block port map(x"00000007",iter6_a,iter6_b,iter6_c,iter6_d,key3,key4,key5,key6,key7,key8,key1,clk,iter7_a,iter7_b,iter7_c,iter7_d);
block8:one_cycle_iter_belt_block port map(x"00000008",iter7_a,iter7_b,iter7_c,iter7_d,key2,key3,key4,key5,key6,key7,key8,clk,iter8_a,iter8_b,iter8_c,iter8_d);

c5:convert_endian port map(iter8_a,output_a);
c6:convert_endian port map(iter8_b,output_b);
c7:convert_endian port map(iter8_c,output_c);
c8:convert_endian port map(iter8_d,output_d);

output<=output_b&output_d&output_a&output_c;
end pipeline;