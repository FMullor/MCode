(Tabla1 as table, Tabla2 as table) =>


let
    Origen = Table.SelectColumns(Table.Schema(Tabla1),{"Name", "TypeName"}),
    Origen2 = Table.SelectColumns(Table.Schema(Tabla2),{"Name", "TypeName"}),
    #"Consultas combinadas" = Table.NestedJoin(Origen2, {"Name"}, Origen, {"Name"}, "Cruce", JoinKind.FullOuter),
    #"Se expandió Cruce" = Table.ExpandTableColumn(#"Consultas combinadas", "Cruce", {"Name", "TypeName"}, {"Cruce.Name", "Cruce.TypeName"}),
    #"Personalizada agregada" = Table.AddColumn(#"Se expandió Cruce", "CheckType", each [TypeName]=[Cruce.TypeName])
in
    #"Personalizada agregada"
