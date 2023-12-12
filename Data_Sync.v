module Data_Sync #( parameter NUM_STAGES = 2, BUS_WIDTH = 8 )
(
input   wire                      CLK,
input   wire                      RST,
input   wire    [BUS_WIDTH-1:0]   unsync_bus,
input   wire                      bus_enable,
output  reg     [BUS_WIDTH-1:0]   sync_bus,
output  reg                       enable_pulse
);

reg    [NUM_STAGES-1:0]   multi_FF ;

reg             Pulse_Gen_r    ;
wire            Pulse_Gen      ;

reg    [BUS_WIDTH-1:0]   sync_bus_r ;

//////////////// Multi Flip Flop ////////////////
always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            multi_FF <= 'b0 ;
        end
    else
        begin
            multi_FF <= {multi_FF[NUM_STAGES-2:0],bus_enable} ;
        end
 end

/////////////////// Pulse Gen //////////////////
always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            Pulse_Gen_r <= 'b0 ;
        end
    else
        begin
            Pulse_Gen_r <= multi_FF[NUM_STAGES-1] ;
        end
 end
 
assign Pulse_Gen = !Pulse_Gen_r && multi_FF[NUM_STAGES-1] ;
 
/////////////////// Enable Pulse //////////////////
always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            enable_pulse <= 'b0 ;
        end
    else
        begin
            enable_pulse <= Pulse_Gen ;
        end
 end

/////////////////// Sync Bus //////////////////
always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            sync_bus <= 'b0 ;
        end
    else
        begin
            if(Pulse_Gen)
                begin
                    sync_bus <= unsync_bus ;
                end
            else
                begin
                    sync_bus <= sync_bus ;
                end
        end
 end

endmodule