`default_nettype none

module gpio_mmio #(
    parameter BASE_ADDR = 32'h2000_0000   // must match GPIO_REG in C
)(
    input         clk,
    input         resetn,

    input  [31:0] mem_addr,
    input  [31:0] mem_wdata,
    input  [3:0]  mem_wmask,
    output [31:0] gpio_rdata,
    output [31:0] gpio_out
);

    reg [31:0] gpio_reg;

    // address decode: word address of BASE_ADDR
    wire [31:0] base_word = BASE_ADDR;
    wire        sel       = (mem_addr[31:2] == base_word[31:2]);

    wire        write_en  = sel & |mem_wmask;

    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            gpio_reg <= 32'h00000000;
        else if (write_en)
            gpio_reg <= mem_wdata;
    end

    assign gpio_rdata = sel ? gpio_reg : 32'h0000_0000;
    assign gpio_out   = gpio_reg;

endmodule
