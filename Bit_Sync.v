module Bit_Sync #( parameter  NUM_STAGES = 1,  BUS_WIDTH = 1)
(
input   wire                      CLK,
input   wire                      RST,
input   wire    [BUS_WIDTH-1:0]   ASYNC,
output  wire    [BUS_WIDTH-1:0]   SYNC
);

reg     [NUM_STAGES-1:0]   Sync_reg;

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            Sync_reg <= 'b0 ;
        end
    else
        begin
            Sync_reg <= {Sync_reg[NUM_STAGES-2:0],ASYNC} ;
        end
 end

assign SYNC = Sync_reg[NUM_STAGES-1];

endmodule