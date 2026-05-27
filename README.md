# Sentinela - Módulo MMA-01 (Braço Robótico de Coleta)

**Projeto Integrado:** Global Solution & Project-Based Maker Lab (PBML)

## 👩‍🚀 Identificação da Equipe
* Deivison Pertel – RM 550803
* Eduardo Akira Murata – RM 98713
* Wesley Souza de Oliveira – RM 97874

## 🛰️ Contexto do Projeto (Global Solution)
Este projeto é um módulo integrado à plataforma **Sentinela**. Enquanto a Sentinela atua como o sistema central de monitoramento ambiental e detecção de riscos via dados orbitais, o **MMA-01 (Módulo de Manutenção Autônoma)** atua como a ferramenta física de intervenção. Ele é um braço robótico de coleta de amostras e *docking*, projetado para operar em ambientes de microgravidade, permitindo a manutenção de microssatélites ou a coleta de detritos espaciais.

## 🔗 Acesso ao Simulador
O circuito eletrônico e o firmware foram validados no simulador Tinkercad.
* **Link Público do Tinkercad:** [\[Sentinela - Módulo MMA-01\]](https://www.tinkercad.com/things/dwG5EdAbX4d-mma-01)

## ⚙️ Guia de Operação
O controle do módulo MMA-01 é realizado através do Monitor Serial do Arduino. Para operar o braço, inicie a simulação, abra o Monitor Serial, certifique-se de que a terminação de linha está em "Nenhum fim de linha" e envie os seguintes comandos (em letras maiúsculas):

* `U` (Up) -> Move a base do braço para cima (+15 graus).
* `D` (Down) -> Move a base do braço para baixo (-15 graus).
* `O` (Open) -> Abre a garra de coleta (posição 90 graus).
* `C` (Close) -> Fecha a garra de coleta (posição 0 graus).

## 📐 Software de Modelagem e Design
O componente físico da garra (Grip) foi projetado utilizando o **OpenSCAD**. 
A escolha do software se deu pela necessidade de **Design Paramétrico**. O código `.scad` incluído na pasta `/model` utiliza variáveis que permitem ajustar dinamicamente as dimensões do elo e o encaixe do motor, facilitando a adaptação para diferentes missões espaciais. O design inclui furos de alívio estrutural, otimizando a relação resistência-massa, uma premissa fundamental para o lançamento de cargas ao espaço.

## ⚡ Especificações Técnicas (Hardware)
Para garantir a estabilidade do sistema e evitar resets por sobrecarga de corrente nos pinos lógicos, a alimentação dos motores é independente do processador.
* **Tensão da Fonte de Bancada:** O sistema utiliza distribuição via barramento de protoboard, com alimentação configurada em **5V**.
* **Pinagem do Arduino:**
    * **Pino 9 (PWM):** Controle de sinal do Servo Motor da Base.
    * **Pino 10 (PWM):** Controle de sinal do Servo Motor da Garra.
    * **Pino 13 (Digital):** Acionamento do LED indicador de status do sistema.