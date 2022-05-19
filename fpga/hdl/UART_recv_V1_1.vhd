----------------------------------------------------------------------------------
--
-- UART_recv_V1
-- Version 1.3
-- Written by Yannick Bornat (2014/01/27)
-- Updated by Yannick Bornat (2014/05/12) : output is now synchronous
-- Updated by Yannick Bornat (2014/06/10) :
--    V1.1 : totally rewritten 
--       reception is now more reliable
--       for 3Mbps @50MHz, it is safer to use 1.5 or 2 stop bits.
-- Updated by Yannick Bornat (2014/08/04) :
--    V1.2 : Added slow values for instrumentation compatibility
-- Updated by Yannick Bornat (2015/10/20) :
--    V1.3 : Fixed integer range declarations that did not fit powers of 2
--
-- Receives a char on the UART line
-- dat_en is set for one clock period when a char is received 
-- dat must be read at the same time
-- 
-- speed defines the baudrate of the line (SLOW_VALUES=0):
--    00 : 115.200kbps
--    01 : 921.600kbps
--    10 : 2.0000 Mbps
--    11 : 3.0000 Mbps
--
-- speed defines the baudrate of the line (SLOW_VALUES=1):
--    00 : 115.200kbps
--    01 :  57.600kbps
--    10 :  38.400kbps
--    11 :   9.600kbps
--
-- UPDATES :
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity UART_recv_V1 is
   Generic ( clk100M     : integer range 0 to 1:=0;
             SLOW_VALUES : integer range 0 to 1:=0);
   Port ( clk    : in  STD_LOGIC;
          reset  : in  STD_LOGIC;
          speed  : in  STD_LOGIC_VECTOR(1 downto 0);
          rx     : in  STD_LOGIC;
          dat    : out STD_LOGIC_VECTOR (7 downto 0);
          dat_en : out STD_LOGIC);
end UART_recv_V1;

architecture Behavioral of UART_recv_V1 is

type t_fsm is (idle, zero_as_input, wait_next_bit, bit_sample, bit_received, wait_stop_bit, last_bit_is_zero);
  -- idle            : the normal waiting state (input should always be 1)
  -- zero_as_input   : we received a '1' in input but it may be noise
  -- wait_next_bit   : we just received an input that remained unchanged for 1/4 of the bit period, we wait for 3/4 to finish timeslot
  -- bit_sample      : we wait for a bit to last at least 1/4 of the period without changing
  -- bit_received    : a bit was received during 1/4 of period, so it is valid
  -- wait_stop_bit   : the last bit was a stop, we wait for it to finish (1/2 of period)
  -- last_bit_is_zero: well last bit was not a stop, we wait for a 1 that lasts a full period...
  
  
  
signal state : t_fsm := idle;
signal nbbits: integer range 0 to 9:=0;
signal cnt   : integer range -1 to 511*(1+clk100M)*(1+SLOW_VALUES*15)-1;
signal rxi   : std_logic:='1';
signal ref_bit          : std_logic;
signal shift : STD_LOGIC_VECTOR (7 downto 0);



signal quarter          : integer range 0 to 127*(1+clk100M)*(1+SLOW_VALUES*15)-1;
signal half             : integer range 0 to 255*(1+clk100M)*(1+SLOW_VALUES*15)-1;
signal three_quarters   : integer range 0 to 511*(1+clk100M)*(1+SLOW_VALUES*15)-1;
signal full             : integer range 0 to 511*(1+clk100M)*(1+SLOW_VALUES*15)-1;



begin

-- we fisrt need to sample the input signal
process(clk)
begin
	if clk'event and clk='1' then
		rxi <= rx;
	end if;
end process;

-- the FSM of the module...
process(clk)
begin
   if rising_edge(clk) then
      if reset='1' then
         state <= idle;
      else
         case state is
            when idle            => if rxi    = '0' then state <= zero_as_input;    end if;
            when zero_as_input   => if rxi    = '1' then state <= idle;
                                 elsif cnt    =  0  then state <= wait_next_bit;    end if;
            when wait_next_bit   => if cnt    =  0  then state <= bit_sample;       end if;
            when bit_sample      => if cnt    =  0  then state <= bit_received;     end if;
            when bit_received    => if nbbits <  8  then state <= wait_next_bit;
                                 elsif ref_bit= '1' then state <= wait_stop_bit;
                                                    else state <= last_bit_is_zero; end if;
            when wait_stop_bit   => if rxi    = '0' then state <= last_bit_is_zero;
                                 elsif cnt    =  0  then state <= idle;             end if;
            when last_bit_is_zero=> if cnt    =  0  then state <= idle;             end if;
         end case;
      end if;
   end if;
end process;

-- here we manage the counter 
process(clk)
begin
   if rising_edge(clk) then
      if reset='1' then
         cnt <= quarter;
      else
         case state is
            when idle            =>                        cnt <= quarter;
            when zero_as_input   => if cnt = 0        then cnt <= three_quarters;               -- transition, we prepare the next waiting time
                                                      else cnt <= cnt - 1;          end if;
            when wait_next_bit   => if cnt = 0        then cnt <= quarter;                      -- transition, we prepare the next waiting time
                                                      else cnt <= cnt - 1;          end if;
            when bit_sample      => if ref_bit /= rxi then cnt <= quarter;                -- if bit change, we restart the counter
                                                      else cnt <= cnt - 1;          end if;
            when bit_received    => if nbbits <  8    then cnt <= three_quarters;
                                 elsif ref_bit = '0'  then cnt <= full;
                                                      else cnt <= half;             end if;
            when wait_stop_bit   =>                        cnt <= cnt - 1;
            when last_bit_is_zero=> if rxi = '0'      then cnt <= full;
                                                      else cnt <= cnt - 1;          end if;
         end case;
      end if;
   end if;
end process;

-- we now manage the reference bit that should remain constant for 1/4 period during bit_sample
-- we affect ref_bit in both wait_next_bit (so that we arrive in bit_sample with initialized value)
-- and in bit_sample because if different, we consider each previous value as a mistake, and if equal
-- it has no consequence...
process(clk)
begin
   if rising_edge(clk) then
      if state = wait_next_bit or state = bit_sample then
         ref_bit <= rxi;
      end if;
   end if;
end process;


-- output (shift) register
process (clk)
begin
   if rising_edge(clk) then
      if state = bit_sample and cnt = 0 and nbbits < 8 then
         shift <= ref_bit & shift (7 downto 1);
      end if;
   end if;
end process;


-- nbbits management
process (clk)
begin
   if rising_edge(clk) then
      if state = idle then
         nbbits <= 0;
      elsif state = bit_received then
         nbbits <= nbbits + 1;
      end if;
   end if;
end process;

-- outputs
process(clk)
begin
   if rising_edge(clk) then
      if reset = '1' then
         dat_en <= '0';
         dat    <= (others => '0');
      elsif state = wait_stop_bit and cnt = 0 then
         dat_en <= '1';
         dat    <= shift;
      else
         dat_en <= '0';
      end if;
   end if;
end process;

-- timings
-- we consider truncated values, if we sample too early, the bit_sample will resynchronize
-- the state machine, to manage too high input frequency and compensate the bit_received state,
-- 3/4 value is only 99% of the expected value, finally, all values are minored by 1 because
-- we count till 0
-- 
process(clk)
begin
   if rising_edge(clk) then
      if SLOW_VALUES = 0 then
         if clk100M=0 then
            case speed is
               when  "00"  =>    --  50MHz / 115200 bps
                  quarter         <= 107;    -- 108.507
                  half            <= 216;    -- 217.014    
                  three_quarters  <= 321;    -- 322.265 = 99% of 325.521
                  full            <= 433;    -- 434.028
               when  "01"  =>    --  50MHz / 921600 bps
                  quarter         <=  12;    --  13.563
                  half            <=  26;    --  27.127
                  three_quarters  <=  39;    --  40.283 = 99% of 40.690
                  full            <=  53;    --  54.253            
               when  "10"  =>    --  50MHz / 2Mbps
                  quarter         <=   5;    --   6.250
                  half            <=  11;    --  12.500
                  three_quarters  <=  17;    --  18.563 = 99% of 18.750
                  full            <=  24;    --  25.000            
               when others =>    --  50MHz / 3Mbps
                  quarter         <=   3;    --   4.167
                  half            <=   7;    --   8.333
                  three_quarters  <=  11;    --  12.375 = 99% of 12.500
                  full            <=  15;    --  16.667                        
            end case;
         else
            case speed is
               when  "00"  =>    --  100MHz / 115200 bps
                  quarter         <= 216;    -- 217.014
                  half            <= 433;    -- 434.028
                  three_quarters  <= 643;    -- 644.531 = 99% of 651.042
                  full            <= 867;    -- 868.056
               when  "01"  =>    
                  -- 56MHz / 921600 bps 
                  quarter         <= 14;
                  half            <= 29;
                  three_quarters  <= 44;
                  full            <= 59;
                  -- 96 MHZ / 921600 bps 
                  -- quarter         <= 25;
                  -- half            <= 51;
                  -- three_quarters  <= 76;
                  -- full            <= 103;
                  -- 100MHz / 921600 bps
                  -- quarter         <=  26;    --  27.127
                  -- half            <=  53;    --  54.253
                  -- three_quarters  <=  79;    --  80.566 = 99% of 81.380
                  -- full            <= 107;    --  108.507
               when  "10"  =>    --  100MHz / 2Mbps
                  quarter         <=  11;    --  12.500
                  half            <=  24;    --  25.000
                  three_quarters  <=  36;    --  37.125 = 99% of 37.500
                  full            <=  49;    --  50.000
               when others =>    --  100MHz / 3Mbps
                  quarter         <=   7;    --   8.333
                  half            <=  15;    --  16.667
                  three_quarters  <=  23;    --  24.750 = 99% of 25.000
                  full            <=  32;    --  33.333                        
            end case;
         end if;
      else -- SLOW_VALUES = 1
         if clk100M=0 then
            case speed is
               when  "00"  =>    --  50MHz / 115200 bps
                  quarter         <= 107;    -- 108.507
                  half            <= 216;    -- 217.014    
                  three_quarters  <= 321;    -- 322.265 = 99% of 325.521
                  full            <= 433;    -- 434.028
               when  "01"  =>    --  50MHz /  57600 bps
                  quarter         <= 216;    -- 217.014
                  half            <= 433;    -- 434.028
                  three_quarters  <= 643;    -- 644.531 = 99% of 651.042
                  full            <= 867;    -- 868.056            
               when  "10"  =>    --  50MHz /  38400 bps
                  quarter         <= 324;    --  325.521
                  half            <= 650;    --  651.042
                  three_quarters  <= 965;    --  966.797 = 99% of 976.562
                  full            <=1301;    -- 1302.083
               when others =>    --  50MHz /   9600 bps
                  quarter         <=1301;    -- 1302.083
                  half            <=2603;    -- 2604.167
                  three_quarters  <=3866;    -- 3867.187 = 99% of 3906.250
                  full            <=5207;    -- 5208.333                        
            end case;
         else
            case speed is
               when  "00"  =>    --  100MHz / 115200 bps
                  quarter         <=  216;    --  217.014
                  half            <=  433;    --  434.028
                  three_quarters  <=  643;    --  644.531 = 99% of 651.042
                  full            <=  867;    --  868.056
               when  "01"  =>    --  100MHz /  57600 bps
                  quarter         <=  433;    --  434.028
                  half            <=  867;    --  868.056
                  three_quarters  <= 1288;    -- 1289.063 = 99% of 1302.084
                  full            <= 1735;    -- 1736.112
               when  "10"  =>    --  100MHz /  38400 bps
                  quarter         <=  650;    --  651.042
                  half            <= 1301;    -- 1302.083
                  three_quarters  <= 1932;    -- 1933.594 = 99% of 1953.125
                  full            <= 2603;    -- 2604.167
               when others =>    --  100MHz /   9600 bps
                  quarter         <= 2603;    -- 2604.167
                  half            <= 5207;    -- 5208.333
                  three_quarters  <= 7733;    -- 7734.375 = 99% of 7812.500
                  full            <=10415;    --10416.667                        
            end case;
         end if;

      end if;
   end if;
end process;

end Behavioral;