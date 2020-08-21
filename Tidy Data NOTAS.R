### Tidy Data - SOLUCIÓN ###

# Revisaremos una serie de datasets y en caso de no estar ordenados,
# se le hará el tratamiento respectivo. 

# Paquetes requeridos:
library(tidyverse)
library(datos)

tabla4a
# ¿Es un conjunto de datos ordenados?
# NO. 
# Para que el conjunto de datos sea ordenado los nombres de las columnas deben
# corresponder a nombres de las variables, y en este caso los nombres de las 
# columnas son los valores de una variable (la variable anio en este caso).
# Otra forma de ver el problema: Cada fila representa dos observaciones
# en lugar de una.
# A esto se le denomina: "Datos largos"
# Solución: aplicar la función pivot_longer() a la base de datos.
tabla4a %>%
  pivot_longer(cols = c("1999","2000"), names_to = "anio", values_to = "casos")
# Parámetros:
# cols -> nombres de las columnas que no son variables
# names_to -> nombre de la variables cuyos VALORES forman los nombres de las
# columnas (en este caso el nombre de esa variable es anio).
# values_to -> nombre de la variables cuyos valores están repartidos por las
# celdas


tabla2
# ¿Es un conjunto de datos ordenados?
# NO. 
# Para que el conjunto de datos sea ordenado cada fila debe ser una 
# observación diferente, y en este caso vemos que las dos primeras filas son
# en realidad una observación, la 3era y 4ta fila también son en realidad una 
# sola observación y así.
# Esto se soluciona usando la función pivot_wider().
tabla2 %>%
  pivot_wider(names_from = tipo, values_from = cuenta)
# Parámetros: 
# names_from -> columna de la que se obtienen los nombres de las variables.
# values_from -> columna de la que se obtienen los valores.


tabla3
# ¿Es un conjunto de datos ordenados?
# NO.
# Para que el conjunto de datos sea ordenado cada columna debe ser una
# variable diferente, y en este caso se tiene una columna (tasa) que contiene
# dos variables (casos y población).
# Esto se soluciona usando la función separate().
tabla3 %>%
  separate(col = tasa, into = c("casos","población"))
# Los parámetros de la función separate() son:
# La base de datos, en este caso no se especifica porque aquí está (señalar
# tabla3 antes del pipe).
# col = el nombre de la columna que se quiere separar. Si simplemente se 
# escribe el nombre de la columna R también lo entiende (no hace falta
# escribir col= ).
# into = c() -> nombre de las columna en las que se dividirá. El orden 
# importa y la más a la izquierda en la primera.
# Si el carácter que marca los dos valores que queremos separar -> 745 y
# 19987071 en este caso -> NO es ni un número ni una letra, entonces no hay 
# que especificarlo, como en este caso.
tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), sep = "/")
# También se puede especificar el separador.
tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), convert = TRUE)
# Si notamos la columna "tasa" que es la que queremos separar es de tipo 
# caracter porque tiene el slash... ¿que sucede? La función separate() tiene 
# algo y es que al separar una columna R asume que su tipo es igual al tipo 
# de columna original que se separó... pero vemos que son números, lo que se 
# hace es poner el parámetro:
# convert = TRUE -> convierte al tipo más adecuado las nuevas columnas.


tabla5
# Explicación
# Esta es como una tabla aparte que simplemente propone el libro para explicar
# otra función que no es tan utlizada pero que es bueno conocerla.
# Vemos que es este data set se separa lo que sería un año completo en dos
# partes, una llamada "siglo" y otra que se llama "anio". 
# Si queremos juntar estas dos columnas en una sola, puesto que en realidad
# el año completo es una sola variable utilizamos la función -> unite()
tabla5 %>%
  unite(anio_comp, siglo, anio)
# Para que halla continuidad se define como separador dos comillas SIN espacio:
tabla5 %>%
  unite(anio_comp, siglo, anio, sep = "")

###
# Hasta ahora todos los data sets que habiamos utilizado provenían de la 
# libreria "datos", pero para explicar el tema de valores faltantes usaremos
# el siguiente data set escrito "a mano". Corranlo porfa...
acciones <- tibble(
  anio = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  trimestre = c(1, 2, 3, 4, 2, 3, 4),
  retorno = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66))
# Existen dos valores faltantes en este data set:
# .	El retorno del cuarto trimestre de 2015 que está explícitamente perdido, 
# debido a que la celda donde el valor debiera estar contiene NA.
# .	El retorno del primer semestre de 2016 está implícitamente perdido, 
# debido a que simplemente no aparece en el set de datos.
# Inicialmente lo que se quiere es que todos los valores faltantes estén 
# explícitos. 
# Formas de hacer esto:
# Primera: usando la función que vimos para corregir los datos "anchos".
# Puesto que que en esta forma de organizar los datos se genera una celda 
# para cada trimestre de cada año.
acciones %>%
  pivot_wider(names_from = anio, values_from = retorno)
# La segunda forma de dejar los valores faltantes implicitos como explicitos
# es usando la función spread.
acciones %>%
  spread(anio, retorno)
# Los parámetros son:
# Lo que es el libro se llama como la llave o key = anio -> nombre de la 
# variable cuyos valores formaran los nombres de las columnas.
# value = retorno -> nombre de la variable cuyos valores están repartidos 
# por las celdas.
acciones %>%
  complete(anio, trimestre)
# Y la tercera forma de  pasar los valores faltantes implicitos como 
# explicitos es usando la función complete(). Esta es la más recomendada puesto
# Aquí los parámetros son nombres de columnas... lo que se hace es generar 
# todas las combinaciones únicas... año 2015: semestre 1,2,3,4... y lo mismo 
# con el año 2016.
# La ventaja de usar esta es que además de ser muy fácil de entender, les
# queda el Data Set ordenado.

# Ahora si lo que se quiere no es solo pasar los valores faltantes de 
# implicitos a explicitos, sino que además se quiere remover las observaciones
# que tengan los NA, una forma de hacerlo es la siguiente:
acciones %>%
  pivot_wider(names_from = anio, values_from = retorno) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "anio", 
    values_to = "retorno", 
    values_drop_na = TRUE)
# Primero se transforma todo a explicito y despues se lleva a una forma ordenada
# el data set quitando todos los NA al agregar el parámetro values_drop_na)

###
# Finalmente les pido que corran la última línea de código que es un último 
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
# Solución:
# Puedes completar los valores faltantes usando fill(). Esta función toma un 
# conjunto de columnas sobre las cuales los valores faltantes son reemplazados 
# por el valor anterior más cercano que se haya reportado.
tratamiento %>%
  fill(sujeto)

# Otro ejemplo:
tratamiento <- tribble(
  ~sujeto, ~tratamiento, ~respuesta,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, 9,
  "Katherine Burke", 1, 4, NA, 3, 7)
# Solución:
tratamiento %>%
  fill(sujeto)



