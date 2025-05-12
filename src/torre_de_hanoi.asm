section .data ; Inicializando a seção que possui dados já definidos (como se fossem "constantes")
    prompt db "Digite um número: ", 0 ; Define a mensagem de entrada do prompt. O 0 no final serve para delimitar onde a string finalizará (um "marco" para o programa saber que é para finalizar ali)
    len_prompt equ $ - prompt - 1 ; Calcula o tamanho da string, desconsiderando outros valores da memória e o próprio 0, que foi utilizado para delimitar o fim da string
    output db "Você digitou: ", 0 ; Define a mensagem de saída utilizando a mesma lógica da mensagem de entrada
    len_output equ $ - output - 1 ; Define o tamanho da mensagem de saída utilizando a mesma lógica da mensagem de entrada
    newline db 10 ; Caractere de quebra de linha (ASCII 10 = "\n")

section .bss ; Reserva espaço na memória para variáveis que serão usadas depois.
    num resb 2 ; Buffer para armazenar a entrada (até 2 bytes, o suficiente para a especificidade do projeto)

section .text ; Define o código principal que será executado
    global _start ; Define o ponto de entrada do programa (equivalente a um main())

_start: ; Marca onde o código começará a ser executado
    ; Escreve o prompt
    mov eax, 4 ; sys_write (código da syscall para escrever)
    ; Obs.: syscall - solicitar serviços do sistema operacional
    mov ebx, 1 ; stdout (define o file descriptor [1 = saída padrão para a tela, stdout])
    mov ecx, prompt ; Endereço da mensagem que será escrita
    mov edx, len_prompt ; Tamanho da mensagem que será escrita
    int 0x80 ; Chama a interrupção do kernel (núcleo do SO) para executar a syscall

    ; Lê a entrada do usuário
    mov eax, 3 ; sys_read (código da syscall para ler)
    mov ebx, 0 ; stdin (file descriptor 0 = entrada padrão para leitura)
    mov ecx, num ; Buffer onde a entrada será armazenada
    mov edx, 2 ; Tamanho máximo da entrada (2 bytes)
    int 0x80 ; Chama a interrupção do kernel (núcleo do SO) para executar a syscall

    ; Escreve a mensagem de saída
    mov eax, 4 ; sys_write (código da syscall para escrever)
    mov ebx, 1 ; stdout (define o file descriptor [1 = saída padrão para a tela, stdout])
    mov ecx, output ; Endereço da mensagem que será escrita
    mov edx, len_output ; Tamanho da mensagem que será escrita
    int 0x80 ; Chama a interrupção do kernel (núcleo do SO) para executar a syscall

    ; Escreve o número digitado
    mov eax, 4 ; sys_write (código da syscall para escrever)
    mov ebx, 1 ; stdout (define o file descriptor [1 = saída padrão para a tela, stdout])
    mov ecx, num ; Endereço do buffer que contém o número
    mov edx, 2 ; Tamanho máximo a ser escrito (2 bytes)
    int 0x80 ; Chama a interrupção do kernel (núcleo do SO) para executar a syscall

    ; Adiciona uma nova linha
    mov eax, 4 ; sys_write (código da syscall para escrever)
    mov ebx, 1 ; stdout (define o file descriptor [1 = saída padrão para a tela, stdout])
    mov ecx, newline ; Endereço do caractere (ASCII 10 = "\n")
    mov edx, 1 ; Tamanho máximo a ser escrito (1 byte - 1 linha)
    int 0x80 ; Chama a interrupção do kernel (núcleo do SO) para executar a syscall

    ; Sai do programa
    mov eax, 1 ; sys_exit (código da syscall para sair)
    mov ebx, 0 ; Define o status de saída como 0 (sucesso)
    int 0x80 ; Chama o kernel para encerrar
