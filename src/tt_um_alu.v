`default_nettype none

module tt_um_alu (
    input  [7:0] ui_in,    // A[3:0], B[3:0]
    output [7:0] uo_out,   // Resultado[7:0]
    input  [7:0] uio_in,   // Selector[2:0]
    output [7:0] uio_out,  // Flags [carry, zero]
    output [7:0] uio_oe,   // Configuración E/S
    input        ena,
    input        clk,
    input        rst_n
);
    wire [3:0] A = ui_in[3:0];
    wire [3:0] B = ui_in[7:4];
    wire [2:0] sel = uio_in[2:0];
    
    wire [7:0] result;
    wire carry, zero;
    
    alu_8bit alu_core (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(result),
        .carry(carry),
        .zero(zero)
    );
    
    assign uo_out = result;
    assign uio_out = {6'b0, carry, zero};
    assign uio_oe = 8'b00000011; // Bits 0-1 como salidas
endmodule
