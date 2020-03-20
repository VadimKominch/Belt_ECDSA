library ieee;
use ieee.std_logic_1164.all;

entity convert_endian is
port(
a:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end convert_endian;

architecture beh of convert_endian is

begin
  b(31 downto 24)<=a(7 downto 0);
  b(23 downto 16)<=a(15 downto 8);
  b(15 downto 8)<=a(23 downto 16);
  b(7 downto 0)<=a(31 downto 24);
end beh;
