library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--write a test for one cycle

entity one_cycle_iter_belt_block is
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
end one_cycle_iter_belt_block;

architecture beh of one_cycle_iter_belt_block is

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

component Gblock
port(
    a:in std_logic_vector(31 downto 0);
    shift:in std_logic_vector(4 downto 0);
    clk:in std_logic; 
    b:out std_logic_vector(31 downto 0));
end component;


signal a,b,c,d:std_logic_vector(31 downto 0);
signal a1_out,b1,c1_out,d1_out:std_logic_vector(31 downto 0);
signal a2_out,b2_out,c2,d2_out:std_logic_vector(31 downto 0);
signal a3,b3_out,c3_out,d3_out:std_logic_vector(31 downto 0);
signal a4_out,b4_out,c4_out,d4_out,e:std_logic_vector(31 downto 0);
signal a5_out,b5_out,b5,c5_out,c5,d5_out:std_logic_vector(31 downto 0);
signal a6_out,b6_out,c6_out,d6:std_logic_vector(31 downto 0);
signal a7_out,b7,c7_out,d7_out:std_logic_vector(31 downto 0);
signal a8_out,b8_out,c8,d8_out:std_logic_vector(31 downto 0);
signal outputG1,outputG2,outputG3,outputG4,outputG5,outputG6,outputG7:std_logic_vector(31 downto 0);
signal temp_sum_1,temp_sum_2,temp_sum_3,temp_sum_4,temp_sum_5,temp_sum_6,temp_sum_7:std_logic_vector(31 downto 0);


begin

reg_a:reg generic map(32) port map(a_input,clk,a);
reg_b:reg generic map(32) port map(b_input,clk,b);
reg_c:reg generic map(32) port map(c_input,clk,c);
reg_d:reg generic map(32) port map(d_input,clk,d);

temp_sum_1 <= a + key1;
Gblock1:Gblock port map(temp_sum_1,"00101",clk,outputG1);
b1 <= b xor outputG1;--b
reg_a1:reg generic map(32) port map(a,clk,a1_out);
reg_c1:reg generic map(32) port map(c,clk,c1_out);
reg_d1:reg generic map(32) port map(d,clk,d1_out);

temp_sum_2 <= d1_out + key2;
Gblock2:Gblock port map(temp_sum_2,"10101",clk,outputG2);
c2 <= c1_out xor outputG2;--c
reg_a2:reg generic map(32) port map(a1_out,clk,a2_out);
reg_b2:reg generic map(32) port map(b1,clk,b2_out);
reg_d2:reg generic map(32) port map(d1_out,clk,d2_out);

temp_sum_3 <= b2_out + key3;
Gblock3:Gblock port map(temp_sum_3,"01101",clk,outputG3);
a3 <= a2_out - outputG3; --a
reg_b3:reg generic map(32) port map(b2_out,clk,b3_out);
reg_c3:reg generic map(32) port map(c2,clk,c3_out);
reg_d3:reg generic map(32) port map(d2_out,clk,d3_out);

temp_sum_4 <= b3_out + c3_out + key4;
Gblock4:Gblock port map(temp_sum_4,"10101",clk,outputG4);
e <= outputG4 xor iteration; --e -- change for number of iteration
reg_a4:reg generic map(32) port map(a3,clk,a4_out);
reg_b4:reg generic map(32) port map(b3_out,clk,b4_out);
reg_c4:reg generic map(32) port map(c3_out,clk,c4_out);
reg_d4:reg generic map(32) port map(d3_out,clk,d4_out);

b5 <= b4_out + e;
c5 <= c4_out - e;

reg_a5:reg generic map(32) port map(a4_out,clk,a5_out);
reg_b5:reg generic map(32) port map(b5,clk,b5_out);
reg_c5:reg generic map(32) port map(c5,clk,c5_out);
reg_d5:reg generic map(32) port map(d4_out,clk,d5_out);

temp_sum_5 <= c5_out + key5;
Gblock5:Gblock port map(temp_sum_5,"01101",clk,outputG5);
d6 <= d5_out + outputG5;
reg_a6:reg generic map(32) port map(a5_out,clk,a6_out);
reg_b6:reg generic map(32) port map(b5_out,clk,b6_out);
reg_c6:reg generic map(32) port map(c5_out,clk,c6_out);

temp_sum_6 <= a6_out + key6;
Gblock6:Gblock port map(temp_sum_6,"10101",clk,outputG6);
b7 <= b6_out xor outputG6;
reg_a7:reg generic map(32) port map(a6_out,clk,a7_out);
reg_c7:reg generic map(32) port map(c6_out,clk,c7_out);
reg_d7:reg generic map(32) port map(d6,clk,d7_out);

temp_sum_7 <= d7_out + key7;
Gblock7:Gblock port map(temp_sum_7,"00101",clk,outputG7);
c8 <= c7_out xor outputG7;
reg_a8:reg generic map(32) port map(a7_out,clk,a8_out);
reg_b8:reg generic map(32) port map(b7,clk,b8_out);
reg_d8:reg generic map(32) port map(d7_out,clk,d8_out);

output_a <= b8_out;
output_b <= d8_out;
output_c <= a8_out;
output_d <= c8;

end beh;
