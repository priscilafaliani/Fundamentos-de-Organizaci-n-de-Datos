program ejercicio4;

uses sysutils;

const
    MAQUINAS = 5;
    CODIGO_FIN = 32767;
type

    // la LAN existe desde 2020
    rango_anios = 2020..2021;
    rango_meses = 1..12;
    rango_dias = 1..31;

    reg_fecha = record
        anio : rango_anios;
        mes : rango_meses;
        dia : rango_dias;
    end;

    reg_sesion = record
        codigo_usuario : integer;
        fecha : reg_fecha;
        tiempo : integer;
    end;
    arr_reg_sesion = array[1..MAQUINAS] of reg_sesion;

    // archivos detalle
    archivo_detalle = file of reg_sesion;

    arr_detalles = array[1..MAQUINAS] of archivo_detalle;

    reg_tiempo_total_sesion = record
        codigo_usuario : integer;
        fecha : reg_fecha;
        tiempo_total : integer;
    end;

    // archivo maestro
    archivo_maestro = file of reg_tiempo_total_sesion;


// retorna TRUE si fecha1 < fecha2 o FALSE en caso contrario
function es_menor(fecha1, fecha2 : reg_fecha): boolean;
var menor : boolean;
begin
    if (fecha1.anio < fecha2.anio) then
        menor := true
    else if (fecha1.anio = fecha2.anio) and (fecha1.mes < fecha2.mes) then
        menor := true
    else if (fecha1.anio = fecha2.anio) and (fecha1.mes = fecha2.mes) and (fecha1.dia < fecha2.dia) then
        menor := true
    else
        menor := false;
    es_menor := menor;
end;


function es_mismo_dia(fecha1, fecha2 : reg_fecha): boolean;
begin
    es_mismo_dia := (fecha1.anio = fecha2.anio) and (fecha1.mes = fecha2.mes) and (fecha1.dia = fecha2.dia);
end;


procedure leer_sesion(var detalle : archivo_detalle; var sesion :reg_sesion);
begin
    if not eof(detalle) then
        read(detalle, sesion)
    else
        sesion.codigo_usuario := CODIGO_FIN;
end;


procedure iniciar_registros_detalle(var detalles : arr_detalles; var registros : arr_reg_sesion);
var i : integer;
begin
    for i := 1 to MAQUINAS do
        leer_sesion(detalles[i], registros[i]);
end;


procedure abrir_detalles(var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to MAQUINAS do
    begin
        assign(detalles[i], 'detalle' + intToStr(i));
        reset(detalles[i]);
    end;
end;


procedure cerrar_detalles(var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to MAQUINAS do
        close(detalles[i]);
end;


procedure minimo_sesion_detalle(var detalles : arr_detalles; var registros : arr_reg_sesion; var minimo : reg_sesion);
var i, pos : integer;
begin
    minimo.codigo_usuario := CODIGO_FIN;
    minimo.fecha.anio := 2021;
    minimo.fecha.mes := 12;
    minimo.fecha.dia := 31;

    for i := 1 to MAQUINAS do
    begin
        if (minimo.codigo_usuario < registros[i].codigo_usuario) then
        begin
            minimo := registros[i];
            pos := i;
        end
        else if (minimo.codigo_usuario = registros[i].codigo_usuario) and (es_menor(minimo.fecha, registros[i].fecha)) then
        begin
            minimo := registros[i];
            pos := i;            
        end;
    end;

    if (minimo.codigo_usuario <> CODIGO_FIN) then
        read(detalles[pos], registros[pos]);
end;


procedure generar_archivo_maestro();
var
    maestro : archivo_maestro;
    detalles : arr_detalles;
    reg_detalles : arr_reg_sesion;
    minimo_sesion : reg_sesion;
    total_sesion : reg_tiempo_total_sesion;
begin
    assign(maestro, 'var\log\maestro');
    rewrite(maestro);

    abrir_detalles(detalles);
    iniciar_registros_detalle(detalles, reg_detalles);

    minimo_sesion_detalle(detalles, reg_detalles, minimo_sesion);
    while (minimo_sesion.codigo_usuario <> CODIGO_FIN) do
    begin
        total_sesion.codigo_usuario := minimo_sesion.codigo_usuario;
        total_sesion.fecha := minimo_sesion.fecha;
        // mientras sea el mismo usuario y la misma fecha, acumulo
        while (minimo_sesion.codigo_usuario = total_sesion.tiempo_total) and (es_mismo_dia(minimo_sesion.fecha, total_sesion.fecha)) do
        begin
            total_sesion.tiempo_total := total_sesion.tiempo_total + minimo_sesion.tiempo;
            minimo_sesion_detalle(detalles, reg_detalles, minimo_sesion);
        end;

        // escribo en maestro
        write(maestro, total_sesion);
    end;

    close(maestro);
    cerrar_detalles(detalles);
end;

begin
    generar_archivo_maestro();
    readln;
end.
