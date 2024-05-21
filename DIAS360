

//Autor: Francisco Mullor
//Funcion DIAS360 Excel para Power Query para hallar la diferencia entre dos fechas en base a calendario360

(INICIO as date, FIN as date)=>


let 

Transformacion=

(if Date.Year(INICIO)=Date.Year(FIN) then Date.Month(FIN)-Date.Month(INICIO)

else Date.Month(FIN)-Date.Month(INICIO)+ (Date.Year(FIN)-Date.Year(INICIO))*12 )*30+ (

if Date.Day(FIN)=31 then 30 else Date.Day(FIN)) - 
(if Date.Day(INICIO)=31 then 30 else Date.Day(INICIO)) 

in

Transformacion
