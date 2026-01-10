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

    // -------------------------------------------------
    // Address decode
    // -------------------------------------------------
    wire sel = mem_valid && (mem_addr[31:2] == BASE_ADDR[31:2]);

    wire sel_data = sel && (mem_addr[3:2] == 2'b00); // 0x00
    wire sel_dir  = sel && (mem_addr[3:2] == 2'b01); // 0x04
    wire sel_read = sel && (mem_addr[3:2] == 2'b10); // 0x08

    wire write_en = |mem_wstrb;

    // -------------------------------------------------
    // Registers
    // -------------------------------------------------
    reg [31:0] data_reg;   // GPIO_DATA
    reg [31:0] dir_reg;    // GPIO_DIR

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            data_reg <= 32'h0000_0000;
            dir_reg  <= 32'h0000_0000;  // default all inputs
        end else begin
            if (write_en && sel_data)
                data_reg <= mem_wdata;
            if (write_en && sel_dir)
                dir_reg <= mem_wdata;
        end
    end

    // -------------------------------------------------
    // GPIO state logic
    // -------------------------------------------------
    wire [31:0] gpio_state;
    assign gpio_state = (dir_reg & data_reg);  // inputs read as 0 for now

    // -------------------------------------------------
    // Readback mux
    // -------------------------------------------------
    reg [31:0] rdata;

    always @(*) begin
        if (sel_data)
            rdata = data_reg;
        else if (sel_dir)
            rdata = dir_reg;
        else if (sel_read)
            rdata = gpio_state;
        else
            rdata = 32'h0000_0000;
    end

    assign mem_rdata = rdata;
    assign gpio_out  = gpio_state;

endmodule

`default_nettype wire
