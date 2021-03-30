program ejercicio8;

const
    CATEGORIAS = 15;
    CODIGO_SALIDA = -1;
type
    reg_empleado = record
        departamento : string;
        division : string;
        numero_empleado : integer;
        categoria : string;
        horas_extras : integer;
    end;

    arr_valor_horas = arr[1.. CATEGORIAS] of real;

    archivo_horas_extras = file of reg_empleado;


procedure cargar_valor_horas(var horas : arr_valor_horas);
var
    horas : text;
    valor : real;
    categoria : integer;
begin
    assign(horas, 'horas.txt');
    reset(horas);

    while not eof(horas) do
    begin
        read(horas, categoria, valor);
        horas[categoria] := valor;
    end;

    close(horas);    
end;


procedure leer_empleado_bin(var archivo : archivo_horas_extras; var registro : reg_empleado);
begin
    if (not eof(archivo)) then
        read(archivo, registro);
    else
        registro.categoria := CODIGO_SALIDA;
end;


procedure realizar_informe();
var
    horas : archivo_horas_extras;
    aux, actual : reg_empleado;
    // total de horas
    total_empleado, total_division, total_departamento : integer;
    // monto
    monto_total_empleado, monto_total_division, monto_total_departamento : real;
    valor_horas : arr_valor_horas;
begin

    assign(horas, 'horas');
    reset(horas);

    cargar_valor_horas(valor_horas);
    leer_empleado_bin(horas, aux);
    while(aux.categoria <> CODIGO_SALIDA) do
    begin
        actual.departamento := aux.departamento;
        writeln('****Departamento**** ', actual.departamento);
        total_departamento := 0; monto_total_departamento := 0;
        // mientras sea el mismo departamento
        while (aux.categoria <> CODIGO_SALIDA) and (aux.departamento = actual.departamento) do
        begin
            actual.division := aux.division;
            writeln('----Division---- ', actual.division);
            total_division := 0; monto_total_division := 0;
            // y la misma division
            while (aux.categoria <> CODIGO_SALIDA) and (aux.departamento = actual.departamento) and (aux.division = actual.division) do
            begin
                actual.numero_empleado := aux.numero_empleado;
                total_empleado := 0; monto_total_empleado := 0;
                // y el mismo empleado
                while (aux.categoria <> CODIGO_SALIDA) and (aux.departamento = actual.departamento) and (aux.division = actual.division) and (aux.numero_empleado = actual.numero_empleado) do
                begin
                    total_empleado := total_empleado + aux.horas_extras;
                    monto_total_empleado := monto_total_empleado + (aux.horas_extras * valor_horas[aux.categoria]);
                    leer_empleado_bin(horas, aux);
                end;
                writeln('...Empleado... ', actual.numero_empleado);
                writeln('Total de horas: ', total_empleado);
                writeln('Total a cobrar: ', monto_total_empleado);

                total_division := total_division + total_empleado;
                monto_total_division := monto_total_division + monto_total_empleado;
            end;

            writeln('Total horas division: ', total_division);
            writeln('Monto total division: ', monto_total_division);

            total_departamento := total_departamento + total_division;
            monto_total_departamento := monto_total_departamento + monto_total_division;
        end;
        writeln('Total horas departamento: ', total_departamento);
        writeln('Monto total departamento: ', monto_total_departamento);
        writeln('*******************')
    end;

    close(horas);    
end;

begin
    realizar_informe();
end.