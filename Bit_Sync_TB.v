`timescale 1ns/1ns

module Bit_Sync_TB();

/******************************************************/
/******************** TB Parameters *******************/
/******************************************************/
parameter    NUM_STAGES_TB   = 2 ;
parameter    BUS_WIDTH_TB    = 1 ;  
parameter    clk_period      = 10 ;  

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg                            CLK_TB   ;
reg                            RST_TB   ;
reg     [BUS_WIDTH_TB-1:0]     ASYNC_TB ;
wire    [BUS_WIDTH_TB-1:0]    SYNC_TB  ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
Bit_Sync # (.NUM_STAGES(NUM_STAGES_TB), .BUS_WIDTH(BUS_WIDTH_TB)) U0 
(
.CLK(CLK_TB),
.RST(RST_TB),
.ASYNC(ASYNC_TB),
.SYNC(SYNC_TB)
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
$dumpfile("Bit_Sync.vcd");
$dumpvars;
      
// initialization
initialize() ;

// Reset the design
reset();

delay_periods(1) ;

$display("\n*************************");
$display("\n Used 1 bit and 2 stages");
$display("\n*************************");
$display("****** TEST CASE 1 ******");
$display("*************************");
$display("ASYNC = 0");
ASYNC_TB = 'b0 ;
delay_periods(2) ;
if(SYNC_TB == 'b0)
  begin
    $display("\n    SUCCESS\n");
  end
else
  begin
    $display("\n    FAILED\n");
  end
  
$display("\n*************************");
$display("****** TEST CASE 2 ******");
$display("*************************");
$display("ASYNC = 1");
ASYNC_TB = 'b1 ;
delay_periods(2) ;
if(SYNC_TB == 'b1)
  begin
    $display("\n    SUCCESS\n");
  end
else
  begin
    $display("\n    FAILED\n");
  end
  
$display("\n*************************");
$display("****** TEST CASE 3 ******");
$display("*************************");
$display("ASYNC = 0");
ASYNC_TB = 'b0 ;
delay_periods(2) ;
if(SYNC_TB == 'b0)
  begin
    $display("\n    SUCCESS\n");
  end
else
  begin
    $display("\n    FAILED\n");
  end
  
$display("\n*************************");
$display("****** TEST CASE 4 ******");
$display("*************************");
$display("ASYNC = 1");
ASYNC_TB = 'b1 ;
delay_periods(2) ;
if(SYNC_TB == 'b1)
  begin
    $display("\n    SUCCESS\n");
  end
else
  begin
    $display("\n    FAILED\n");
  end

#50

$stop;

 end

////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization /////////////////
task initialize ;
 begin
  CLK_TB   = 1'b0 ; 
  ASYNC_TB = 1'b1 ;
 end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
 begin
  RST_TB = 1'b1  ;  // deactivated
  #(clk_period)
  RST_TB = 1'b0  ;  // activated
  #(clk_period)
  RST_TB = 1'b1  ;  // decativated
 end
endtask

/////////////////// Delay periods  //////////////////////
task delay_periods ;
 input integer num ;
 
 begin
  #(clk_period*num) ;
 end
endtask

endmodule