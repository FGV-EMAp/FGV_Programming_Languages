# Programando Jogos Retro com a biblioteca Pyxel
A biblioteca Pyxel possui uma curva de aprendizagem extremamente suave para quem deseja começa com a programaçao de jogos. Os exercicios apresentados aqui tambem podem ser realizados na plataforma Repl.it.

Um jogo *Hello Pyxel* e muito simples:

```python
import pyxel


class App:
    def __init__(self):
        pyxel.init(160, 120, caption="Hello Pyxel")
        pyxel.image(0).load(0, 0, "assets/pyxel_logo_38x16.png")
        pyxel.run(self.update, self.draw)

    def update(self):
        if pyxel.btnp(pyxel.KEY_Q):
            pyxel.quit()

    def draw(self):
        pyxel.cls(0)
        pyxel.text(55, 41, "Hello, Pyxel!", pyxel.frame_count % 16)
        pyxel.blt(61, 66, 0, 0, 0, 38, 16)


App()
```

## Exercicio:

Modifique o codigo acima para desenhar em ordem os numeros primos de *1* a *n*, em uma tabela de acordo com o algoritmo conhecido como crivo de Eratostenes. Primeiro desenhe uma tabela quadrada com os numeros de um a 100 e depois va apagando os nao-primos.

### Solução

```Python
import pyxel
from crivo import crivo
from random import choice

class App:
    def __init__(self):
        pyxel.init(160, 120, caption="Crivo de Eratostenes")
        n = 100
        self.primos = list(crivo(n))
        self.pintados = []
        # pyxel.image(0).load(0, 0, "Logo_FGV_EMAp.png")
        self.positions = [(x, y) for y in range(12, 112, 10) for x in range(22, 122, 10)]
        pyxel.run(self.update, self.draw)


    def update(self):
        if pyxel.btnp(pyxel.KEY_Q):
            pyxel.quit()

    def draw_full_table(self):
        self.coords = {}
        for n in range(100):
            x, y = self.positions[n]
            self.coords[n] = (x, y)
            # cor = 8 if n in self.primos else 6
            if n in self.pintados:
                pyxel.text(x, y, str(n), pyxel.frame_count % 16)
            else:
                pyxel.text(x, y, str(n), 6)

    def pinta_primo(self, p):
        self.pintados.append(p)
        x, y = self.coords[p]
        pyxel.text(x, y, str(p), pyxel.frame_count % 16)
        self.primos.pop(self.primos.index(p))


    def draw(self):
        pyxel.cls(0)
        # pyxel.text(2,2,str(pyxel.frame_count),6)
        pyxel.text(20, 3, "Numeros primos", 10)
        pyxel.rectb(20,10,102, 102, 9)
        self.draw_full_table()
        if pyxel.frame_count % 10 == 0 and len(self.primos) > 0:
            self.pinta_primo(choice(self.primos))

    # pyxel.text(22, 22, "2", pyxel.frame_count % 16)



App()

```
