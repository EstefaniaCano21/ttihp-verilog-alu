`default_nettype none

module alu_8bit (
    input  wire [3:0] A,        // Operando A (4 bits)
    input  wire [3:0] B,        // Operando B (4 bits)
    input  wire [2:0] sel,      // Selector de operación
    output wire [7:0] Y,        // Resultado extendido a 8 bits
    output wire       zero,      // Bandera zero
    output wire       carry     // Bandera carry
);

    // Definición de operaciones
    localparam
        OP_ADD = 3'b000,
        OP_SUB = 3'b001,
        OP_AND = 3'b010,
        OP_OR  = 3'b011,
        OP_XOR = 3'b100,
        OP_NOT = 3'b101,
        OP_SHL = 3'b110,
        OP_SHR = 3'b111;

    wire [4:0] add_sub_result;  // 5 bits para incluir carry
    reg  [3:0] logical_result;
    reg  [3:0] shift_result;
    reg  [3:0] arith_result;
    
    // Sumador/Restador
    assign add_sub_result = (sel == OP_SUB) ? (A - B) : (A + B);
    
    // Operaciones lógicas
    always_comb begin
        case(sel)
            OP_AND: logical_result = A & B;
            OP_OR:  logical_result = A | B;
            OP_XOR: logical_result = A ^ B;
            OP_NOT: logical_result = ~A;
            default: logical_result = 4'b0;
        endcase
    end
    
    // Shifts
    always_comb begin
        case(sel)
            OP_SHL: shift_result = {A[2:0], 1'b0};
            OP_SHR: shift_result = {1'b0, A[3:1]};
            default: shift_result = 4'b0;
        endcase
    end
    
    // Selección de resultado final
    always_comb begin
        case(sel)
            OP_ADD, OP_SUB: arith_result = add_sub_result[3:0];
            OP_AND, OP_OR, OP_XOR, OP_NOT: arith_result = logical_result;
            OP_SHL, OP_SHR: arith_result = shift_result;
            default: arith_result = 4'b0;
        endcase
    end
    
    // Extensión a 8 bits y asignación de salidas
    assign Y = {4'b0, arith_result};
    assign carry = add_sub_result[4];
    assign zero = (arith_result == 4'b0);

endmodule
