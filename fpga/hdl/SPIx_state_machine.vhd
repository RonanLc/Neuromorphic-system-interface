library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity SPIx_state_machine is
generic(
    CLOCK_FREQUENCY : integer range 1 to 50;	-- Clock frequency MHz
    constant DELAY_SPI_COM : positive -- time between two SPI communications in microseconds
);
port (
    clk : in std_logic;
    reset   : in std_logic;
    
    target_is_selected : in std_logic;
    
    reg_requirements_write : in std_logic_vector(7 downto 0);
    reg_requirements_read : in std_logic_vector(7 downto 0);
    register_read : out std_logic_vector(7 downto 0) := (others => 'Z');
    register_write : in std_logic_vector(7 downto 0);
    write_enable : in std_logic;
    -- module_select : in std_logic_vector(1 downto 0);

    iWr : out std_logic := '0';

    -- SPI standard type 2 -- 
    SPI_sclk 	: out std_logic;
    SPI_cs 		: out std_logic;
    SPI_mosi	: out std_logic;
    SPI_miso	: in std_logic;

    test : out std_logic_vector(7 downto 0);
    -- led1 : out std_logic := '0';
    led2 : out std_logic := '0'
);
end SPIx_state_machine;

architecture Behavioral of SPIx_state_machine is

    -- Clock
    signal SPI_clk : std_logic := '0';
    signal clock_speed : integer;
    signal clock_divider : std_logic_vector(5 downto 0) := "110010";
    signal clk_100MHz : std_logic := '0';
    
    -- Registers for the state machine
    type state is (IDLE, READ_SPIx_to_COMMAND_PROCESSOR, WRITE_COMMAND_PROCESSOR_to_SPIx, SPI_WRITE, iWr_STATE, SPI_READ);
    signal state_machine : state := IDLE; 
    signal FIFO_number_of_lower_bits : std_logic_vector(7 downto 0);
    signal FIFO_number_of_upper_bits : std_logic_vector(7 downto 0);
    signal data_to_read : std_logic_vector(7 downto 0) := (others => 'Z');
    
    -- SPI transmission interface
    signal SPI_enable : std_logic;
    signal SPI_data_tx : std_logic_vector(7 downto 0);
    signal SPI_data_rx : std_logic_vector(7 downto 0);
    signal previous_cs : std_logic := '1';
    signal SPI_acq : std_logic;
    
    -- FIFO in interface
    signal FIFO_in_WriteEn : std_logic := '0';
    signal FIFO_in_DataIn : std_logic_vector(7 downto 0) := (others => 'Z');
    signal FIFO_in_ReadEn : std_logic := '0';
    signal FIFO_in_DataOut : std_logic_vector(7 downto 0);
    signal FIFO_in_Empty : std_logic;
    signal FIFO_in_Full : std_logic;
    signal FIFO_in_counter : std_logic := '0';
    
    -- FIFO out interface
    signal FIFO_out_WriteEn : std_logic := '0';
    signal FIFO_out_DataIn : std_logic_vector(7 downto 0);
    signal FIFO_out_ReadEn : std_logic := '0';
    signal FIFO_out_DataOut : std_logic_vector(7 downto 0);
    signal FIFO_out_Empty : std_logic;
    signal FIFO_out_Full : std_logic;
    signal FIFO_out_counter : std_logic := '0';
    
    signal buffer_length : integer := 0;
    
    shared variable number_data_read : integer := 0;
    
    signal counter_a_supp : std_logic_vector(7 downto 0) := (others => '0');
    signal counter : integer := 0;

    signal instruction : std_logic_vector(2 downto 0) := "ZZZ";
    signal FIFO_memory : std_logic_vector(15 downto 0);
    signal spix_to_command : std_logic;
    signal stop_rx : std_logic;
    signal iWr_counter : std_logic_vector(6 downto 0) := "0000001";

    signal is_treated : std_logic := '0'; 
    signal data_counter : integer := 0;

    signal register_adress_i : integer := 0;
    signal reg_adress_write : integer := 0;
    signal reg_adress_read : integer := 0;

    signal iWr_counter_i : integer := 1;
    signal loop_counter : integer := 0; 
    signal stop_iWr : std_logic := '0';
    signal memory_needed : std_logic_vector(15 downto 0) := (others => '0');

    signal iWr_counter_register : std_logic_vector(7 downto 0) := (iWr_counter(0), iWr_counter(1), iWr_counter(2), iWr_counter(3), iWr_counter(4), iWr_counter(5), iWr_counter(6), stop_iWr);
    signal command_register : std_logic_vector(7 downto 0) := (spix_to_command, FIFO_out_Empty, FIFO_out_Full, FIFO_in_Empty, FIFO_in_Full, instruction(0), instruction(1), instruction(2));
    signal clock_divider_register : std_logic_vector(7 downto 0) := ('0', '0', clock_divider(0), clock_divider(1), clock_divider(2), clock_divider(3), clock_divider(4), clock_divider(5));

    -- Register map
    type register_map_type is array (0 to 5) of std_logic_vector(7 downto 0); -- D?claration d'un type tableau
    signal register_map : register_map_type := (data_to_read, command_register, memory_needed(7 downto 0), memory_needed(15 downto 8), clock_divider_register,  iWr_counter_register); 
    signal Command : std_logic_vector(7 downto 0);
    signal clock_register : std_logic_vector(7 downto 0);
    signal data_register : std_logic_vector(7 downto 0);
    signal number_data_read_buffer : std_logic_vector(15 downto 0);

    signal debug1 : std_logic := '0';
    signal debug2 : std_logic := '0';

begin

    test <= std_logic_vector(to_unsigned(buffer_length,8));
    -- led1 <= debug1;
    -- led2 <= debug2;
    led2 <= '1' when state_machine = IDLE;

    -- Register map -------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------

    clk100: process (clk)
    begin
        if(rising_edge(clk)) then
            clk_100MHz <= not(clk_100MHz);
        end if;
    end process;

    iWr_counter <= register_map(5)(6 downto 0);
    clock_divider(5 downto 0) <= register_map(4)(5 downto 0);
    instruction <= register_map(1)(7 downto 5);
    memory_needed(7 downto 0) <= register_map(2);
    memory_needed(15 downto 8) <= register_map(3);

    reg_adress_read <= to_integer(unsigned(reg_requirements_read(6 downto 0)));
    reg_adress_write <= to_integer(unsigned(reg_requirements_write));
    register_read <= register_map(reg_adress_read) when (target_is_selected = '1') else (others => 'Z');
    
    regiter_process: process (clk_100MHz)
    begin
        if(rising_edge(clk_100MHz)) then
            if(reg_requirements_write = x"00") then
               register_map(0) <= register_write;
            else
                register_map(0) <= data_to_read;
            end if;

            register_map(1)(0) <= spix_to_command;
            register_map(1)(1) <= FIFO_out_Empty; 
            register_map(1)(2) <= FIFO_out_Full; 
            register_map(1)(3) <= FIFO_in_Empty;
            register_map(1)(4) <= FIFO_in_Full;
            register_map(1)(7 downto 5) <= instruction;
            register_map(2) <= memory_needed(7 downto 0); -- Compteur du nombre de bits dans le read register (sur 16 bits)
            register_map(3) <= memory_needed(15 downto 8); -- Fin du compteur
            register_map(4)(7 downto 6) <= "00";
            register_map(4)(5 downto 0) <= clock_divider(5 downto 0);
            register_map(5)(6 downto 0) <= iWr_counter;
            register_map(5)(7) <= stop_iWr;

            if(target_is_selected = '1' and write_enable = '1') then          
                if(reg_adress_write = 2 or reg_adress_write = 3 or reg_adress_write = 5) then
                    register_map(reg_adress_write) <= register_write;
                elsif(reg_adress_write = 1) then
                    register_map(reg_adress_write)(7 downto 5) <= register_write(7 downto 5);
                elsif(reg_adress_write = 4) then
                    register_map(reg_adress_write)(5 downto 0) <= register_write(5 downto 0);
                end if;
            end if;
        end if;

    end process;

    -- State machine ------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------
    
    fsm: process(clk_100MHz)
        variable rising_edge_acq : integer range 0 to 1 := 1;
        
        variable rising_edge_stop_tx : integer range 0 to 1 := 0;
        variable rising_edge_stop_rx : integer range 0 to 1 := 0;
        variable clk_counter : integer := 0;
        variable FIFO_counter : integer := 0;
    begin
        if rising_edge(clk_100MHz) then
            number_data_read_buffer <= std_logic_vector(to_unsigned(number_data_read, 16));
            case state_machine is
                when IDLE => -- Receipt of commands from the command processor
                    
                    buffer_length <= to_integer(unsigned(memory_needed));
                    -- buffer_length <= 10;
                    SPI_enable <= '0';
                    FIFO_out_ReadEn <= '0';
                    stop_iWr <= '0';
                    loop_counter <= 0;
                    counter <= 0;
                    data_counter <= 0;
                    spix_to_command <= '0';
                    if(target_is_selected = '1') then
                        if(instruction = "001") then
                            state_machine <= iWr_STATE;
                        elsif(instruction = "010" and reg_requirements_write = x"00") then
                    --    elsif (instruction = "010") then
                           state_machine <= WRITE_COMMAND_PROCESSOR_to_SPIx;
                           
                           debug2 <= not(debug2);
                        elsif(instruction = "100") then
                            state_machine <= SPI_READ;
                        end if;
                    end if;

                when WRITE_COMMAND_PROCESSOR_to_SPIx => -- Je remplis la FIFO
                    
                    if(reg_requirements_write = x"00") then
                        spix_to_command <= '1'; 
                    end if;

                    if(data_counter = buffer_length+1) then
                        FIFO_in_WriteEn <= '0';
                        state_machine <= SPI_WRITE;
                        spix_to_command <= '0';
                        -- data_counter <= 0;
                        FIFO_in_ReadEn <= '1';
                        debug1 <= not(debug1);
                    else
                        if(spix_to_command = '1') then
                            FIFO_in_DataIn <= register_write;
                            FIFO_in_WriteEn <= '1';
                            data_counter <= data_counter+1;
                        end if;
                    end if;

                when SPI_WRITE => -- Je vide la FIFO dans le SPI
                    
                    FIFO_in_WriteEn <= '0';
                    if (FIFO_in_Empty = '0') then
                        SPI_enable <= '1';
                        SPI_data_tx <= FIFO_in_DataOut;
                        
                        -- Writing the data should be enable when the SPI is ready to send
                        if((SPI_acq = '1') and (rising_edge_acq = 0)) then
                            FIFO_in_ReadEn <= '1';
                            rising_edge_acq := 1;
                            
                        elsif (SPI_acq = '0') then
                            rising_edge_acq := 0;
                            FIFO_in_ReadEn <= '0';
                        else
                            FIFO_in_ReadEn <= '0';
                        end if;
                        
                    else
                        state_machine <= IDLE;
                        SPI_enable <= '0';
                    end if;
                
                when iWr_STATE =>
                    iWr_counter_i <= to_integer(unsigned(iWr_counter(6 downto 0)));

                    if(iWr_counter_i > loop_counter) then
                        iWr <= '1';
                        loop_counter <= loop_counter+1;
                        stop_iWr <= '0';
                    else
                        state_machine <= IDLE;
                        iWr <= '0';
                        stop_iWr <= '1';
                    end if;
            
                when SPI_READ => -- Writing in the buffer until it is full
                    
                    FIFO_out_ReadEn <= '0';                    
                    -- if ( FIFO_out_Full = '0') then
                    if(counter < buffer_length) then

                        SPI_enable <= '1';
                        FIFO_out_DataIn <= SPI_data_rx;
                        
                        -- Reading the data should be enable when the SPI is ready to send
                        if((SPI_acq = '0') and (rising_edge_acq = 0)) then
                            FIFO_out_WriteEn <= '1';
                            counter <= counter + 1;
                            rising_edge_acq := 1;
                            number_data_read := number_data_read + 1;
                        elsif (SPI_acq = '1') then
                            rising_edge_acq := 0;
                            FIFO_out_WriteEn <= '0';
                        else
                            FIFO_out_WriteEn <= '0';
                        end if;
                    else
                        state_machine <= READ_SPIx_to_COMMAND_PROCESSOR;
                        FIFO_out_WriteEn <= '0';
                        FIFO_out_ReadEn <= '1';
                    end if;
                    
                when READ_SPIx_to_COMMAND_PROCESSOR =>
                    -- FIFO out
                    spix_to_command <= '1'; 

                    if(is_treated = '0') then
                        is_treated <= '1';
                    else
                        Data_to_read <= FIFO_out_DataOut;
                        if (FIFO_out_Empty = '1') then
                            state_machine <= IDLE;
                            
                        end if;
                    end if;
                    
            end case;
        end if;
    end process;


    desired_clk: process(clk_100MHz)
        variable clock_divider_var : integer := 0;
        variable clock_coefficient : integer;
    begin
        if(rising_edge(clk_100MHz)) then

            -- Generate the clock for the SPI module
            clock_coefficient := to_integer(unsigned(clock_divider));
            if(clock_divider_var = clock_coefficient) then
                clock_divider_var := 0;
                SPI_clk <= not(SPI_clk);
            else
                clock_divider_var := clock_divider_var + 1;
            end if;
            
            -- -- Retrieve the exact frequency
             clock_speed <= 100/(2*clock_coefficient);
        end if;
    end process;

-------------------------------------------------------------------------------------

  SPI: entity work.SPI
  generic map (
    DATA_LENGTH => 8,
    DELAY_SPI => DELAY_SPI_COM
  )
    port map (
    clk => SPI_clk,
    clk_frequency => clock_speed,
    reset => reset,
    enable => SPI_enable,
    CPOL => '0',
    CPHA => '0',
    acq => SPI_acq,
    data_tx => SPI_data_tx,
    data_rx => SPI_data_rx,
    sclk => SPI_sclk,
    cs => SPI_cs,
    mosi => SPI_mosi,
    miso => SPI_miso
  );
  

INSA_FIFO_1: entity work.STD_FIFO
generic map( 
  DATA_WIDTH => 8,
  MAX_FIFO_DEPTH => 20
--    FIFO_DEPTH => 100
)
port map(
  CLK     => clk_100MHz,
  RST     => reset,
  Length  => buffer_length,
  WriteEn => FIFO_in_WriteEn,
  DataIn  => FIFO_in_DataIn,
  ReadEn  => FIFO_in_ReadEn,
  DataOut => FIFO_in_DataOut,
  Empty   => FIFO_in_Empty,
  Full    => FIFO_in_Full
);

INSA_FIFO_2: entity work.STD_FIFO
generic map( 
  DATA_WIDTH => 8,
  MAX_FIFO_DEPTH => 20
--    FIFO_DEPTH => 100
)
port map(
  CLK     => clk_100MHz,
  RST     => reset,
  Length  => buffer_length,
  WriteEn => FIFO_out_WriteEn,
  DataIn  => FIFO_out_DataIn,
  ReadEn  => FIFO_out_ReadEn,
  DataOut => FIFO_out_DataOut,
  Empty   => FIFO_out_Empty,
  Full    => FIFO_out_Full
);
  

end Behavioral;