procedure leer(var archivo : arch; var registro : reg);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.campo := CODIGO_FIN;
end;


procedure escribir_txt(var archivo : text; registro : reg);
begin
    with registro do
    begin
        writeln(archivo, registro.campo);
        // etc
    end;
end;


procedure iniciar_arr_reg(var archivos : arr_archivos; var registros : arr_registros);
var i : integer;
begin
    for i := 1 to CANTIDAD do
        leer(archivos[i], registros[i]);
end;


procedure abrir_detalles(var detalles : arr_archivos);
var i : integer;
begin
    for i := 1 to CANTIDAD do
    begin
        assign(archivos[i], 'archivo' + intToStr(i));
        reset(archivos[i]);
    end;
end;


procedure cerrar_detalles(var archivos : arr_archivos);
var i : integer;
begin
    for i := 1 to CANTIDAD do
        close(archivos[i]);
end;


procedure minimo(var archivos : arr_archivos; var registros : arr_registros; var minimo : reg);
var i, pos : integer;
begin
    minimo.campo := CODIGO_FIN;
    for i := 1 to CANTIDAD do
    begin
        if (minimo.campo < registros[i].campo) then
        begin
            minimo := registros[i];
            pos := i;
        end;
    end;

    if (minimo.campo <> CODIGO_FIN) then
        leer(archivos[pos], registros[pos]);
end;


procedure minimo(var minimo, reg1, reg2 : reg_detalle; var detalle1, detalle2 : archivo_detalle);
begin
    minimo.provincia := CODIGO_FIN;

    if reg1.provincia < reg2.provincia then
    begin
        minimo := reg1
        leer(detalle1, reg1);
    end
    else begin
        minimo := reg2;
        leer(detalle2, reg2);        
    end;
end;


// modificar tipos de variables y eso
procedure crear_archivo_maestro();
var
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    item : reg;
begin
    assign(maestro, 'maestro');
    rewrite(maestro);

    assign(detalle, 'detalle');
    reset(detalle);

    leer(detalle, item);
    while (item.campo <> CODIGO_FIN) do
    begin
        write(maestro, actual);
        leer(detalle, item);
    end;

    close(maestro);
    close(detalle);
end;


procedure mostrar_contenido_archivo();
var
    archivo : arch;
    item : reg;
begin

    assign(archivo, 'archivo');
    reset(archivo);

    leer(archivo, item);
    while (item.campo <> CODIGO_FIN) do
    begin
        // escribir es un procedure acorde al registro
        escribir(item);
        leer(archivo, item);
    end;

    close(archivo);    
end;


procedure actualizar_maestro();
var
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    item_detalle : reg_detalle;
    item_maestro : reg_maestro;
begin
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');

    reset(maestro);
    reset(detalle);

    leer_bin_venta(detalle, item_detalle);
    while (item_detalle.codigo <> CODIGO_FIN) do
    begin
        leer_bin(maestro, item_maestro);
        while (item_maestro.codigo <> item_detalle) do
            leer_bin(maestro, item_maestro);

        // recolecto datos
        while (item_maestro.codigo = item_detalle.codigo) do
        begin
            // acciones            
            leer_bin_venta(detalle, item_detalle);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, item_maestro);
    end;

    close(maestro);
    close(detalle);
end;

// para exportar a txt baso en una condicion
procedure escribir_txt_condicional(var archivo : text; registro : reg_articulo);
begin
    if (registro.stock < registro.stock_minimo) then
    begin
        with registro do
        begin
            writeln(archivo, stock, precio, nombre);
            writeln(archivo, descripcion);
        end;    
    end;    
end;


procedure menu();
begin
    writeln('-----------------------------------');
    writeln('1. ');
    writeln('2. ');
    writeln('3. ');
    writeln('4. ');
    writeln('5. ');
    writeln('6. ');
    writeln('-----------------------------------');
end;


procedure main();
var
    eleccion : integer;
begin
    readln(eleccion);
    while (eleccion > 0) and (eleccion < 7) do 
    begin
        case eleccion of
            1: 
            2: 
            3: 
            4: 
            5: 
            6: 
        end;
        readln(eleccion);
    end;    
end;

// estructura de fecha, lo pide en muchos ejercicios
type
    rango_anios = 2020..2021;
    rango_meses = 1..12;
    rango_dias = 1..31;

    reg_fecha = record
        anio : rango_anios;
        mes : rango_meses;
        dia : rango_dias;
    end;

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

/////////////////////////////////////////////////////////////////////