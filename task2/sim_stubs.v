// -------------------------------------------------
// Simulation stubs for FPGA-only primitives
// Used ONLY for BENCH simulation
// -------------------------------------------------

module SB_HFOSC (
    input  CLKHFPU,
    input  CLKHFEN,
    output CLKHF
);
    assign CLKHF = 1'b0;
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
