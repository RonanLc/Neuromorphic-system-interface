-- ===================================================================================
-- UART handle tx
--
-- Version      : V 1.0
-- Creation     : 05/04/2016
-- Update       : 05/04/2016
-- Created by   : KHOYRATEE Farad
-- Updated by   : KHOYRATEE Farad
-- 
-- Purpose      :
--      * Send data through Tx Line for UART
--
-- Update       :
--
-- ===================================================================================

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity UART_tr is
generic(
	CLOCK_F	   :   integer range 0 to 200;	-- Clock frequency MHz
	BAUD_RATE  :   integer range 0 to 3_000_000;
	EN_PARITY  :   std_logic := '0'
);
port(
	clk		: in	std_logic;
	rst		: in	std_logic;
	
	en_tx	: in	std_logic;
	tx_data	: in	std_logic_vector(7 downto 0);
	
	stop_tx : out	std_logic;
	tx		: out	std_logic := '1'
	
);
end UART_tr;

architecture behavioral of UART_tr is

--  Tx line is high when sleeping -----------------------------------------------------------------------------------------
type state is (
	IDLE,                          --  Waiting authorization to send data send start bit ('0')
	DATA,                          --  Send the LSB on Tx line and shift register to the left (send all data bit to bit)
	PARITY,                        --  If parity bit activated
	STOP_1,                        --  First stop bit 
	STOP_2                         --  Last stop bit
);

signal tx_fsm : state:= IDLE;

signal clock_rs232_en	: std_logic;
signal tx_data_reg      : std_logic_vector(7 downto 0);

begin

-- Generate a clock according to the baud rate --------------------------
clock_generation : process(clk, rst)
	variable clock_counter: integer := 0;
begin
	if rst='1' then
		clock_counter 	:= 0;
		clock_rs232_en	<= '0';
	elsif rising_edge(clk) then
		if clock_counter > ((CLOCK_F*1_000_000)/BAUD_RATE)-1 then
			clock_counter 	:= 0;
			clock_rs232_en	<= '1';
		else
			clock_counter 	:= clock_counter + 1;
			clock_rs232_en	<= '0';
		end if;
	end if;
end process;

-- Frame Handle : Create a frame which follow the RS232 standard ----------
tx_handle : process(clk, rst)
	variable counter       : integer range 0 to 7:=0;
begin
    if rst='1' then
        tx 			<= '1';
		stop_tx		<= '0';
		tx_data_reg <= (tx_data_reg'range => '0');
    elsif rising_edge(clk) then
        if clock_rs232_en='1' then
            tx          <= '1';                     --  When sending is disable UART line is high
			tx_data_reg <= X"00";                   --  No data to send    
            case tx_fsm is
                when IDLE =>
					stop_tx 	<= '0';             --  UART is available to send
                    if en_tx = '1' then             --  Wait authorization to send data
                        tx 			<= '0';             --  Start bit is '0'    
                        tx_data_reg <= tx_data;         --  Save the data to send into a register
                        tx_fsm 		<= DATA;            --  Next state
                    end if;
                when DATA =>                        --  Shift register and send data
                    tx <= tx_data_reg(0);               --  Send the LSB to the Tx line
                    if counter > 6 then                 --  Last bit is sent
                        if EN_PARITY='1' then               --  Parity is activated ?
                            tx_fsm <= PARITY;                   -- Yes => state PARITY
                        else
                            tx_fsm <= STOP_1;                   -- Nop => send the bit stop
                        end if;
                        counter	:= 0;                           --  reset counter
                    else                                --  Last bit isn't sent
                        tx_data_reg(6 downto 0) <= tx_data_reg(7 downto 1); --  shift the register to the left
                        counter	:= counter + 1;             --  Increment counter        
                    end if;
                when PARITY =>
                    tx <= '0';
                    tx_fsm <= STOP_1;
                when STOP_1 =>                      --  First stop bit
                    tx		<= '1';
                    tx_fsm	<= STOP_2;                  --return to first state  --Next state which is last stop bit
                when STOP_2 =>                      --  Last stop bit
                    tx		<= '1';                     --  Stop bit is high
                    stop_tx <= '1';                     --  ACK
                    tx_fsm  <= IDLE;                    --  Return to the first state
            end case;
        end if;
    end if;
end process;

end behavioral;