library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Command_processor is
generic(
    constant MODULE_NAME_LENGTH : positive;
    constant MODULE_BEHAVIOUR_LENGTH : positive;
    constant NUMBER_OF_TARGETS : positive
);
port (
    clk     : in std_logic;
    reset   : in std_logic;
    
    tx : out std_logic;
    rx : in std_logic;
    
    t_clk_200Meg : out std_logic;
    t_reset : out std_logic;
    target_select : out std_logic_vector(NUMBER_OF_TARGETS-1 downto 0) := (others => '0');

    reg_requirements_write : out std_logic_vector(7 downto 0) := (others => '1');
    reg_requirements_read : out std_logic_vector(7 downto 0) := (others => 'Z');
    register_read : in std_logic_vector(7 downto 0);
    register_write : out std_logic_vector(7 downto 0) := (others => 'Z');
    -- module_select : out std_logic_vector(1 downto 0) := "00"; -- '10' to write to SPIx and '01' to write to STrI
    write_enable : out std_logic := '0';

    test : in std_logic_vector(7 downto 0);
    led1 : out std_logic := '0'
    -- led2 : out std_logic := '0'
);
end Command_processor;

architecture Behavioral of Command_processor is

    -- Clock
    signal clk_100Meg : std_logic:='0';
    signal clk_200Meg : std_logic;
    signal clk_400Meg : std_logic;
    signal IP_locked  : std_logic;
    
    -- UART reception
    signal UART_tr_en_tx : std_logic := '0';
    signal UART_tr_tx_data : std_logic_vector(7 downto 0) := x"00";
    signal UART_tr_stop_tx : std_logic;
    
    -- UART transmission
    signal UART_re_dat : std_logic_vector(7 downto 0);
    signal UART_re_dat_en : std_logic;

    -- UART transmission FIFO
    signal FIFO_tr_WriteEn : std_logic := '0';
    signal FIFO_tr_DataIn : std_logic_vector(7 downto 0);
    signal FIFO_tr_ReadEn : std_logic := '0';
    signal FIFO_tr_DataOut : std_logic_vector(7 downto 0);
    signal FIFO_tr_Empty : std_logic;
    signal FIFO_tr_Full : std_logic;
    signal FIFO_tr_length : integer := 5;

    -- UART reception FIFO
    signal FIFO_re_WriteEn : std_logic;
    signal FIFO_re_DataIn : std_logic_vector(7 downto 0);
    signal FIFO_re_ReadEn : std_logic;
    signal FIFO_re_DataOut : std_logic_vector(7 downto 0);
    signal FIFO_re_Empty : std_logic;
    signal FIFO_re_Full : std_logic;
    signal FIFO_re_length : integer := 0;
    
    component clk_wiz_1
    port (
        clk_out1 : out std_logic;
        reset : in std_logic;
        locked : out std_logic;
        clk_in1 : in std_logic
    );
    end component;
   
    -- State machine
    type state is (IDLE, MODULE_NAME, MODULE_NUMBER, MODULE_BEHAVIOUR, MEMORY_NEEDED, STATUS_REGISTER_NUMBER_OF_BITS, STATUS_REGISTER_ADRESS, STATUS_REGISTER_DATA_WRITE, ACKNOLEDGE, SYNTAX_ERROR, TARGET_CONFIGURATION);
    signal state_machine : state := IDLE;
    type read_state is (READ_IDLE, READ_MEMORY_LOWER, READ_MEMORY_UPPER, READ_TRANSFER, UART_WRITE);
    signal read_state_machine : read_state := READ_IDLE;
    type STrI_en_state is (EN_IDLE, EN_ADRESS_LOWER, EN_ADRESS_UPPER, EN_DAT, EN_COMMAND_COMPLETED);
    signal stri_en_state_machine : STrI_en_state := EN_IDLE;
    type STrI_dis_state is (DIS_IDLE, DIS_ADRESS_LOWER, DIS_ADRESS_UPPER, DIS_DAT, DIS_COMMAND_COMPLETED);
    signal stri_dis_state_machine : STrI_dis_state := DIS_IDLE;
    type STrI_clr_state is (CLR_IDLE, CLR_SET, CLR_RESET);
    signal stri_clr_state_machine : STrI_clr_state := CLR_IDLE;
    type UART_tr_state is (UART_IDLE, UART_FULL, UART_LAST_WORD);
    signal UART_tr_state_machine : UART_tr_state := UART_IDLE;
    type acknoledge_state is (ACK_IDLE, ACK_WRITE, ACK_READ);
    signal acknoledge_state_machine : acknoledge_state := ACK_IDLE;
    type write_state is (WRITE_IDLE, WRITE_MEMORY_LOWER, WRITE_MEMORY_UPPER, WRITE_TRANSFER, WRITE_UART_WRITE, WRITE_TO_TARGET);
    signal write_state_machine : write_state := WRITE_IDLE;
    type module_name_buffer is array (0 to MODULE_NAME_LENGTH-1) of std_logic_vector(7 downto 0);
    signal module_name_buff : module_name_buffer := (others =>(others => '0'));
    type module_behaviour_buffer is array (0 to MODULE_BEHAVIOUR_LENGTH-1) of std_logic_vector(7 downto 0);
    signal module_behaviour_buff : module_behaviour_buffer := (others =>(others => '0'));
    
    signal retrieved_module_number : std_logic_vector(3 downto 0);
    signal retrieved_memory_needed : std_logic_vector(3 downto 0);
    signal retrieved_status_register : std_logic_vector(3 downto 0);
    signal send_data_streem : std_logic := '0';
    signal number_of_bits : std_logic;
    signal UART_write_enable : std_logic := '0';
    signal register_adress : std_logic_vector(6 downto 0);

    signal t_memory : std_logic_vector(15 downto 0) := (others => '0');
    signal rw_register : std_logic;
    signal status_register_i : integer;

    signal UART_fifo_full : std_logic := '0';
    signal memory_needed_i : integer := 0;

    type fourth_argument_letters is array(0 to 4) of std_logic_vector(7 downto 0);
    signal four_letters  : fourth_argument_letters := (others => (others => '0'));

    signal iWr_en : std_logic := '0';
    signal data_counter : integer := 0;
    signal debug1 : std_logic := '0';
    signal debug2 : std_logic := '0';

    -- STrl
    signal adress_in : std_logic_vector(11 downto 0);
    signal fourth_argument : std_logic_vector(15 downto 0); 
    signal data_frame_ok : std_logic := '0';
    signal time_id_counter : integer := 0;
    signal word_counter : integer := 0;
    signal UART_re_dat_en_rising_edge : integer range 0 to 1 := 0;

    signal STrI_length : integer := 0;
    signal STrI_WriteEn : std_logic := '0';
    signal STrI_DataIn : std_logic_vector(7 downto 0) := (others => '0');
    signal STrI_ReadEn : std_logic := '0';
    signal STrI_DataOut : std_logic_vector(7 downto 0) := (others => '0');
    signal STrI_Empty : std_logic;
    signal STrI_Full : std_logic;

    signal time_step : integer := 0;
        
        

    -- Tests 
    signal test1 : std_logic_vector(7 downto 0);
    signal test2 : std_logic_vector(7 downto 0) := (others => '0');



begin
    
    t_clk_200Meg <= clk_200Meg when IP_locked = '1' else '0';
    t_reset <= reset;
    
 
    led1 <= debug1;
    -- led2 <= debug2;

    clock100: process (clk_200Meg)
    begin
        if(rising_edge(clk_200Meg)) then
            clk_100Meg <= not(clk_100Meg);
        end if;
    end process;


    state_machine_process: process (clk_100Meg)
        variable module_name_counter : integer := 0;
        variable module_number_i : integer := 0;
        variable module_behaviour_counter : integer := 0;
        variable fourth_argument_counter : integer := 0;
        variable spix_process : integer := 0;
        variable counter_target_configuration : integer := 0;
        variable hexadecimal_data : integer := 0;
    begin
        if(rising_edge(clk_100Meg)) then
            if(reset = '1') then
                state_machine <= IDLE;
            else
                case state_machine is
                    when IDLE => -- State of inhibition. We wait for a letter on the UART before going to the next state.
                        FIFO_re_ReadEn <= '0'; 
                        FIFO_tr_WriteEn <= '0';
                        fourth_argument <= (others => '0');
                        module_number_i := 0;
                        memory_needed_i <= 0;
                        status_register_i <= 0;
                        -- module_select <= "00";
                        retrieved_module_number <= (others => '0');
                        retrieved_memory_needed <= (others => '0');
                        retrieved_status_register <= (others => '0');
                        four_letters <= (others => (others => '0'));
                        UART_write_enable <= '0';
                        send_data_streem <= '0';
                        if((UART_re_dat_en = '1') and (((UART_re_dat > 64) and (UART_re_dat < 91)) or ((UART_re_dat > 96) and (UART_re_dat < 123)))) then
                            module_name_buff(module_name_counter) <= UART_re_dat;
                            module_name_counter := module_name_counter + 1;
                            state_machine <= MODULE_NAME;
                        end if;
                    
                    when MODULE_NAME => -- State in which either the letters SPI or STrI are recovered. We go to the next state when we press the space key.
                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and (((UART_re_dat > 64) and (UART_re_dat < 91)) or ((UART_re_dat > 96) and (UART_re_dat < 123)))) then
                            module_name_buff(module_name_counter) <= UART_re_dat;
                            module_name_counter := module_name_counter + 1;
                        end if;
                        if((UART_re_dat /= x"20") and ((UART_re_dat < 65) or ((UART_re_dat < 97) and (UART_re_dat > 90)) or (UART_re_dat > 122))) then
                            module_name_counter := 0;
                            state_machine <= SYNTAX_ERROR;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"20")) then
                            module_name_counter := 0;
                            state_machine <= MODULE_NUMBER;
                        end if;
                    
                    when MODULE_NUMBER => -- Number of the module used to perform the action
                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and ((UART_re_dat > 47) and (UART_re_dat < 58))) then
                            retrieved_module_number <= UART_re_dat(3 downto 0);
                            module_number_i := (10 * module_number_i) + to_integer(unsigned(retrieved_module_number));
                        end if;
                        
                        if((UART_re_dat_en = '1') and (UART_re_dat /= x"20") and ((UART_re_dat < 48) or (UART_re_dat > 57))) then
                            state_machine <= SYNTAX_ERROR;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"20")) then
                            module_number_i := (10 * module_number_i) + to_integer(unsigned(retrieved_module_number));
                            state_machine <= MODULE_BEHAVIOUR;
                        end if;
                        
                    when MODULE_BEHAVIOUR => -- Number of the module used to perform the action 
                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and (((UART_re_dat > 64) and (UART_re_dat < 91)) or ((UART_re_dat > 96) and (UART_re_dat < 123)))) then
                            module_behaviour_buff(module_behaviour_counter) <= UART_re_dat;
                            module_behaviour_counter := module_behaviour_counter + 1;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat /= x"20") and (UART_re_dat /= x"0D") and ((UART_re_dat < 65) or ((UART_re_dat < 97) and (UART_re_dat > 90)) or (UART_re_dat > 122))) then
                            module_behaviour_counter := 0;
                            state_machine <= SYNTAX_ERROR;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"20")) then -- espace
                            module_behaviour_counter := 0;
                            if((module_behaviour_buff(0) = 82 or module_behaviour_buff(0) = 114) and (module_behaviour_buff(1) = 82 or module_behaviour_buff(0) = 114)) then --RR
                                state_machine <= STATUS_REGISTER_ADRESS;
                                rw_register <= '0';
                            elsif((module_behaviour_buff(0) = 82 or module_behaviour_buff(0) = 114) and (module_behaviour_buff(1) = 87 or module_behaviour_buff(0) = 119)) then --RW
                                state_machine <= STATUS_REGISTER_ADRESS;
                                rw_register <= '1';
                            else
                                state_machine <= MEMORY_NEEDED;
                            end if;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"0D")) then -- enter
                            module_behaviour_counter := 0;
                            state_machine <= ACKNOLEDGE;                          
                        end if;
                    
                    when MEMORY_NEEDED => 
                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and ((UART_re_dat > 47) and (UART_re_dat < 58))) then
                            retrieved_memory_needed <= UART_re_dat(3 downto 0);
                            memory_needed_i <= (10 * memory_needed_i) + to_integer(unsigned(retrieved_memory_needed));
                        end if;
                        if((UART_re_dat_en = '1') and (((UART_re_dat > 64) and (UART_re_dat < 91)) or ((UART_re_dat > 96) and (UART_re_dat < 123)))) then
                            four_letters(fourth_argument_counter) <= UART_re_dat;
                            fourth_argument_counter := fourth_argument_counter+1;                 
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat /= x"20") and ((UART_re_dat < 48) or ((UART_re_dat < 65) and (UART_re_dat > 57)) or ((UART_re_dat < 97) and (UART_re_dat > 90)) or (UART_re_dat > 122))) then
                            state_machine <= SYNTAX_ERROR;
                            fourth_argument_counter := 0;
                        end if;

                        if((UART_re_dat_en = '1') and (UART_re_dat = x"0D")) then -- enter
                            memory_needed_i <= (10 * memory_needed_i) + to_integer(unsigned(retrieved_memory_needed));
                            state_machine <= ACKNOLEDGE;
                            fourth_argument_counter := 0;
                        end if;
                        
                    when STATUS_REGISTER_NUMBER_OF_BITS =>

                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and ((UART_re_dat = 49) or (UART_re_dat = 50))) then
                            if(UART_re_dat = 49) then -- 8 bit
                                number_of_bits <= '0';
                            else
                                number_of_bits <= '1';
                            end if;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat /= x"20") and (UART_re_dat /= 49) and (UART_re_dat /= 50)) then
                            state_machine <= SYNTAX_ERROR;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"0D")) then -- espace
                            state_machine <= ACKNOLEDGE;
                        end if;
                        
                        
                    when STATUS_REGISTER_ADRESS =>

                        FIFO_re_ReadEn <= '0';
                        FIFO_tr_WriteEn <= '0';
                        if((UART_re_dat_en = '1') and ((UART_re_dat > 47) and (UART_re_dat < 58))) then
                            retrieved_status_register <= UART_re_dat(3 downto 0);
                            status_register_i <= (10 * status_register_i) + to_integer(unsigned(UART_re_dat(3 downto 0)));
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat /= x"0D") and ((UART_re_dat < 48) or (UART_re_dat > 57))) then
                            state_machine <= SYNTAX_ERROR;
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"20")) then -- espace
                            if(rw_register = '0') then
                                state_machine <= STATUS_REGISTER_NUMBER_OF_BITS;
                            else
                                state_machine <= STATUS_REGISTER_DATA_WRITE;
                            end if;
                        end if;

                    when STATUS_REGISTER_DATA_WRITE =>
                        if((UART_re_dat_en = '1') and (((UART_re_dat > 64) and (UART_re_dat < 71)) or ((UART_re_dat > 96) and (UART_re_dat < 103)) )) then
                            hexadecimal_data := (16 * hexadecimal_data) + to_integer(unsigned(UART_re_dat(3 downto 0))) + 9;                            
                        elsif((UART_re_dat_en = '1') and ((UART_re_dat > 47) and (UART_re_dat < 58))) then
                            hexadecimal_data := (16 * hexadecimal_data) + to_integer(unsigned(UART_re_dat(3 downto 0)));
                        end if;
                        if((UART_re_dat_en = '1') and (UART_re_dat = x"0D")) then -- carriage return
                            state_machine <= ACKNOLEDGE;
                        end if;

                    when ACKNOLEDGE =>
                        case acknoledge_state_machine is 
                            when ACK_IDLE =>
                                FIFO_re_ReadEn <= '0';
                                -- register_adress <= std_logic_vector(to_unsigned(status_register_i, 7));
                                fourth_argument <= std_logic_vector(to_unsigned(memory_needed_i,16));
                                acknoledge_state_machine <= ACK_WRITE;
                                FIFO_tr_DataIn <= x"23";
                                t_memory <= std_logic_vector(to_unsigned(memory_needed_i,16));
                                if(((module_name_buff(0) = 83) or (module_name_buff(0) = 115)) and ((module_name_buff(1) = 84) or (module_name_buff(1) = 116)) and ((module_name_buff(2) = 82) or (module_name_buff(2) = 114)) and ((module_name_buff(3) = 73) or (module_name_buff(3) = 105))) and (((module_behaviour_buff(0) = 68) or (module_behaviour_buff(0) = 100)) and ((module_behaviour_buff(1) = 70) or (module_behaviour_buff(1) = 102))) then -- STrI and DF
                                    register_write <= std_logic_vector(to_unsigned(memory_needed_i,8));
                                    reg_requirements_write <= x"06";
                                    write_enable <= '1';
                                end if;

                            when ACK_WRITE =>
                                FIFO_tr_WriteEn <= '1';
                                acknoledge_state_machine <= ACK_READ;
                                write_enable <= '0';

                            when ACK_READ =>
                                FIFO_tr_WriteEn <= '0';
                                if(FIFO_tr_Empty = '0') then
                                    UART_write_enable <= '1';
                                elsif(FIFO_tr_Empty = '1' and UART_write_enable = '1') then
                                    state_machine <= TARGET_CONFIGURATION;
                                    acknoledge_state_machine <= ACK_IDLE;
                                    UART_write_enable <= '0';
                                    acknoledge_state_machine <= ACK_IDLE;
                                    state_machine <= TARGET_CONFIGURATION;
                                end if; 
                                
                        end case;
                    
                    when SYNTAX_ERROR =>

                        case acknoledge_state_machine is 
                            when ACK_IDLE =>
                                FIFO_re_ReadEn <= '0';
                                fourth_argument <= std_logic_vector(to_unsigned(memory_needed_i,16));
                                acknoledge_state_machine <= ACK_WRITE;
                                FIFO_tr_DataIn <= x"21";

                            when ACK_WRITE =>
                                FIFO_tr_WriteEn <= '1';
                                acknoledge_state_machine <= ACK_READ;

                            when ACK_READ =>
                                FIFO_tr_WriteEn <= '0';
                                if(FIFO_tr_Empty = '0') then
                                    UART_write_enable <= '1';
                                elsif(FIFO_tr_Empty = '1' and UART_write_enable = '1') then
                                    state_machine <= TARGET_CONFIGURATION;
                                    acknoledge_state_machine <= ACK_IDLE;
                                    UART_write_enable <= '0';
                                    acknoledge_state_machine <= ACK_IDLE;
                                    state_machine <= IDLE;
                                end if; 
                                
                        end case;
                        
                                        
                    when TARGET_CONFIGURATION =>
                        --STrI module
                        if(((module_name_buff(0) = 83) or (module_name_buff(0) = 115)) and ((module_name_buff(1) = 84) or (module_name_buff(1) = 116)) and ((module_name_buff(2) = 82) or (module_name_buff(2) = 114)) and ((module_name_buff(3) = 73) or (module_name_buff(3) = 105))) then

                            -- module_select <= "01";
                        -- Selection of the right output
                            for index in target_select'range loop
                                if(index = module_number_i) then
                                    target_select(index) <= '1';
                                else
                                    target_select(index) <= '0';
                                end if;
                            end loop;

                            if(((module_behaviour_buff(0) = 69) or (module_behaviour_buff(0) = 101)) and ((module_behaviour_buff(1) = 78) or (module_behaviour_buff(1) = 110))) then --EN
                                --Send data=1 via the command register
                                
                                FIFO_tr_WriteEn <= '0';
                                case stri_en_state_machine is
                                    when EN_IDLE =>
                                        write_enable <= '0';
                                        stri_en_state_machine <= EN_ADRESS_LOWER;
                                        reg_requirements_write <= x"00";
                                        reg_requirements_read <= x"00";
                                    when EN_ADRESS_LOWER =>
                                        register_write <= fourth_argument(7 downto 0);
                                        write_enable <= '1';
                                        if(register_read = fourth_argument(7 downto 0)) then
                                            stri_en_state_machine <= EN_ADRESS_UPPER;
                                            reg_requirements_write <= x"01";
                                            reg_requirements_read <= x"01";
                                        end if;
                                    when EN_ADRESS_UPPER =>
                                        register_write <= fourth_argument(15 downto 8);
                                        if(register_read = fourth_argument(15 downto 8)) then
                                            stri_en_state_machine <= EN_DAT;
                                            reg_requirements_write <= x"03";
                                            reg_requirements_read <= x"03";
                                        end if;
                                    when EN_DAT =>
                                        register_write <= x"05";
                                        if(register_read(2 downto 0) = "101") then
                                            stri_en_state_machine <= EN_COMMAND_COMPLETED;
                                            reg_requirements_write <= x"03";
                                            reg_requirements_read <= x"03";
                                        end if;
                                    when EN_COMMAND_COMPLETED =>
                                        register_write <= x"01";
                                        if(register_read(2) = '0') then
                                            stri_en_state_machine <= EN_IDLE;
                                            state_machine <= IDLE;
                                        end if;
                                end case;

                            elsif(((module_behaviour_buff(0) = 68) or (module_behaviour_buff(0) = 100)) and ((module_behaviour_buff(1) = 73) or (module_behaviour_buff(1) = 105)) and ((module_behaviour_buff(2) = 83) or (module_behaviour_buff(2) = 115))) then --DIS

                                FIFO_tr_WriteEn <= '0';
                                case stri_dis_state_machine is
                                    when DIS_IDLE =>
                                        write_enable <= '0';
                                        stri_dis_state_machine <= DIS_ADRESS_LOWER;
                                    when DIS_ADRESS_LOWER =>
                                        reg_requirements_write <= x"00";
                                        reg_requirements_read <= x"00";
                                        register_write <= fourth_argument(7 downto 0);
                                        write_enable <= '1';
                                        if(register_read = fourth_argument(7 downto 0)) then
                                            stri_dis_state_machine <= DIS_ADRESS_UPPER;
                                        end if;
                                    when DIS_ADRESS_UPPER =>
                                        reg_requirements_write <= x"01";
                                        reg_requirements_read <= x"01";
                                        register_write <= fourth_argument(15 downto 8);
                                        if(register_read = fourth_argument(15 downto 8)) then
                                            stri_dis_state_machine <= DIS_DAT;
                                        end if;
                                    when DIS_DAT =>
                                        reg_requirements_write <= x"03";
                                        reg_requirements_read <= x"03";
                                        register_write <= x"04";
                                        if(register_read(2 downto 0) = "100") then
                                            stri_dis_state_machine <= DIS_COMMAND_COMPLETED;
                                        end if;
                                    when DIS_COMMAND_COMPLETED =>
                                        reg_requirements_write <= x"03";
                                        reg_requirements_read <= x"03";
                                        register_write <= x"00";
                                        if(register_read(2) = '0') then
                                            stri_dis_state_machine <= DIS_IDLE;
                                            state_machine <= IDLE;
                                        end if;
                                end case;

                            elsif(((module_behaviour_buff(0) = 67) or (module_behaviour_buff(0) = 99)) and ((module_behaviour_buff(1) = 76) or (module_behaviour_buff(1) = 108)) and ((module_behaviour_buff(2) = 82) or (module_behaviour_buff(2) = 114))) then --CLR
                                
                                FIFO_tr_WriteEn <= '0';
                                --Clear
                                case stri_clr_state_machine is
                                    when CLR_IDLE =>
                                        write_enable <= '0';
                                        stri_clr_state_machine <= CLR_SET;
                                    when CLR_SET =>
                                        reg_requirements_write <= x"03";
                                        reg_requirements_read <= x"03";
                                        register_write <= x"02";
                                        write_enable <= '1';
                                        if(register_read(1) = '1') then
                                            stri_clr_state_machine <= CLR_RESET;
                                        end if;
                                    when CLR_RESET =>
                                        reg_requirements_write <= x"03";
                                        reg_requirements_read <= x"03";
                                        register_write <= x"00";
                                        if(register_read(1) = '0') then
                                            stri_clr_state_machine <= CLR_IDLE;
                                            state_machine <= IDLE;
                                        end if;
                                end case;

                            elsif(((module_behaviour_buff(0) = 68) or (module_behaviour_buff(0) = 100)) and ((module_behaviour_buff(1) = 70) or (module_behaviour_buff(1) = 102))) then --DF
                                
                                reg_requirements_write <= x"06";
                                register_write <= UART_re_dat;
                                if((UART_re_dat_en = '1') and (UART_re_dat_en_rising_edge = 0)) then
                                    word_counter <= word_counter+1;
                                    UART_re_dat_en_rising_edge <= 1;
                                    write_enable <= '1';
                                elsif(UART_re_dat_en = '0') then
                                    UART_re_dat_en_rising_edge <= 0;
                                    write_enable <= '0';
                                else
                                    write_enable <= '0';
                                end if;

                                if(word_counter = fourth_argument) then
                                    state_machine <= IDLE;
                                    data_frame_ok <= '1';
                                    word_counter <= 0;
                                end if;

                            elsif(((module_behaviour_buff(0) = 83) or (module_behaviour_buff(0) = 115)) and ((module_behaviour_buff(1) = 71) or (module_behaviour_buff(1) = 103))) then --SG
                                    if(data_frame_ok = '1') then
                                        if((four_letters(0) = 83 or four_letters(0) = 115) and (four_letters(1) = 84 or four_letters(1) = 116) and (four_letters(2) = 65 or four_letters(2) = 97) and (four_letters(3) = 82 or four_letters(3) = 114) and (four_letters(4) = 84 or four_letters(4) = 116)) then --START
                                            time_step <= time_step + 1;
                                            reg_requirements_write <= x"06";
                                            register_write <= STrI_DataOut;
                                            STrI_ReadEn <= '1';
                                            -- if(STrI_Empty = '1') then
                                            --     
                                            --     state_machine <= IDLE;
                                            -- end if;
                                            if(time_step = 1048575) then
                                                data_frame_ok <= '0';
                                                state_machine <= IDLE;
                                            end if;

                                        end if;
                                        
                                    elsif((four_letters(0) = 69 or four_letters(0) = 101) and (four_letters(1) = 78 or four_letters(1) = 110) and (four_letters(2) = 68 or four_letters(2) = 100) and (four_letters(3) = 0) and (four_letters(4) = 0)) then --END
                                        if(STrI_Empty = '0') then
                                            STrI_ReadEn <= '1';
                                        else
                                            state_machine <= IDLE;
                                        end if;
                                    else
                                        state_machine <= SYNTAX_ERROR;
                                    end if;

                            elsif(((module_behaviour_buff(0) = 82) or (module_behaviour_buff(0) = 114)) and ((module_behaviour_buff(1) = 82) or (module_behaviour_buff(1) = 114))) then --RR
                                
                                FIFO_tr_WriteEn <= '0';
                                FIFO_re_ReadEn <= '0';
                                write_enable <= '0';
                                reg_requirements_read <= std_logic_vector(to_unsigned(status_register_i,8));
                                FIFO_tr_DataIn <= register_read;
                                -- FIFO_tr_WriteEn <= '1';
                                if(FIFO_tr_Empty = '0') then
                                    state_machine <= IDLE;
                                end if;
                            
                            elsif(((module_behaviour_buff(0) = 82) or (module_behaviour_buff(0) = 114)) and ((module_behaviour_buff(1) = 87) or (module_behaviour_buff(1) = 119))) then --RW
                                FIFO_tr_WriteEn <= '0';
                                register_write <= std_logic_vector(to_unsigned(hexadecimal_data,8));
                                reg_requirements_write <= std_logic_vector(to_unsigned(status_register_i,8));
                                reg_requirements_read(7) <= '0';
                                reg_requirements_read(6 downto 0) <=  std_logic_vector(to_unsigned(status_register_i,7));
                                if(register_read = std_logic_vector(to_unsigned(hexadecimal_data,8))) then
                                    state_machine <= IDLE;
                                end if;
                            
                            end if;


                        -- SPIx module
                        elsif(((module_name_buff(0) = 83) or (module_name_buff(0) = 115)) and ((module_name_buff(1) = 80) or (module_name_buff(1) = 112)) and ((module_name_buff(2) = 73) or (module_name_buff(2) = 105)) and ((module_name_buff(3) = 88) or (module_name_buff(3) = 120))) then
                            
                            -- Selection of the right output
                            for index in target_select'range loop
                                if(index = module_number_i) then
                                    target_select(index) <= '1';
                                else
                                    target_select(index) <= '0';
                                end if;
                            end loop;
                            
                            if(memory_needed_i = 0) then
                                memory_needed_i <= 100;
                            end if;
                            -- module_select <= "10";
                          
                            if(((module_behaviour_buff(0) = 82) or (module_behaviour_buff(0) = 114)) and ((module_behaviour_buff(1) = 68) or (module_behaviour_buff(1) = 100))) then --RD
                            
                                case read_state_machine is
                                    when READ_IDLE =>
                                        write_enable <= '1';
                                        reg_requirements_write <= "00000010";
                                        reg_requirements_read <= "00000010";
                                        read_state_machine <= READ_MEMORY_LOWER;
                                        FIFO_tr_WriteEn <= '0';
                                        UART_write_enable <= '0';
                                        register_write <= t_memory(7 downto 0);
                                    when READ_MEMORY_LOWER =>
                                        register_write <= t_memory(7 downto 0);
                                        if(register_read = t_memory(7 downto 0)) then
                                            read_state_machine <= READ_MEMORY_UPPER;
                                            reg_requirements_write <= "00000011";
                                            reg_requirements_read <= "00000011";
                                            register_write <= t_memory(15 downto 8);
                                        end if;
                                        FIFO_tr_WriteEn <= '0';
                                        UART_write_enable <= '0';
                                        
                                    when READ_MEMORY_UPPER =>
                                       register_write <= t_memory(15 downto 8);
                                        if(register_read = t_memory(15 downto 8)) then
                                            read_state_machine <= READ_TRANSFER;
                                            reg_requirements_write <= "00000001";
                                            reg_requirements_read <= "00000001";
                                        end if;
                                        FIFO_tr_WriteEn <= '0';
                                        UART_write_enable <= '0';
                                        
                                    when READ_TRANSFER =>
                                        UART_write_enable <= '0';
                                        
                                        if(data_counter > memory_needed_i+1) then
                                            counter_target_configuration := 0;
                                            FIFO_tr_WriteEn <= '0';
                                            spix_process := 0;
                                            data_counter <= 0;
                                            read_state_machine <= UART_WRITE;
                                            test2(0) <= '1';
                                        else
                                            if(register_read(0) = '1') then
                                                spix_process := 1;
                                                reg_requirements_read <= "00000000";
                                                FIFO_tr_WriteEn <= '0';
                                                
                                            end if;

                                            if(spix_process = 1) then
                                                data_counter <= data_counter+1;
                                                if(data_counter /= 0) then
                                                    FIFO_tr_DataIn <= register_read;
                                                    if(data_counter <= memory_needed_i) then
                                                        FIFO_tr_WriteEn <= '1';
                                                    else
                                                        FIFO_tr_WriteEn <= '0';
                                                    end if;
                                                    register_write <= "00000000";
                                                    reg_requirements_write <= "00000001";
                                                end if;
                                            else
                                                FIFO_tr_WriteEn <= '0';
                                                register_write <= "10000000";
                                                reg_requirements_write <= "00000001";
                                                reg_requirements_read <= "00000001";
                                                
                                            end if;
                                        end if;
                                    when UART_WRITE =>
                                        if(FIFO_tr_Empty = '0') then
                                            UART_write_enable <= '1';
                                        else
                                            write_enable <= '0';
                                            state_machine <= IDLE;
                                            read_state_machine <= READ_IDLE;
                                            UART_write_enable <= '0';
                                        end if; 
                                        
                                end case;
                                FIFO_re_ReadEn <= '0';

                            elsif(((module_behaviour_buff(0) = 87) or (module_behaviour_buff(0) = 119)) and ((module_behaviour_buff(1) = 82) or (module_behaviour_buff(1) = 114))) then --WR

                                FIFO_tr_WriteEn <= '0';
                                case write_state_machine is
                                    when WRITE_IDLE =>
                                        write_enable <= '1';
                                        FIFO_re_length <= memory_needed_i;
                                        reg_requirements_write <= "00000010";
                                        reg_requirements_read <= "00000010";
                                        write_state_machine <= WRITE_MEMORY_LOWER;
                                        FIFO_re_ReadEn <= '0';
                                        register_write <= t_memory(7 downto 0);
                                        -- UART_write_enable <= '0';
                                    when WRITE_MEMORY_LOWER =>
                                        register_write <= t_memory(7 downto 0);
                                        
                                        if(register_read = t_memory(7 downto 0)) then
                                            write_state_machine <= WRITE_MEMORY_UPPER;
                                            reg_requirements_write <= "00000011";
                                            reg_requirements_read <= "00000011";
                                            register_write <= t_memory(15 downto 8);
                                        end if;
                                        FIFO_re_ReadEn <= '0';
                                    when WRITE_MEMORY_UPPER =>
                                        register_write <= t_memory(15 downto 8);
                                        if(register_read = t_memory(15 downto 8)) then
                                            write_state_machine <= WRITE_UART_WRITE;
                                            reg_requirements_write <= "00000001";
                                            reg_requirements_read <= "00000001";
                                        end if;
                                        FIFO_re_ReadEn <= '0';
                                        -- UART_write_enable <= '0';

                                    when WRITE_UART_WRITE =>
                                        reg_requirements_write <= "00000001";
                                        reg_requirements_read <= "00000001";
                                        if(FIFO_re_Full = '1') then
                                            FIFO_re_ReadEn <= '0';
                                            register_write <= "01000000";
                                            if(register_read(7 downto 5) = "010") then
                                                write_state_machine <= WRITE_TRANSFER;
                                                FIFO_re_ReadEn <= '1';
                                                reg_requirements_write <= "00000000";
                                            end if;
                                        end if;
                                    when WRITE_TRANSFER =>
                                    
                                        if(data_counter > memory_needed_i +1) then
                                            register_write <= "00000000";
                                            reg_requirements_write <= "00000001";
                                            reg_requirements_read <= x"01";
                                            if(register_read(7 downto 5) = "000") then
                                                -- state_machine <= IDLE;
                                                -- write_state_machine <= WRITE_IDLE;
                                                write_state_machine <= WRITE_TO_TARGET;
                                                debug2 <= not(debug2);
                                                data_counter <= 0;
                                            end if;
                                            counter_target_configuration := 0;
                                            FIFO_re_ReadEn <= '0';
                                            spix_process := 0;
                                            UART_fifo_full <= '0';
                                            

                                        else
                                            reg_requirements_write <= "00000000";
                                            register_write <= FIFO_re_DataOut; -- Writing the received data in the SPIx register map
                                            data_counter <= data_counter+1;
                                            FIFO_re_ReadEn <= '1';
                                        end if;
                                    
                                    when WRITE_TO_TARGET =>
                                        if(register_read(3) = '1') then
                                            state_machine <= IDLE;
                                            write_state_machine <= WRITE_IDLE;
                                            write_enable <= '0';
                                        end if;
                                        debug1 <= '1';
                                end case;
                                
                            elsif(((module_behaviour_buff(0) = 82) or (module_behaviour_buff(0) = 114)) and ((module_behaviour_buff(1) = 82) or (module_behaviour_buff(1) = 114))) then --RR
                                FIFO_re_ReadEn <= '0';
                                reg_requirements_read(7) <= number_of_bits;
                                reg_requirements_read(6 downto 0) <= std_logic_vector(to_unsigned(status_register_i,7));
                                FIFO_tr_DataIn <= register_read;
                                -- FIFO_tr_WriteEn <= '1';
                                if(FIFO_tr_Empty = '0') then
                                    state_machine <= IDLE;
                                end if;
                            
                            elsif(((module_behaviour_buff(0) = 82) or (module_behaviour_buff(0) = 114)) and ((module_behaviour_buff(1) = 87) or (module_behaviour_buff(1) = 119))) then --RW
                                register_write <= std_logic_vector(to_unsigned(hexadecimal_data,8));
                                reg_requirements_write <= std_logic_vector(to_unsigned(status_register_i,8));
                                state_machine <= IDLE;
                            elsif(((module_behaviour_buff(0) = 73) or (module_behaviour_buff(0) = 105)) and ((module_behaviour_buff(1) = 87) or (module_behaviour_buff(1) = 119)) and ((module_behaviour_buff(2) = 82) or (module_behaviour_buff(2) = 114))) then --iWr
                               
                                reg_requirements_read <= "00000101";
                                reg_requirements_write <= "00000001";
                                if(register_read(7) = '0') then
                                    register_write <= "00100000";
                                    iWr_en <= '1';
                                end if;

                                if(iWr_en = '1') then
                                    iWr_en <= '0';
                                    state_machine <= IDLE;
                                    register_write <= "00000000";
                                end if;
                                FIFO_tr_WriteEn <= '0';
                                FIFO_re_ReadEn <= '0';
                            else
                                state_machine <= SYNTAX_ERROR;
                            end if;
                        else
                            state_machine <= SYNTAX_ERROR;
                        end if;
                end case;
            end if;
        end if;
    end process;

    
    UART_tr_process : process(clk_100Meg)
       variable rising_edge_tr : integer range 0 to 1 := 0;
       variable wait_for_finish : integer range 0 to 2 := 0;
       variable falling_edge_tr : integer range 0 to 1 := 0;
       variable falling_edges_counter : integer range 0 to 2 := 0;
            
    begin
        if (rising_edge(clk_100Meg)) then

        case UART_tr_state_machine is
            when UART_IDLE =>
                UART_tr_en_tx <= '0';
                wait_for_finish := 0;
                falling_edges_counter := 0;
                UART_tr_tx_data <= "ZZZZZZZZ";
                if(UART_write_enable = '1') then
                    UART_tr_state_machine <= UART_FULL;
                    FIFO_tr_ReadEn <= '1';
                end if;

            when UART_FULL =>
                if(FIFO_tr_Empty = '0') then
                    UART_tr_tx_data <= FIFO_tr_DataOut;
                    UART_tr_en_tx <= '1';
                    if((UART_tr_stop_tx = '1') and (rising_edge_tr = 0)) then
                        FIFO_tr_ReadEn <= '1';
                        rising_edge_tr := 1;
                    elsif (UART_tr_stop_tx = '0') then
                        rising_edge_tr := 0;
                        FIFO_tr_ReadEn <= '0';
                    else
                        FIFO_tr_ReadEn <= '0';
                    end if;
                else
                    UART_tr_state_machine <= UART_LAST_WORD;
                end if;

            when UART_LAST_WORD =>
                if(UART_tr_stop_tx = '1' and wait_for_finish /= 0) then
                    UART_tr_state_machine <= UART_IDLE;
                    UART_tr_tx_data <= ((others => '0'));
                    falling_edges_counter := 0;
                    falling_edge_tr := 0;
                else
                    if((UART_tr_stop_tx = '0') and (falling_edge_tr = 0)) then
                        falling_edges_counter := falling_edges_counter+1;
                        falling_edge_tr := 1;
                    elsif (UART_tr_stop_tx = '1') then
                        falling_edge_tr := 0;
                    end if;
                    if(falling_edges_counter = 1) then
                        wait_for_finish := 1;
                    end if;         
                end if;
        end case;
        end if;
    end process;

    UART_re_process : process(clk_100Meg)
       variable rising_edge_re : integer range 0 to 1 := 0;
    begin
        if (rising_edge(clk_100Meg)) then
            if((state_machine = TARGET_CONFIGURATION) and ((module_behaviour_buff(0) = 87) or (module_behaviour_buff(0) = 119)) and ((module_behaviour_buff(1) = 82) or (module_behaviour_buff(1) = 114))) then --WR
                if(FIFO_re_Full = '0') then
                    if((UART_re_dat_en = '1') and (rising_edge_re = 0)) then
                        FIFO_re_WriteEn <= '1';
                        rising_edge_re := 1;
                    elsif (UART_re_dat_en = '0') then
                        rising_edge_re := 0;
                        FIFO_re_WriteEn <= '0';
                    else
                        FIFO_re_WriteEn <= '0';
                    end if;

                    FIFO_re_DataIn <= UART_re_dat;
                end if;
            end if;
        end if;
    end process;


    

-------------------------------------------------------------------------------------
    IP_clock: clk_wiz_1
    port map(
        clk_out1 => clk_200Meg,
        reset => reset,
        locked => IP_locked,
        clk_in1 => clk
    );
  
    UART_transmsission: entity work.UART_tr
    generic map (
        CLOCK_F	=> 100,	-- Clock frequency MHz
        BAUD_RATE => 3000000,
        EN_PARITY => '0'
    )
    port map (
        clk => clk_100Meg,
        rst	=> reset,
        en_tx => UART_tr_en_tx,
        tx_data => UART_tr_tx_data,
        stop_tx => UART_tr_stop_tx,
        tx => tx
    );

    UART_rece: entity work.UART_recv_V1
    generic map (
        clk100M => 1,
        SLOW_VALUES => 0
    )
    port map (
        clk => clk_100Meg,
        reset => reset,
        speed => "11",
        rx => rx,
        dat => UART_re_dat,
        dat_en => UART_re_dat_en
    );

    UART_transmission_FIFO: entity work.STD_FIFO
    generic map( 
    DATA_WIDTH => 8,
    MAX_FIFO_DEPTH => 60
    )
    port map(
    CLK     => clk_100Meg,
    RST     => reset,
    Length  => 60,
    WriteEn => FIFO_tr_WriteEn,
    DataIn  => FIFO_tr_DataIn,
    ReadEn  => FIFO_tr_ReadEn,
    DataOut => FIFO_tr_DataOut,
    Empty   => FIFO_tr_Empty,
    Full    => FIFO_tr_Full
    );

    UART_reception_FIFO: entity work.STD_FIFO
    generic map( 
    DATA_WIDTH => 8,
    MAX_FIFO_DEPTH => 20
    )
    port map(
    CLK     => clk_100Meg,
    RST     => reset,
    Length  => FIFO_re_length,
    WriteEn => FIFO_re_WriteEn,
    DataIn  => FIFO_re_DataIn,
    ReadEn  => FIFO_re_ReadEn,
    DataOut => FIFO_re_DataOut,
    Empty   => FIFO_re_Empty,
    Full    => FIFO_re_Full
    );  

    STrI_FIFO: entity work.STD_FIFO
    generic map( 
    DATA_WIDTH => 8,
    MAX_FIFO_DEPTH => 20
    )
    port map(
    CLK     => clk_100Meg,
    RST     => reset,
    Length  => STrI_length,
    WriteEn => STrI_WriteEn,
    DataIn  => STrI_DataIn,
    ReadEn  => STrI_ReadEn,
    DataOut => STrI_DataOut,
    Empty   => STrI_Empty,
    Full    => STrI_Full
    );  

end Behavioral;