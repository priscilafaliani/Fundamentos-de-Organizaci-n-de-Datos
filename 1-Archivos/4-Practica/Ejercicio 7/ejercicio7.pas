program ejercicio7;

const
    CODIGO_FIN = 32767;

type
    reg_maestro = record
        codigo : integer;
        nombre : string;
        precio : real;
        stock : integer;
        stock_minimo : integer;
    end;

    archivo_maestro = file of reg_maestro;

    reg_detalle = record
        codigo : integer;
        cantidad : integer;
    end;

    archivo_detalle = file of reg_detalle;


procedure leer_txt(var archivo : text; var registro : reg_maestro);
begin
    if not eof(archivo) then
        with registro do
            read(archivo, codigo, precio, stock, stock_minimo, nombre)
    else
        registro.codigo := CODIGO_FIN;
end;


procedure leer_bin(var archivo : archivo_maestro; var registro : reg_maestro);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.codigo := CODIGO_FIN;
end;


procedure crear_archivo_maestro();
var
    maestro : archivo_maestro;
    txt : text;
    item_maestro : reg_maestro;
begin
    assign(maestro, 'maestro');
    rewrite(maestro);

    assign(txt, 'productos.txt');
    reset(txt);

    leer_txt(txt, item_maestro);
    while (item_maestro.codigo <> CODIGO_FIN) do
    begin
        write(maestro, item_maestro);
        leer_txt(txt, item_maestro);
    end;

    close(maestro);
    close(txt);
end;


procedure escribir_txt(var archivo : text; registro : reg_maestro);
begin
    with registro do
        writeln(archivo, codigo, precio, stock, stock_minimo, nombre);
end;


procedure exportar_maestro();
var
    maestro : archivo_maestro;
    txt : text;
    item_maestro : reg_maestro;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(txt, 'reporte.txt');
    rewrite(txt);

    leer_bin(maestro, item_maestro);
    while (item_maestro.codigo <> CODIGO_FIN) do
    begin
        escribir_txt(txt, item_maestro);
        leer_bin(maestro, item_maestro);
    end;

    close(maestro);
    close(txt);
end;


procedure leer_txt_venta(var archivo : text; var registro : reg_detalle);
begin
    if not eof(archivo) then
        with registro do
            read(archivo, codigo, cantidad)
    else
        registro.codigo := CODIGO_FIN;
end;


procedure leer_bin_venta(var archivo : archivo_detalle; var registro : reg_detalle);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.codigo := CODIGO_FIN;
end;


procedure crear_detalle_txt();
var
    detalle : archivo_detalle;
    txt : text;
    item : reg_detalle;
begin
    assign(detalle, 'detalle');
    rewrite(detalle);

    assign(txt, 'ventas.txt');
    reset(txt);

    leer_txt_venta(txt, item);
    while (item.codigo <> CODIGO_FIN) do
    begin
        write(detalle, item);
        leer_txt_venta(txt, item);
    end;

    close(detalle);
    close(txt);
end;


procedure escribir_venta(venta : reg_detalle);
begin
    with venta do
    begin
        writeln('codigo: ', codigo);
        writeln('cantidad: ', cantidad);
    end;
end;


procedure mostrar_contenido_detalle();
var
    archivo : archivo_detalle;
    item : reg_detalle;
begin

    assign(archivo, 'detalle');
    reset(archivo);

    leer_bin_venta(archivo, item);
    while (item.codigo <> CODIGO_FIN) do
    begin
        // escribir es un procedure acorde al registro
        escribir_venta(item);
        leer_bin_venta(archivo, item);
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
        while (item_maestro.codigo <> item_detalle.codigo) do
            leer_bin(maestro, item_maestro);

        while (item_maestro.codigo = item_detalle.codigo) do
        begin
            item_maestro.stock := item_maestro.stock - item_detalle.cantidad;
            leer_bin_venta(detalle, item_detalle);
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, item_maestro);
    end;

    close(maestro);
    close(detalle);
end;


procedure escribir_txt_condicional(var archivo : text; registro : reg_maestro);
begin
    if (registro.stock < registro.stock_minimo) then
        with registro do
            writeln(archivo, codigo, stock, stock_minimo, precio, nombre);       
end;


procedure listar_algunos();
var
    maestro : archivo_maestro;
    algunos : text;
    item : reg_maestro;
begin
    assign(maestro, 'maestro');
    assign(algunos, 'stock_minimo.txt');

    reset(maestro);
    rewrite(algunos);

    leer_bin(maestro, item);
    while (item.codigo <> CODIGO_FIN) do
    begin
        escribir_txt_condicional(algunos, item);
        leer_bin(maestro, item);
    end;

    close(maestro);
    close(algunos);
end;


procedure menu();
begin
    writeln('-----------------------------------');
    writeln('1. crear archivo maestro');
    writeln('2. crear archivo detalle');
    writeln('3. exportar archivo maestro a txt');
    writeln('4. listar archivo detalle');
    writeln('5. actualizar archivo maestro');
    writeln('6. realizar informe stock');
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
            1: crear_archivo_maestro();
            2: crear_detalle_txt();
            3: exportar_maestro();
            4: mostrar_contenido_detalle();
            5: actualizar_maestro();
            6: listar_algunos();
        end;
        readln(eleccion);
    end;    
end;

begin
    main();
end.