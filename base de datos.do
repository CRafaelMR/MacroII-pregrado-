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
b)  graph twoway scatter n rgdpwok if year==2008
c)  graph twoway scatter h rgdpwok if year==2008

*ejercicio 6*
a)
b)
c)
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
   gen pib_rln=((nusa+deprec)/(n+deprec))^(0.5)
   *generamos el pib relativo por solo n*

*ejercicio 9*
  graph twoway scatter pib_rln pib_rl if year==2008
*hacemos el grafico

*ejercicio 10*
 list ci if country=="United States"
  scalar ciusa= 21.08093
  gen pib_rlcin=((ci*(nusa+deprec))/(ciusa*(n+deprec)))^(0.5) if year==2008
  graph twoway scatter pib_rlcin pib_rl if year==2008
  
 *ejercicio 11*
 list h if year==2008 & country=="United States"
 scalar husa= 3.617599
 *creamos escalar de capital humano de estados unidos*
 gen pib_rlcihn=(ci^(1/3)+h^(1/3))*(nusa+deprec)^(0.5)/(((ciusa)^(1/3)+(husa)^(1/3))*(n+deprec)^(0.5))
graph twoway scatter pib_rlcihn pib_rl if year==2008


 
 
 
 
 *ejercicio 12
 gen lnci=ln(ci)
  gen lnh=ln(h)
   gen lnpib=ln(rgdpwok)
    gen lndep=ln(n+deprec)
 
 