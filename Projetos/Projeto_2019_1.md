# Primeiro projeto em dupla
Neste projeto, os alunos deverao desenvolver um simulador de populaçao. 
O projeto contem dois componentes(ver especificaçao abaixo). Cada membro do grupo devera focar principalmente em um dos componentes, mas trabalhar em conjunto com o colega no desenho geral do projeto e integraçao de suas contribuiçoes em um projeto coeso. No caso de grupo de tres individuos o terceiro membro deve procurar contribuir parcial para os dois componentes. As contribuiçoes de cada membro do projeto serao verificadas pela identificaçao dos **commits** feitos no respositorio do grupo. Logo, todos precisarao programar e fazer commits.

## Especificaçao 
 - Uma populaçao e composta de individuos. Neste Projeto construiremos uma populaçoes de estudantes. Individuos devem ser implementados como uma classe com diversos atributos. **Escolha 15 atributos** a partir dos dados da [PNAD de 2014](pnad_2014_educacao_profissional.ods). Por exemplo:

```python
from random import randrange
class Pessoa:
    def __init__(self, idade, peso):
        self.idade = idade
        self.peso = peso

populaçao = [Pessoa(randrange(17,30), randrange(50,150)) for i in range(1000)]
print(populaçao[0].peso, populaçao[0].idade) 
```
-  A partir dos dados da PNAD para os atributos escolhidos, Desenvolva um algoritmo para  para gerar populaçoes de tamanho arbitrario, que apresentem as mesmas estatisticas da amostra da PNAD, com respeito a media e [coeficiente de variaçao](pnad_2014_educacao_profissional_cv.ods). Lembre-se de que o coeficiente de variaçao corresponde ao desvio padrao dividido pela media. A populaçao gerada deve tambem ser representada como uma classe, por exemplo:
```python
class Populaçao:
    def __init__(self, tamanho=1000):
        self.tamanho = tamanho
        self.individuos = []
    def amostra(self, n):
        pass
```
A classe populaçao deve conter instancias de pessoas dentro de seu atributo `individuos`. Deve tambem conter um metodo amostra que retorna uma amostra aleatoria da populaçao de tamanho `n` 

## Detalhes sobre a realizaçao e entrega do projeto.
Cada grupo deve criar um projeto no Github, para hospedagem deste trabalho. Cada membro do grupo deve trabalhar do seu clone do reposiorio para que seus commits sejam identificados. A contagem de commits por cada membro do grupo sera considerada para atribuiçao da nota individual.

Duvidas sobre este aspecto organizacional para entrega do trabalho podem ser tiradas com o Monitor da disciplina.
