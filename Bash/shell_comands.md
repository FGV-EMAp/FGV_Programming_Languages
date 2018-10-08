##Introdução ao Shell do Linux

Baseado [neste](https://www.guiadopc.com.br/artigos/693/prompt-do-linux-stdin-stdout-stderr-e-seus-truques-parte-i.html) artigos, dentre outros.

### stdin, o stdout e o stderr

Todos os programas que fazem interface com o usuário precisam receber por algum meio as informações passadas por ele. O meio mais antigo e comum do usuário passar informações a um programa é via teclado. Por isto mesmo, ele é considerado a entrada padrão, e é daí que vem o nome stdin (STandarD INput, ou Entrada Padrão).

No Linux, em alguns programas, você passa as informações previamente, via parâmetros, antes de executá-lo. Em outros, você pode digitar as informações durante a execução, caso especifique que a entrada deve originar do stdin.

Também temos o stdout (STandarD OUTput, ou Saída Padrão), que representa o monitor, já que ele é o dispositivo de saída padrão na interface com o usuário. Nesta saída, temos acesso a todas as mensagens de informação que o sistema gera na tela para o usuário. Ela pode ser representada pelo número 1.

Por fim, temos o stderr (STandarD ERRor, ou Erro Padrão), que também é apresentado no monitor, mas é por ele que são enviadas as mensagens de erro geradas pelos aplicativos. Ela pode ser representada pelo número 2.

A maioria dos programas em modo texto trabalham com estes “carinhas”, ou seja, aceitam entrada pelo stdin, mostram mensagens informativas pelo stdout, e mostram erros via stderr.

Operadores

Você pode manipular as entradas e saídas com estes três operadores:

- Pipe ( | ): Liga o stdout de um programa ao stdin de outro.
- Write ( > ): Redireciona o stdout para outro local (um arquivo, por exemplo).
- Append ( >> ): Anexa o stdout para outro local (um arquivo, por exemplo).

Repare que há uma pequena diferença entre o “>” e o “>>”: o primeiro apaga o conteúdo do destino, para então escrever seus dados; o segundo apenas acrescenta as informações às já existentes.

Legal, mas o que eu faço com isto?

Ora, dá pra fazer muita coisa!!! Se você entendeu o conceito, e se você conhecer alguns comandos úteis (assunto para o próximo artigo), dá para fazer muitas coisas interessantes usando estes operadores e conceitos. Alguns exemplos pra começar:

- Enviar a saída do comando ls para o arquivo “lista.txt”:
$ ls > lista.txt
- Semelhante ao comando acima, mas preservando o conteúdo original do arquivo “lista.txt”:
$ ls >> lista.txt
- Obter uma lista do tamanho (em MiB) ocupado por cada arquivo na pasta atual e subpastas, e classificar a relação do maior para o menor:
$ du -m | sort -nr

Em todos estes casos, trabalhamos apenas com stdout e stdin. Para trabalhar com a stderr, a coisa fica assim (repare no “2″):

- Remover todos os arquivos em /home, listando um por um, e fazer log dos erros no arquivo /tmp/erros.txt:
$ rm -rfv /home 2> /tmp/erros.txt
- Mesmo caso acima, mas as mensagens de informação irão para o arquivo /tmp/info.txt:
$ rm -rfv /home 1> /tmp/info.txt 2> /tmp/erros.txt
- Outra abordagem do mesmo problema, mas desta vez, tudo irá para o arquivo /tmp/info.txt:
$ rm -rfv /home 1> /tmp/info.txt 2>&1

Ponha tudo numa linha só

O nosso amigo pipe (aquele “caninho” vertical: | ) pode ser uma tremenda mão na roda em alguns casos.

Suponha que você está com sua partição /home cheia, e você quer descobrir quem são os 10 usuários mais “fominhas”, classificado do maior para o menor, com números em megabytes, e ainda por cima, quer mandar esta relação por e-mail. Não existe comando que faça tudo isto numa tacada só; o jeito é concatenar a saída de um programa (stdout) com a entrada de outro (stdin):

# du -m --max-depth=1 /home | sort -rn | head -n 11 | mail -s "Usuários fominhas" meu_email@provedor.com.br

Não vou explicar parâmetro por parâmetro, senão isto aqui vai ficar enorme. Mas resumindo, a primeira parte (du -m --max-depth=1 /home) obtém uma lista com os totais ocupados por cada pasta dentro do /home, sem exibir as subpastas, e mostra os totais em megabytes; a segunda parte (sort -rn) classifica a relação obtida em ordem reversa, e tratando números como números (não como texto, que é o padrão); a terceira parte (head -n 11) pega as 11 primeiras linhas desta relação (11 porque a primeira vai ser o total geral); e por fim, o último comando pega esta relação e a manda por e-mail (você precisa ter o envio de e-mails instalado e configurado).

Vai pra lá, vai pra cá…

No último artigo, havia falado do write (>). Acontece que eu esqueci de mencionar que há o inverso também, no caso, “<" A função é parecida, porém, com a mudança de direção, obviamente muda-se o sentido em que as coisas devem ser digitadas, e o jeito de aplicá-lo também.

Por exemplo: os comandos cat teste | sort e sort < teste fazem basicamente a mesma coisa: lêem o arquivo "teste" e o classificam em ordem alfabética. Só que no segundo caso, eu estou passando como entrada do programa um arquivo, quando no primeiro, o que eu passei foi a saída de um comando. Lembre-se: depois do "<", o que deve vir é um nome de um arquivo, jamais um comando. E há ganho de performance nisto: a segunda sintaxe é cerca de 3x mais rápida do que a primeira. A diferença pode ser imperceptível ao executar o comando uma vez, mas se for executado várias e várias vezes, dá para se notar.

Comandos úteis

Agora que você entendeu o conceito básico (sim, há muito mais conteúdo pra quem quer se aprofundar...), aí vão vários comandos legais para se trabalhar desta forma. Alguns deles vão merecer destaque especial aqui no Guia, pois são extremamente úteis em vários cenários.

cat / tac: o primeiro abre um arquivo e o mostra na tela (stdout); o segundo faz o mesmo, mas mostra o arquivo de trás para frente.
sort: classifica a entrada em ordem alfabética ou numérica (-n), crescente ou descrescente (-r).
nl: numera as linhas.
wc: conta os caracteres (-c), as palavras (-w) ou as linhas (-l).
head: mostra as primeiras linhas. O número pode ser definido com -n.
tail: mostra as últimas linhas. O número pode ser definido com -n.
grep / egrep / fgrep: pesquisador de expressões regulares, usado para encontrar padrões dentro de um texto. Este aqui vai merecer atenção especial no Guia.
cut: demilita a entrada por um separador (-d), e permite pegar campos específicos (-f). Pense nele como o seu amigo para quando você tiver um arquivo com linhas no estilo "dado1:dado2:dado3", e você precisar pegar apenas um ou alguns destes dados, que no caso, estão delimitados por dois pontos.
awk: semelhante ao acima, porém muito mais poderoso. Quando eu aprender a trabalhar com ele direito, eu faço um artigo no Guia :)
tr: substitui ou deleta caracteres, e também pode deletar repetidos.
sed: equivalente ao comando acima, porém muito mais flexível e poderoso. Este aqui vai merecer atenção especial no Guia.
tee: copia a saída para um arquivo.
Alguns comandos podem ficar meio obscuros agora; eu pretendo voltar neles quando for falar de shell scripts, mas antes, pretendo falar sobre expressões regulares (base do comando grep), pois este cara é importante. Sugiro que você pratique estes comandos com alguns arquivos de teste e leia seus respectivos manuais (man nomedocomando), para ir pegando o jeito. Tem quem ache que aprender este tipo de coisa é bobagem, mas eu garanto, estes comandos podem ser a sua salvação em muitos casos, especialmente o grep.

Semana que vem tem mais. Por ora, faça seus comentários abaixo, se desejar, ou acesse o Fórum do Guia para tirar dúvidas com os outros participantes. Até mais!

Continuando a série, vamos tratar de um tema muito útil no ambiente Linux, e que tem sido usado em vários outros softwares, inclusive para Windows: as expressões regulares.

Uma expressão regular (também conhecida por regex) nada mais é do que a especificação de um padrão de texto, algo que segue uma determinada regra de formato. Escrevendo-se a expressão correta, você pode encontrar fragmentos de texto dentro de um arquivo, por exemplo. O como fazer isto vai explicado abaixo:

grep: utilitário de busca de regex

A maioria (se não for todas) das distribuições Linux incluem o grep, que é um buscador de regex.

A sintaxe é bem simples: grep 'padrao' entrada. Se a entrada não for especificada, usa-se a entrada padrão (stdin). Você também pode usar alguns parâmetros, como o “-v”, que mostra o inverso do padrão (ou seja, tudo aquilo que não bate com o padrão passado), e o “-i”, que torna a busca insensível à casa (não diferencia maiúsculas de minúsculas).

Note que usei aspas simples delimitando o padrão. Nem sempre elas são necessárias, mas em alguns casos, um metacaracter pode acabar sendo traduzido pelo shell, causando resultados errôneos, e as aspas simples evitam isto. Não entendeu? Relaxa, tá explicado aí embaixo…

Tá bom, mas como escrevo padrões?!

Nesta parte é bom ir devagar, com carinho, senão dói =)

Primeira coisa, entenda que há caracteres e metacaracteres numa regex. Os caracteres são literais, ou seja, as letras (a-z, A-Z) e números (0-9), além de alguns símbolos e acentos. E os metacaracteres são caracteres que têm um significado especial, como o “^”, que indica começo de linha, e o “$”, que representa final de linha. Se você quer que um símbolo seja tratado literalmente, isto é, sem que seja tratado como um metacaracter, você precisa escapá-lo, colocando uma barra invertida ( \ ) antes do dito cujo. Um exemplo de uso disto é para o ponto ( . ), que é um metacaracter que representa qualquer caracter, e você pode querer tratá-lo como sendo apenas um ponto mesmo.

Aí vai uma listinha com alguns dos metacaracteres mais usados:

^ : começa com
$ : término de linha
. : qualquer caracter
[] : relação de valores possíveis para um caracter. Você pode especificar uma lista ( [abcde] ), uma faixa ( [0-9] ), ou várias faixas ( [a-zA-Z0-9] ).
\{\} : especifica quantas vezes o caracter pode se repetir. Por exemplo: “{2}” (duas vezes), “{2,5}” (duas a cinco vezes), “{2,}” (duas ou mais vezes).
| : operador lógico ou
.* : operador lógico e
Olhe esta “lingüiça”, por exemplo: [0-9]\{3\}\.[0-9]\{3\}\.[0-9]\{3\}-[0-9]\{2\}. Adivinha com o que ela casa? Com um número de CPF que esteja formatado com pontos e traço. Leia a expressão com calma que você vai enxergar isto =)

Existe um outro utilitário, o egrep, que é uma versão extendida do grep. A sintaxe de uso é a mesma. Uma coisa legal dele é dispensar o escape para certos metacaracteres, como o “{}”, o que tornaria esta mesma expressão um pouquinho mais curta: [0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}. Note que o ponto ainda precisou ser escapado, pois a intenção é tratá-lo apenas como ponto mesmo.

E onde eu uso este tipo de coisa?

Se você só navega na internet e papeia pelo MSN ou algo parecido, aprender este tipo de coisa pode parecer desnecessário. Mas se você costuma ler os logs do sistema, ou se trabalha com arquivos texto, ou se é um admin de sistemas Linux, ou se alguma vez se deparar com a necessidade de achar uma agulha no meio do palheiro, você vai usar regex. E como disse no começo, já há aplicativos no Windows que entendem o conceito de regex – cada um a seu jeito, claro. O Notepad++ é um deles. E até o Microsoft Word =) Pra quem não acredita, aí vai a tela de Pesquisa Avançada dele:

Word - Expressões

Hoje, vou dar 2 exemplos apenas, um onde a entrada é um arquivo, e outro onde a entrada é o stdin. No próximo artigo, vou me dedicar exclusivamente a dar exemplos de uso do grep, egrep e fgrep, incluindo exemplos de uso dos metacaracteres.

- Exemplo 1: achar no arquivo de usuários quem tem “/bin/bash” em sua linha, o que indica que o seu shell é o Bash:
grep '/bin/bash' /etc/passwd

- Exemplo 2: exibir o log do sistema em tempo real, porém filtrar apenas as linhas que contenham o e-mail “usuario@provedor.com.br”:
tail -f /var/log/syslog | grep 'usuario@provedor\.com\.br'
