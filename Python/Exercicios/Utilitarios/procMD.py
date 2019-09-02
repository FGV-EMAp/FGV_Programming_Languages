import re
import pygments
import os
from pygments.lexers import guess_lexer

class ProcessaTexto:
    def __init__(self, caminho):
        self.caminho = caminho
        self.caminho_base = os.path.split(self.caminho)[0]
        self.linhas = self.le_texto()
        self.nlinhas = len(self.linhas)

    def le_texto(self):
        with open(self.caminho, 'r') as f:
            linhas = f.readlines()
        return linhas

    def encontra_referencias(self, linha):
        marcações = re.findall("\{([/\w+]+.*\w+.py)\}", linha)
        return marcações

    def carrega_codigo(self, caminho):
        with open(os.path.join(self.caminho_base, caminho), 'r') as f:
            texto = f.read()
        linguagem = guess_lexer(texto).name
        return texto, linguagem


if __name__ == "__main__":
    P = ProcessaTexto('../Jogos/README.md')
    print(P.linhas)
    for l in P.linhas:
        m = P.encontra_referencias(l)
        if m:
            _, ling = P.carrega_codigo(m[0])
            print(m)
            print(ling)

