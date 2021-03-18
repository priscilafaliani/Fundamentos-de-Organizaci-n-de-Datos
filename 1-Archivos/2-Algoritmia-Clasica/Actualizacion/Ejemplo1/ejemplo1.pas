program ejemplo1;

type 

    reg_producto = record
        codigo : string[4];
        descripcion : string;
        stock : integer;
    end;

    { venta de un producto }
    reg_venta = record
        codigo : string[4];
        cantidad : integer;
    end;

    archivo_detalle = file of reg_venta;
    archivo_maestro = file of reg_producto;

var
    venta : reg_venta;
    producto : reg_producto;
    maestro : archivo_maestro;
    detalle : archivo_detalle;

begin
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');

    reset(maestro);
    reset(detalle);

    while (not eof(detalle)) do begin
        read(maestro, producto);
        read(detalle, venta);

        while (producto.codigo <> venta.codigo) do
            read(maestro, producto);

        producto.stock := producto.stock - venta.cantidad;

        seek(maestro, filepos(maestro) - 1);

        write(maestro, producto);
    end;

    close(maestro);
    close(detalle);
end.