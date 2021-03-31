program ejercicio6;

const
    SUCURSALES = 15;
    CODIGO_FIN = 32767;
type
    reg_articulo = record
        codigo_articulo : integer;
        nombre : string;
        descripcion : string;
        talle : string;
        color : string;
        stock : integer;
        stock_minimo : integer;
        precio : real;
    end;

    archivo_maestro = file of reg_articulo;

    reg_venta = record
        codigo_articulo : integer;
        cantidad : integer;
    end;

    arr_reg_venta = array[1..SUCURSALES] of reg_venta;

    archivo_detalle = file of reg_venta;

    arr_detalles = array[1..SUCURSALES] of archivo_detalle;


procedure abrir_detalles(var detalles : arr_detalles);
var i : integer;
begin
    for i := 1 to SUCURSALES do
    begin
        assign(archivos[i], 'detalles' + intToStr(i));
        reset(archivos[i]);
    end;
end;


procedure cerrar_detalles(var archivos : arr_detalles);
var i : integer;
begin
    for i := 1 to SUCURSALES do
        close(archivos[i]);
end;


procedure leer_venta(var archivo : archivo_detalle; var registro : reg_venta);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.codigo_articulo = CODIGO_FIN;
end;


// procedure leer_articulo(var archivo : archivo_maestro; var registro : reg_articulo);
// begin
//     if not eof(archivo) then
//         read(archivo, registro)
//     else
//         registro.codigo_articulo = CODIGO_FIN;
// end;


procedure iniciar_arr_reg(var archivos : arr_detalles; var registros : arr_reg_venta);
var i : integer;
begin
    for i := 1 to SUCURSALES do
        leer_venta(archivos[i], registros[i]);
end;


procedure minimo(var archivos : arr_detalles; var registros : arr_reg_venta; var minimo : reg_venta);
var i, pos : integer;
begin
    minimo.codigo_articulo := CODIGO_FIN;
    for i := 1 to SUCURSALES do
    begin
        if (minimo.codigo_articulo < registros[i].codigo_articulo) then
        begin
            minimo := registros[i];
            pos := i;
        end;
    end;

    if (minimo.codigo_articulo <> CODIGO_FIN) then
        leer_venta(archivos[pos], registros[pos]);
end;


procedure escribir_txt(var archivo : text; registro : reg_articulo);
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



procedure actualizar_stock();
var
    maestro : archivo_maestro;
    informe_stock : text;
    detalles : arr_detalles;
    ventas : arr_reg_venta;
    venta : reg_venta;
    articulo : reg_articulo;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    assign(informe_stock, 'informe_stock.txt');
    rewrite(informe_stock);

    abrir_detalles(detalles);
    iniciar_arr_reg(detalles, ventas);
    minimo(detalles, ventas, venta);

    while (venta.codigo_articulo <> CODIGO_FIN) do
    begin
        read(maestro, articulo);
        while (articulo.codigo_articulo <> venta.codigo_articulo) do
            read(maestro, articulo);

        while (articulo.codigo_articulo = venta.codigo_articulo) do
        begin
            articulo.stock := articulo.stock - venta.cantidad;
            minimo(detalles, ventas, venta);
        end;

        escribir_txt(informe_stock, articulo);
        seek(maestro, filepos(maestro) - 1);
        write(maestro, articulo);
    end;

    close(maestro);    
    close(informe_stock);
    cerrar_detalles(detalles);
end;

begin
    actualizar_stock();
end.
