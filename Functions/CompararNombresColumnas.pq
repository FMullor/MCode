
//Autor: Francisco Mullor
//Esta funcion nos va a permitir comparar los nombres de las columnas de dos tablas para poder ver a priori si vamos a poder anexarlas sin problema


(Tabla1 as table, Tabla2 as table) =>


let
    Origen = Table.ColumnNames(Tabla1),
    #"Convertida en tabla" = Table.FromList(Origen, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    TablaA = Table.TransformColumnTypes(#"Convertida en tabla",{{"Column1", type text}}),
    Personalizado1 = Table.ColumnNames(Tabla2),
    #"Convertida en tabla1" = Table.FromList(Personalizado1, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Convertida en tabla1",{{"Column1", type text}}),
    #"Consultas combinadas" = Table.NestedJoin(#"Tipo cambiado", {"Column1"}, TablaA, {"Column1"}, "Columnas con nombre cambiado1", JoinKind.FullOuter),
    #"Se expandió Columnas con nombre cambiado1" = Table.ExpandTableColumn(#"Consultas combinadas", "Columnas con nombre cambiado1", {"Column1"}, {"Column1.1"}),
    CambioNombres= Table.RenameColumns(#"Se expandió Columnas con nombre cambiado1",{{"Column1", "Tabla1"}, {"Column1.1", "Tabla2"}})
in
    CambioNombres





//Por observación de Bernat Agulló, comparar nombres y tipo de datos para mejorar aun los datos previos a la anexión

(Tabla1 as table, Tabla2 as table) =>


let
    Origen = Table.SelectColumns(Table.Schema(Tabla1),{"Name", "TypeName"}),
    Origen2 = Table.SelectColumns(Table.Schema(Tabla2),{"Name", "TypeName"}),
    #"Consultas combinadas" = Table.NestedJoin(Origen2, {"Name"}, Origen, {"Name"}, "Cruce", JoinKind.FullOuter),
    #"Se expandió Cruce" = Table.ExpandTableColumn(#"Consultas combinadas", "Cruce", {"Name", "TypeName"}, {"Cruce.Name", "Cruce.TypeName"}),
    #"Personalizada agregada" = Table.AddColumn(#"Se expandió Cruce", "CheckType", each [TypeName]=[Cruce.TypeName])
in
    #"Personalizada agregada"
