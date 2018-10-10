##Introdução ao Shell do Linux

Baseado [neste](https://www.guiadopc.com.br/artigos/693/prompt-do-linux-stdin-stdout-stderr-e-seus-truques-parte-i.html) e [neste](https://gist.github.com/LeCoupa/122b12050f5fb267e75f) artigos, dentre outros.


### Comandos básicos do Shell

ls                            # lists your files
ls -l                         # lists your files in 'long format'
ls -a                         # lists all files, including hidden files
ln -s <filename> <link>       # creates symbolic link to file
touch <filename>              # creates or updates your file
cat > <filename>              # places standard input into file
more <filename>               # shows the first part of a file (move with space and type q to quit)
head <filename>               # outputs the first 10 lines of file
tail <filename>               # outputs the last 10 lines of file (useful with -f option)
emacs <filename>              # lets you create and edit a file
mv <filename1> <filename2>    # moves a file
cp <filename1> <filename2>    # copies a file
rm <filename>                 # removes a file
diff <filename1> <filename2>  # compares files, and shows where they differ
wc <filename>                 # tells you how many lines, words and characters there are in a file
chmod -options <filename>     # lets you change the read, write, and execute permissions on your files
gzip <filename>               # compresses files
gunzip <filename>             # uncompresses files compressed by gzip
gzcat <filename>              # lets you look at gzipped file without actually having to gunzip it
grep <pattern> <filenames>    # looks for the string in the files
grep -r <pattern> <dir>       # search recursively for pattern in directory


### Comandos de diretórios e caminhos

mkdir <dirname>               # makes a new directory
rm -r, rmdir <folder>         # removes a file
cd                            # changes to home
cd <dirname>                  # changes directory
pwd                           # tells you where you currently are

### Input/Output Redirectors.

cmd1|cmd2  # pipe; takes standard output of cmd1 as standard input to cmd2
> file     # directs standard output to file
< file     # takes standard input from file
>> file    # directs standard output to file; append to file if it already exists
>|file     # forces standard output to file even if noclobber is set
n>|file    # forces output to file from file descriptor n even if no clobber is set
<> file    # uses file as both standard input and standard output
n<>file    # uses file as both input and output for file descriptor n
<<label    # here-document
n>file     # directs file descriptor n to file
n<file     # takes file descriptor n from file
n>>file    # directs file description n to file; append to file if it already exists
n>&        # duplicates standard output to file descriptor n
n<&        # duplicates standard input from file descriptor n
n>&m       # file descriptor n is made to be a copy of the output file descriptor
n<&m       # file descriptor n is made to be a copy of the input file descriptor
&>file     # directs standard output and standard error to file
<&-        # closes the standard input
>&-        # closes the standard output
n>&-       # closes the ouput from file descriptor n
n<&-       # closes the input from file descripor n

### SSH, System Info & Network Commands.


ssh user@host            # connects to host as user
ssh -p <port> user@host  # connects to host on specified port as user
ssh-copy-id user@host    # adds your ssh key to host for user to enable a keyed or passwordless login

whoami                   # returns your username
passwd                   # lets you change your password
quota -v                 # shows what your disk quota is
date                     # shows the current date and time
cal                      # shows the month's calendar
uptime                   # shows current uptime
w                        # displays whois online
finger <user>            # displays information about user
uname -a                 # shows kernel information
man <command>            # shows the manual for specified command
df                       # shows disk usage
du <filename>            # shows the disk usage of the files and directories in filename (du -s give only a total)
last <yourUsername>      # lists your last logins
ps -u yourusername       # lists your processes
kill <PID>               # kills (ends) the processes with the ID you gave
killall <processname>    # kill all processes with the name
top                      # displays your currently active processes
bg                       # lists stopped or background jobs ; resume a stopped job in the background
fg                       # brings the most recent job in the foreground
fg <job>                 # brings job to the foreground
ping <host>              # pings host and outputs results
whois <domain>           # gets whois information for domain
dig <domain>             # gets DNS information for domain
dig -x <host>            # reverses lookup host
wget <file>              # downloads file

### Comandos de impressão

lpr <filename>                # print the file
lpq                           # check out the printer queue
lprm <jobnumber>              # remove something from the printer queue
genscript                     # converts plain text files into postscript for printing and gives you some options for formatting
dvips <filename>              # print .dvi files (i.e. files produced by LaTeX)

### Basic Shell Programming.


#### Variables.


varname=value                # defines a variable
varname=value command        # defines a variable to be in the environment of a particular subprocess
echo $varname                # checks a variable's value
echo $$                      # prints process ID of the current shell
echo $!                      # prints process ID of the most recently invoked background job
echo $?                      # displays the exit status of the last command
export VARNAME=value         # defines an environment variable (will be available in subprocesses)

array[0] = val               # several ways to define an array
array[1] = val
array[2] = val
array=([2]=val [0]=val [1]=val)
array(val val val)

${array[i]}                  # displays array's value for this index. If no index is supplied, array element 0 is assumed
${#array[i]}                 # to find out the length of any element in the array
${#array[@]}                 # to find out how many values there are in the array

declare -a                   # the variables are treaded as arrays
declare -f                   # uses funtion names only
declare -F                   # displays function names without definitions
declare -i                   # the variables are treaded as integers
declare -r                   # makes the variables read-only
declare -x                   # marks the variables for export via the environment

${varname:-word}             # if varname exists and isn't null, return its value; otherwise return word
${varname:=word}             # if varname exists and isn't null, return its value; otherwise set it word and then return its value
${varname:?message}          # if varname exists and isn't null, return its value; otherwise print varname, followed by message and abort the current command or script
${varname:+word}             # if varname exists and isn't null, return word; otherwise return null
${varname:offset:length}     # performs substring expansion. It returns the substring of $varname starting at offset and up to length characters

${variable#pattern}          # if the pattern matches the beginning of the variable's value, delete the shortest part that matches and return the rest
${variable##pattern}         # if the pattern matches the beginning of the variable's value, delete the longest part that matches and return the rest
${variable%pattern}          # if the pattern matches the end of the variable's value, delete the shortest part that matches and return the rest
${variable%%pattern}         # if the pattern matches the end of the variable's value, delete the longest part that matches and return the rest
${variable/pattern/string}   # the longest match to pattern in variable is replaced by string. Only the first match is replaced
${variable//pattern/string}  # the longest match to pattern in variable is replaced by string. All matches are replaced

${#varname}                  # returns the length of the value of the variable as a character string

*(patternlist)               # matches zero or more occurences of the given patterns
+(patternlist)               # matches one or more occurences of the given patterns
?(patternlist)               # matches zero or one occurence of the given patterns
@(patternlist)               # matches exactly one of the given patterns
!(patternlist)               # matches anything except one of the given patterns

$(UNIX command)              # command substitution: runs the command and returns standard output


#### Functions.

The function refers to passed arguments by position (as if they were positional parameters), that is, $1, $2, and so forth.
$@ is equal to "$1" "$2"... "$N", where N is the number of positional parameters. $# holds the number of positional parameters.

functname() {
  shell commands
}

unset -f functname  # deletes a function definition
declare -f          # displays all defined functions in your login session


#### Flow Control.

statement1 && statement2  # and operator
statement1 || statement2  # or operator

-a                        # and operator inside a test conditional expression
-o                        # or operator inside a test conditional expression

str1=str2                 # str1 matches str2
str1!=str2                # str1 does not match str2
str1<str2                 # str1 is less than str2
str1>str2                 # str1 is greater than str2
-n str1                   # str1 is not null (has length greater than 0)
-z str1                   # str1 is null (has length 0)

-a file                   # file exists
-d file                   # file exists and is a directory
-e file                   # file exists; same -a
-f file                   # file exists and is a regular file (i.e., not a directory or other special type of file)
-r file                   # you have read permission
-r file                   # file exists and is not empty
-w file                   # your have write permission
-x file                   # you have execute permission on file, or directory search permission if it is a directory
-N file                   # file was modified since it was last read
-O file                   # you own file
-G file                   # file's group ID matches yours (or one of yours, if you are in multiple groups)
file1 -nt file2           # file1 is newer than file2
file1 -ot file2           # file1 is older than file2
-lt                       # less than
-le                       # less than or equal
-eq                       # equal
-ge                       # greater than or equal
-gt                       # greater than
-ne                       # not equal

if condition
then
  statements
[elif condition
  then statements...]
[else
  statements]
fi

for x := 1 to 10 do
begin
  statements
end

for name [in list]
do
  statements that can use $name
done

for (( initialisation ; ending condition ; update ))
do
  statements...
done

case expression in
  pattern1 )
    statements ;;
  pattern2 )
    statements ;;
  ...
esac

select name [in list]
do
  statements that can use $name
done

while condition; do
  statements
done

until condition; do
  statements
done


### Command-Line Processing Cycle.

The default order for command lookup is functions, followed by built-ins, with scripts and executables last.
There are three built-ins that you can use to override this order: `command`, `builtin` and `enable`.

command  # removes alias and function lookup. Only built-ins and commands found in the search path are executed
builtin  # looks up only built-in commands, ignoring functions and commands found in PATH
enable   # enables and disables shell built-ins

eval     # takes arguments and run them through the command-line processing steps all over again


### Process Handling.

To suspend a job, type CTRL+Z while it is running. You can also suspend a job with CTRL+Y.
This is slightly different from CTRL+Z in that the process is only stopped when it attempts to read input from terminal.
Of course, to interupt a job, type CTRL+C.

myCommand &  # runs job in the background and prompts back the shell
jobs         # lists all jobs (use with -l to see associated PID)
fg           # brings a background job into the foreground
fg %+        # brings most recently invoked background job
fg %-        # brings second most recently invoked background job
fg %N        # brings job number N
fg %string   # brings job whose command begins with string
fg %?string  # brings job whose command contains string
kill -l      # returns a list of all signals on the system, by name and number
kill PID     # terminates process with specified PID
ps           # prints a line of information about the current running login shell and any processes running under it
ps -a        # selects all processes with a tty except session leaders
trap cmd sig1 sig2  # executes a command when a signal is received by the script
trap "" sig1 sig2   # ignores that signals
trap - sig1 sig2    # resets the action taken when the signal is received to the default
disown <PID|JID>    # removes the process from the list of jobs
wait                # waits until all background jobs have finished


### Tips and Tricks.

#### set an alias
cd; nano .bash_profile
> alias gentlenode='ssh admin@gentlenode.com -p 3404'  # add your alias in .bash_profile

#### to quickly go to a specific directory
cd; nano .bashrc
> shopt -s cdable_vars
> export websites="/Users/mac/Documents/websites"

source .bashrc
cd websites


### Debugging Shell Programs.

bash -n scriptname  # don't run commands; check for syntax errors only
set -o noexec       # alternative (set option in script)
bash -v scriptname  # echo commands before running them
set -o verbose      # alternative (set option in script)
bash -x scriptname  # echo commands after command-line processing
set -o xtrace       # alternative (set option in script)

trap 'echo $varname' EXIT  # useful when you want to print out the values of variables at the point that your script exits

function errtrap {
  es=$?
  echo "ERROR line $1: Command exited with status $es."
}

trap 'errtrap $LINENO' ERR  # is run whenever a command in the surrounding script or function exists with non-zero status 

function dbgtrap {
  echo "badvar is $badvar"
}

trap dbgtrap DEBUG  # causes the trap code to be executed before every statement in a function or script

### section of code in which the problem occurs...

trap - DEBUG  # turn off the DEBUG trap

function returntrap {
  echo "A return occured"
}

trap returntrap RETURN  # is executed each time a shell function or a script executed with the . or source commands finishes executing

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

du -m --max-depth=1 /home | sort -rn | head -n 11 | mail -s "Usuários fominhas" meu_email@provedor.com.br

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
Olhe esta “linguiça”, por exemplo: [0-9]\{3\}\.[0-9]\{3\}\.[0-9]\{3\}-[0-9]\{2\}. Adivinha com o que ela casa? Com um número de CPF que esteja formatado com pontos e traço. Leia a expressão com calma que você vai enxergar isto =)

Existe um outro utilitário, o egrep, que é uma versão extendida do grep. A sintaxe de uso é a mesma. Uma coisa legal dele é dispensar o escape para certos metacaracteres, como o “{}”, o que tornaria esta mesma expressão um pouquinho mais curta: [0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}. Note que o ponto ainda precisou ser escapado, pois a intenção é tratá-lo apenas como ponto mesmo.
