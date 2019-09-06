import re
import pygments
import os
from pygments.lexers import guess_lexer


class ProcessaTexto:
    """
    Processador de markdown para inserção de código.
    """

    def __init__(self, caminho):
        self.max_linhas = 15
        self.regex = "(```[\w\W]*\s```)\n(\[Full *source\]\([/*\w\W]+\))"  # Antigo: "\{([/\w+]+.*\w+.py)\}"
        self.caminho = caminho
        self.codigo = None
        self.caminho_codigo = None
        self.caminho_base = os.path.split(self.caminho)[0]
        self.linhas = []
        self.marcações = []
        self.nlinhas = len(self.linhas)
        self.__processa()

    def __processa(self):
        self.linhas = self.le_texto()
        for l in self.linhas:
            m = self.encontra_referencias(l)
            if m:
                _, ling = self.carrega_codigo(m[2])
                self.insere_codigo(codigo=self.codigo, linguagem=ling)

    def le_texto(self):
        with open(self.caminho, 'r') as f:
            linhas = f.readlines()
        return linhas

    def encontra_referencias(self, linha):
        """
        Dada a linha returna marcações se existirem
        :param linha:  linha a ser analisada
        :return: lista com marcações.
        """
        marcações = re.findall(self.regex, linha)
        if marcações:
            self.marcações.append(self.linhas.index(linha))
        return marcações

    def carrega_codigo(self, caminho):
        with open(os.path.join(self.caminho_base, caminho), 'r') as f:
            texto = f.read()
        self.codigo = texto
        linguagem = guess_lexer(texto).name
        return texto, linguagem

    def insere_codigo(self, codigo, linguagem):
        linhas = codigo.split('\n')
        linhas = linhas[:self.max_linhas]
        codigo = '\n'.join(linhas)

        codigo = '```{}\n'.format(linguagem) + codigo + '\n```'
        for m in self.marcações:
            self.linhas[m] = re.sub(self.regex, codigo, self.linhas[m])
        with open(self.caminho, 'w') as f:
            f.writelines(self.linhas)


if __name__ == "__main__":
    P = ProcessaTexto('../Jogos/README.md')
    print(P.linhas)
