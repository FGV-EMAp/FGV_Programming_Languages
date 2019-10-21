from django.shortcuts import render, HttpResponse
from .models import Grafico

# Create your views here.

def index(request):
    if request.method == 'GET':
        return HttpResponse("alo mundo")
    elif request.method == 'POST':
        g = Grafico(tipo=tipo, datax=x, datay=y)
        g.save()
        cria_grafico(x,y,tipo)

def cria_grafico(x,y,tipo):



