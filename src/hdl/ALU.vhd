--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    port(
        i_A : in std_logic_vector (7 downto 0);
        i_B : in std_logic_vector (7 downto 0);
        i_op : in std_logic_vector (2 downto 0);
        o_result : out std_logic_vector (7 downto 0);
        o_flags : out std_logic_vector (2 downto 0)
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
component halfAdder is 
	port(
	    i_A     : in  std_logic; -- 1-bit input port
        i_B     : in  std_logic;
        o_Cout  : out std_logic;  
        o_S     : out std_logic  -- 1-bit output port
	);
end component halfAdder;
    
component TDM4 is
    port(
    
    );
end component TDM4;
  
begin
	-- PORT MAPS ----------------------------------------
    
    o_result <= i_A xor i_B when (i_op = x"0"); --add when i_op is 0
    o_result <= i_A xor not i_B when (i_op = x"1"); --subtract when i_op is 1
    o_result <= i_A and i_B when (i_op = x"2"); --AND when i_op is 2
    o_result <= i_A or i_B when (i_op = x"3"); --OR when i_op is 3
    --o_result <= i_A<<i_B when (i_op = x"4"); --left shift when i_op is 4
    --o_result <= i_A>>i_B when (i_op = x"5"); -- right shift when i_op is 5
    
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end behavioral;
