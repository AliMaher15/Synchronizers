`timescale 1ns/1ps

module Rst_Sync_TB();

/******************************************************/
/******************** TB Parameters *******************/
/******************************************************/
parameter    NUM_STAGES_TB   = 2 ;
parameter    clk_period      = 10 ;  

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg                            CLK_TB   ;
reg                            RST_TB   ;
wire                           Sync_RST_TB  ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
Rst_Sync # (.NUM_STAGES(NUM_STAGES_TB) ) U1 
(
.CLK(CLK_TB),
.RST(RST_TB),
.Sync_RST(Sync_RST_TB)
);      

////////////////////////////////////////////////////////
////////////       Clock Generator         /////////////
////////////////////////////////////////////////////////
initial
 begin
  forever #5  CLK_TB = ~CLK_TB ;
 end

////////////////////////////////////////////////////////
////////////            INITIAL             ////////////
////////////////////////////////////////////////////////
initial
 begin
$dumpfile("RST_Sync.vcd");
$dumpvars;
      
// initialization
initialize() ;

delay_periods(1) ;

$display("\n*************************");
$display("\n Used %d FF Stages", NUM_STAGES_TB);
$display("\n*************************");
$display("****** TEST CASE 1 ******");
$display("*************************");
$display("Async RST = 0 for 1 Clock Cycle then deasserted away from validation");
#(clk_period*0.5) ;
RST_TB = 1'b0 ;
delay_periods(1) ;
$display(" After 1 Clock Cycles");
check_output(1'b0) ;
RST_TB = 1'b1 ;
$display(" The Async RST is de-asserted") ;
delay_periods(3) ;
$display(" After 2 Clock Cycles starting from the next posedge");
check_output(1'b1) ;
  
$display("\n*************************");
$display("****** TEST CASE 2 ******");
$display("*************************");
$display("RST = 0 for 1 Clock Cycle then deasserted in validation region");
#(clk_period*0.5) ;
RST_TB = 1'b0 ;
delay_periods(1) ;
$display(" After 1 Clock Cycles");
check_output(1'b0) ;
RST_TB = 1'b1 ;
$display(" The Async RST is de-asserted") ;
delay_periods(3) ;
$display(" After 2 Clock Cycles starting from the posedge");
check_output(1'b1) ;

#10

$stop;

 end

////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization /////////////////
task initialize ;
 begin
  CLK_TB   = 1'b1 ; 
  RST_TB   = 1'b1 ;
 end
endtask

/////////////////// Delay periods  //////////////////////
task delay_periods ;
 input integer num ;
 
 begin
  #(clk_period*num) ;
 end
endtask

///////////////// Check output ////////////////
task check_output ;
 input data ;
 
 begin
  $display( "Sync_RST = %b", Sync_RST_TB);
  if(Sync_RST_TB == data)
    begin
        $display("\n    SUCCESS\n");
    end
  else
    begin
        $display("\n    FAILED\n");
    end
   end
endtask

endmodule