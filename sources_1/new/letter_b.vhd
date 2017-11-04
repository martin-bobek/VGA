library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity letter_b is
    port(
        scale: in std_logic_vector(4 downto 0);
        x_coord: in std_logic_vector(10 downto 0);
        y_coord: in std_logic_vector(10 downto 0);
        contained: out std_logic
    );
end;

architecture behavioural of letter_b is
begin
    contain: process(scale, x_coord, y_coord) begin
        if (unsigned(x_coord) < unsigned(scale)) then
            if (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 3 * unsigned(scale)) then
            if (unsigned(y_coord) < unsigned(scale)) then
                contained <= '1';
            elsif (unsigned(y_coord) < 3 * unsigned(scale)) then
                contained <= '0';
            elsif (unsigned(y_coord) < 4 * unsigned(scale)) then
                contained <= '1';
            elsif (unsigned(y_coord) < 6 * unsigned(scale)) then
                contained <= '0';
            elsif (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 4 * unsigned(scale)) then
            if (unsigned(y_coord) < unsigned(scale)) then
                if (unsigned(y_coord) + 3 * unsigned(scale) >= unsigned(x_coord)) then
                    contained <= '1';
                else
                    contained <= '0';
                end if;
            elsif (unsigned(y_coord) < 3 * unsigned(scale)) then
                contained <= '1';
            elsif (unsigned(y_coord) < 4 * unsigned(scale)) then
                if ((unsigned(y_coord) >= unsigned(x_coord)) or (unsigned(y_coord) + unsigned(x_coord) < 7 * unsigned(scale))) then
                    contained <= '1';
                else
                    contained <= '0';
                end if;
            elsif (unsigned(y_coord) < 6 * unsigned(scale)) then
                contained <= '1';
            elsif (unsigned(y_coord) < 7 * unsigned(scale)) then
                if (unsigned(y_coord) + unsigned(x_coord) < 10 * unsigned(scale)) then
                    contained <= '1';
                else
                    contained <= '0';
                end if;
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 5 * unsigned(scale)) then
            contained <= '0';
        elsif (unsigned(x_coord) < 6 * unsigned(scale)) then
            if (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 8 * unsigned(scale)) then
            if ( (unsigned(y_coord) + 12 * unsigned(scale) >= 2 * unsigned(x_coord)) and-- (unsigned(y_coord) + 14 * unsigned(scale) >= 2 * unsigned(x_coord)) and
                (unsigned(y_coord) + 9 * unsigned(scale) < 2 * unsigned(x_coord))) then --(unsigned(y_coord) + 15 * unsigned(scale) < 2 * unsigned(x_coord))) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 9 * unsigned(scale)) then
            if (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 10 * unsigned(scale)) then
            contained <= '0';
        elsif (unsigned(x_coord) < 11 * unsigned(scale)) then
            if (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        elsif (unsigned(x_coord) < 14 * unsigned(scale)) then
            if (unsigned(y_coord) < 6 * unsigned(scale)) then
                contained <= '0';
            elsif (unsigned(y_coord) < 7 * unsigned(scale)) then
                contained <= '1';
            else
                contained <= '0';
            end if;
        else
            contained <= '0';
        end if;
    end process;
end;