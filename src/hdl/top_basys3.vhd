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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_basys3 is
    port(
    -- inputs
    clk     :   in std_logic; -- native 100MHz FPGA clock
    sw      :   in std_logic_vector(7 downto 0);
    btnU    :   in std_logic; -- i_reset controller_fsm
    btnC    :   in std_logic; -- i_adv controller_fsm
    
    -- outputs
    led :   out std_logic_vector(15 downto 0);
    -- 7-segment display segments (active-low cathodes)
    seg :   out std_logic_vector(6 downto 0);
    -- 7-segment display active-low enables (anodes)
    an  :   out std_logic_vector(3 downto 0)        
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
component TDM4 is
	generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    Port ( i_clk        : in  STD_LOGIC;
           i_reset        : in  STD_LOGIC; -- asynchronous
           i_sign         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
           i_hund         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
           i_tens         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
           i_ones         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
           o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
           o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
    );
end component TDM4; 
signal TDM_num : std_logic_vector (3 downto 0); 

component controller_fsm is
    Port ( i_reset   : in  STD_LOGIC;
           i_adv    : in  STD_LOGIC;
           o_cycle   : out STD_LOGIC_VECTOR (3 downto 0);
           led : out std_logic_vector (3 downto 0)            
         );
end component controller_fsm;  
signal w_cycle: std_logic_vector (3 downto 0); 

component ALU is
    port(
    i_A : in std_logic_vector (7 downto 0);
    i_B : in std_logic_vector (7 downto 0);
    i_op : in std_logic_vector (2 downto 0);
    o_result : out std_logic_vector (7 downto 0);
    o_flags : out std_logic_vector (2 downto 0)
);
end component ALU;
signal w_result : std_logic_vector (7 downto 0);
signal w_num : std_logic_vector (7 downto 0);

component clk_div is
	generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles
                                           -- Effectively, you divide the clk double this 
                                           -- number (e.g., k_DIV := 2 --> clock divider of 4)
    port (  i_clk    : in std_logic;
            i_reset  : in std_logic;           -- asynchronous
            o_clk    : out std_logic           -- divided (slow) clock
        );
end component clk_div;

component twoscomp_decimal is
    port (
    i_binary: in std_logic_vector(7 downto 0);
    o_negative: out std_logic;
    o_hundreds: out std_logic_vector(3 downto 0);
    o_tens: out std_logic_vector(3 downto 0);
    o_ones: out std_logic_vector(3 downto 0)
);
end component twoscomp_decimal;
signal w_ones : std_logic_vector (3 downto 0);
signal w_tens : std_logic_vector (3 downto 0);
signal w_hund : std_logic_vector (3 downto 0);
signal w_sign : std_logic;

component sevenSegDecoder is
      port(
         i_neg : in std_logic;
         i_D : in std_logic_vector (3 downto 0);
         o_S : out std_logic_vector (6 downto 0)
      ); 
end component sevenSegDecoder;

component reg is
    Port ( 
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_data : in std_logic_vector (7 downto 0);
        o_data : out std_logic_vector (7 downto 0)
    );
end component reg;
signal w_A, w_B : std_logic_vector (7 downto 0);

component clock_divider is
	generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles
											   -- Effectively, you divide the clk double this 
											   -- number (e.g., k_DIV := 2 --> clock divider of 4)
	port ( 	i_clk    : in std_logic;
			i_reset  : in std_logic;		   -- asynchronous
			o_clk    : out std_logic		   -- divided (slow) clock
	);
end component clock_divider;
signal w_clk : std_logic;
  
begin
	-- PORT MAPS ----------------------------------------

sevenSegDecoder_inst: sevenSegDecoder
    port map(
       i_neg => w_sign,
       i_D => TDM_num,
       o_S => seg
    );	
    
controller_inst : controller_fsm
    port map(
        i_reset => btnU,
        i_adv => btnC,
        o_cycle => w_cycle,
        led => led(3 downto 0)
    );
--an <= o_sel;

clock_divider_inst : clock_divider
    port map(
       i_clk => clk,
       i_reset => btnU,
       o_clk => w_clk
    );
TDM_inst : TDM4
    port map ( 
       i_clk => w_clk,
       i_reset => btnU,
       i_sign => w_sign,
       i_hund => w_hund,
       i_tens => w_tens,
       i_ones => w_ones,
       o_data => TDM_num,
       o_sel => an (3 downto 0)
    );	
ALU_inst : ALU
    port map(
        i_A => w_A,
        i_B => w_B,
        i_op => sw (2 downto 0),
        o_result => w_result,
        o_flags => led (15 downto 13)
    );
    
twoscomp_decimal_inst : twoscomp_decimal
        port map (
            i_binary => w_num,
            o_negative => w_sign,
            o_hundreds => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
        );

regA : reg
    port map(
        i_clk => w_cycle(0),
        i_reset => btnU,
        i_data => sw (7 downto 0),
        o_data => w_A      
    );
    
regB : reg
    port map(
        i_clk => w_cycle(1),
        i_reset => btnU,
        i_data => sw (7 downto 0),
        o_data => w_B      
    );
	
	
	-- CONCURRENT STATEMENTS ----------------------------

led(12 downto 4) <= "000000000";	
	
	
end top_basys3_arch;
