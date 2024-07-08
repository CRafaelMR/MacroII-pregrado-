cd "C:\Users\el tulón\Contacts\Desktop\Macro"
use barrolee
keep if year==2005
 *revisamos cada variable con pwt y corregimos discrepancias de nombres* 
  replace country = "Nigeria" in 22
  replace country = "Macao" in 145
  replace country = "Hong Kong" in 66
  replace country = "Cote d`Ivoire" in 12
  replace country = "Russia" in 123
  replace country = "Congo, Dem. Rep." in 33
  replace country = "Dominican Republic" in 39
  replace country = "Tanzania" in 29
  replace country = "Iran" in 69
  replace country = "Congo, Republic of" in 7
  replace country = "Korea, Republic of" in 74
  replace country = "Gambia, The" in 10
  replace country = "Syria" in 83
  replace country = "United States" in 49
  replace country = "Vietnam" in 137
  
  
save "barrolee2005"
clear all
*empezamos a trabajar en la base de datos pwt70
import delimited using "C:\Users\el tulón\Contacts\Desktop\Macro\pwt70_w.csv" 
*mete el archivo a stata*
compress 
*descomprime archivo .csv*
save "pwt70_w.dta"
merge m:1 country using barrolee2005
 *unimos la informacion de barro-lee a la base de datos.*
keep if year==1960 | year==2008 
*borramos toda informacion que no sea de estos años.*
save "BMacro1"
*salvamos Base (de datos) Macro #1
tsset year BLcode
*establecemos datos de panel*
 gen n=(pop/L.pop)^(1/48)-1 if year==2008
 replace n=.0109256 in 238
 replace n=((305/112.234)^(1/48)-1) in 372
 replace n=(33770/10909.29)^(1/48)-1 in 191
 replace n=(8533/2055.083)^(1/48)-1 in 192
 replace n=(9139/2815.405)^(1/48)-1 in 194
 replace n=(4642/1467.449/)^(1/48)-1 in 196
 replace n=(3905/1002.214/)^(1/48)-1 in 197
 replace n=(1486/446.004)^(1/48)-1 in 199
 replace n=(20180/3576.077)^(1/48)-1 in 202
 replace n=(14624/3450.444)^(1/48)-1 in 206
 replace n=(10441/3031.804)^(1/48)-1 in 213
 replace n=(5023/2396.304)^(1/48)-1 in 215
 replace n=(48783/17416.65)^(1/48)-1 in 216
 replace n=(283.4/232.339)^(1/48)-1 in 226
 replace n=(9558/3231.488)^(1/48)-1 in 229
 replace n=(13002/4099.72)^(1/48)-1 in 231
 replace n=(3286/2530.969)^(1/48)-1 in 248
 replace n=(7019/3075.3)^(1/48)-1 in 253
 replace n=(178479/50386.9)^(1/48)-1 in 265
 replace n=(10723/8327.405)^(1/48)-1 in 281
 replace n=(21007/10361.27)^(1/48)-1 in 297
 replace n=(105/63.718)^(1/48)-1 in 301
 replace n=(2089/590.731)^(1/48)-1 in 302
 replace n=(301/91.863)^(1/48)-1 in 303
 replace n=(7263/7867.374)^(1/48)-1 in 304
 replace n=(22061/18403.41)^(1/48)-1 in 306
  replace n=(82065/72480.87)^(1/48)-1 in 310
  replace n=(825/45.588)^(1/48)-1 in 317
   replace n=(45994/42644.04)^(1/48)-1 in 327
  *por motivos desconocidos para los investigadores, una cantidad no menor de valores no se produjiero automaticamente*
    *por esto, decidimos tabularlos manualmente. Este problema se repite en un par de ejercicios posteriores.*
 *generamos la variable n que es el crecimiento poblacional anualizado
 gen deprec=0.075
 *generamos g + sigma, que es la depreciacion del capital humano y fisico
 gen h=exp(0.1*yr_sch) if year==2008
 *generamos el capital humano
  scalar a=1/3
  *definimos el alfa*
 
 *empezamos con los ejercicios*
 *ejercicio 4*
 graph twoway scatter ci rgdpwok if year==2008
 *ejercicio 5* 
a)  graph twoway scatter n rgdpwok if year==2008
b)  graph twoway scatter h rgdpwok if year==2008

 *ejercicio 7*
 list rgdpwok if year==2008 & country=="United States"
 *mostramos el valor del pib per capita controlado por PPP de estados unidos el año 2008* 
 scalar gdpusa = 84771.23
 *generamos un escalar con el valor obtenido anteriormente
  gen pib_rl= rgdpwok/gdpusa if year==2008 
  *generamos la variable del pib relativo* 
  
 *ejercicio 8*
 list n if country=="United States" & year==2008
  scalar nusa=.0109256
  *usaremos un escalar llamado n de estados unidos*
   gen pib_rln=(((ci/n+deprec)^(scalar(a)/(1-scalar(a))))*h)/(((ci/nusa+deprec)^(scalar(a)/(1-scalar(a))))*h)
   *generamos el pib relativo por solo n*

*ejercicio 9*
  graph twoway scatter pib_rln pib_rl if year==2008
*hacemos el grafico

*ejercicio 10*
 list ci if country=="United States"
  scalar ciusa= 21.08093
  *generamos el escalar de la taza de inversion de estados unidos*
  gen pib_rlcin=(((ci/n+deprec)^(scalar(a)/(1-scalar(a))))*h)/(((ciusa/nusa+deprec)^(scalar(a)/(1-scalar(a))))*h)
  graph twoway scatter pib_rlcin pib_rl if year==2008
  
 *ejercicio 11*
 list h if year==2008 & country=="United States"
 scalar husa= 3.617599
 *creamos escalar de capital humano de estados unidos*
 gen pib_rlcihn=(((ci/n+deprec)^(scalar(a)/(1-scalar(a))))*h)/(((ciusa/nusa+deprec)^(scalar(a)/(1-scalar(a))))*husa)
graph twoway scatter pib_rlcihn pib_rl if year==2008
*vemos la relacion entre el pib de estado estacionario estimado por el modelo partido en el producto observado*

*ejercicio 12*
gen A=(((ci/n+deprec)^(scalar(a)/(1-scalar(a))))*h)/rgdpwok
list A if country=="United States"
scalar Ausa= .0018746
*generamos un escalar con el A de estados unidos*
 gen A_rl=A/Ausa
 *generamos la variable A relativo, con el A de un pais/el A de estados unidos*
*ejercicio 13*
 graph twoway scatter  A_rl pib_rl if year==2008


