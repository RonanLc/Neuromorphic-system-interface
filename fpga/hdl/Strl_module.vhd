library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Strl is
generic(
    constant N : integer range 0 to 12;
    constant M : integer range 0 to 256;
    constant MAX_SYNAPSES : integer;
    constant MAX_FRAMES : integer
);
port (
    clk : in std_logic;
    reset   : in std_logic;

    Strl_is_selected : in std_logic;

    -- Register map
    reg_requirements_write : in std_logic_vector(7 downto 0);
    reg_requirements_read : in std_logic_vector(7 downto 0);
    register_read : out std_logic_vector(7 downto 0) := (others => 'Z');
    register_write : in std_logic_vector(7 downto 0);
    write_enable : in std_logic;
    -- module_select : in std_logic_vector(1 downto 0);
    
    Adrs : out std_logic_vector(N-1 downto 0);
    Sel : out std_logic_vector(M-1 downto 0);
    Strb : out std_logic;
    Clr : out std_logic;
    D : out std_logic
);
end Strl;

architecture Behavioral of Strl is
    
    signal command_completed : std_logic := '0';
    signal Din : std_logic := '0';
    signal Clr_out : std_logic := '0';
    signal adress_in : std_logic_vector(N-1 downto 0) := (others => '0');
    signal upper_adress_in : std_logic_vector(7 downto 0) := ('0','0','0','0', adress_in(11), adress_in(10), adress_in(9), adress_in(8));
    signal command : std_logic_vector(7 downto 0) := ('0', '0', '0', '0', '0', command_completed, Clr_out, Din);
    type strobe_fsm is (IDLE, DELAY, STROBE_LOW, STROBE_HIGH, CLEAR);
    signal state_machine : strobe_fsm := IDLE;
    type settings_fsm is (SETTINGS_IDLE, SET_SETTINGS, FIFO_SETTINGS, STATE_THREE);
    signal settings_state_machine : settings_fsm := SETTINGS_IDLE;
   
    signal adress_out : std_logic_vector(N-1 downto 0); 
    signal Data_out : std_logic;
    signal Strb_out : std_logic;
    signal tsc_counter : std_logic_vector(7 downto 0) := x"01";
    signal tas_counter : std_logic_vector(7 downto 0) := x"01";
    signal change_state : std_logic_vector(7 downto 0) := (others => '0');
    signal counter_state : std_logic_vector(7 downto 0) := (others => '0');
    
    type rfsm is (REGISTER_IDLE, ONE_BYTE, TWO_BYTES);
    signal reg_state_machine : rfsm := REGISTER_IDLE;
    signal is_treated : std_logic := '0';    
    signal Selection : std_logic_vector(7 downto 0) := (others => '0');

    type FIFO_fsm is (FIFO_IDLE, FIFO_FILL, FIFO_EMPTY);
    signal FIFO_state_machine : FIFO_fsm := FIFO_IDLE;
    signal FIFO_in : std_logic_vector(7 downto 0) := (others => '0'); 
    signal size_buff : std_logic := '0';
    signal WriteEn : std_logic := '0';
    signal DataIn : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
    signal ReadEn : std_logic := '0';
    signal DataOut : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
    signal Empty : std_logic;
    signal Full : std_logic;
    signal length : integer := 0;
    signal length_is_transmitted : std_logic := '0';
    signal spike_number : integer := 0;
    type tab_integer is array (0 to MAX_SYNAPSES) of integer; -- au lieu de natural range : machin downto 0
    type tab_integer_frames is array (0 to MAX_FRAMES) of integer;
    type spikes_id_tab is array (0 to MAX_FRAMES) of tab_integer; 
    signal FIFO_time_ID : std_logic_vector(19 downto 0) := (others => '0');
    signal TIME_IDS : tab_integer_frames := (others => 0);
    signal NUMBER_SPIKES : tab_integer_frames := (others => 0);
    signal SPIKES_IDS : spikes_id_tab := (others => (others => 0));
    signal time_id : integer := 0;
    signal Number_of_spikes : integer range 0 to 2047 := 0;
    signal FIFO_number_of_spikes : std_logic_vector(9 downto 0) := (others => '0');
    signal FIFO_counter_fill : integer := 0;
    signal FIFO_counter_empty : integer := 0;
    signal FIFO_counter : integer := 0;
    signal FIFO_output : std_logic := '0';
    
    signal synaps_selection : tab_integer := (others => 0);
    signal synapses_enable : std_logic_vector(MAX_SYNAPSES downto 0) := (others => '0');
    signal FIFO_bit_counter : integer :=0;
    signal synaps_id : std_logic_vector(9 downto 0) := (others => '0');
    signal synaps_enable : std_logic := '0';

    type rmap is array (0 to 6) of std_logic_vector(7 downto 0);
    signal register_map : rmap := (adress_in(7 downto 0), upper_adress_in, Selection, command, tsc_counter, tas_counter, FIFO_in);
    signal reg_adress_write : integer := 0;
    signal reg_adress_read : integer := 0;
    signal frame_counter : integer := 0;

    signal time_counter : integer := 0;
    signal id_index : integer := 0;

begin


    Adrs <= adress_out;
    D <= Data_out;
    Clr <= Clr_out;
    Strb <= Strb_out;

    -- FIFO ---------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------

     FIFO_process: process (clk)
         variable UART_counter : integer := 0;
         Variable number_of_spikes_var : integer := 0;
         variable loop_counter : integer := 0;
         variable synaps_id_variable : integer := 0;
         variable synaps_enable_variable : integer range 0 to 1 := 0;
         variable synaps_id_index : integer := 0;
            
     begin
         if(reset = '1') then
             frame_counter <= 0;
             FIFO_state_machine <= FIFO_IDLE;
         elsif (rising_edge(clk)) then
            
             case FIFO_state_machine is 
                 when FIFO_IDLE =>

                     FIFO_counter <= 0;
                     FIFO_counter_empty <= 0;
                     FIFO_counter_fill <= 0;
                     if(reg_requirements_write = 6) then
                         length <= to_integer(unsigned(register_write));
                         FIFO_state_machine <= FIFO_FILL;
                     end if;
                    

                 when FIFO_FILL => 
        
                     if(reg_adress_write = 6 and write_enable = '1') then
                         WriteEn <= '1';
                         DataIn <= register_write;
                         FIFO_counter_fill <= FIFO_counter_fill + 1;
                        
                     else
                         WriteEn <= '0';
                     end if;

                     if(FIFO_counter_fill = length) then
                         WriteEn <= '0';
                         FIFO_state_machine <= FIFO_EMPTY;
                         ReadEn <= '1';
                     end if;

                 when FIFO_EMPTY =>
                        
                     FIFO_counter_empty <= FIFO_counter_empty+1;
                     if(FIFO_counter = 0) then
                         FIFO_counter <= FIFO_counter + 1;
                         
                     elsif(FIFO_counter = 1) then
                         for index in DataOut'range loop
                             FIFO_time_ID(19- index) <= DataOut(index);
                         end loop;
                         FIFO_counter <= FIFO_counter + 1;
                        
                     elsif(FIFO_counter = 2) then
                         for index in DataOut'range loop
                             FIFO_time_ID(11- index) <= DataOut(index);
                         end loop;
                         FIFO_counter <= FIFO_counter + 1;

                     elsif(FIFO_counter = 3) then
                         for i in 0 to 7 loop
                             if(i < 4) then
                                 FIFO_time_ID(3- i) <= DataOut(i);
                             elsif(i > 3) and (i < 8) then
                                 if(DataOut(i) = '1') then
                                     number_of_spikes_var := number_of_spikes_var + 512 /(2**(i-4));
                                 end if;
                             end if;
                         end loop;
                         FIFO_counter <= FIFO_counter + 1;

                     elsif(FIFO_counter = 4) then
                         time_id <= to_integer(unsigned(FIFO_time_ID));
                        
                         for i in 0 to 7 loop
                             if(i < 6) then
                                 if(DataOut(i) = '1') then
                                     number_of_spikes_var := number_of_spikes_var + 32 /(2**i);
                                 end if;
                             elsif(i > 5) then
                                 Number_of_spikes <= number_of_spikes_var;
                                 if(DataOut(i) = '1') then
                                     synaps_id_variable := synaps_selection(0) + 512/(2**(i-6));
                                 end if;
                             end if;
                         end loop;
                         FIFO_counter <= FIFO_counter + 1;
                         UART_counter := 2;
                         synaps_id_index := 0;

                     elsif(FIFO_counter > 4) then
                        
                         loop_counter:= 0;
                         for i in 0 to 7 loop
                             UART_counter := UART_counter + 1;
                             if(UART_counter = 11) then
                                 UART_counter := 0;
                                 synapses_enable(synaps_id_index) <= DataOut(i);
                                 SPIKES_IDS(frame_counter)(synaps_id_index) <= synaps_id_variable;
                                 synaps_id_index := synaps_id_index+1;
                                 synaps_id_variable := 0;
                             else
                                 if(DataOut(i) = '1') then
                                     synaps_id_variable := synaps_id_variable + (512/(2**(UART_counter-1)));
                                     loop_counter := loop_counter + 1;
                                 end if;
                             end if;
                            
                         end loop;

                        if(FIFO_counter_empty >= FIFO_counter_fill) then
--                            FIFO_state_machine <= FIFO_IDLE;
--                            FIFO_output <= '1'; -- Signal that indicates that an info is ready to be sent to the spike generator
                        end if;  

                         if(synaps_id_index >= number_of_spikes_var) then
                             FIFO_counter <= 1;
                             TIME_IDS(frame_counter) <= time_id;
                             NUMBER_SPIKES(frame_counter) <= number_of_spikes_var;
                             frame_counter <= frame_counter + 1;
                             number_of_spikes_var := 0;
                             -- ReadEn <= '0';
                         else
                             FIFO_counter <= FIFO_counter + 1;
                         end if;

                     end if;
             end case;
         end if;
     end process;

    -- Single spike ------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------

    settings_process: process (clk)
        variable Selection_i : integer range 0 to 100;
    begin
        if(rising_edge(clk)) then
            case settings_state_machine is
                when SETTINGS_IDLE =>
                    adress_out <= (others => 'Z');
                    Sel <= (others => '0');
                    Data_out <= 'Z';
                    counter_state <= (others => '0');
                    id_index <= 0;
                    time_counter <= 0;

                    if(FIFO_output = '1')then
                        settings_state_machine <= FIFO_SETTINGS;
                    elsif(Strl_is_selected = '1') then
                        settings_state_machine <= SET_SETTINGS;
                    end if;
                when FIFO_SETTINGS =>
                    if(TIME_IDS(id_index) = time_counter and NUMBER_SPIKES(id_index) < 4) then
                        for index in Sel'range loop
--                           for j in 0 to NUMBER_SPIKES(id_index)-1 loop
--                               if(index = SPIKES_IDS(id_index)(j)) then
--                                   Sel(index) <= '1';
--                               end if;
--                           end loop;
                        end loop;

                        Data_out <= synapses_enable(id_index);
                        adress_out <= adress_in;
                        -- settings_state_machine <= STATE_THREE;
                    end if;
                    time_counter <= time_counter+1;

                when SET_SETTINGS =>
                    if(Strl_is_selected = '0') then
                        settings_state_machine <= SETTINGS_IDLE;
                    else
                        Selection_i := to_integer(unsigned(Selection));
                        for index in Sel'range loop
                            if(index = Selection_i) then
                                Sel(index) <= '1';
                            else
                                Sel(index) <= '0';
                            end if;
                        end loop;
                        
                        Data_out <= Din;
                        adress_out <= adress_in;
                        settings_state_machine <= STATE_THREE;
                    end if;
                when STATE_THREE =>
                    if(Strl_is_selected = '0') then
                        settings_state_machine <= SETTINGS_IDLE;
                    else
                        counter_state <= counter_state+1;
                        if(counter_state = tsc_counter + tsc_counter)then
                            settings_state_machine <= SET_SETTINGS;
                            counter_state <= (others => '0');
                        end if;
                    end if;
            end case;
        end if;
    end process;
    
    
    strobe_process: process (clk)
        variable re_command_completed : integer range 0 to 1 := 0;
    begin
        if(reset = '1') then
            state_machine <= IDLE;
        elsif(rising_edge(clk)) then
            if(command_completed = '0') then
                re_command_completed := 0;
            end if;
            case state_machine is
                when IDLE =>
                    
                    Strb_out <= '0';
                    change_state <= (others => '0');
                    if(Strl_is_selected = '1') then
                        if(command_completed = '1' and re_command_completed = 0) then
                            state_machine <= DELAY;
                            Strb_out <= '0';
                            re_command_completed := 1;
                        elsif(Clr_out = '1') then
                            state_machine <= CLEAR;
                        end if;
                    end if;

                when DELAY => 

                    if(Strl_is_selected = '0' or (command_completed = '1' and re_command_completed = 0)) then
                        state_machine <= IDLE;
                    elsif Clr_out = '1' then
                        state_machine <= CLEAR;
                    else
                        if(change_state = tas_counter) then
                            state_machine <= STROBE_HIGH;
                            Strb_out <= '1';
                            change_state <= (others => '0');
                        else
                            change_state <= change_state+1;
                        end if;
                    end if;
                    
                when STROBE_LOW =>

                    if(Strl_is_selected = '0' or (command_completed = '1' and re_command_completed = 0)) then
                        state_machine <= IDLE;
                    elsif Clr_out = '1' then
                        state_machine <= CLEAR;
                    else
                        if(change_state = tsc_counter) then
                            state_machine <= STROBE_HIGH;
                            Strb_out <= not(Strb_out);
                            change_state <= (others => '0');
                        else
                            change_state <= change_state+1;
                        end if;
                    end if;
                    
                when STROBE_HIGH =>
                    if(Strl_is_selected = '0' or (command_completed = '1' and re_command_completed = 0)) then
                        state_machine <= IDLE;
                    elsif Clr_out = '1' then
                        state_machine <= CLEAR;
                    else
                        if(change_state = tsc_counter) then
                            state_machine <= STROBE_LOW;
                            Strb_out <= not(Strb_out);
                            change_state <= (others => '0');
                        else
                            change_state <= change_state+1;
                        end if;
                    end if;
                when CLEAR =>
                    Strb_out <= '0';
                    if(Strl_is_selected = '0' or (command_completed = '1' and re_command_completed = 0)) then
                        state_machine <= IDLE;
                    end if;
            end case;
        end if;
    end process;

    -- Register map -------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------

    adress_in(7 downto 0) <= register_map(0) when state_machine /= CLEAR else (others => '0');
    adress_in(11 downto 8) <= register_map(1)(3 downto 0) when state_machine /= CLEAR else (others => '0');
    Selection <= register_map(2);
    Din <= register_map(3)(0) when state_machine /= CLEAR else '0';
    Clr_out <= register_map(3)(1);
    command_completed <= register_map(3)(2);
    tsc_counter <= register_map(4);
    tas_counter <= register_map(5);

    reg_adress_read <= to_integer(unsigned(reg_requirements_read));
    reg_adress_write <= to_integer(unsigned(reg_requirements_write));
    register_read <= register_map(reg_adress_read) when (Strl_is_selected = '1') else (others => 'Z');
    
    regiter_process: process (clk)
    begin
        if(rising_edge(clk)) then
        
            register_map(0) <= adress_in(7 downto 0);
            register_map(1)(3 downto 0) <= adress_in(11 downto 8);
            register_map(1)(7 downto 4) <= "0000";
            register_map(2) <= Selection; --Compteur du nombre de bits dans le read register (sur 16 bits)
            register_map(3)(0) <= Din;
            register_map(3)(1) <= Clr_out;
            register_map(3)(2) <= command_completed;
            register_map(3)(7 downto 3) <= "00000";
            register_map(4) <= tsc_counter;
            register_map(5) <= tas_counter;
            register_map(6) <= FIFO_in;

            if(Strl_is_selected = '1' and write_enable = '1') then          
                if(reg_adress_write = 0 or reg_adress_write = 2 or reg_adress_write = 4 or reg_adress_write = 5 or reg_adress_write = 6) then
                    register_map(reg_adress_write) <= register_write;
                elsif(reg_adress_write = 1) then
                    register_map(reg_adress_write)(3 downto 0) <= register_write(3 downto 0);
                elsif(reg_adress_write = 3) then
                    register_map(reg_adress_write)(2 downto 0) <= register_write(2 downto 0);
                end if;
            end if;
        end if;

    end process;

    
    
--    -- FIFO ---------------------------------------------------------------------------------------------------------------------------------
--    -----------------------------------------------------------------------------------------------------------------------------------------

    STrI_FIFO: entity work.STD_FIFO
    generic map( 
    DATA_WIDTH => 8,
    MAX_FIFO_DEPTH => 2000000
    )
    port map(
    CLK     => clk,
    RST     => reset,
    Length  => 2000000,
    WriteEn => WriteEn,
    DataIn  => DataIn,
    ReadEn  => ReadEn,
    DataOut => DataOut,
    Empty   => Empty,
    Full    => Full
    );  
    

end Behavioral;




--                         for i in 0 to number_of_spikes_var-1 loop
--                             for j in 0 to 10 loop
--                                 k := k+1;
--                                 synaps_id_counter := synaps_id_counter - 1;
--                                 if(k > 6) then
--                                     k := 0;
--                                 end if;
--                                 if(synaps_id_counter = 0) then
--                                     synaps_id_counter := 10;
--                                 end if;
--                                 if(synaps_id_counter = 10) then
-- --                                    synapses_enable(i) <= DataOut(k);
--                                     null;
--                                 else
--                                     synaps_id(synaps_id_counter) <= DataOut(k);
--                                 end if;
                                
--                             end loop;
--                            synaps_selection(i) <= to_integer(unsigned(synaps_id));
--                         end loop;