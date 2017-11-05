library IEEE;
use IEEE.STD_LOGIC_1164;
use IEEE.NUMERIC_STD.ALL;

entity tb_scales is end;

architecture behavioural of tb_scales is
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
    
    signal scale: unsigned(4 downto 0) := (others => '0');
    signal scale_3, scale_4: unsigned(6 downto 0);
    signal scale_5, scale_6, scale_7, scale_8: unsigned(7 downto 0);
    signal scale_9, scale_10, scale_11, scale_12, scale_14: unsigned(8 downto 0);
begin
    uut: scales
        port map(
            scale => scale,
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

    scale <= scale + 1 after 10ns;
end;
