# Instruções de Uso: Fantasy32

Este documento explica como compilar e executar os três programas do projeto: o **Assembler**, a **Máquina Virtual (VM)** e os **jogos**.

Todo o fluxo é feito via `Makefile`. Não há mais dependência de Docker.

---

## 1. Assembler

O assembler converte um arquivo de código-fonte (`.asm`) em um binário (`.bin`) executável pela VM.

### Sintaxe

```sh
./src/assembler/assembler caminho/para/entrada.asm caminho/para/saida.bin
```

Ele recebe exatamente dois argumentos posicionais, nesta ordem:

1. **Arquivo de entrada**: o código-fonte em Assembly (`.asm`).
2. **Arquivo de saída**: onde o binário gerado (`.bin`) será salvo.

**Exemplo:**

```sh
./src/assembler/assembler src/game/tetris/tetris.asm build/tetris.bin
```

---

## 2. Máquina Virtual (VM)

A VM executa um binário (`.bin`) gerado pelo assembler, interpretando suas instruções e cuidando da renderização, entrada e áudio via SDL2.

### Sintaxe

```sh
./build/app [opções] caminho/para/o/arquivo.bin
```

### Opções de linha de comando

`--scale <fator>`: Define o fator de escala da janela.
Um fator de 2 resulta em uma janela de 640x480. Padrão: `1`.

`--no-syscall`: Desativa a execução da instrução `SYSCALL`, fazendo com que a VM ignore essa instrução.

`--help`, `-h`: Exibe a mensagem de ajuda com todas as opções disponíveis.

Se nenhum caminho de arquivo `.bin` for informado, a VM tenta carregar `src/assembler/prog1.bin` por padrão.

**Exemplo:**

```sh
./build/app --scale 2 --no-syscall build/tetris.bin
```

### Executando via Makefile

A VM também pode ser executada através do `make`, usando a variável `BIN` para indicar o binário e `ARGS` para passar as opções acima.

```sh
make run BIN=build/tetris.bin ARGS="--scale 2 --no-syscall"
```

> **Importante:** as opções da VM (`--scale`, `--no-syscall`) precisam ser passadas através da variável `ARGS="..."`. Não é possível passá-las diretamente após o nome do alvo (ex: `make run --scale 2` **não funciona**), pois o `make` tentaria interpretá-las como opções dele mesmo, e não do programa.

---

## 3. Jogos

O projeto inclui dois jogos prontos: **Tetris** e **Space Shooter**. O `Makefile` automatiza o processo de montar (assemblar) o jogo e em seguida executá-lo na VM, em um único comando.

### Tetris

**Objetivo:** encaixar as peças que caem para formar linhas completas, eliminando-as e evitando que a pilha de peças alcance o topo do tabuleiro.

**Controles:**

| Tecla | Ação |
|---|---|
| `A` | Move a peça para a esquerda |
| `D` | Move a peça para a direita |
| `W` | Gira a peça |

**Como executar:**

```sh
make tetris
```

Com opções da VM:

```sh
make tetris ARGS="--scale 2"
```

### Space Shooter

**Objetivo:** destruir as naves inimigas e sobreviver o maior tempo possível, evitando colisões e tiros adversários.

**Controles:**

| Tecla | Ação |
|---|---|
| `↑` `↓` `←` `→` | Move a nave |
| `Espaço` | Atira |

**Como executar:**

```sh
make space-shooter
```

Com opções da VM:

```sh
make space-shooter ARGS="--no-syscall"
```

---

## Resumo rápido

| Programa | Comando (Makefile) | Comando (binário direto) |
|---|---|---|
| Assembler | - | `./src/assembler/assembler entrada.asm saida.bin` |
| VM | `make run BIN=arquivo.bin ARGS="--scale 2"` | `./build/app --scale 2 arquivo.bin` |
| Tetris | `make tetris ARGS="--scale 2"` | `./build/app --scale 2 build/tetris.bin` |
| Space Shooter | `make space-shooter ARGS="--no-syscall"` | `./build/app --no-syscall build/space-shooter.bin` |