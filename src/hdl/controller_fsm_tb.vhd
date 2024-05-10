----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 02:24:00 PM
-- Design Name: 
-- Module Name: controller_fsm_tb - Behavioral
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

entity controller_fsm_tb is
end controller_fsm_tb;

architecture Behavioral of controller_fsm_tb is

component controller_fsm is    

    Port ( 
       i_reset   : in  STD_LOGIC;
       i_adv    : in  STD_LOGIC;
       o_cycle   : out STD_LOGIC_VECTOR (3 downto 0);
       led : out std_logic_vector (3 downto 0)            
     );
end component controller_fsm;

signal btnU : std_logic;
signal btnC : std_logic;
signal w_cycle : std_logic_vector (3 downto 0);
signal LEDs : std_logic_vector (3 downto 0);

begin


controller_fsm_inst : controller_fsm
    port map ( 
        i_reset => btnU,
        i_adv => btnC,
        o_cycle => w_cycle,
        led => LEDs         
     );
     
     
	test_process : process 
    begin
    
        btnU <= '1'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0001" report "error on reset" severity failure;
        btnC <= '0'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0001" report "error staying at x1" severity failure;
        btnC <= '1'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0010" report "error going to x2" severity failure; 
        btnC <= '0'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0010" report "error staying at x2" severity failure;
        btnC <= '1'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0100" report "error going to x3" severity failure; 
        btnC <= '0'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0100" report "error staying at x3" severity failure;
        btnC <= '1'; wait for 10 ns;
            assert (w_cycle and LEDs) = "1000" report "error going to x4" severity failure; 
        btnC <= '0'; wait for 10 ns;
            assert (w_cycle and LEDs) = "1000" report "error staying at x4" severity failure;
        btnC <= '1'; wait for 10 ns;
            assert (w_cycle and LEDs) = "0001" report "error going to x1" severity failure; 

            wait;
    end process;
        
end Behavioral;
