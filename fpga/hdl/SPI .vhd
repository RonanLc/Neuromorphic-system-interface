-- Standard --
library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity SPI is
generic(
	DATA_LENGTH	: integer;	-- Nbits of all frame
	DELAY_SPI : integer
);
port(

	clk		: in std_logic; 							-- 50 MHz max
	clk_frequency   : in integer range 1 to 50;
	reset	: in std_logic;
	enable  : in std_logic;
	CPOL    : in std_logic;
	CPHA    : in std_logic;
	acq : out std_logic;
	
	-- Data handle --
	data_tx : in std_logic_vector(DATA_LENGTH-1 downto 0);		-- Data to send
	data_rx	: out std_logic_vector(DATA_LENGTH-1 downto 0);		-- Received data
	
	-- SPI standard type 2 -- 
	sclk 	: out std_logic := '0';
	cs 		: out std_logic := '0';
	mosi	: out std_logic := '0';							-- Master Out Slave In
	miso	: in std_logic

	-- led2 : out std_logic := '0'
	
);
end SPI;

architecture behavioral of SPI is

-- SPI tx handle ---------------------------------------
type SPI_Tx_state is (
	IDLE,
	TX1,
	ACQ_S
);
signal SPI_fsm 			: SPI_Tx_state := IDLE;
signal data_tx_temp		: std_logic_vector(DATA_LENGTH-1 downto 0);
signal shift_reg_counter: std_logic_vector((DATA_LENGTH/4)+1 downto 0) := (others => '0');
--------------------------------------------------------
-- SPI tx handle ---------------------------------------
signal buffer_rx : std_logic_vector(DATA_LENGTH-1 downto 0);
--------------------------------------------------------
-- Clock -----------------------------------------------
 signal sclk_en : std_logic := '0';
 signal clk_2Meg: std_logic := '0';
 --------------------------------------------------------
signal data_rx_test : std_logic_vector(7 downto 0);

signal Mode1 : std_logic;
signal Mode2 : std_logic;

signal rx_counter : integer := DATA_LENGTH-1;


begin

    acq <= '1' when SPI_fsm = ACQ_S else '0';
    data_rx <= data_rx_test;

	-- Send data through SPI --
	SPI_Tx : process(clk)
		variable clk_divider  : integer := 0;
		variable retrieved_value : integer := 0;
		variable clk_frequency_v : integer := 0;
		variable clk_period : integer :=0;
		variable delay : integer := 1000;
	begin
		if rising_edge(clk) then
			if reset = '1' then
				mosi				<= '0';
				data_tx_temp	    <= (others => '0');
				shift_reg_counter 	<= (others => '0');
				SPI_fsm				<= IDLE;
				cs                  <= '1';
				data_rx_test        <= (others => '0');

			else
				
				case SPI_fsm is
					-- Waiting the enable signal --
					when IDLE =>
					    sclk_en <= '0';
					    
						-- Enable is detected --
						if enable = '1' then
							SPI_fsm		  <= TX1;
							data_tx_temp  <= data_tx;
							cs			  <= '0';
							sclk_en 	  <= '0';
						end if;

					-- Shift the frame register and send the MSB through MOSI
					when TX1 =>
						
					    cs       <= '0';
						if shift_reg_counter > DATA_LENGTH-1 then							
							shift_reg_counter 	<= (others => '0');
							SPI_fsm				<= ACQ_S;
							buffer_rx(0) <= miso;
							rx_counter <= DATA_LENGTH-1;
							sclk_en <= '0';
							data_tx_temp	<= data_tx;
						elsif(shift_reg_counter = 0) then
						    shift_reg_counter <= shift_reg_counter + 1;
							data_tx_temp(DATA_LENGTH-1 downto 1) <= data_tx_temp(DATA_LENGTH-2 downto 0);
							buffer_rx(rx_counter) <= miso;
							sclk_en <= '1';
						else
							shift_reg_counter <= shift_reg_counter + 1;
							data_tx_temp(DATA_LENGTH-1 downto 1) <= data_tx_temp(DATA_LENGTH-2 downto 0);					
							rx_counter <= rx_counter-1;	
							buffer_rx(rx_counter) <= miso;
							sclk_en <= '1';
							-- led2 <= '1';
						end if;
						
						mosi <= data_tx_temp(DATA_LENGTH-1);

					when ACQ_S =>
						mosi 		<= '0';
						sclk_en     <= '0';
					    data_rx_test     <= buffer_rx;
						cs <= '1';
						
						clk_divider := clk_divider + 1;
--						clk_frequency_v := to_integer(unsigned(clk_frequency));
						clk_period := 1000/clk_frequency; -- clock period in ns
						delay := (1000*DELAY_SPI)/clk_period;
						if(clk_divider >= delay) then
							clk_divider := 0;
							SPI_fsm		<= IDLE;
						end if;

				end case;
		    end if;
		end if;
	end process;
	
	Mode1 <= clk when sclk_en='1' else CPOL;
	Mode2 <= not(clk) when sclk_en='1' else CPOL;
	
	
	sclk	<= 	Mode1 when CPHA = '1' else Mode2;
end behavioral;