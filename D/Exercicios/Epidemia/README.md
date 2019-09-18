# Modelando Uma epidemia
Neste exercício vamos modelar uma epidemia como um processo estocástico. 

O modelo a ser implementado é o clássico [SIR](https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model), ou **S**uscetível, **I**nfeccioso e **R**ecuperado. Neste modelo temos uma população, cujos indivíduos podem assumir 3 estados de saúde possíveis: S|I|R sendo que as únicas transições possíveis são S => I e I => R.

No código Python Abaixo temos uma implementação deste modelo. Execute-os e familiarize-se com o comportamento do modelo.

```python
import numpy as np
from scipy.integrate import odeint
from numpy.random import rand, gamma, exponential, poisson
import pylab as P


#  @numba.jit    
def run_sir(N, tf, nsims, *pars):
    """
    Runs simulation.

    :parameters:
    :param N: tamanho da população
    :param tf: tempo final
    :param nsims:  Numero de simulações
    :param pars: parametros 
    """
    beta, gam, I0, Tmed, constant = pars
    betat = lambda t: beta+(0.5*beta)*np.cos((2*np.pi*t)/365.)
    sims = {}
    for k in range(nsims):
        t = [0]
        S = [N-I0]
        I = [I0]
        dts =[]
        while I[-1] > 0 and t[-1] < tf:
            U = rand()
            # Probabilidade de que pelo menos um evento ocorra
            R = beta*S[-1]*I[-1]/N + gam*I[-1]
            # Probabilidade do próximo evento ser uma infecção
            pinf = ((beta/N)*S[-1]*I[-1])/R 
            
            if U <= pinf: # próximo evento é uma infecçao
                dt = exponential(1/R) 
                
                S.append(S[-1]-1)
                I.append(I[-1]+1)
                t.append(t[-1] + dt)
                dts.append(dt)
            else: # próximo evento é uma recuperação
                S.append(S[-1])
                I.append(I[-1]-1)
                #print('removal')
                t.append(t[-1] + exponential(1/R))  # -np.log(rand())/R)
        sims[k] = (np.array([t,S,I]).T, np.array(t), dts)
        P.plot(t,I,label='$O_t^{}$'.format(k+1), drawstyle='steps-post')
    return sims

if __name__ == "__main__":
    beta=0.1
    gam = 1/21
    N = 500
    Tmed = 20
    constant = False
    I0 = 2
    tf = 365
    ts = np.arange(tf)
    nsims = 5
    
    P.legend(loc=0)
    P.xlabel("t (dias)")
    P.ylabel("casos")
    P.grid()
    P.savefig('simulacao.png')
    
    P.show()
```

Agora implemente este mesmo modelo em **D**. Abaixo segue o início do código especificando as bibliotecas necessárias.

```D
#!/usr/bin/env rdmd
/+dub.sdl:
dependency "mir" version="~>3.1.0"
dependency "mir-random" version="~>2.2.4"
dependency "mir-algorithm" version="~>3.2.1"
dependency "matplotlib-d" version="~>0.1.5"
+/
import std.stdio;
import std.math;
import std.file;
import std.typecons: tuple, Tuple;
import core.exception : RangeError;
import mir.random;
import mir.random.variable: uniformVar, exponentialVar;
import mir.ndslice;
import mir.ndslice.fuse;
import plt = matplotlibd.pyplot;
```
