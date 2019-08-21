import pyxel


class App:
    def __init__(self):
        pyxel.init(160, 120, caption="Crivo de Eratostenes")

        # pyxel.image(0).load(0, 0, "Logo_FGV_EMAp.png")
        self.positions = [(x, y) for y in range(12, 112, 10) for x in range(22, 122, 10)]
        pyxel.run(self.update, self.draw)


    def update(self):

        if pyxel.btnp(pyxel.KEY_Q):
            pyxel.quit()

    def draw_full_table(self):
        for n in range(100):
            x, y = self.positions[n]
            pyxel.text(x, y, str(n), 6)#pyxel.frame_count % 16)

    def draw(self):
        pyxel.cls(0)
        pyxel.text(20, 3, "Numeros primos", 10)
        pyxel.rectb(120, 110, 20, 10, 9)
        self.draw_full_table()
        # pyxel.text(22, 22, "2", pyxel.frame_count % 16)



App()
