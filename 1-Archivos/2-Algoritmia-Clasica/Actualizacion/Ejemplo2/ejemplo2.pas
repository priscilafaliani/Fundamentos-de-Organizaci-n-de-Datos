program ejemplo2;

type 

    reg_producto = record
        codigo : string[4];
        descripcion : string;
        stock : integer;
    end;

    reg_venta = record
        codigo : string[4];
        cantidad : integer;
    end;

    archivo_detalle = file of venta;
    archivo_maestro = file of producto;

var
    producto : reg_producto;
    venta : reg_venta;
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    codigo_actual : string[4];
    total_vendido : integer;

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

        codigo_actual := venta.codigo;
        total_vendido := 0;

        { 
            con el codigo de esta manera:
            1. no se verifica el EOF!
            2. cuando se vuelve a la iteracion externa, se pierde un dato leido!
        }
        while (venta.codigo = codigo_actual) do begin
            total_vendido := total_vendido + venta.cantidad;
            read(detalle, venta);
        end;

        producto.stock := producto.stock - total_vendido;
        seek(maestro, filepos(maestro) - 1);
        write(maestro, producto);
    end;
    
    close(maestro);
    close(detalle);
end.