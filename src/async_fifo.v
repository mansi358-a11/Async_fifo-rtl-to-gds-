module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_SIZE  = 4
)(
    input                     wr_clk,
    input                     rd_clk,
    input                     rst,

    input                     wr_en,
    input                     rd_en,

    input  [DATA_WIDTH-1:0]   wr_data,

    output [DATA_WIDTH-1:0]   rd_data,

    output                    full,
    output                    empty
);

    
    // Internal Signals
    

    // Write Pointer
    wire [ADDR_SIZE:0] wr_bin;
    wire [ADDR_SIZE:0] wr_gray;

    // Read Pointer
    wire [ADDR_SIZE:0] rd_bin;
    wire [ADDR_SIZE:0] rd_gray;

    // Synchronized Gray Pointers
    wire [ADDR_SIZE:0] wr_gray_sync;
    wire [ADDR_SIZE:0] rd_gray_sync;

    
    // Write Pointer
    

    write_ptr #(
        .ADDR_SIZE(ADDR_SIZE)
    ) u_wr_ptr (
        .wr_clk(wr_clk),
        .rst(rst),
        .wr_en(wr_en),

        .rd_gray_sync(rd_gray_sync),

        .wr_bin(wr_bin),
        .wr_gray(wr_gray),

        .full(full)
    );

    
    // Read Pointer
    

    read_ptr #(
        .ADDR_SIZE(ADDR_SIZE)
    ) u_rd_ptr (
        .rd_clk(rd_clk),
        .rst(rst),
        .rd_en(rd_en),

        .wr_gray_sync(wr_gray_sync),

        .rd_bin(rd_bin),
        .rd_gray(rd_gray),

        .empty(empty)
    );

    
    // Dual Port Memory
    

    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) u_mem (
        .wr_clk (wr_clk),
        .wr_en  (wr_en & ~full),

        .rd_clk (rd_clk),
        .rd_en  (rd_en & ~empty),

        .wr_addr(wr_bin[ADDR_SIZE-1:0]),
        .rd_addr(rd_bin[ADDR_SIZE-1:0]),

        .wr_data(wr_data),
        .rd_data(rd_data)
    );

    
    // Synchronize Write Pointer into Read Clock Domain
    

    sync_ff #(
        .WIDTH(ADDR_SIZE+1)
    ) u_wr_sync (
        .clk(rd_clk),
        .rst(rst),

        .d(wr_gray),

        .q(wr_gray_sync)
    );

    
    // Synchronize Read Pointer into Write Clock Domain
    

    sync_ff #(
        .WIDTH(ADDR_SIZE+1)
    ) u_rd_sync (
        .clk(wr_clk),
        .rst(rst),

        .d(rd_gray),

        .q(rd_gray_sync)
    );

endmodule
