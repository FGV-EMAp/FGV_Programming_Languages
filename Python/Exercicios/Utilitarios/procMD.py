class ProcessaTexto:
    def __init__(self, caminho):
        self.caminho = caminho
        self.linhas = self.le_texto()
        self.nlinhas = len(self.linhas)

    def le_texto(self):
        with open(self.caminho, 'r') as f:
            linhas = f.readlines()
        return linhas


if __name__ == "__main__":
    P = ProcessaTexto('../../Jogos/Crivo/eratostenes.py')
    print(P.linhas, P.nlinhas)
