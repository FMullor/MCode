let
    // Define metadata for the function, describing its purpose and usage.
    metaDocumentation = type function (
        StartDate as (type date meta [
            Documentation.FieldCaption = "Start Date",
            Documentation.SampleValues = {" 01/01/2024 (dd/MM/yyyy) "},
            // Documentation.AllowedValues = {"01/01/2024"},
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ]),
        EndDate as (type date meta [
            Documentation.FieldCaption = "End Date",
            Documentation.SampleValues = {" 31/01/2024 (dd/MM/yyyy) "},
            // Documentation.AllowedValues = {"31/01/2025"},
            Formatting.IsMultiLine = false,
            Formatting.IsCode = false
        ]),
        optional CompletedMonthsOnly as (type nullable logical meta [
            Documentation.FieldCaption = "Do you want to count completed months only?",
            Documentation.FieldDescription = "Count by completed months (true) or actual months (false)",
            Documentation.SampleValues = {"True", "False"},
            Documentation.AllowedValues = {true,false},
            Formatting.IsMultiLine = false,
            Formatting.IsCode = true
        ])
    ) as list meta [
        Documentation.Name = "fnCountMonths",
        Documentation.LongDescription = 
        "    
                <p><b>  Count Months Between Dates  </b></p>

                <li>------------------------------------------------------</li>
                
                <li><b>  Creator: </b> Imran Haq  </li>
                <li><b>  Web: </b> https://github.com/PBIQueryous  </li>

                <li>------------------------------------------------------</li>

                <p><b>  Function Description:  </b></br>
                This function counts the number of months between the a selected Start Date and End Date. The third parameter allow you to count either complete months or actual months
                
                <p><b>  Parameters:  </b></br>
                <ul>
                    <li><b>  • StartDate:  </b>  The Start Date field from your data. <code> (eg: 01/01/2024) </code> </li>
                    <li><b>  • EndDate:  </b>  The End Date field from your data. <code> (eg: 31/12/2025) </code> </li>
                    <li><b>  • CompletedMonthsOnly:  </b>  Select 'true' to count only completed months, 'false' for actual months. </li>
                    
                </ul>

                <b>  Returns:  </b></br>
                A custom column.

                <p><b>  formula bar (fx) example:  </b></br>
                <code>  fn_CountMonths( [StartDate], [EndDate], true )  </code>
                
            "
    ],
    // Define the main function
    
myFunction = (Tabla1 as table, Tabla2 as table) =>


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
