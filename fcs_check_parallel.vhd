library IEEE;
use ieee.std_logic_1164.all;

entity fcs_check_parallel is
  port ( 
    clk            : in std_logic; -- system clock
    reset          : in std_logic; -- asynchronous reset
    start_of_frame : in std_logic; -- arrival of the first byte.
    end_of_frame   : in std_logic; -- arrival of the first byte in FCS.
    data_in 	 : in std_logic_vector(7 downto 0); -- input data.
    fcs_error      : out std_logic -- indicates an error.
  );
end fcs_check_parallel;

architecture fcs_check_parallel_arch of fcs_check_parallel is

	signal G : std_logic_vector(31 downto 0);
	signal R : std_logic_vector(31 downto 0);

signal data_in_1 : std_logic_vector(7 downto 0);
	
	signal start_cnt : integer range 0 to 33;
	
	signal end_cnt : integer range 0 to 34; -- 0 is not used for counting, but for enable flag
	
	constant zeros : std_logic_vector(31 downto 0) := (others => '0');

BEGIN
	-- Init values of G
	G <= "00000100110000010001110110110111"; -- MSB -> LSB

	
	main : process(reset,clk)
		begin
			if(reset = '1') then
			-- reset logic
				
				end_cnt <= 0;
				fcs_error <= '1';
				start_cnt <= 0;
				data_in_1 <= (others => '0');
				
			R <= (others => '0');
				
			elsif rising_edge(clk) then
			
			-- main logic
			
				-- Handle start of frame ! -- TODO: implement inversion
					if(start_of_frame = '1') then
						-- reset R 
						R <= (others => '0');
						data_in_1 <= (others => '0');
						start_cnt <= 1;
					
					
					end if;
						-- This is the generalt case, inversions appear below
						data_in_1 <= data_in; -- delays the data one clock cycle for easy counting
						
						
	
							-- Look for end flag, if found count to 32, and get the result !!! 
						if(end_of_frame = '1') then
						
							-- enable our end counter
							end_cnt <= 1;
						end if;	

						if(start_cnt > 0) then
							-- we are counting gentlemen!

							if start_cnt = 5 then -- compensate for delay? -- was 33

								start_cnt <= 0;

							elsif start_cnt <= 4 then
								start_cnt <= start_cnt+1;
								-- between 0 and 
								data_in_1 <= not data_in;
							

							end if;
							
							

						end if;

					
						if(end_cnt > 0) then
							-- counter enabled! Increment
							if(end_cnt < 6) then 
							
							end_cnt <= end_cnt+1;
							end if;
						-- If we are in the final 32 bits, invert theese! 

							data_in_1 <= not data_in;

							
						end if;

						---- FROM MATLAB



						R(0) <= R(24) xor R(30) xor data_in_1(0);
						R(1) <= R(24) xor R(25) xor R(30) xor R(31) xor data_in_1(1);
						R(2) <= R(24) xor R(25) xor R(26) xor R(30) xor R(31) xor data_in_1(2);
						R(3) <= R(25) xor R(26) xor R(27) xor R(31) xor data_in_1(3);
						R(4) <= R(24) xor R(26) xor R(27) xor R(28) xor R(30) xor data_in_1(4);
						R(5) <= R(24) xor R(25) xor R(27) xor R(28) xor R(29) xor R(30) xor R(31) xor data_in_1(5);
						R(6) <= R(25) xor R(26) xor R(28) xor R(29) xor R(30) xor R(31) xor data_in_1(6);
						R(7) <= R(24) xor R(26) xor R(27) xor R(29) xor R(31) xor data_in_1(7);
						R(8) <= R(0) xor R(24) xor R(25) xor R(27) xor R(28);
						R(9) <= R(1) xor R(25) xor R(26) xor R(28) xor R(29);
						R(10) <= R(2) xor R(24) xor R(26) xor R(27) xor R(29);
						R(11) <= R(3) xor R(24) xor R(25) xor R(27) xor R(28);
						R(12) <= R(4) xor R(24) xor R(25) xor R(26) xor R(28) xor R(29) xor R(30);
						R(13) <= R(5) xor R(25) xor R(26) xor R(27) xor R(29) xor R(30) xor R(31);
						R(14) <= R(6) xor R(26) xor R(27) xor R(28) xor R(30) xor R(31);
						R(15) <= R(7) xor R(27) xor R(28) xor R(29) xor R(31);
						R(16) <= R(8) xor R(24) xor R(28) xor R(29);
						R(17) <= R(9) xor R(25) xor R(29) xor R(30);
						R(18) <= R(10) xor R(26) xor R(30) xor R(31);
						R(19) <= R(11) xor R(27) xor R(31);
						R(20) <= R(12) xor R(28);
						R(21) <= R(13) xor R(29);
						R(22) <= R(14) xor R(24);
						R(23) <= R(15) xor R(24) xor R(25) xor R(30);
						R(24) <= R(16) xor R(25) xor R(26) xor R(31);
						R(25) <= R(17) xor R(26) xor R(27);
						R(26) <= R(18) xor R(24) xor R(27) xor R(28) xor R(30);
						R(27) <= R(19) xor R(25) xor R(28) xor R(29) xor R(31);
						R(28) <= R(20) xor R(26) xor R(29) xor R(30);
						R(29) <= R(21) xor R(27) xor R(30) xor R(31);
						R(30) <= R(22) xor R(28) xor R(31);
						R(31) <= R(23) xor R(29);
												
												---- END FROM MATLAB
						if(end_cnt = 6) then --was 34
							 -- Woah! check the registers now!
							 end_cnt <= 0;
							 
							 assert false report "Checking!!!";
							 -- Check if the result is OK
							 if(R = zeros) then
							 
							  fcs_error <= '0';
								--!!!!  TODO: implement so fcs_error becomes 1 at next start!
							 end if;
					 
					
						end if;
			
			
			end if;
	end process main;
	

end fcs_check_parallel_arch;
