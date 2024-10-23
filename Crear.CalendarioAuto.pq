let
    
    metaDocumentation = type function (
		
        ) as list
	
        meta [

        Documentation.Name = "Crear.CalendarioAuto",
        Documentation.LongDescription = 
        "    
                <p><b>  Creación de calendario completo entre la fecha máxima y minima de las tablas existentes  </b></p>

                <li>------------------------------------------------------</li>
                
                <li><b>  Autor: </b> Francisco Mullor  </li>
                <li><b>  Web: </b> https://github.com/FMullor/MCode </li>

                <li>------------------------------------------------------</li>

                <p><b>  Descripción de la función:  </b></br>
                Esta función nos permite crear un completísimo calendario de manera totalmente automátia simulando el calendarauto() de DAX y además de todos los atributos habituales de los calendarios, contiene los desvíos de ejercicio, 
				trimestre, mes y día para la dinamización del calendario, así como columnas especiales como el Ejercicio-Mes filtro para poder establecer un filtro dinámico con el mes actual
				y como extra el calendario laboral de Madrid desde 2017 a 2024.
				Si no hay ningún campo de fecha en el modelo, creará la tabla de fechas del año en curso
                
                <p><b>  Parametros:  </b></br>
                <ul>
                    <li><b>  • Ninguno </li>
                       </li>
                    
                    
                </ul>

                <b>  Retorna:  </b></br>
                Tabla de calendario www.powerbisp.com

                <p><b>  barra de fórmulas (fx) ejemplo:  </b></br>
                <code>  Crear.CalendarioAuto()  </code>
                
            "
          ], 
    
    
  myFunction = 
  
()=>

let
AllQueries = #sections,
   RecordToTable = Record.ToTable(AllQueries[Section1]),
    #"Errores quitados" = Table.RemoveRowsWithErrors(RecordToTable, {"Value"}),
   AddTableSchemaColumn = Table.AddColumn(
      #"Errores quitados",
      "TableSchema",
      each
         try Table.Schema([Value])
         otherwise null),
   ExpandTableSchema = Table.Buffer(
      Table.ExpandTableColumn(
      AddTableSchemaColumn,
      "TableSchema",
      {"Name", "Kind"},
      {"Column Name", "Datatype"})),
   FilterTypes = Table.SelectRows(
      ExpandTableSchema,
      each
         ([Datatype] = "datetime"
      or
         [Datatype] = "date")),
   AddedMinDateColumn = Table.AddColumn(
      FilterTypes,
      "Min Date",
      each
         Date.From(
            List.Min(
               Table.Column([Value], [Column Name])))),
   AddedMaxDateColumn = Table.AddColumn(
      AddedMinDateColumn,
      "Max Date",
      each
         Date.From(
            List.Max(
               Table.Column([Value], [Column Name])))),
 MinDate = if (Date.Year(List.Min(
      List.Combine(
         {AddedMaxDateColumn[Min Date],
         AddedMaxDateColumn[Max Date]})))) = null then  Date.Year(Date.From(DateTime.LocalNow())) else  Date.Year(List.Min(
      List.Combine(
         {AddedMaxDateColumn[Min Date],
         AddedMaxDateColumn[Max Date]}))),
   MaxDate = if (Date.Year(List.Max(
      List.Combine(
         {AddedMaxDateColumn[Min Date],
         AddedMaxDateColumn[Max Date]}))))= null then Date.Year(Date.From(DateTime.LocalNow())) else 
         Date.Year(List.Max(
      List.Combine(
         {AddedMaxDateColumn[Min Date],
         AddedMaxDateColumn[Max Date]}))),
   FestivosMadrid= Table.TransformColumnTypes(Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("XdRbDoIwEEDRvfhtQueBTNdi3P82LNIpc038uSnYHkZ5vx9NtvHRJsfj8xz5QkrfmpW0rXlJZ76YB/LcaC+r+9aipG7ScLHwVOOCOwOpO1dTFBQFRVcq0xry/CovqcwUBUVBUVAUFAVFQVFQ1CnqFM2Mech7taQKU5FL1CnqFHWKOkWdok5Rh0gbRJnzzDPHpjXzkJmKPM/8l1FyEu57hfsij+vMmYFMUTnV716hSDCjXJ1TyFRmAmcacgGFIsFQMjtzzigzkEskFClFiv9+5o5cQ9H1Zig5NhrPFvdGyRQpRUqRUqQUzY3+VpNgK73kwcwpGEXGKRhFRpFRZBQZRUaRUWSckXFGTuCVGvNX53jX5cUJdAKdQCfQCXQCnUAn0Al0ikZ+vg==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [FestivosMadrid = _t]),{{"FestivosMadrid", type datetime}}),
  Origen = Table.TransformColumnTypes(
    Table.FromList({Number.From(#date(MinDate,1,1))..Number.From(#date(MaxDate,12,31))}, Splitter.SplitByNothing(), {"Fecha"}) , {{"Fecha", type date}} ),
    #"Año insertado" = Table.AddColumn(Origen, "Año", each Date.Year([Fecha]), type number),
  #"Columnas con nombre cambiado 1" = Table.RenameColumns(#"Año insertado", {{"Año", "Ejercicio"}}),
  #"Mes insertado" = Table.AddColumn(#"Columnas con nombre cambiado 1", "Mes", each Date.Month([Fecha]), type number),
  #"Columnas con nombre cambiado 2" = Table.RenameColumns(#"Mes insertado", {{"Mes", "MesNro"}}),
  #"Nombre del mes insertado" = Table.AddColumn(#"Columnas con nombre cambiado 2", "Mes", each Date.MonthName([Fecha]), type text),
  #"Texto en mayúsculas" = Table.TransformColumns(#"Nombre del mes insertado", {{"Mes", each Text.Upper(_), type text}}),
  #"Día insertado" = Table.AddColumn(#"Texto en mayúsculas", "Día", each Date.Day([Fecha]), Int64.Type),
  #"Columnas con nombre cambiado 3" = Table.RenameColumns(#"Día insertado", {{"Día", "Dia"}}),
  #"Personalizado agregado" = Table.AddColumn(#"Columnas con nombre cambiado 3", "IdFecha", each [Ejercicio]*10000 + [MesNro]*100 + [Dia], Int64.Type),
  #"Personalizado agregado 1" = Table.AddColumn(#"Personalizado agregado", "IdFechaEntero", each Number.From([Fecha]), Int64.Type),
  #"Columnas con nombre cambiado 4" = Table.RenameColumns(#"Personalizado agregado 1", {{"Dia", "NroDia"}}),
  #"Trimestre insertado" = Table.AddColumn(#"Columnas con nombre cambiado 4", "Trimestre", each "T" & Text.From(Date.QuarterOfYear([Fecha])), type text),
  #"Día de la semana insertado" = Table.AddColumn(#"Trimestre insertado", "DiaSemana", each Date.DayOfWeek([Fecha]) +1, Int64.Type),
  #"Semana del año insertada" = Table.AddColumn(#"Día de la semana insertado", "NroSemana", each Date.WeekOfYear([Fecha]), Int64.Type),
  #"Personalizado agregado 2" = Table.AddColumn(#"Semana del año insertada", "Ejercicio-Trim.", each Number.ToText([Ejercicio])&"-"&[Trimestre], type text),
  #"Primeros caracteres insertados" = Table.AddColumn(#"Personalizado agregado 2", "MesCorto", each Text.Start([Mes], 3), type text),
  #"Columna condicional insertada" = Table.AddColumn(#"Primeros caracteres insertados", "EsLaborable", each if [DiaSemana] <= 5 then 1 else 0, Int64.Type),
  #"Día del año insertado" = Table.AddColumn(#"Columna condicional insertada", "DiaEjercicio", each Date.DayOfYear([Fecha]), Int64.Type),
  #"Personalizado agregado 3" = Table.AddColumn(#"Día del año insertado", "Ejercicio-Mes", each Number.ToText([Ejercicio])&"-"&Text.End("0"&Text.From([MesNro]),2)),
  #"Transformar columnas" = Table.TransformColumnTypes(#"Personalizado agregado 3", {{"Ejercicio-Mes", type text}}),
  #"Reemplazar errores" = Table.ReplaceErrorValues(#"Transformar columnas", {{"Ejercicio-Mes", null}}),
  #"Personalizado agregado 4" = Table.AddColumn(#"Reemplazar errores", "EjercicioActual", each Date.Year(DateTime.LocalNow()), Int64.Type),
  #"Personalizado agregado 5" = Table.AddColumn(#"Personalizado agregado 4", "DesvioEjercicio", each [Ejercicio] - [EjercicioActual], Int64.Type),
  Personalizado = Table.AddColumn(#"Personalizado agregado 5", "MesActual", each Date.Month(DateTime.LocalNow()), Int64.Type),
  #"Personalizado 1" = Table.AddColumn(Personalizado, "HoyEntero", each Number.RoundDown(Number.From(DateTime.LocalNow())), Int64.Type),
  #"Tipo de columna cambiado 2" = Table.TransformColumnTypes(#"Personalizado 1", {{"Fecha", type datetime}}),
  #"Personalizado 2" = Table.AddColumn(#"Tipo de columna cambiado 2", "TrimestreActual", each Date.QuarterOfYear(DateTime.LocalNow()), Int64.Type),
  #"Personalizado agregado 6" = Table.AddColumn(#"Personalizado 2", "Semestre", each Number.RoundUp(Date.Month([Fecha])/6), Int64.Type),
  #"Personalizado agregado 7" = Table.AddColumn(#"Personalizado agregado 6", "DesvioMes", each if [Ejercicio]=[EjercicioActual] then [MesNro]-[MesActual]
else [MesNro]-[MesActual]+([DesvioEjercicio]*12), Int64.Type),
  #"Personalizado agregado 8" = Table.AddColumn(#"Personalizado agregado 7", "DesvioDia", each [IdFechaEntero] - [HoyEntero], Int64.Type),
  #"Personalizado agregado 9" = Table.AddColumn(#"Personalizado agregado 8", "HastaFecha", each if [IdFechaEntero]<=[HoyEntero] then "PASADO"
else "FUTURO", type text),
  #"Personalizado agregado 10" = Table.AddColumn(#"Personalizado agregado 9", "TrimestreNro", each Date.QuarterOfYear([Fecha]), Int64.Type),
  #"Personalizado 3" = Table.AddColumn(#"Personalizado agregado 10", "DesvioTrimestre", each if [Ejercicio]=[EjercicioActual] then [TrimestreNro]-[TrimestreActual]
else

[TrimestreNro]-[TrimestreActual]+([DesvioEjercicio]*4), Int64.Type),
  #"Personalizado 4" = Table.AddColumn(#"Personalizado 3", "SemestreActual", each Number.RoundUp(Date.Month(DateTime.LocalNow())/6), Int64.Type),
  #"Personalizado 5" = Table.AddColumn(#"Personalizado 4", "DesvioSemestre", each if [Ejercicio]=[EjercicioActual] then [Semestre]-[SemestreActual]
else
[Semestre]-[SemestreActual]+([DesvioEjercicio]*2), Int64.Type),
  #"Consultas combinadas" = Table.NestedJoin(#"Personalizado 5", {"Fecha"}, FestivosMadrid, {"FestivosMadrid"}, "aux FestivosMadrid", JoinKind.LeftOuter),
  #"aux FestivosMadrid expandido" = Table.ExpandTableColumn(#"Consultas combinadas", "aux FestivosMadrid", {"FestivosMadrid"}, {"FestivosMadrid"}),
  #"Columna condicional insertada 1" = Table.AddColumn(#"aux FestivosMadrid expandido", "EsLaborableMadrid", each if [FestivosMadrid] = null and [EsLaborable]=1 then 1 else if [FestivosMadrid] = 1 and [EsLaborable]=1 then 0 else 0),
  #"Tipo de columna cambiado 4" = Table.TransformColumnTypes(#"Columna condicional insertada 1", {{"EsLaborableMadrid", Int64.Type}}),
  #"Personalizado agregado 12" = Table.AddColumn(#"Tipo de columna cambiado 4", "EjercicioMes_FiltroActual", each if [DesvioMes]=0 then "Ejercicio Mes Actual" else [#"Ejercicio-Mes"], type text),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Personalizado agregado 12",{{"FestivosMadrid", type date}, {"Fecha", type date}}),
    #"Columna condicional agregada" = Table.AddColumn(#"Tipo cambiado", "Dia", each if [DiaSemana] = 3 then "Miércoles" else if [DiaSemana] = 4 then "Jueves" else if [DiaSemana] = 5 then "Viernes" else if [DiaSemana] = 6 then "Sábado" else if [DiaSemana] = 7 then "Domingo" else if [DiaSemana] = 1 then "Lunes" else if [DiaSemana] = 2 then "Martes" else null, type text)
in
    #"Columna condicional agregada"
