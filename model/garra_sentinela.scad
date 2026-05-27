// --- Módulo MMA-01 Sentinela: Garra de Microgravidade (Design Autoral) ---

// 1. Variáveis Paramétricas (Garante os pontos de "Ajustes")
tamanho_garra = 75;
espessura_peca = 4;
abertura_boca = 22;

// 2. Módulo Principal da Peça
module garra_sentinela() {
    difference() {
        // CORPO PRINCIPAL: Formato orgânico e reforçado usando 'hull'
        hull() {
            // Base circular robusta para o eixo do motor
            cylinder(d=34, h=espessura_peca, $fn=60);
            // Ponta superior do "dedo" da garra
            translate([tamanho_garra, 16, 0]) cylinder(d=8, h=espessura_peca, $fn=30);
            // Ponta inferior do "dedo" da garra
            translate([tamanho_garra, -16, 0]) cylinder(d=8, h=espessura_peca, $fn=30);
        }
        
        // SUBTRAÇÕES (O que tiramos da peça para moldá-la)
        
        // A. Encaixe central para Micro Servo 9g (23x12.5mm)
        translate([-11.5, -6.25, -1]) 
            cube([23, 12.5, espessura_peca + 2]);
            
        // B. Corte interno para formar os "dedos" em formato de 'C'
        translate([20, 0, -1]) 
            cylinder(d=28, h=espessura_peca + 2, $fn=60); // Fundo da boca
        translate([20, -abertura_boca/2, -1]) 
            cube([tamanho_garra, abertura_boca, espessura_peca + 2]); // Abertura frontal
            
        // C. Furos de Alívio de Massa (Garante pontos de "Microgravidade")
        translate([0, 12, -1]) cylinder(d=4, h=espessura_peca + 2, $fn=20);
        translate([0, -12, -1]) cylinder(d=4, h=espessura_peca + 2, $fn=20);
        translate([32, 14, -1]) cylinder(d=5, h=espessura_peca + 2, $fn=20);
        translate([32, -14, -1]) cylinder(d=5, h=espessura_peca + 2, $fn=20);
    }
}

// Renderiza a garra final
garra_sentinela();