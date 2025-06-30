
; A seção .data é onde declaramos todas as variáveis e constantes pré-definidas que serão usadas pelo programa:
section .data

    ; Agora definimos todas as mensagens que serão exibidas para o usuário durante a execução do programa. A primeira mensagem pede ao usuário para digitar quantos discos ele deseja usar na Torre de Hanói:
    ; Obs.: 'db' significa 'define bytes' e armazena a string como uma sequência de caracteres.
    msg_input db "Digite a quantidade de discos com que você deseja jogar: "
    
    ; "len_input" calcula automaticamente o tamanho da mensagem subtraindo o endereço atual ($) do endereço inicial ("msg_input"), isso é importante porque precisamos saber quantos bytes escrever quando exibirmos a mensagem.
    ; Obs.: "equ" é a abreviação de "equate" (equivalente a um "definir como"), ele é usado para criar constantes simbólicas, ou seja, nomes que representam valores fixos durante a compilação, no caso abaixo sendo atribuído à "len_input" o valor respectivo ao tamanho da mensagem:
    len_input equ $ - msg_input
    
    ; Esta é a mensagem que será mostrada no início, informando com quantos discos o jogo será executado, observe que ela contém espaços reservados que serão preenchidos durante a execução:
    msg_inicial db "Algoritmo da Torre de Hanói com "
    msg_discos db " " ; Aqui será colocado o número de discos (um caractere ASCII).
                db " discos", 0x0A  ; 0x0A é o código para nova linha (como \n em C++).
    ; Novamente calculamos o tamanho total da mensagem, nesse caso, a inicial:
    len_inicial equ $ - msg_inicial
    
    ; Esta é a mensagem que será exibida para cada movimento dos discos, ela contém vários espaços reservados que serão preenchidos durante a execução:
    msg_mova db "Mova disco "
    msg_disco_atual db " " ; Aqui vai o número do disco respectivo que está sendo movido.
                db " da Torre "
    msg_torre_origem db " " ; Aqui vai a torre de origem (A, B ou C).
                db " para a Torre "
    msg_torre_destino db " " ; Aqui vai a torre de destino (A, B ou C).
                db 0x0A ; 0x0A é o código para nova linha (como \n em C++).
    ; Novamente calculamos o tamanho total da mensagem, nesse caso, a de movimento:
    len_movimento equ $ - msg_mova
    
    ; Mensagem simples que será exibida quando todos os movimentos forem concluídos:
    msg_concluido db "Concluído!"
    ; Novamente calculamos o tamanho total da mensagem, nesse caso, a de conclusão:
    len_concluido equ $ - msg_concluido


; Seção .bss: Define variáveis não inicializadas (espaço reservado na memória):
section .bss

    entrada_numero resb 2 ; Reserva 2 bytes para armazenar a entrada do usuário.
    num_discos resb 1 ; Reserva 1 byte para armazenar o número de discos.


; O ".text" é uma área de memória em um programa que contém o código executável, ou seja, as instruções que o processador irá executar. Essa seção não contém dados variáveis, mas sim as instruções que formam o programa propriamente dito. 
section .text

; A função 'input' é responsável por ler a entrada do usuário do teclado, ela usa a chamada de sistema 'sys_read' do Linux:
input:
    ; Primeiro salvamos os valores atuais dos registradores na pilha, isso é importante porque essas funções são chamadas em outras partes do programa e não queremos alterar acidentalmente valores que estão sendo usados:
    push eax
    push ebx
    push ecx
    push edx

    ; Configuramos os parâmetros para a chamada de sistema de leitura:
    mov eax, 3 ; O número 3 representa a syscall 'sys_read';
    mov ebx, 0 ; O arquivo descriptor 0 representa a entrada padrão (teclado).
    ; ecx e edx já devem ter sido configurados antes de chamar esta função;
    ; ecx deve apontar para onde armazenar a entrada (buffer);
    ; edx deve conter o número máximo de bytes a serem lidos.
    int 0x80 ; Esta instrução faz a chamada ao sistema operacional.

    ; Após a leitura, restauramos os valores originais dos registradores.
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; A função 'output' é responsável por escrever mensagens na tela, ela usa a chamada de sistema 'sys_write' do Linux:
output:
    ; Novamente, salvamos os registradores para preservar seus valores:
    push eax
    push ebx
    push ecx
    push edx

    ; Configuramos os parâmetros para a chamada de sistema de escrita:
    mov eax, 4 ; O número 4 representa a syscall 'sys_write';
    mov ebx, 1 ; O arquivo descriptor 1 representa a saída padrão (tela).
    ; ecx deve conter o endereço da mensagem a ser exibida;
    ; edx deve conter o tamanho da mensagem em bytes;
    ; Esses valores devem ser configurados antes de chamar esta função.
    int 0x80 ; Chamada ao sistema operacional.

    ; Restauramos os registradores originais:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; Esta função exibe a mensagem inicial que informa quantos discos serão usados:
exibir_mensagem_inicial:
    ; Salvamos os registradores:
    push eax
    push ebx
    push ecx
    push edx

    ; Preparamos o número de discos para exibição:
    ; O valor está armazenado em [num_discos] (na memória):
    mov al, [num_discos]
    ; Convertemos o número para seu equivalente ASCII adicionando '0':
    add al, "0"
    ; Armazenamos o caractere ASCII no local apropriado para a exibição na mensagem:
    mov [msg_discos], al

    ; Configuramos os parâmetros para a chamada de output:
    mov ecx, msg_inicial ; Endereço da mensagem.
    mov edx, len_inicial ; Tamanho da mensagem.
    call output ; Chamamos a função para exibir a mensagem.
    
    ; Restauramos os registradores originais:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; Esta função exibe uma mensagem mostrando o movimento atual:
output_movimento:
    ; Salvamos os registradores:
    push eax
    push ebx
    push ecx
    push edx

    ; Preparamos os valores para exibição.
    ; dl contém o número do disco, convertemos para ASCII:
    add dl, "0"
    mov [msg_disco_atual], dl
    ; al contém a torre de origem (A, B ou C).
    mov [msg_torre_origem], al
    ; cl contém a torre de destino (A, B ou C).
    mov [msg_torre_destino], cl

    ; Precisamos salvar ecx e edx porque vamos usá-los para a chamada de output:
    push ecx
    push edx
    ; Configuramos os parâmetros para exibir a mensagem:
    mov ecx, msg_mova ; Endereço da mensagem.
    mov edx, len_movimento ; Tamanho da mensagem.
    call output ; Exibimos a mensagem.
    ; Restauramos ecx e edx:
    pop edx
    pop ecx

    ; Convertemos dl de volta para valor numérico:
    sub dl, "0"

    ; Restauramos todos os registradores:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; Esta função lida com o caso base da recursão (quando há apenas 1 disco):
caso_base:
    ; Simplesmente chama a função para exibir o movimento:
    call output_movimento
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; Esta função implementa o algoritmo recursivo da Torre de Hanói:
recursao:
    ; Primeiro verificamos se estamos no caso base (apenas 1 disco):
    cmp dl, 1
    je caso_base  ; Se for 1, trata como caso base. "je" significa: "saltar se Igual".

    ; Se não for o caso base, precisamos fazer a recursão.
    ; Salvamos o estado atual dos registradores na pilha:
    push eax
    push ebx
    push ecx
    push edx

    ; Preparamos os parâmetros para a chamada recursiva:
    dec edx ; Diminuímos o número de discos.
    xchg ebx, ecx ; Trocamos as torres B e C (auxiliar e destino).
    
    ; Chamamos recursivamente a função:
    call recursao

    ; Após a chamada recursiva, restauramos os valores originais:
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ; Agora exibimos o movimento atual:
    call output_movimento

    ; Preparamos para a segunda chamada recursiva:
    push eax
    push ebx
    push ecx
    push edx

    dec edx ; Diminuímos o número de discos novamente.
    xchg eax, ebx ; Trocamos as torres A e B (origem e auxiliar).
    
    ; Segunda chamada recursiva:
    call recursao

    ; Restauramos os registradores novamente:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret ; Retorna para o ponto onde a função foi chamada. Equivalente a return em C++. Ele restaura o fluxo de execução para a próxima instrução após o call.


; Aqui começa a execução principal do programa.
; Marca onde o sistema operacional deve começar a executar o programa.
; Detalhes importantes: 1° Equivalente à função main() em C++; 2° O rótulo precisa ser declarado como global para ser visível externamente.
inicio_programa:

    global _start  ; Define o ponto de entrada do programa.

; O programa inicia aqui:
_start:
    ; Primeiro exibimos a mensagem pedindo o número de discos:
    mov ecx, msg_input  ; Endereço da mensagem.
    mov edx, len_input  ; Tamanho da mensagem.
    call output         ; Chamamos a função para exibir.

    ; Agora lemos a entrada do usuário:
    mov ecx, entrada_numero ; Buffer onde a entrada será armazenada.
    mov edx, 2 ; Número máximo de bytes a ler (1 dígito + enter).
    call input ; Chamamos a função de leitura.

    ; Convertemos o caractere ASCII para valor numérico:
    mov dl, [entrada_numero] ; Caractere digitado.
    sub dl, "0" ; Subtraímos '0' para converter para número.

    ; Armazenamos o número de discos na variável correspondente:
    mov [num_discos], dl

    ; Exibimos a mensagem inicial com o número de discos:
    call exibir_mensagem_inicial

    ; Configuramos os parâmetros iniciais para a Torre de Hanói:
    ; eax = torre origem ('A');
    ; ebx = torre auxiliar ('B');
    ; ecx = torre destino ('C');
    ; dl = número de discos (já está configurado).
    mov eax, "A"
    mov ebx, "B"
    mov ecx, "C"

    ; Chamamos a função recursiva principal:
    call recursao
    
    ; Após resolver toda a Torre de Hanói, exibimos a mensagem de conclusão:
    mov ecx, msg_concluido ; Endereço da mensagem;
    mov edx, len_concluido ; Tamanho da mensagem;
    call output ; Exibimos a mensagem.

    ; Finalizamos o programa com a chamada de sistema 'exit':
    mov eax, 1 ; Número da syscall 'exit';
    int 0x80 ; Chamada ao sistema operacional.
