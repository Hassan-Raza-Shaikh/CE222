module and_gate (
    input a,
    input b,
    input c,
    output reg sum,carry 

);
always @(*)
begin
  
sum = a^b^c;
 carry= (a &b) | (( a ^b) & c);
 end
 
endmodule