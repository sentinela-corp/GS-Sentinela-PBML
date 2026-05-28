# Sentinela - Módulo MMA-01 (Braço Robótico de Coleta)

**Projeto Integrado:** Global Solution & Project-Based Maker Lab (PBML)

## 👩‍🚀 Identificação da Equipe
* Deivison Pertel – RM 550803
* Eduardo Akira Murata – RM 98713
* Wesley Souza de Oliveira – RM 97874

**Repositório GitHub:** [https://github.com/sentinela-corp/GS-Sentinela-PBML](https://github.com/sentinela-corp/GS-Sentinela-PBML)

## 🛰️ Contexto do Projeto (Global Solution)
Este projeto é um módulo integrado à plataforma **Sentinela**. Enquanto a Sentinela atua como o sistema central de monitoramento ambiental e detecção de riscos via dados orbitais, o **MMA-01 (Módulo de Manutenção Autônoma)** atua como a ferramenta física de intervenção. Ele é um braço robótico de coleta de amostras e *docking*, projetado para operar em ambientes de microgravidade, permitindo a manutenção de microssatélites ou a coleta de detritos espaciais.

## 🔗 Acesso ao Simulador
O circuito eletrônico e o firmware foram validados no simulador Tinkercad.
* **Link Público do Tinkercad:** [Sentinela - Módulo MMA-01](https://www.tinkercad.com/things/dwG5EdAbX4d-mma-01)

## ⚙️ Guia de Operação
O controle do módulo MMA-01 é realizado através do Monitor Serial do Arduino. Para operar o braço, inicie a simulação, abra o Monitor Serial, certifique-se de que a terminação de linha está em "Nenhum fim de linha" e envie os seguintes comandos (em letras maiúsculas):

* `U` (Up) -> Move a base do braço para cima (+15 graus).
* `D` (Down) -> Move a base do braço para baixo (-15 graus).
* `O` (Open) -> Abre a garra de coleta (posição 90 graus).
* `C` (Close) -> Fecha a garra de coleta (posição 0 graus).

## 📐 Software de Modelagem e Design

Os componentes físicos do MMA-01 foram projetados integralmente no **OpenSCAD**, utilizando **design paramétrico** para garantir adaptabilidade a diferentes configurações de missão.

O arquivo `garra_sentinela.scad` na pasta `/model` contém **dois módulos independentes**:

* **`elo_braco()`** — Elo estrutural que conecta dois servos em série. O perfil em "U" com paredes laterais contínuas e um **X-brace diagonal** (treliça em forma de X) distribui as forças de torque ao longo de toda a peça, prevenindo torção em manobras de docking. Inclui slot de encaixe preciso para o Servo 9g na extremidade de saída, furo de pivô M4 na extremidade de entrada, orelhas de montagem com furos M3 e janelas de alívio de massa retangulares.

* **`garra_sentinela()`** — Garra de captura com base dodecagonal (12 lados) e 8 fins radiais de reforço, replicando o padrão estrutural de um horn de servo usinado. Os dois dedos simétricos possuem perfil cônico construído em **5 seções encadeadas** (`hull()`), formando um gancho retroflexo na ponta para captura passiva de amostras. Cada dedo conta com nervura longitudinal no dorso (afilando de 4 mm para 1,6 mm) e duas nervuras transversais posicionadas em 1/3 e 1/2 do comprimento, garantindo rigidez sem adição de massa desnecessária.

Todas as dimensões críticas — comprimento do elo, abertura da garra, espessura das peças e medidas de encaixe do servo — são controladas por **variáveis paramétricas globais** no topo do arquivo, permitindo reescalonamento completo do conjunto sem reescrita de geometria.

O design responde diretamente ao desafio de microgravidade: a relação resistência-massa é otimizada pelos furos de alívio em cada componente, e a geometria de gancho retroflexo permite captura passiva de objetos sem necessidade de pressão contínua do servo, reduzindo consumo energético em órbita.

## ⚡ Especificações Técnicas (Hardware)
Para garantir a estabilidade do sistema e evitar resets por sobrecarga de corrente nos pinos lógicos, a alimentação dos motores é independente do processador.
* **Tensão da Fonte de Bancada:** O sistema utiliza distribuição via barramento de protoboard, com alimentação configurada em **5V**.
* **Pinagem do Arduino:**
    * **Pino 9 (PWM):** Controle de sinal do Servo Motor da Base.
    * **Pino 10 (PWM):** Controle de sinal do Servo Motor da Garra.
    * **Pino 13 (Digital):** Acionamento do LED indicador de status do sistema.