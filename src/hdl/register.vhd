----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2024 03:13:36 PM
-- Design Name: 
-- Module Name: register - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    Port ( 
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_data : in std_logic_vector (7 downto 0);
        o_data : out std_logic_vector (7 downto 0)
    );
end reg;

architecture Behavioral of reg is

begin

load_num : process(i_clk, i_reset)
begin
    if i_reset = '1' then
        o_data <= "00000000";
    elsif rising_edge(i_clk) then
        o_data <= i_data;
    end if;
end process load_num;

end Behavioral;
