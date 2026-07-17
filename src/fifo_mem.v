module fifo_mem #(parameter DATA_WIDTH =8,
parameter ADDR_SIZE =4
)(
  input wr_clk , wr_en , rd_clk , rd_en ,
  input [ADDR_SIZE-1:0] wr_addr, rd_addr ,
  input [DATA_WIDTH-1:0] wr_data,
  output reg [DATA_WIDTH-1:0] rd_data

);


reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_SIZE)-1]; 

always @(posedge wr_clk)
begin
 if (wr_en)
mem[wr_addr] <= wr_data;
end


always @(posedge rd_clk)
begin
if(rd_en)
rd_data <= mem[rd_addr];
end

endmodule
