LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX8_1 IS
	PORT(A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 S : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Y : OUT STD_LOGIC);
END MUX8_1;

ARCHITECTURE ARCH OF MUX8_1 IS
BEGIN
	WITH S SELECT
	Y <= A(0) WHEN "000",
		 A(1) WHEN "001",
		 A(2) WHEN "010",
		 A(3) WHEN "011",
		 A(4) WHEN "100",
		 A(5) WHEN "101",
		 A(6) WHEN "110",
		 A(7) WHEN OTHERS;
END ARCH;