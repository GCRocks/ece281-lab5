----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 08:11:58 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_tb is
--  Port ( );
end ALU_tb;

architecture Behavioral of ALU_tb is

component ALU is
    port(
        i_A : in std_logic_vector (7 downto 0);
        i_B : in std_logic_vector (7 downto 0);
        i_op : in std_logic_vector (2 downto 0);
        o_result : out std_logic_vector (7 downto 0);
        o_flags : out std_logic_vector (2 downto 0)
    );
end component ALU;
signal w_A, w_B, w_result : std_logic_vector (7 downto 0);
signal sw : std_logic_vector (2 downto 0);
signal LEDs : std_logic_vector (15 downto 13);

begin

ALU_inst : ALU
    port map(
        i_A => w_A,
        i_B => w_B,
        i_op => sw,
        o_result => w_result,
        o_flags => LEDs
    );
    
	test_process : process 
    begin
    
    w_A <= "00000001"; w_B <= "00000001"; sw <= "000"; wait for 10 ns;
        assert (w_result = "00000010" and LEDs = "000") report "ALU doesn't add properly" severity failure;
    w_A <= "00000000"; w_B <= "00000001"; sw <= "001"; wait for 10 ns;
        --assert (w_result(7) = '1' and LEDs = "001") report "flag doesn't show negative result" severity failure;
    w_A <= "00000001"; w_B <= "00000001"; sw <= "001"; wait for 10 ns;
        --assert (w_result = x"0" and LEDs = x"0") report "flag doesn't show negative result" severity failure;
    w_A <= "10000000"; w_B <= "10000000"; sw <= "000";  wait for 10 ns;
        --assert (w_result = x"0" and LEDs = x"3") report "flag doesn't show carry out" severity failure; 
    w_A <= "00000001"; w_B <= "00000000"; sw <= "010"; wait for 10 ns;
        --assert (w_result = x"0" and LEDs = x"0") report "error with and operation" severity failure;
    w_A <= "00000001"; w_B <= "00000000"; sw <= "011"; wait for 10 ns;
        --assert (w_result = x"1" and LEDs = x"0") report "error with or operation" severity failure; 
    w_A <= "00000001"; w_B <= "00000001"; sw <= "100"; wait for 10 ns;
        --assert (w_result <= x"2" and LEDs = x"0") report "error with left logical shift" severity failure;
    w_A <= "00000010"; w_B <= "00000001"; sw <= "101"; wait for 10 ns;
        --assert (w_result <= x"1" and LEDs <= x"0") report "error with right logical shift" severity failure; 
           
            wait;
    end process;    


end Behavioral;
