let
    // Step 1: Define metadata for each parameter describing its purpose and usage
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
        ]),
        optional parameter3 as (type nullable logical meta [
            Documentation.FieldCaption = " parameter3 list allowed values ",
            Documentation.FieldDescription = "parameter3 field description ",
            Documentation.SampleValues = {"True", "False"},
            Documentation.AllowedValues = {true,false},
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ])
    ) as list 
    // Step 2: Define global metadata in detail
    meta [

        Documentation.Name = "CompararNombresColumnas",
        Documentation.Author = "Francisco Mullor",
          ],
    
  // Define the main function and parameters
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
