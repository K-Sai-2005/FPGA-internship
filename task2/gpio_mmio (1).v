`default_nettype none

module gpio_mmio #(
    parameter BASE_ADDR = 32'h2000_0000
)(
    input  wire        clk,
    input  wire        resetn,

    input  wire        mem_valid,
    input  wire [31:0] mem_addr,
    input  wire [31:0] mem_wdata,
    input  wire [3:0]  mem_wstrb,

    output wire [31:0] mem_rdata,
    output wire [31:0] gpio_out
);

    // Address decode (one 32-bit register at BASE_ADDR)
    wire sel = mem_valid && (mem_addr[31:2] == BASE_ADDR[31:2]);
    wire write_en = sel && (|mem_wstrb);

    // GPIO register
    reg [31:0] gpio_reg;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            gpio_reg <= 32'h0000_0000;
        end else if (write_en) begin
            gpio_reg <= mem_wdata;
        end
    end

    // Readback
    assign mem_rdata = sel ? gpio_reg : 32'h0000_0000;

    // Drive output
    assign gpio_out = gpio_reg;

endmodule

`default_nettype wire
