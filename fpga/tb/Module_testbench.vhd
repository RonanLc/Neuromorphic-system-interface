library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Top_tb is
end;

architecture bench of Top_tb is

  component Top
    generic (
      TARGET_AMOUNT : positive := 10
    );
      port (
      clk : in std_logic;
      reset : in std_logic;
      tx : out std_logic;
      rx : in std_logic;
      SPI_sclk : out std_logic;
      SPI_cs : out std_logic;
      SPI_mosi : out std_logic;
      SPI_miso : in std_logic;
      led1 : out std_logic;
      led2 : out std_logic
    );
  end component;

  -- Clock period
  constant clk_period : time := 83 ns;
  -- Generics
  constant TARGET_AMOUNT : positive := 15;

  -- Ports
  signal clk : std_logic;
  signal reset : std_logic;
  signal tx : std_logic;
  signal rx : std_logic;
  signal SPI_sclk : std_logic;
  signal SPI_cs : std_logic;
  signal SPI_mosi : std_logic;
  signal SPI_miso : std_logic;
  signal led1 : std_logic;
  signal led2 : std_logic;

begin

  Top_inst : Top
    generic map (
      TARGET_AMOUNT => TARGET_AMOUNT
    )
    port map (
      clk => clk,
      reset => reset,
      tx => tx,
      rx => rx,
      SPI_sclk => SPI_sclk,
      SPI_cs => SPI_cs,
      SPI_mosi => SPI_mosi,
      SPI_miso => SPI_miso,
      led1 => led1,
      led2 => led2
    );

    clk_process : process
    begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
    end process clk_process;
    
    reset <= '0';
    -- SPI_miso <= '1';
    miso_process: process
    begin
      SPI_miso <= '1';
      wait for 1115 ns;
      SPI_miso <= '0';
      wait for 1789 ns;
    end process;

     rx_process: process
     begin
       rx <= '1';
       wait for 59 us;

       -- S
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- P
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- I
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
      
       -- x
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- espace
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
      
       -- 0
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
      
       -- espace
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- W
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- R
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- espace
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- 1
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

       -- 0
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

     -- cariage return
     rx <= '0';
     wait for 333 ns;
     rx <= '1';
     wait for 333 ns;
     rx <= '0';
     wait for 333 ns;
     rx <= '1';
     wait for 333 ns;
     rx <= '1';
     wait for 333 ns;
     rx <= '0';
     wait for 333 ns;
     rx <= '0';
     wait for 333 ns;
     rx <= '0';
     wait for 333 ns;
     rx <= '0';
     wait for 333 ns;
     rx <= '1';
     wait for 333 ns;
     
     -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- a
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       
       -- z
       rx <= '0';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;
       rx <= '0';
       wait for 333 ns;
       rx <= '1';
       wait for 333 ns;

     end process;
    
    -- rx_process: process
    -- begin
    --   rx <= '1';
    --   wait for 59 us;

    --   -- S
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- T
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- r
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
      
    --   -- I
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- espace
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
      
    --   -- 0
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
      
    --   -- espace
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- E
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- N
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- espace
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- 1
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    --   -- 0
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '0';
    --   wait for 333 ns;
    --   rx <= '1';
    --   wait for 333 ns;

    -- -- cariage return
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '1';
    -- wait for 333 ns;
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '1';
    -- wait for 333 ns;
    -- rx <= '1';
    -- wait for 333 ns;
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '0';
    -- wait for 333 ns;
    -- rx <= '1';
    -- wait for 333 ns;

    -- end process;


--    rx_process: process
--    begin
--        rx <= '1';
--        wait for 59 us;

             
--        -- S
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- T
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- r
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
        
--        -- I
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- espace
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
        
--        -- 0
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
        
--        -- espace
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
        
--        -- D
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- F
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

        
--        -- espace
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- 2
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- 0
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- cariage return
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

------------------------------------------------------------------------------------------------------------------------------------------------
--        -- Frame 1
--        -- Time ID 1
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------

--        -- Time ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Time ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ---------------
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;

--        -- Number of spikes 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------
        
--        -- Number of spikes 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;

--        -- Synaps ID 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------


--        -- Synaps ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Synaps ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------

--        -- enalble
--        rx <= '0';
--        wait for 333 ns;

--        -- Synaps ID 2
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Synaps ID 4
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;

--        -- enalble
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Stuffing
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Frame 2
--        -- Time ID 1
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------

--        -- Time ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Time ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ---------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;

--        -- Number of spikes 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------
        
--        -- Number of spikes 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- Synaps ID 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------


--        -- Synaps ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Synaps ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Frame 3
--        -- Time ID 1
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------

--        -- Time ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Time ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ---------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;

--        -- Number of spikes 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------
        
--        -- Number of spikes 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;

--        -- Synaps ID 1
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ----------------


--        -- Synaps ID 2
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '1';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------

--        -- Synaps ID 3
--        -- start of frame
--        rx <= '0';
--        wait for 333 ns;
--        ----------------
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        rx <= '0';
--        wait for 333 ns;
--        -- end of frame
--        rx <= '1';
--        wait for 333 ns;
--        ---------------


        

---- ----------------------------------------------------------------------------------------------------------------------------------------------

--      -- S
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- T
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- r
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- I
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- espace
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- 0
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- espace
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- S
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- G
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- espace
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
      
--      -- S
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- T
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- A
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- R
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- T
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
    
--      -- cariage return
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '0';
--      wait for 333 ns;
--      rx <= '1';
--      wait for 333 ns;


--    rx <= '1';
--    wait for 10 us;
    
--    end process;
end;
