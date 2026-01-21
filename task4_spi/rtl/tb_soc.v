`timescale 1ns/1ps
module tb_soc;

    reg clk = 0;
    reg resetn = 0;

    always #5 clk = ~clk;

    initial begin
        $dumpfile("spi_wave.vcd");
        $dumpvars(0, tb_soc);

        #50 resetn = 1;

        // Force SPI write after reset
        #100;
        force dut.mem_addr  = 32'h2000_1000; // SPI CTRL
        force dut.mem_wdata = 32'h0000_0103; // ctrl_en=1, ctrl_start=1
        force dut.mem_wmask = 4'b1111;
        force dut.mem_valid = 1'b1;

        #20;
        release dut.mem_valid;
        release dut.mem_addr;
        release dut.mem_wdata;
        release dut.mem_wmask;

        #2000;
        $finish;
    end

    SOC dut (
        .CLK(clk),
        .RESET(resetn)
    );

endmodule
