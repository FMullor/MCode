let
    
    metaDocumentation = type function (
        Tabla as (type table meta [
            Documentation.FieldCaption = "Origen",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ]),
        QueryNativa as (type text meta [
            Documentation.FieldCaption = " Consulta Nativa ",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ])
		
        ) as list
	
        meta [

        Documentation.Name = "ConsultaNativa.Folding",
        Documentation.LongDescription = 
        "    
                <p><b>  Ejecución de consulta nativa manteniendo el plegado  </b></p>

                <li>------------------------------------------------------</li>
                
                <li><b>  Autor: </b> Francisco Mullor  </li>
                <li><b>  Web: </b> https://github.com/FMullor/MCode </li>

                <li>------------------------------------------------------</li>

                <p><b>  Descripción de la función:  </b></br>
                Esta función nos permite realizar una consulta nativa sobre una base de datos SQL y continual manteniendo el plegado de consulta, algo que no nos permite el cuadro de diálogo nativo.
				Es imprescincible apuntar a una tabla que contenga el origen de la base de datos sin seleccionar tabla alguna del mismo.
                
                <p><b>  Parametros:  </b></br>
                <ul>
                    <li><b>  • Tabla:  </b>  Tabla Origen Base Datos  </li>
                    <li><b>  • Query Nativa:  </b>  Consulta SQL que queramos ejecutar </li>
                    
                    
                </ul>

                <b>  Retorna:  </b></br>
                Tabla con los resultados de la consulta ejecutada sobre Base de datos SQL.

                <p><b>  barra de fórmulas (fx) ejemplo:  </b></br>
                <code>  ConsultaNativa.Folding(Origen, ""select * from tb.tabla"")  </code>
                
            "
          ],
    
    
  myFunction = 
  
( Tabla as table, QueryNativa as text ) =>
    
   let
        Source = 
        Tabla,

        Query = 
        Value.NativeQuery(Source, QueryNativa, null, [EnableFolding=true])

    in
    
    Query
  
  
  
  in  

    Value.ReplaceType(myFunction, metaDocumentation)
