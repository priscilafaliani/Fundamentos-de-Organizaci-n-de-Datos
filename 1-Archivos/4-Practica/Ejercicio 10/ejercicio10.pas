program ejercicio10;

const
    CANT_CATEGORIAS = 15;
    CODIGO_FIN = 'zzz'

type
    reg_empleado = record
        departamento : string;
        division : string;
        numero_empleado : integer;
        categoria : integer;
        cant_horas_extras : integer;
    end;

    archivo_maestro = file or reg_empleado;

    arr_valor_horas = array[1..15] of real;


procedure leer(var archivo : archivo_maestro; var registro : reg_empleado);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.departamento := CODIGO_FIN;
end;


procedure cargar_valor_horas(var valores : arr_valor_horas);
var
    horas : text;
    categoria : integer;
    valor : real;
begin
    assign(horas, 'horas.txt');
    reset(horas);

    while (not eof(horas)) do
    begin
        readln(horas, categoria, valor);
        valores[categoria] := valor;
    end;

    close(horas);
end;


procedure presentar_listado();
var
    valores_horas : arr_valor_horas;
    maestro : archivo_maestro;
    empleado : reg_empleado;
    dep_actual, div_actual : string;
    emp_actual, total_horas_emp, total_horas_div, total_horas_dep : integer;
    monto_emp, monto_div, monto_dep : real;    
begin
    assign(maestro, 'maestro');
    reset(maestro);

    cargar_valor_horas(valores_horas);
    leer(maestro, empleado);
    
    while (empleado.departamento <> CODIGO_FIN) do
    begin
        dep_actual := empleado.departamento;
        total_horas_dep := 0;
        monto_dep := 0;

        writeln('Departamento: ', dep_actual);
        while (empleado.departamento = dep_actual) do
        begin
            div_actual := empelado.division;
            total_horas_div := 0;
            monto_div := 0;

            writeln('Division: ', div_actual);
            while (empleado.departamento = dep_actual) and (empleado.division = div_actual) do
            begin
                emp_actual := empleado.numero_empleado;
                total_horas_emp := 0;
                monto_emp := 0;

                writeln('Numero empleado\tTotal de Hs\tImporte a cobrar');
                while (empleado.departamento = dep_actual) and (empleado.division = div_actual) and (empleado.numero_empleado = emp_actual) do
                begin
                    total_horas_emp := total_horas_emp + empleado.cant_horas_extras;
                    monto_emp := monto_emp + (empleado.cant_horas_extras * valores_horas[empleado.categoria]);
                    leer(maestro, empleado);
                end;

                writeln(emp_actual, '\t', total_horas_emp, '\t', monto_emp);

                total_horas_div := total_horas_div + total_horas_emp;
                monto_div := monto_div + monto_emp;
            end;

            writeln('Total de horas division: ', total_horas_div);
            writeln('Monto total por divison: ', monto_div);

            total_horas_dep := total_horas_dep + total_horas_div;
            monto_dep := monto_dep + monto_div;
        end;

        writeln('Total horas departamento: ', total_horas_dep);
        writeln('Monto total departamento: ', monto_dep);
    end;

    close(maestro);    
end;

begin
    presentar_listado();
end.