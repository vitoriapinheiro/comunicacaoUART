
module TX(clk, rst, botao, instrucao, dado, info_saida,estado,contador);

    input [3:0]dado;
	input [3:0]instrucao;
    input botao;
    input clk, rst;
    output reg info_saida;

    reg [2:0]estado;
    reg [3:0]contador;

    parameter INICIO = 3'b000, 
              ESPERA = 3'b001,
              EXTREMO = 3'b010,
              ENVIA_DADO = 3'b011,
              ENVIA_INSTRUCAO = 3'b100;

    initial begin
        info_saida = 1'd1;
        estado = INICIO;
        contador = 4'd0;
    end
    
    always@(*) begin
        case(estado)
            INICIO: begin
                info_saida = 1;
            end
            ESPERA: begin
                info_saida = 1;
            end
            EXTREMO: begin
                info_saida = 0;
            end
            ENVIA_DADO: begin
                info_saida = dado[contador];
            end
            ENVIA_INSTRUCAO: begin
                info_saida = instrucao[contador - 4];
            end
            default: begin
                info_saida = info_saida;
            end
            
        endcase

    end

    always@(posedge clk or negedge rst) begin

        if(rst == 0) begin 
            estado <= INICIO;
            contador <= 0;
        end
        else begin
            case(estado)
                INICIO: begin
                    if(botao == 1) begin
                        estado <= ESPERA;
                    end
                end
                ESPERA: begin
                    if(botao == 0) begin
                        estado <= EXTREMO;
                    end
                end
                EXTREMO: begin
                    if(contador == 0) begin
                        estado <= ENVIA_DADO;
                    end
                    else begin
                        estado <= INICIO;
                    end

                end
                ENVIA_DADO: begin
                    if(contador < 4) begin
                        contador <= contador + 1;
                    end
                    else begin
                        estado <= ENVIA_INSTRUCAO;
                    end

                end
                ENVIA_INSTRUCAO: begin
                    if(contador < 8) begin
                        contador <= contador + 1;
                    end
                    else begin
                        estado <= EXTREMO;
                    end
                end
                default: begin
                    estado = estado;
                end
            endcase
        end
    end

endmodule