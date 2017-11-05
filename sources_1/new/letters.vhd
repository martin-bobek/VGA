library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity letters is
    port(
        scale: in std_logic_vector(4 downto 0);
        x_coord: in std_logic_vector(9 downto 0);
        y_coord: in std_logic_vector(8 downto 0);
        letter: out std_logic
    );
end;

architecture behavioural of letters is
    component scales is
        port(
            scale: in unsigned(4 downto 0);
            scale_3: out unsigned(6 downto 0);
            scale_4: out unsigned(6 downto 0);
            scale_5: out unsigned(7 downto 0);
            scale_6: out unsigned(7 downto 0);
            scale_7: out unsigned(7 downto 0);
            scale_8: out unsigned(7 downto 0);
            scale_9: out unsigned(8 downto 0);
            scale_10: out unsigned(8 downto 0);
            scale_11: out unsigned(8 downto 0);
            scale_12: out unsigned(8 downto 0);
            scale_14: out unsigned(8 downto 0)
        );
    end component;

    signal scale_1: unsigned(4 downto 0);
    signal scale_3, scale_4: unsigned(6 downto 0);
    signal scale_5, scale_6, scale_7, scale_8: unsigned(7 downto 0);
    signal scale_9, scale_10, scale_11, scale_12, scale_14: unsigned(8 downto 0);
    
    signal u_x_coord: unsigned(9 downto 0);
    signal u_y_coord: unsigned(8 downto 0);
    signal u_x_coord_2: unsigned(10 downto 0);
begin
    u_x_coord <= unsigned(x_coord);
    u_x_coord_2 <= u_x_coord & '0';
    u_y_coord <= unsigned(y_coord);
    scale_1 <= unsigned(scale);
    
    mult: scales
        port map(
            scale => scale_1,
            scale_3 => scale_3,
            scale_4 => scale_4,
            scale_5 => scale_5,
            scale_6 => scale_6,
            scale_7 => scale_7,
            scale_8 => scale_8,
            scale_9 => scale_9,
            scale_10 => scale_10,
            scale_11 => scale_11,
            scale_12 => scale_12,
            scale_14 => scale_14
        );
    
    process(scale_1, scale_3, scale_4, scale_5, scale_6, scale_7, scale_8, scale_9, scale_10, scale_11, scale_12, scale_14, u_x_coord, u_y_coord) begin
        if (u_x_coord < scale_1) then
            if (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_3) then
            if (u_y_coord < scale_1) then
                letter <= '1';
            elsif (u_y_coord < scale_3) then
                letter <= '0';
            elsif (u_y_coord < scale_4) then
                letter <= '1';
            elsif (u_y_coord < scale_6) then
                letter <= '0';
            elsif (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_4) then
            if (u_y_coord < scale_1) then
                if (u_y_coord + scale_3 >= u_x_coord) then
                    letter <= '1';
                else
                    letter <= '0';
                end if;
            elsif (u_y_coord < scale_3) then
                letter <= '1';
            elsif (u_y_coord < scale_4) then
                if (u_y_coord >= u_x_coord) or (('0' & u_x_coord) + u_y_coord < scale_7) then
                    letter <= '1';
                else
                    letter <= '0';
                end if;
            elsif (u_y_coord < scale_6) then
                letter <= '1';
            elsif (u_y_coord < scale_7) then
                if (('0' & u_x_coord) + u_y_coord < scale_10) then
                    letter <= '1';
                else
                    letter <= '0';
                end if;
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_5) then
            letter <= '0';
        elsif (u_x_coord < scale_6) then
            if (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_8) then
            if (('0' & u_y_coord) + scale_12 >= u_x_coord_2) and (('0' & u_y_coord) + scale_9 < u_x_coord_2) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_9) then
            if (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_10) then
            letter <= '0';
        elsif (u_x_coord < scale_11) then
            if (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        elsif (u_x_coord < scale_14) then
            if (u_y_coord < scale_6) then
                letter <= '0';
            elsif (u_y_coord < scale_7) then
                letter <= '1';
            else
                letter <= '0';
            end if;
        else
            letter <= '0';
        end if;
    end process;
end;
