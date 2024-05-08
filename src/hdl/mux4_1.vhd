----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2024 12:11:40 PM
-- Design Name: 
-- Module Name: mux4_1 - Behavioral
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

entity mux4_1 is
    port ( 
        i_D0 : in std_logic_vector (3 downto 0);
        i_D1 : in std_logic_vector (7 downto 0);
        i_D2 : in std_logic_vector (7 downto 0);
        i_D3 : in std_logic_vector (7 downto 0);
        f : out std_logic_vector (7 downto 0)
    );
end mux4_1;

architecture Behavioral of mux4_1 is

--signal f_sel : unsigned(1 downto 0) := "00";

begin
    f <= i_D1 when i_D0 = "0010" else
         i_D3 when i_D0 = "0100" else
         i_D3 when i_D0 = "1000";
          


end Behavioral;
