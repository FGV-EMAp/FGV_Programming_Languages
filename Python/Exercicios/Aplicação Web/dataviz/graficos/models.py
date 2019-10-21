from django.db import models

# Create your models here.

class Grafico(models.Model):
    tipo = models.CharField(max_length=16, choices=[('l','linha'),('b','barra')])
    dadosx = models.CharField(max_length=1000,null=False)
    dadosy = models.CharField(max_length=1000,null=False)

