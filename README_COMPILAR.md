# Instruções de Compilação: Fantasy32

Este documento explica, passo a passo, como instalar as dependências e compilar o executável do projeto (VM + Jogos) em ambiente Linux (Ubuntu/Debian).

---

## 1. Dependências necessárias

Para compilar o projeto, é necessário ter instalado:

* **g++** (compilador C++ com suporte a C++17), através do pacote `build-essential`.
* **SDL2** (biblioteca usada para renderização gráfica, entrada de teclado e áudio), incluindo os arquivos de desenvolvimento (`libsdl2-dev`), que fornecem o utilitário `sdl2-config` usado pelo `Makefile`.
* **make**, para interpretar o `Makefile` do projeto (normalmente já vem incluso no `build-essential`).

---

## 2. Compilando o projeto

Para compilar o executável principal (`build/app`), que contém a VM e é capaz de executar qualquer jogo no formato `.bin`, execute na raiz do projeto:

```sh
make
```

Esse comando compila todos os arquivos-fonte de `src/` e gera o executável em:

```
build/app
```

Caso queira limpar os arquivos já compilados antes de uma nova build (por exemplo, após alterações no código), execute:

```sh
make clean
```

E em seguida rode `make` novamente.

---

## 3. Compilando e executando os jogos de exemplo

O `Makefile` também automatiza o processo de montar (assemblar) os jogos prontos e executá-los na VM, em um único comando.

### Tetris

```sh
make compilar-tetris
```

### Space Shooter

```sh
make compilar-space-shooter
```

Esses comandos compilam o executável principal (se ainda não tiver sido compilado), usam o assembler fornecido pelo professor para gerar o binário do jogo a partir do `.asm`, e então executam o jogo na VM.

---

## 4. Resumo dos comandos

| Etapa | Comando |
|---|---|
| Compilar o projeto | `make` |
| Limpar arquivos compilados | `make clean` |
| Compilar e rodar o Tetris | `make compilar-tetris` |
| Compilar e rodar o Space Shooter | `make compilar-space-shooter` |

> Para detalhes sobre como executar o programa com opções específicas (escala da janela, desativar `SYSCALL`, etc.), consulte o arquivo `README_USO.pdf`.