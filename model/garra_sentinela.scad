// ================================================================
//  Sentinela – Módulo MMA-01 | Braço Robótico Espacial v3
//  Componentes: Elo do Braço (arm link) + Garra de Captura
//  Design: Aeroespacial / Microgravidade
//  Software: OpenSCAD – Design 100% Paramétrico
// ================================================================


// ---------------------------------------------------------------
//  VARIÁVEIS PARAMÉTRICAS GLOBAIS
//  Altere APENAS esta seção para adaptar o projeto.
// ---------------------------------------------------------------

// Servo 9g – Tower Pro SG90 (medidas reais)
servo_larg    = 23.0;   // largura do corpo
servo_comp    = 12.5;   // comprimento do corpo
servo_horn_d  = 14.0;   // diâmetro do horn circular

// Elo do Braço
elo_comp      = 95;     // comprimento total do elo (mm)
elo_larg      = 32;     // largura da peça
elo_esp       = 6;      // espessura da placa base
elo_rib_h     = 5;      // altura das nervuras acima da placa
parede        = 3;      // espessura mínima de parede

// Garra de Captura
garra_comp    = 76;     // comprimento de cada dedo
garra_esp     = 5;      // espessura (altura Z) da garra
abertura      = 30;     // abertura máxima entre os dedos (mm)
dedo_larg     = 11;     // largura na base do dedo
rib_h_dedo    = 4;      // altura da nervura longitudinal do dedo

// Tolerâncias de impressão 3D
folga         = 0.3;    // folga geral para encaixes
furo_m3       = 3.2;    // diâmetro de furo parafuso M3
furo_m4       = 4.2;    // diâmetro de furo pino/pivô M4

$fn           = 48;     // qualidade global de arcos


// ================================================================
//  MÓDULO 1 – ELO DO BRAÇO
//  Conecta dois servos em série. Estrutura em "U" com X-brace
//  diagonal, orelhas de montagem e janelas de alívio de massa.
// ================================================================
module elo_braco() {

    // Limite seguro antes do slot do servo
    brace_fim = elo_comp - servo_larg - parede * 2 - 2;

    difference() {
        union() {

            // ── Placa base ──
            cube([elo_comp, elo_larg, elo_esp]);

            // ── Paredes laterais longitudinais (perfil em "U") ──
            cube([elo_comp, parede, elo_esp + elo_rib_h]);
            translate([0, elo_larg - parede, 0])
                cube([elo_comp, parede, elo_esp + elo_rib_h]);

            // ── X-BRACE DIAGONAL ──────────────────────────────
            // Diagonal A: canto inf-esq → canto sup-dir
            hull() {
                translate([parede * 2 + 10, parede, elo_esp])
                    cube([parede, parede, elo_rib_h]);
                translate([brace_fim - parede, elo_larg - parede * 2, elo_esp])
                    cube([parede, parede, elo_rib_h]);
            }
            // Diagonal B: canto sup-esq → canto inf-dir
            hull() {
                translate([parede * 2 + 10, elo_larg - parede * 2, elo_esp])
                    cube([parede, parede, elo_rib_h]);
                translate([brace_fim - parede, parede, elo_esp])
                    cube([parede, parede, elo_rib_h]);
            }

            // ── Nervura transversal central (reforço no nó do X) ──
            translate([elo_comp / 2 - parede / 2, 0, elo_esp])
                cube([parede, elo_larg, elo_rib_h]);

            // ── Parede de fechamento extremidade esquerda ──
            translate([0, 0, elo_esp])
                cube([parede, elo_larg, elo_rib_h]);

            // ── Orelhas de montagem (protuberâncias nas extremidades) ──
            // Esquerda: recebe pivô/eixo do servo anterior
            translate([0, elo_larg / 2, 0])
                cylinder(d = 20, h = elo_esp);
            // Direita: assenta sobre o servo seguinte
            translate([elo_comp, elo_larg / 2, 0])
                cylinder(d = 20, h = elo_esp);
        }

        // ── SUBTRAÇÕES ───────────────────────────────────────

        // Slot do servo 9g – extremidade direita
        translate([elo_comp - servo_larg - parede,
                   (elo_larg - servo_comp) / 2,
                   -1])
            cube([servo_larg + folga * 2,
                  servo_comp + folga * 2,
                  elo_esp + 2]);

        // Furo passante do horn – eixo de saída do servo
        translate([elo_comp - servo_larg / 2 - parede,
                   elo_larg / 2, -1])
            cylinder(d = servo_horn_d + folga * 2, h = elo_esp + 2);

        // Furo de pivô M4 – extremidade esquerda
        translate([0, elo_larg / 2, -1])
            cylinder(d = furo_m4, h = elo_esp + 2);

        // Furos de fixação M3 nas orelhas
        translate([0,    elo_larg / 2, -1]) cylinder(d = furo_m3, h = elo_esp + 2);
        translate([elo_comp, elo_larg / 2, -1]) cylinder(d = furo_m3, h = elo_esp + 2);

        // Janelas de alívio de massa – 2 aberturas retangulares
        // (redução de peso: requisito de microgravidade)
        w1_x = 15;
        w1_w = 22;
        translate([w1_x, parede * 2, -1])
            cube([w1_w, elo_larg - parede * 4, elo_esp + 2]);

        w2_x = w1_x + w1_w + 8;
        w2_w = brace_fim - w2_x - 4;
        translate([w2_x, parede * 2, -1])
            cube([w2_w, elo_larg - parede * 4, elo_esp + 2]);
    }
}


// ================================================================
//  MÓDULO 2 – GARRA DE CAPTURA
//  Base dodecagonal com fins radiais de reforço. Dois dedos
//  simétricos chamados pelo sub-módulo _dedo().
// ================================================================
module garra_sentinela() {

    base_r = servo_larg / 2 + parede + 5;   // raio da base

    difference() {
        union() {

            // ── Base dodecagonal (look de peça usinada aeroespacial) ──
            cylinder(r = base_r, h = garra_esp, $fn = 12);

            // ── 8 Fins radiais de reforço (padrão de servo horn) ──
            for (ang = [22.5 : 45 : 337.5]) {
                rotate([0, 0, ang])
                    translate([0, -parede / 2, garra_esp])
                        cube([base_r - 1, parede, rib_h_dedo]);
            }

            // ── Dedo Superior ──
            translate([0, abertura / 2 + dedo_larg / 2, 0])
                _dedo();

            // ── Dedo Inferior (espelhado em Y) ──
            translate([0, -(abertura / 2 + dedo_larg / 2), 0])
                mirror([0, 1, 0])
                    _dedo();
        }

        // Slot retangular do servo na base
        translate([-(servo_larg / 2 + folga),
                   -(servo_comp / 2 + folga), -1])
            cube([servo_larg + folga * 2,
                  servo_comp + folga * 2,
                  garra_esp + 2]);

        // Furo central do horn
        cylinder(d = servo_horn_d + folga, h = garra_esp + 2, center = true);

        // 4 Furos de fixação M3 em cruz (45°, 135°, 225°, 315°)
        for (ang = [45, 135, 225, 315]) {
            rotate([0, 0, ang])
                translate([base_r - 5, 0, -1])
                    cylinder(d = furo_m3, h = garra_esp + 2);
        }
    }
}


// ================================================================
//  MÓDULO INTERNO – _dedo()
//  Perfil cônico em 5 seções (hull encadeado) com gancho
//  retroflexo na ponta e nervuras estruturais no dorso.
// ================================================================
module _dedo() {

    difference() {
        union() {

            // ── CORPO: 5 seções cônicas encadeadas ──────────

            // Seção 1 – Base larga, reta
            hull() {
                cylinder(d = dedo_larg, h = garra_esp, $fn = 30);
                translate([garra_comp * 0.28, 0, 0])
                    cylinder(d = dedo_larg * 0.88, h = garra_esp, $fn = 30);
            }

            // Seção 2 – Afunila levemente, ainda reto
            hull() {
                translate([garra_comp * 0.28, 0, 0])
                    cylinder(d = dedo_larg * 0.88, h = garra_esp, $fn = 30);
                translate([garra_comp * 0.52, -abertura * 0.06, 0])
                    cylinder(d = dedo_larg * 0.74, h = garra_esp, $fn = 30);
            }

            // Seção 3 – Curva interna começa (início do gancho)
            hull() {
                translate([garra_comp * 0.52, -abertura * 0.06, 0])
                    cylinder(d = dedo_larg * 0.74, h = garra_esp, $fn = 30);
                translate([garra_comp * 0.70, -abertura * 0.22, 0])
                    cylinder(d = dedo_larg * 0.60, h = garra_esp, $fn = 30);
            }

            // Seção 4 – Curva agressiva rumo à captura
            hull() {
                translate([garra_comp * 0.70, -abertura * 0.22, 0])
                    cylinder(d = dedo_larg * 0.60, h = garra_esp, $fn = 30);
                translate([garra_comp * 0.84, -abertura * 0.40, 0])
                    cylinder(d = dedo_larg * 0.48, h = garra_esp, $fn = 30);
            }

            // Seção 5 – Ponta retroflexo (gancho de captura final)
            hull() {
                translate([garra_comp * 0.84, -abertura * 0.40, 0])
                    cylinder(d = dedo_larg * 0.48, h = garra_esp, $fn = 30);
                translate([garra_comp * 0.92, -abertura * 0.51, 0])
                    cylinder(d = dedo_larg * 0.36, h = garra_esp, $fn = 30);
            }

            // ── NERVURA LONGITUDINAL DO DORSO ───────────────
            // Corre do 1/4 até 72% do dedo, afilando em altura
            hull() {
                translate([garra_comp * 0.22, -parede / 2, garra_esp])
                    cube([parede, parede, rib_h_dedo]);
                translate([garra_comp * 0.70, -parede / 2 - abertura * 0.07, garra_esp])
                    cube([parede * 0.7, parede, rib_h_dedo * 0.4]);
            }

            // ── NERVURA TRANSVERSAL no 1/3 ──────────────────
            translate([garra_comp * 0.27, -(dedo_larg * 0.55), garra_esp])
                cube([parede, dedo_larg * 1.1, rib_h_dedo * 0.85]);

            // ── NERVURA TRANSVERSAL no 1/2 ──────────────────
            translate([garra_comp * 0.50, -(dedo_larg * 0.48), garra_esp])
                cube([parede, dedo_larg * 0.95, rib_h_dedo * 0.60]);
        }

        // ── Furo de alívio de massa no corpo do dedo ──
        translate([garra_comp * 0.38, -dedo_larg * 0.08, -1])
            cylinder(d = dedo_larg * 0.46, h = garra_esp + 2, $fn = 22);

        // ── Furo de alívio na seção de curvatura ──
        translate([garra_comp * 0.63, -abertura * 0.13, -1])
            cylinder(d = dedo_larg * 0.40, h = garra_esp + 2, $fn = 22);
    }
}


// ================================================================
//  RENDERIZAÇÃO FINAL
//  Os dois componentes são exibidos lado a lado para visualização.
//  Para exportar STL de cada peça individualmente:
//    1. Comente o translate/render que NÃO quer exportar
//    2. Use Arquivo → Exportar → Exportar como STL
// ================================================================

// Componente 1 – Elo do Braço
elo_braco();

// Componente 2 – Garra de Captura (deslocada para não sobrepor)
translate([0, elo_larg + 28, 0])
    garra_sentinela();

