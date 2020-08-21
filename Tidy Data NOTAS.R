### Tidy Data - SOLUCI�N ###

# Revisaremos una serie de datasets y en caso de no estar ordenados,
# se le har� el tratamiento respectivo. 

# Paquetes requeridos:
library(tidyverse)
library(datos)

tabla4a
# �Es un conjunto de datos ordenados?
# NO. 
# Para que el conjunto de datos sea ordenado los nombres de las columnas deben
# corresponder a nombres de las variables, y en este caso los nombres de las 
# columnas son los valores de una variable (la variable anio en este caso).
# Otra forma de ver el problema: Cada fila representa dos observaciones
# en lugar de una.
# A esto se le denomina: "Datos largos"
# Soluci�n: aplicar la funci�n pivot_longer() a la base de datos.
tabla4a %>%
  pivot_longer(cols = c("1999","2000"), names_to = "anio", values_to = "casos")
# Par�metros:
# cols -> nombres de las columnas que no son variables
# names_to -> nombre de la variables cuyos VALORES forman los nombres de las
# columnas (en este caso el nombre de esa variable es anio).
# values_to -> nombre de la variables cuyos valores est�n repartidos por las
# celdas


tabla2
# �Es un conjunto de datos ordenados?
# NO. 
# Para que el conjunto de datos sea ordenado cada fila debe ser una 
# observaci�n diferente, y en este caso vemos que las dos primeras filas son
# en realidad una observaci�n, la 3era y 4ta fila tambi�n son en realidad una 
# sola observaci�n y as�.
# Esto se soluciona usando la funci�n pivot_wider().
tabla2 %>%
  pivot_wider(names_from = tipo, values_from = cuenta)
# Par�metros: 
# names_from -> columna de la que se obtienen los nombres de las variables.
# values_from -> columna de la que se obtienen los valores.


tabla3
# �Es un conjunto de datos ordenados?
# NO.
# Para que el conjunto de datos sea ordenado cada columna debe ser una
# variable diferente, y en este caso se tiene una columna (tasa) que contiene
# dos variables (casos y poblaci�n).
# Esto se soluciona usando la funci�n separate().
tabla3 %>%
  separate(col = tasa, into = c("casos","poblaci�n"))
# Los par�metros de la funci�n separate() son:
# La base de datos, en este caso no se especifica porque aqu� est� (se�alar
# tabla3 antes del pipe).
# col = el nombre de la columna que se quiere separar. Si simplemente se 
# escribe el nombre de la columna R tambi�n lo entiende (no hace falta
# escribir col= ).
# into = c() -> nombre de las columna en las que se dividir�. El orden 
# importa y la m�s a la izquierda en la primera.
# Si el car�cter que marca los dos valores que queremos separar -> 745 y
# 19987071 en este caso -> NO es ni un n�mero ni una letra, entonces no hay 
# que especificarlo, como en este caso.
tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), sep = "/")
# Tambi�n se puede especificar el separador.
tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), convert = TRUE)
# Si notamos la columna "tasa" que es la que queremos separar es de tipo 
# caracter porque tiene el slash... �que sucede? La funci�n separate() tiene 
# algo y es que al separar una columna R asume que su tipo es igual al tipo 
# de columna original que se separ�... pero vemos que son n�meros, lo que se 
# hace es poner el par�metro:
# convert = TRUE -> convierte al tipo m�s adecuado las nuevas columnas.


tabla5
# Explicaci�n
# Esta es como una tabla aparte que simplemente propone el libro para explicar
# otra funci�n que no es tan utlizada pero que es bueno conocerla.
# Vemos que es este data set se separa lo que ser�a un a�o completo en dos
# partes, una llamada "siglo" y otra que se llama "anio". 
# Si queremos juntar estas dos columnas en una sola, puesto que en realidad
# el a�o completo es una sola variable utilizamos la funci�n -> unite()
tabla5 %>%
  unite(anio_comp, siglo, anio)
# Para que halla continuidad se define como separador dos comillas SIN espacio:
tabla5 %>%
  unite(anio_comp, siglo, anio, sep = "")

###
# Hasta ahora todos los data sets que habiamos utilizado proven�an de la 
# libreria "datos", pero para explicar el tema de valores faltantes usaremos
# el siguiente data set escrito "a mano". Corranlo porfa...
acciones <- tibble(
  anio = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  trimestre = c(1, 2, 3, 4, 2, 3, 4),
  retorno = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66))
# Existen dos valores faltantes en este data set:
# .	El retorno del cuarto trimestre de 2015 que est� expl�citamente perdido, 
# debido a que la celda donde el valor debiera estar contiene NA.
# .	El retorno del primer semestre de 2016 est� impl�citamente perdido, 
# debido a que simplemente no aparece en el set de datos.
# Inicialmente lo que se quiere es que todos los valores faltantes est�n 
# expl�citos. 
# Formas de hacer esto:
# Primera: usando la funci�n que vimos para corregir los datos "anchos".
# Puesto que que en esta forma de organizar los datos se genera una celda 
# para cada trimestre de cada a�o.
acciones %>%
  pivot_wider(names_from = anio, values_from = retorno)
# La segunda forma de dejar los valores faltantes implicitos como explicitos
# es usando la funci�n spread.
acciones %>%
  spread(anio, retorno)
# Los par�metros son:
# Lo que es el libro se llama como la llave o key = anio -> nombre de la 
# variable cuyos valores formaran los nombres de las columnas.
# value = retorno -> nombre de la variable cuyos valores est�n repartidos 
# por las celdas.
acciones %>%
  complete(anio, trimestre)
# Y la tercera forma de  pasar los valores faltantes implicitos como 
# explicitos es usando la funci�n complete(). Esta es la m�s recomendada puesto
# Aqu� los par�metros son nombres de columnas... lo que se hace es generar 
# todas las combinaciones �nicas... a�o 2015: semestre 1,2,3,4... y lo mismo 
# con el a�o 2016.
# La ventaja de usar esta es que adem�s de ser muy f�cil de entender, les
# queda el Data Set ordenado.

# Ahora si lo que se quiere no es solo pasar los valores faltantes de 
# implicitos a explicitos, sino que adem�s se quiere remover las observaciones
# que tengan los NA, una forma de hacerlo es la siguiente:
acciones %>%
  pivot_wider(names_from = anio, values_from = retorno) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "anio", 
    values_to = "retorno", 
    values_drop_na = TRUE)
# Primero se transforma todo a explicito y despues se lleva a una forma ordenada
# el data set quitando todos los NA al agregar el par�metro values_drop_na)

###
# Finalmente les pido que corran la �ltima l�nea de c�digo que es un �ltimo 
# data set donde explicaremos algo interesante.
tratamiento <- tribble(
  ~sujeto, ~tratamiento, ~respuesta,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, 9,
  "Katherine Burke", 1, 4)
# En algunos casos en que la fuente de datos se ha usado principalmente para 
# ingresar datos, los valores faltantes indican que el valor previo debe 
# arrastrarse hacia adelante:
# Soluci�n:
# Puedes completar los valores faltantes usando fill(). Esta funci�n toma un 
# conjunto de columnas sobre las cuales los valores faltantes son reemplazados 
# por el valor anterior m�s cercano que se haya reportado.
tratamiento %>%
  fill(sujeto)

# Otro ejemplo:
tratamiento <- tribble(
  ~sujeto, ~tratamiento, ~respuesta,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, 9,
  "Katherine Burke", 1, 4, NA, 3, 7)
# Soluci�n:
tratamiento %>%
  fill(sujeto)


