module tb_spi_mmio;

reg clk = 0;
always #5 clk = ~clk;

reg resetn = 0;
initial begin
  #20 resetn = 1;
end

// MMIO signals
reg mem_valid;
reg [31:0] mem_addr;
reg [31:0] mem_wdata;
reg [3:0]  mem_wmask;

wire spi_sclk, spi_mosi, spi_cs_n;
reg  spi_miso = 1'b1;

spi_mmio DUT (
  .clk(clk),
  .resetn(resetn),
  .mem_valid(mem_valid),
  .mem_addr(mem_addr),
  .mem_wdata(mem_wdata),
  .mem_wmask(mem_wmask),
  .mem_rdata(),
  .spi_sclk(spi_sclk),
  .spi_mosi(spi_mosi),
  .spi_miso(spi_miso),
  .spi_cs_n(spi_cs_n)
);

initial begin
  mem_valid = 0;
  mem_wmask = 0;

  #30;
  // CTRL write: enable + start + clkdiv=4
  mem_valid = 1;
  mem_addr  = 32'h2000_1000;
  mem_wdata = (1<<0) | (1<<1) | (4<<8);
  mem_wmask = 4'hF;

  #10;
  mem_valid = 0;
  mem_wmask = 0;

  #2000;
  $finish;
end

initial begin
  $dumpfile("spi_direct.vcd");
  $dumpvars(0, tb_spi_mmio);
end

endmodule
