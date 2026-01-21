`timescale 1ns/1ps

module spi_mmio #(
    parameter BASE_ADDR = 32'h2000_1000
)(
    input  wire        clk,
    input  wire        resetn,

    input  wire        mem_valid,
    input  wire [31:0] mem_addr,
    input  wire [31:0] mem_wdata,
    input  wire [3:0]  mem_wmask,
    output reg  [31:0] mem_rdata,

    output reg         spi_sclk,
    output reg         spi_mosi,
    input  wire        spi_miso,
    output reg         spi_cs_n
);

    /* Address decode */
    wire [31:0] word_addr = {mem_addr[31:2], 2'b00};
    wire [31:0] offset    = word_addr - BASE_ADDR;

    wire spi_sel = (mem_addr[31:12] == BASE_ADDR[31:12]);

    wire sel_ctrl   = spi_sel && (offset == 32'h00);
    wire sel_txdata = spi_sel && (offset == 32'h04);
    wire sel_rxdata = spi_sel && (offset == 32'h08);
    wire sel_status = spi_sel && (offset == 32'h0C);

    wire write_en = mem_valid && (|mem_wmask);

    /* Registers */
    reg        ctrl_en;
    reg        ctrl_start;
    reg [7:0]  clkdiv;
    reg [7:0]  tx_shift;
    reg [7:0]  rx_shift;

    reg [15:0] clk_cnt;
    reg [3:0]  bit_cnt;
    reg        busy;
    reg        done;

    /* Write logic */
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            ctrl_en    <= 1'b0;
            ctrl_start <= 1'b0;
            clkdiv     <= 8'd2;
            tx_shift   <= 8'd0;
            done       <= 1'b0;
        end else begin
            ctrl_start <= 1'b0;  // auto clear

            if (write_en && sel_ctrl) begin
                ctrl_en    <= mem_wdata[0];
                ctrl_start <= mem_wdata[1];
                clkdiv     <= mem_wdata[15:8];
            end

            if (write_en && sel_txdata) begin
                tx_shift <= mem_wdata[7:0];
            end

            if (write_en && sel_status && mem_wdata[1]) begin
                done <= 1'b0; // clear DONE
            end
        end
    end

    /* Read logic */
    always @(*) begin
        mem_rdata = 32'h0;
        if (sel_ctrl)
            mem_rdata = {16'h0, clkdiv, ctrl_start, ctrl_en};
        else if (sel_txdata)
            mem_rdata = {24'h0, tx_shift};
        else if (sel_rxdata)
            mem_rdata = {24'h0, rx_shift};
        else if (sel_status)
            mem_rdata = {30'h0, done, busy};
    end

    /* SPI FSM */
    localparam IDLE     = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;

    wire spi_go = ctrl_en && ctrl_start;

    /* SPI engine */
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            spi_sclk <= 1'b0;
            spi_mosi <= 1'b0;
            spi_cs_n <= 1'b1;
            clk_cnt  <= 0;
            bit_cnt  <= 0;
            busy     <= 1'b0;
            done     <= 1'b0;
            state    <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    spi_cs_n <= 1'b1;
                    spi_sclk <= 1'b0;
                    busy     <= 1'b0;

                    if (spi_go) begin
                        spi_cs_n <= 1'b0;
                        rx_shift <= 8'd0;
                        bit_cnt  <= 4'd7;
                        clk_cnt  <= 0;
                        busy     <= 1'b1;
                        state    <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    clk_cnt <= clk_cnt + 1;

                    if (clk_cnt == clkdiv) begin
                        clk_cnt  <= 0;
                        spi_sclk <= ~spi_sclk;

                        if (!spi_sclk) begin
                            spi_mosi <= tx_shift[bit_cnt];
                        end else begin
                            rx_shift[bit_cnt] <= spi_miso;

                            if (bit_cnt == 0)
                                state <= DONE;
                            else
                                bit_cnt <= bit_cnt - 1;
                        end
                    end
                end

                DONE: begin
                    spi_cs_n <= 1'b1;
                    spi_sclk <= 1'b0;
                    busy     <= 1'b0;
                    done     <= 1'b1;
                    state    <= IDLE;
                end
            endcase
        end
    end

endmodule
