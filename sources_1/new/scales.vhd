library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scales is
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
end;

architecture behavioural of scales is
    signal i_scale_2: unsigned(5 downto 0);
    signal i_scale_3, i_scale_4: unsigned(6 downto 0);
    signal i_scale_5, i_scale_6, i_scale_7, i_scale_8: unsigned(7 downto 0);
    signal i_scale_9, i_scale_10, i_scale_11, i_scale_12, i_scale_14: unsigned(8 downto 0);
begin
    scale_3 <= i_scale_3;
    scale_4 <= i_scale_4;
    scale_5 <= i_scale_5;
    scale_6 <= i_scale_6;
    scale_7 <= i_scale_7;
    scale_8 <= i_scale_8;
    scale_9 <= i_scale_9;
    scale_10 <= i_scale_10;
    scale_11 <= i_scale_11;
    scale_12 <= i_scale_12;
    scale_14 <= i_scale_14;

    i_scale_2 <= scale & '0';
    i_scale_3 <= ('0' & i_scale_2) + scale;
    i_scale_4 <= i_scale_2 & '0';
    i_scale_5 <= ('0' & i_scale_4) + scale;
    i_scale_6 <= ('0' & i_scale_4) + i_scale_2;
    i_scale_7 <= i_scale_6 + scale;
    i_scale_8 <= i_scale_4 & '0';
    i_scale_9 <= ('0' & i_scale_8) + scale;
    i_scale_10 <= ('0' & i_scale_8) + i_scale_2;
    i_scale_11 <= i_scale_10 + scale;
    i_scale_12 <= ('0' & i_scale_8) + i_scale_4;
    i_scale_14 <= i_scale_12 + i_scale_2;
end;
