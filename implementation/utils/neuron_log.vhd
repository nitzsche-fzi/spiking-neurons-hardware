library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;
use std.env.all;

entity logger is
    generic (
        OUTPUT_PATH : string := "output.csv"
    );
    port (
        clk: in std_logic;
        end_of_test: in boolean;
        x: in real;
        y: in real
    );
end logger;

architecture logger_impl of logger is    
begin
    process(clk)    
        file file_handler     : text open write_mode is OUTPUT_PATH;
        variable row          : line;
        variable last_x : real;
        variable first: boolean := true;      
    begin
        if rising_edge(clk) then
            if not end_of_test then
                if not first then
                    write(row, last_x);
                    write(row, y, right, 14);
                    writeline(file_handler, row);
                end if;          
                first := false;
                last_x := x;
            else
                file_close(file_handler);
                finish(0);
            end if;
        end if;
    end process;   
end logger_impl;