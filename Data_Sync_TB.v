`timescale 1ns/1ps

module Data_Sync_TB();

/******************************************************/
/******************** TB Parameters *******************/
/******************************************************/
parameter    NUM_STAGES_TB   = 2 ;
parameter    BUS_WIDTH_TB    = 8 ;  
parameter    clk_period      = 10 ;

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg                            CLK_TB          ;
reg                            RST_TB          ;
reg     [BUS_WIDTH_TB-1:0]     unsync_bus_TB   ;
reg                            bus_enable_TB   ;
wire    [BUS_WIDTH_TB-1:0]     sync_bus_TB     ;
wire                           enable_pulse_TB ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
Data_Sync # (.NUM_STAGES(NUM_STAGES_TB), .BUS_WIDTH(BUS_WIDTH_TB)) U0 
(
.CLK(CLK_TB),
.RST(RST_TB),
.unsync_bus(unsync_bus_TB),
.bus_enable(bus_enable_TB),
.sync_bus(sync_bus_TB),
.enable_pulse(enable_pulse_TB)
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

delay_periods(2) ;

$display("\n*************************");
$display("\n Used Bus Width = 8 & No. of Stages = 2");
$display("\n*************************");
$display("****** TEST CASE 1 ******");
$display("*************************");
$display("Unsync bus = 8'b01100101");
$display("bus_enable = 1");
unsync_bus_TB = 'b01100101 ;
bus_enable_TB = 1'b1 ;
delay_periods(3) ;
$display(" After 2 Clock Cycles starting from the next posedge");
check_output('b01100101, 1'b1) ;

delay_periods(1) ;

$display("\n*************************");
$display("****** TEST CASE 2 ******");
$display("*************************");
$display("Unsync bus = 8'b11111111");
$display("bus_enable = 0");
unsync_bus_TB = 'b11111111 ;
bus_enable_TB = 1'b0 ;
delay_periods(3) ;
$display(" After 2 Clock Cycles starting from the next posedge");
check_output('b01100101, 1'b0) ;

delay_periods(1) ;

$display("\n*************************");
$display("****** TEST CASE 3 ******");
$display("*************************");
$display("Unsync bus = 8'b11110000");
$display("bus_enable = 1");
unsync_bus_TB = 'b11110000 ;
bus_enable_TB = 1'b1 ;
delay_periods(3) ;
$display(" After 2 Clock Cycles starting from the next posedge");
check_output('b11110000, 1'b1) ;

#50
$stop;

 end

////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization /////////////////
task initialize ;
 begin
  CLK_TB   = 1'b1 ; 
  unsync_bus_TB = 'b1 ;
  bus_enable_TB = 'b0 ;
 end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
 begin
  RST_TB = 1'b1  ;  // deactivated
  #(clk_period*0.5)
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

///////////////// Check output ////////////////
task check_output ;
 input [BUS_WIDTH_TB-1:0] data ;
 input                    en_pulse ;
 
 begin
  $display( "sync_bus = %b\nenable_pulse = %b", sync_bus_TB, enable_pulse_TB);
  if(sync_bus_TB == data)
    begin
        $display("\n    Data is Correct (SUCCESS)");
    end
  else
    begin
        $display("\n    Data is Wrong (FAILED)");
    end
  if(enable_pulse_TB == en_pulse)
    begin
        $display("    Enable is Correct (SUCCESS)\n");
    end
  else
    begin
        $display("    Enable is Wrong (FAILED)\n");
    end
   end
endtask



endmodule