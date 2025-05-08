# Obs.: valor_disco assume a quantidade de discos.

def hanoi(valor_disco, origem, destino, auxiliar):
    if valor_disco == 1:

        # Mover o disco maior de origem -> destino.
        print(f'Mova o disco 1 de {origem} para {destino}.')

    else:
        # Nosso primeiro subproblema: precisamos mover (todos os discos - 1) para a torre auxiliar, para assim conseguirmos colocar o maior disco (base) na torre de origem, então nesse caso a torre auxiliar assume o papel de origem.
        # Ou seja: Mover N-1 discos de origem -> auxiliar.
        hanoi(valor_disco-1, origem, auxiliar, destino)

        # Aqui valor_disco representa o disco em questão, não a quantidade.
        print(f'Mova o disco {valor_disco} de {origem} para {destino}')

        # Nosso segundo subproblema: precisamos mover (todos os discos - 1) para a torre de destino - assumindo que a nossa torre de "origem" é a torre auxiliar.
        # Ou seja: Mover N- discos de auxiliar -> destino.
        hanoi(valor_disco-1, auxiliar, destino, origem)

# Exemplo:
qtd_discos = 3
print(f'# Torre de Hanói para {qtd_discos} discos: #')
hanoi(qtd_discos, 'A', 'C', 'B')
print('Fim.')


# Funcionamento para 3 discos:

# 1 - 3, A, C, B;
# 2 - 2, A, B, C;
# 3 - 1, A, C, B <- 1° print (1 A -> C);
# 4 - 2° print (2 A -> B);
# 5 - 1, C, B, A;
# 6 - 3° print (1 C -> B);
# 7 - 4° print (3 A -> C);
# 8 - 2, B, C A;
# 9 - 1, B, A, C <- 5° print (1 B -> A);
# 10 - 6° print (2 B -> C);
# 11 - 1, A, C, B <- 7° print (1 A -> C).
