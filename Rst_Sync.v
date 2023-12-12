module Rst_Sync #(parameter NUM_STAGES = 2)
(
input   wire    RST,
input   wire    CLK,
output  wire    Sync_RST
);

reg    [NUM_STAGES-1:0]   multi_FF ;

always @(posedge CLK or negedge RST)
 begin
    if(!RST)
        begin
            multi_FF <= 'b0 ;
        end
    else
        begin
            multi_FF <= {multi_FF[NUM_STAGES-2:0],1'b1} ;
        end
 end

assign Sync_RST = multi_FF[NUM_STAGES-1] ;

endmodule