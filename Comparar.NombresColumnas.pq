let
    
    metaDocumentation = type function (
        Tabla1 as (type table meta [
            Documentation.FieldCaption = " Tabla1 a comparar",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ]),
        Tabla2 as (type table meta [
            Documentation.FieldCaption = " Tabla2 a comparar ",
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ])
		
        ) as list
	
        meta [

        Documentation.Name = "Comparar.NombresColumnas",
        Documentation.LongDescription = 
        "    
                <p><b>  Comparar nombres y tipos de datos de dos tablas  </b></p>

                <li>------------------------------------------------------</li>
                
                <li><b>  Creator: </b> Francisco Mullor  </li>
                <li><b>  Web: </b> https://github.com/FMullor/RepositorioM </li>

                <li>------------------------------------------------------</li>

                <p><b>  Descripción de la función:  </b></br>
                Esta función permite comparar las columnas de dos tablas para ver que tengan los mismos nombres y sean del mismo tipo antes de anexar dos tablas.
                
                <p><b>  Parametros:  </b></br>
                <ul>
                    <li><b>  • Tabla1:  </b>  La Tabla 1 a comparar  </li>
                    <li><b>  • Tabla2:  </b>  La Tabla 2 a comparar </li>
                    
                    
                </ul>

                <b>  Retorna:  </b></br>
                Una tabla con los nombres de columna y sus tipos asi como un check si es correcto o no la coincidencia .

                <p><b>  barra de fórmulas (fx) ejemplo:  </b></br>
                <code>  Comparar.NombresColumnas( Tabla1, Tabla2 )  </code>
                
            "
          ],
    
    
  myFunction = 
  
  (Tabla1 as table, Tabla2 as table) =>


let
    Origen = Table.SelectColumns(Table.Schema(Tabla1),{"Name", "TypeName"}),
    Origen2 = Table.SelectColumns(Table.Schema(Tabla2),{"Name", "TypeName"}),
    #"Consultas combinadas" = Table.NestedJoin(Origen2, {"Name"}, Origen, {"Name"}, "Cruce", JoinKind.FullOuter),
    #"Se expandió Cruce" = Table.ExpandTableColumn(#"Consultas combinadas", "Cruce", {"Name", "TypeName"}, {"Cruce.Name", "Cruce.TypeName"}),
    #"Personalizada agregada" = Table.AddColumn(#"Se expandió Cruce", "CheckType", each [TypeName]=[Cruce.TypeName])
in
    #"Personalizada agregada"
  
  
  
  in  

    Value.ReplaceType(myFunction, metaDocumentation)
