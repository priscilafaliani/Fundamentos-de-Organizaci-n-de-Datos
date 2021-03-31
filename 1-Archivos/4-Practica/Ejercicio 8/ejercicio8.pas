program ejercicio8;

const
    CODIGO_FIN = 32767;

type
    rango_anios = 1999..2021;
    rango_meses = 1..12;
    rango_dias = 1..31;

    reg_fecha = record
        anio : rango_anios;
        mes : rango_meses;
        dia : rango_dias;
    end;

    reg_cliente = record
        codigo : integer;
        nombre : string;
        apellido : string;
    end;

    { reg venta }
    reg_maestro = record
        cliente : reg_cliente;
        fecha : reg_fecha;
        monto : real;
    end;

    archivo_maestro = file of reg_maestro;


var
    maestro : archivo_maestro;


function es_mismo_dia(fecha1, fecha2 : reg_fecha): boolean;
begin
    es_mismo_dia := (fecha1.anio = fecha2.anio) and (fecha1.mes = fecha2.mes) and (fecha1.dia = fecha2.dia);
end;


procedure leer(var archivo : archivo_maestro; var registro : reg_maestro);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.cliente.codigo := CODIGO_FIN;
end;


function totalizar_mes_cliente(var item : reg_maestro; anio_actual, cliente_actual : integer): real;
var 
    mes_actual : integer;
    total_mensual : real;
begin
    mes_actual := item.fecha.mes;

    total_mensual := 0;
    while (item.cliente.codigo <> CODIGO_FIN) and (item.cliente.codigo = cliente_actual) and (item.fecha.anio = anio_actual) and (item.fecha.mes = mes_actual) do
    begin
        total_mensual := total_mensual + item.monto;
        leer(maestro, item);
    end;

    writeln('Total del mes ', mes_actual, 'del cliente: ', total_mensual);
    totalizar_mes_cliente := total_mensual;
end;


function totalizar_anio_cliente(var item : reg_maestro; cliente_actual : integer): real;
var 
    total_anual : real;
    anio_actual : integer;
begin
    anio_actual := item.fecha.anio;

    total_anual := 0;
    while (item.cliente.codigo <> CODIGO_FIN) and (item.cliente.codigo = cliente_actual) and (item.fecha.anio = anio_actual) do
        total_anual := total_anual + totalizar_mes_cliente(item, cliente_actual, anio_actual);
    writeln('Total del anio ', anio_actual,  ' del cliente: ', total_anual);

    totalizar_anio_cliente := total_anual;
end;


procedure imprimir_datos_cliente(cliente : reg_maestro);
begin
    with cliente, cliente do 
    begin
        writeln('codigo cliente: ', codigo);
        writeln('nombre: ', nombre);
        writeln('apellido: ', apellido);    
    end;
end;


procedure realizar_reporte();
var
    item : reg_maestro;
    cliente_actual : integer;
    total_empresa : real;
begin
    total_empresa := 0;

    leer(maestro, item);
    while (item.cliente.codigo <> CODIGO_FIN) do
    begin
        cliente_actual := item.cliente.codigo;
        imprimir_datos_cliente(item);

        while (item.cliente.codigo <> CODIGO_FIN) and (item.cliente.codigo = cliente_actual) do
            total_empresa := total_empresa + totalizar_anio_cliente(item, cliente_actual);
    end;

    writeln('Total ventas empresa: ', total_empresa);
end;


procedure main();
begin
    assign(maestro, 'maestro');
    reset(maestro);
    realizar_reporte();
    close(maestro);
end;


begin
    main();
end.