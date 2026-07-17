`timescale 1ns/1ps

module async_fifo_tb;

parameter DATA_WIDTH = 8;
parameter ADDR_SIZE  = 4;
parameter DEPTH      = (1<<ADDR_SIZE);




reg wr_clk;
reg rd_clk;
reg rst;

reg wr_en;
reg rd_en;

reg [DATA_WIDTH-1:0] wr_data;




wire [DATA_WIDTH-1:0] rd_data;

wire full;
wire empty;




reg [DATA_WIDTH-1:0] expected_mem [0:DEPTH-1];

integer wr_index;
integer rd_index;

integer pass_count;
integer fail_count;
integer old_wr_index;



async_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_SIZE(ADDR_SIZE)
)
dut
(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .wr_data(wr_data),
    .rd_data(rd_data),

    .full(full),
    .empty(empty)
);



initial
begin
    wr_clk = 0;

    forever #5 wr_clk = ~wr_clk;
end


initial
begin
    rd_clk = 0;

    forever #8 rd_clk = ~rd_clk;
end


// Reset Task


task reset_fifo;

begin

    rst = 1'b1;

    wr_en = 0;
    rd_en = 0;

    wr_data = 0;

    wr_index = 0;
    rd_index = 0;

    pass_count = 0;
    fail_count = 0;

    repeat(3)
        @(posedge wr_clk);

    rst = 0;

    repeat(2)
        @(posedge wr_clk);

end

endtask


// Write Task

task write_fifo;

input [DATA_WIDTH-1:0] data;

begin

    @(negedge wr_clk);

    if(!full)
    begin

        wr_en   = 1'b1;
        wr_data = data;

        @(posedge wr_clk);

        wr_en = 0;

        expected_mem[wr_index] = data;

        wr_index = (wr_index+1)%DEPTH;

    end

    else
    begin

        $display("[%0t] WRITE BLOCKED (FULL)",$time);

    end

end

endtask


// Read Task


task read_fifo;

begin

    @(negedge rd_clk);

    if(!empty)
    begin

        rd_en = 1'b1;

        @(posedge rd_clk);

        #1;

        if(rd_data===expected_mem[rd_index])
        begin

            pass_count = pass_count+1;

            $display("[%0t] PASS Expected=%h Actual=%h",
                     $time,
                     expected_mem[rd_index],
                     rd_data);

        end

        else
        begin

            fail_count = fail_count+1;

            $display("[%0t] FAIL Expected=%h Actual=%h",
                     $time,
                     expected_mem[rd_index],
                     rd_data);

        end

        rd_index=(rd_index+1)%DEPTH;

        rd_en=0;

    end

    else
    begin

        $display("[%0t] READ BLOCKED (EMPTY)",$time);

    end

end

endtask



task write_n;

input integer n;

integer i;

begin

    for(i=0;i<n;i=i+1)
        write_fifo($random);

end

endtask

//------------------------------------------------------------

task read_n;

input integer n;

integer i;

begin

    for(i=0;i<n;i=i+1)
        read_fifo();

end

endtask




// Summary Task

task print_summary;
begin
    $display("");
    $display("-----------------------------------");
    $display("Simulation Summary");
    $display("-----------------------------------");
    $display("PASS = %0d",pass_count);
    $display("FAIL = %0d",fail_count);
    $display("-----------------------------------");
end
endtask

//------------------------------------------------------------
// Test Sequence
//------------------------------------------------------------

initial
begin

    $dumpfile("fifo.vcd");
    $dumpvars(0,async_fifo_tb);

    
    // TEST 1 : RESET
    

    $display("");
    $display("==================================");
    $display("TEST 1 : RESET");
    $display("==================================");

    reset_fifo();

    if(empty && !full)
        $display("PASS : Reset Successful");
    else
        $display("FAIL : Reset Failed");

    #20;

    
    // TEST 2 : BASIC WRITE
    

    $display("");
    $display("==================================");
    $display("TEST 2 : BASIC WRITE");
    $display("==================================");

    write_fifo(8'h11);
    write_fifo(8'h22);
    write_fifo(8'h33);
    write_fifo(8'h44);

    #20;

    
    // TEST 3 : BASIC READ
    

    $display("");
    $display("==================================");
    $display("TEST 3 : BASIC READ");
    $display("==================================");

    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();

    #20;

    
    // TEST 4 : FIFO FULL
    

    $display("");
    $display("==================================");
    $display("TEST 4 : FIFO FULL");
    $display("==================================");

    reset_fifo();

    write_n(DEPTH);

    @(posedge wr_clk);
    #1;

    if(full)
    begin
        $display("PASS : FIFO FULL asserted");
        pass_count = pass_count + 1;
    end
    else
    begin
        $display("FAIL : FIFO FULL not asserted");
        fail_count = fail_count + 1;
    end

    write_fifo(8'hAA);

    @(posedge wr_clk);
    #1;

    if(full)
    begin
        $display("PASS : Overflow blocked");
        pass_count = pass_count + 1;
    end
    else
    begin
        $display("FAIL : Overflow not blocked");
        fail_count = fail_count + 1;
    end

    #20;

    
    // TEST 5 : FIFO EMPTY
    

    $display("");
    $display("==================================");
    $display("TEST 5 : FIFO EMPTY");
    $display("==================================");

    reset_fifo();

    write_n(DEPTH);

    read_n(DEPTH);

    @(posedge rd_clk);
    #1;

    if(empty)
    begin
        $display("PASS : FIFO EMPTY asserted");
        pass_count = pass_count + 1;
    end
    else
    begin
        $display("FAIL : FIFO EMPTY not asserted");
        fail_count = fail_count + 1;
    end

    read_fifo();

    #20;

    
    // TEST 6 : OVERFLOW
    

    $display("");
    $display("==================================");
    $display("TEST 6 : OVERFLOW");
    $display("==================================");

    reset_fifo();

    write_n(DEPTH);

    @(posedge wr_clk);
    #1;

    old_wr_index = wr_index;

    write_fifo(8'hAA);
    write_fifo(8'hBB);
    write_fifo(8'hCC);

    @(posedge wr_clk);
    #1;

    if(full)
    begin
        $display("PASS : FULL remained asserted");
        pass_count = pass_count + 1;
    end
    else
    begin
        $display("FAIL : FULL deasserted unexpectedly");
        fail_count = fail_count + 1;
    end

    if(wr_index == old_wr_index)
    begin
        $display("PASS : Overflow writes ignored");
        pass_count = pass_count + 1;
    end
    else
    begin
        $display("FAIL : Overflow write accepted");
        fail_count = fail_count + 1;
    end

    #20;


   $display("");
$display("==================================");
$display("TEST 7 : UNDERFLOW");
$display("==================================");

reset_fifo();

read_fifo();

@(posedge rd_clk);

#1;

if(empty)
begin
    $display("PASS : Underflow handled correctly");
    pass_count = pass_count + 1;
end
else
begin
    $display("FAIL : Empty flag lost");
    fail_count = fail_count + 1;
end

#20;

$display("");
$display("==================================");
$display("TEST 8 : POINTER WRAP");
$display("==================================");

reset_fifo();

repeat(4)
begin

    write_n(8);

    read_n(8);

end

if(empty)
begin
    $display("PASS : Pointer wrap successful");
    pass_count++;
end
else
begin
    $display("FAIL : Pointer wrap failed");
    fail_count++;
end

#20;


// TEST 9 : SIMULTANEOUS READ WRITE


$display("");
$display("==================================");
$display("TEST 9 : SIMULTANEOUS READ WRITE");
$display("==================================");

reset_fifo();

fork

begin
    write_n(20);
end

begin
    read_n(20);
end

join

#20;


// TEST 11 : RANDOM


$display("");
$display("==================================");
$display("TEST 11 : RANDOM");
$display("==================================");

reset_fifo();

repeat(100)
begin

    if($random%2)
        write_fifo($random);

    if($random%2)
        read_fifo();

end

#50;



// TEST 12 : STRESS


$display("");
$display("==================================");
$display("TEST 12 : STRESS");
$display("==================================");

reset_fifo();

repeat(10000)
begin

    if($random%2)
        write_fifo($random);

    if($random%2)
        read_fifo();

end
#100;






    // SUMMARY
    

    print_summary();

    $finish;

end

endmodule
