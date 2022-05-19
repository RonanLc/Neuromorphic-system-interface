library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Top is
generic(
    constant TARGET_AMOUNT : positive := 10
);
port (
    clk : in std_logic;
    reset   : in std_logic;

    tx : out std_logic;
    rx : in std_logic;

    SPI_sclk : out std_logic;
    SPI_cs : out std_logic;
    SPI_mosi : out std_logic;
    SPI_miso : in std_logic;
    iWr : out std_logic;

    led1        : out std_logic := '0';
    led2        : out std_logic := '0';

    dread : out std_logic_vector(7 downto 0);
    
    Strl_Adrs : out std_logic_vector(11 downto 0);
    Strl_Sel : out std_logic_vector(3 downto 0);
    Strl_Strb : out std_logic;
    Strl_Clr : out std_logic;
    Strl_D : out std_logic
);
end Top;

architecture Behavioral of Top is

    signal clk_200MHz : std_logic;
    signal t_reset : std_logic;
    signal target_select : std_logic_vector(TARGET_AMOUNT-1 downto 0);
    
    signal reg_requirements_read : std_logic_vector(7 downto 0);
    signal reg_requirements_write : std_logic_vector(7 downto 0);
    signal register_write: std_logic_vector(7 downto 0);
    signal register_read : std_logic_vector(7 downto 0);
    signal write_enable : std_logic;
    -- signal module_select : std_logic_vector(1 downto 0);

    signal test : std_logic_vector(7 downto 0);
    

begin

----------------------------------------------------------------------------------
Command_processor: entity work.Command_processor
    generic map(
        MODULE_NAME_LENGTH => 5,
        MODULE_BEHAVIOUR_LENGTH => 5,
        NUMBER_OF_TARGETS => TARGET_AMOUNT
    )
    port map(
        clk => clk,
        reset => reset,
        tx => tx,
        rx => rx, 
        t_clk_200Meg => clk_200MHz,
        t_reset => t_reset,
        target_select => target_select,
        reg_requirements_write => reg_requirements_write,
        reg_requirements_read => reg_requirements_read,
        register_read => register_read,
        register_write => register_write,
        write_enable => write_enable,
        test => test,
        led1 => led1
        -- led2 => led2
    );

SPIx_0 : entity work.SPIx_state_machine
    generic map (
        CLOCK_FREQUENCY => 1,
        DELAY_SPI_COM => 300
    )
    port map (
        clk => clk_200MHz,
        reset => t_reset,
        target_is_selected => target_select(0),
        reg_requirements_write => reg_requirements_write,
        reg_requirements_read => reg_requirements_read,
        register_read => register_read,
        register_write => register_write,
        write_enable => write_enable,
        iWr => iWr,
        SPI_sclk => SPI_sclk,
        SPI_cs => SPI_cs,
        SPI_mosi => SPI_mosi,
        SPI_miso => SPI_miso,
        test => test,
--        led1 => led1
        led2 => led2
    );

 Strl_inst : entity work.Strl
   generic map (
     N => 12,
     M => 4,
     MAX_SYNAPSES => 2,
     MAX_FRAMES => 4
   )
   port map (
     clk => clk_200MHz,
     reset => reset,
     Strl_is_selected => target_select(2),
     reg_requirements_write => reg_requirements_write,
     reg_requirements_read => reg_requirements_read,
     register_read => register_read,
     register_write => register_write,
     write_enable => write_enable,
     Adrs => Strl_Adrs,
     Sel => Strl_Sel,
     Strb => Strl_Strb,
     Clr => Strl_Clr,
     D => Strl_D
   );


end Behavioral;