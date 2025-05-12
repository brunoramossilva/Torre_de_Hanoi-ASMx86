section .data ; Inicializando a seção que possui dados já definidos (como se fossem "constantes")
    prompt db "Digite um número: ", 0   ; Define a mensagem de entrada do prompt. O 0 no final serve para delimitar onde a string finalizará (um "marco" para o programa saber que é para finalizar ali)
    len_prompt equ $ - prompt - 1       ; Calcula o tamanho da string, desconsiderando outros valores da memória e o próprio 0, que foi utilizado para delimitar o fim da string
    output db "Você digitou: ", 0       ; Define a mensagem de saída utilizando a mesma lógica da mensagem de entrada
    len_output equ $ - output - 1       ; Define o tamanho da mensagem de saída utilizando a mesma lógica da mensagem de entrada
    newline db 10                       ; Caractere de quebra de linha (ASCII 10 = "\n")
