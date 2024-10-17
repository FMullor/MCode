

let
    
    metaDocumentation = type function (
        INICIO as (type date meta [
            Documentation.FieldCaption = " Fecha Inicial",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ]),
        FIN as (type date meta [
            Documentation.FieldCaption = " Fecha Final ",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ])
		
        ) as list
	
        meta [

        Documentation.Name = "DIAS360",
        Documentation.LongDescription = 
        "    
                <p><b>  Diferencia de dias entre dos fechas basada en calendario 360  </b></p>

                <li>------------------------------------------------------</li>
                
                <li><b>  Autor: </b> Francisco Mullor  </li>
                <li><b>  Web: </b> https://github.com/FMullor/MCode </li>

                <li>------------------------------------------------------</li>

                <p><b>  Descripción de la función:  </b></br>
                Esta función que permite extraer la diferencia en dias entre dos fechas basada en calendario de 360 días. Sería el equivalente a la función DIAS360 de Excel
                
                <p><b>  Parametros:  </b></br>
                <ul>
                    <li><b>  • INICIO:  </b>  Fecha Inicial  </li>
                    <li><b>  • FIN:  </b>  Fecha Final </li>
                    
                    
                </ul>

                <b>  Retorna:  </b></br>
                Diferencia en días entre dos fechas basada en calendario 360.

                <p><b>  barra de fórmulas (fx) ejemplo:  </b></br>
                <code>  DIAS360( Tabla1, Tabla2 )  </code>
                
            "
          ],
    
    
  myFunction = 
  
(INICIO as date, FIN as date)=>


let 

Transformacion=

(if Date.Year(INICIO)=Date.Year(FIN) then Date.Month(FIN)-Date.Month(INICIO)

else Date.Month(FIN)-Date.Month(INICIO)+ (Date.Year(FIN)-Date.Year(INICIO))*12 )*30+ (

if Date.Day(FIN)=31 then 30 else Date.Day(FIN)) - 
(if Date.Day(INICIO)=31 then 30 else Date.Day(INICIO)) 

in

Transformacion
  
  
  
  in  

    Value.ReplaceType(myFunction, metaDocumentation)
