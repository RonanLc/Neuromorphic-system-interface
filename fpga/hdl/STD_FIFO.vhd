library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity STD_FIFO is
    Generic ( 
        constant DATA_WIDTH : positive;
        constant MAX_FIFO_DEPTH : positive
    );
    Port (CLK    : in  STD_LOGIC;
        RST    : in  STD_LOGIC;
        Length : in integer;
        WriteEn: in  STD_LOGIC;
        DataIn : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
        ReadEn : in  STD_LOGIC;
        DataOut: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) := (others => 'Z');
        Empty  : out STD_LOGIC := '1';
        Full   : out STD_LOGIC := '0'
    );
end STD_FIFO;

architecture Behavioral of STD_FIFO is
    
    signal Head : integer range 0 to MAX_FIFO_DEPTH-1 := 0;
    signal Tail : integer range 0 to MAX_FIFO_DEPTH-1 := 0;

    type FIFO_Memory is array (natural range 0 to MAX_FIFO_DEPTH-1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal Memory : FIFO_Memory;
    signal Looped : boolean;

begin

    

    FIFO_proc: process (CLK)
    begin
        if rising_edge(CLK) then
                
            if RST = '1' then
                Head <= 0;
                Tail <= 0;
                Looped <= false;
                Full <= '0';
                Empty <= '1';
            
            else  
                     
                if (ReadEn = '1') then
                    if ((Looped = true) or (Head /= Tail)) then
                        DataOut <= Memory(Tail);
                        if(Tail >= Length-1) then
                            Tail <= 0;
                            Looped <= false;
                        else
                            Tail <= Tail+1;
                        end if;
                    end if;
                end if;
                
                if (WriteEn = '1') then
                    if ((Looped = false) or (Head /= Tail)) then
                        Memory(Head) <= DataIn;
                        if (Head >= Length-1) then
                            Head <= 0;
                            Looped <= true;
                        else
                            Head <= Head+1;
                        end if;
                    end if;
                end if;
            end if;

            if(Head = Tail) then
                if Looped then
                    Full <= '1';
                else
                    Empty <= '1';
                end if;
            else
                Empty <= '0';
                Full <= '0';
            end if;
        end if;
    end process;

end Behavioral;