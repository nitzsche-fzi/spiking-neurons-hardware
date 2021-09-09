library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rng is
    generic (
        MIN : real := 0.0;
        MAX : real := 1.0
    );
    port (
        clk: in std_logic;
        random_number: out real
    );
end rng;

architecture rng_impl of rng is    
begin
    process(clk)       
    variable r : real;
    variable seed1, seed2 : integer := 999;
    begin
        if rising_edge(clk) then
            uniform(seed1, seed2, r);
            random_number <= r * (MAX - MIN) + MIN;
        end if;
    end process;   
end rng_impl;