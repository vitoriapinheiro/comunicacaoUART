/*vetor[7:4] = instrucao e vetor[3:0] = dado*/
module RX( input dado, input clk,input rst, output reg[6:0] seg_unidade,output reg[6:0] seg_dezena, output reg[7:0] leds, output reg [2:0] estado);
    
    
   
    
    reg [3:0] valor;
    reg [7:0] vetor = 8'b00000000;
    
    reg [3:0] contador = 4'b0000;
    
    parameter iniciar = 3'b000, espera = 3'b001, leitura = 3'b010, analise = 3'b011, instUm = 3'b100, instDois = 3'b101, instQuatro = 3'b110;
    

    
    
    
    // clk duas vezes mais rápido que o transmissor (tx = 9600 Hz|| rx = 19200 Hz)
    
    always@(*) begin
        
        case(estado)
                iniciar: begin
                    leds <= 8'b00000000;
                    seg_unidade <= 7'b0000001;
                    valor <= 4'b0000;
                    seg_dezena <=  7'b0000001;

                end
            espera: begin
                leds <= leds;
                seg_dezena <= seg_dezena;
                seg_unidade <= seg_unidade;
            end

            leitura: begin
                leds <= leds;
                seg_dezena <= seg_dezena;
                seg_unidade <= seg_unidade;
            end

            analise: begin
                leds <= vetor;
                seg_dezena <= seg_dezena;
                seg_unidade <= seg_unidade;
            end

            instUm: begin //limpa
                leds <= leds;
                seg_dezena <= 7'b0000001;
                seg_unidade <= 7'b0000001;
            end

            instDois: begin //carrega
                     valor <= vetor[3:0];
                leds <= leds;
                seg_dezena <= seg_dezena;
                seg_unidade <= seg_unidade;
            end

            instQuatro: begin // mostra
                leds = leds;
                    
                if(valor < 4'd10) begin
                            seg_dezena[6:0] <= 7'b0000001; // 00 até 09
                     end
                    
                     else begin
                            seg_dezena[6:0] <= 7'b1001111; // 10 até 15
                     end
                    
                case(valor)
                        4'd0: begin
                            seg_unidade[6:0] <= 7'b0000001; // 0
                        end
                        4'd1: begin
                            seg_unidade[6:0] <= 7'b1001111; // 1
                        end
                        4'd2: begin
                            seg_unidade[6:0] <= 7'b0010010; // 2
                        end
                        4'd3: begin
                            seg_unidade[6:0] <= 7'b0000110; // 3
                        end
                        4'd4: begin
                            seg_unidade[6:0] <= 7'b1001100; // 4
                        end
                        4'd5: begin
                            seg_unidade[6:0] <= 7'b0100100; // 5
                        end
                        4'd6: begin
                            seg_unidade[6:0] <= 7'b1100000; // 6
                        end
                        4'd7: begin
                            seg_unidade[6:0] <= 7'b0001111; // 7
                        end
                        4'd8: begin
                            seg_unidade[6:0] <= 7'b0000000; // 8
                        end
                        4'd9: begin
                            seg_unidade[6:0] <= 7'b0001100; // 9
                        end
                        4'd10: begin
                            seg_unidade[6:0] <= 7'b0000001; // 10
                        end
                        4'd11: begin
                            seg_unidade[6:0] <= 7'b1001111; // 11
                        end
                        4'd12: begin
                            seg_unidade[6:0] <= 7'b0010010; // 12
                        end
                        4'd13: begin
                            seg_unidade[6:0] <= 7'b0000110; // 13
                        end
                        4'd14: begin
                            seg_unidade[6:0] <= 7'b1001100; // 14
                        end
                        4'd15: begin
                            seg_unidade[6:0] <= 7'b0100100; // 15
                        end
                    endcase
            end

        endcase
    end



    always@(posedge clk or negedge rst) begin
        if(rst == 0) begin
            estado <= iniciar;
            vetor <= 0;
            //valor <= 0;
            contador <= 0;
            
        end
        else begin
            case(estado)
                     iniciar: begin
                        estado <= espera;
                     end
                espera: begin
                    if(dado == 0) begin
                        estado <= leitura; //start point
                    end
                          else begin
                                estado <= espera;
                          end
                end
                    
                leitura: begin    
                
                    //faltando entender como sincronizar com os dados do transmissor
                    
                    if(contador < 8) begin
                        vetor[contador] <= dado;
                        contador <=  contador + 4'b0001;
                                estado <= leitura;
                    end
                    
                    else begin
                        contador <= 0;
                        estado <= analise;
                    end
                end
                
                analise: begin
                    
                    case(vetor[7:4])
                        4'd1: begin // limpar dados
                            estado <= instUm;
                        end
                        4'd2: begin // salvar dados
                            estado <= instDois;
                        end
                        4'd4: begin // mostrar dados
                            estado <= instQuatro;
                        end
                        
                        default: begin // fazer nada
                            estado <= espera;
                        end            
                    endcase
                end
        
                instUm: begin
                    estado <= espera;
                end

                instDois: begin
                    
                    estado <= espera;
                end

                instQuatro: begin
                    estado <= espera;
                end

                default: begin
                    estado <= espera;
                end
            endcase
        end
    end

endmodule
