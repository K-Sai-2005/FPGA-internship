// -------------------------------------------------
// Simulation stubs for FPGA-only primitives
// Used ONLY for BENCH simulation
// -------------------------------------------------

module SB_HFOSC (
    input  CLKHFPU,
    input  CLKHFEN,
    output reg CLKHF
);
    initial CLKHF = 0;
    always #5 CLKHF = ~CLKHF; // 100 MHz equivalent
endmodule



module SB_PLL40_CORE #(
    parameter FEEDBACK_PATH = "",
    parameter PLLOUT_SELECT = "",
    parameter DIVR = 0,
    parameter DIVF = 0,
    parameter DIVQ = 0,
    parameter FILTER_RANGE = 0
)(
    input  REFERENCECLK,
    input  RESETB,
    input  BYPASS,
    output PLLOUTCORE
);
    assign PLLOUTCORE = REFERENCECLK;
endmodule
