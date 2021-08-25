module system(
    input clk_rx,
    input clk_tx,
    input rst,
    input botao,
    input [3:0] dado,
    input [3:0] instrucao,
    output [7:0] leds,
    output [6:0] seg_unidade,
    output [6:0] seg_dezena,
);
wire tx_to_rx;

    TX mytx(
        .clk (clk_tx),
        .rst (rst),
        .dado (dado),
        .instrucao (instrucao),
        .botao (botao), 
        .info_saida (tx_to_rx) ,
        .estado (),
        .contador ()
    );


    RX myrx(
        .dado (tx_to_rx), //output do tx 
        .clk (clk_rx),
        .rst (rst),
        .seg_unidade (seg_unidade),
        .seg_dezena (seg_dezena), 
        .leds (leds), 
        .estado ()
    );

    
endmodule