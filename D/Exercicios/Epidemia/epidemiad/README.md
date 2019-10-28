# Importando um módulo D no Python
Agora que você desenvolveu um modulo para simulação de modelos epidêmicos estocásticos em D, com o intuito de tornar as simulações mais eficientes,
vamos aprender como podemos utiliza-lo de dentro de um programa em Python. 

Para facilitar a importação do nosso módulo de qualquer diretório que quisermos podemos instalar nosso pacote `PyD`.

```bash
$ sudo python setup.py install
```
Este comando irá compilar o módulo D e o instalará. Se tudo correr bem nesta etapa, você já pode testar o módulo [neste notebook](D_importa.ipynb)
