
# Fantasy32

O projeto é uma máquina virtual junto de um jogo feito como projeto da matéria de Aspectos de Línguagem de Programação.

## Introdução

Um Fantasy Computer é uma máquina hipotética, projetada para permitir a implementação de um conjunto de instruções personalizado e a criação de jogos simples. Este projeto é dividido em duas fases: implementação da VM e criação de um jogo simples para a máquina virtual.

## Objetivo do trabalho

O objetivo deste trabalho é compreender na prática os conceitos fundamentais da implementação de assemblers e máquinas virtuais. Para isso, o projeto contempla:

- uma máquina virtual (VM) que executa o código gerado pelo assembler, interpretando instruções e manipulando memória, registradores e dispositivos de entrada e saída conforme especificado;
- um jogo simples desenvolvido em Assembly para o fantasy computer, demonstrando controle de fluxo, manipulação de memória e E/S em uma experiência interativa.

Ao desenvolver estes softwares, o projeto permite:

- entender o ciclo de busca, decodificação e execução de instruções em uma máquina virtual;
- implementar uma CPU simulada com um conjunto de instruções personalizado e um sistema de memória e E/S;
- criar jogos simples em Assembly explorando conceitos de controle de fluxo, manipulação de memória e E/S;
- utilizar a biblioteca SDL (Simple DirectMedia Layer) para renderização gráfica, entrada por teclado e áudio.

## Como rodar

### Build da imagem

```bash
docker build -t fantasy32 .
```

### Executar o projeto

```bash
docker compose up --build --watch
```

Depois de subir o container, lembre de abrir o Docker Desktop e garantir que o container esteja em execução. Se o watcher não estiver ativo automaticamente, pressione `w` no terminal para habilitá-lo.

## Estrutura do projeto

- `assembler/`: código do assembler da linguagem do fantasy computer.
- `vm/`: implementação da máquina virtual.
- `game/`: arquivos relacionados ao jogo executado na VM.
- `main.cpp`: ponto de entrada principal do projeto.

## Observações

- O projeto foi pensado para rodar em ambiente Docker.
- Se houver alterações no código-fonte, basta executar novamente o comando de `docker compose` com `--watch` para recompilar e refletir as mudanças.
