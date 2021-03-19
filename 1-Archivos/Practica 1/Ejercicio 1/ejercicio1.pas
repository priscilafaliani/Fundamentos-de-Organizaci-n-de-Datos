program ejercicio1;

type
    int_file = file of integer;

var
    filename : string;
    ints : int_file;

    n : integer;
begin
    
    { read the filename from the user }
    write('Filename: ');
    readln(filename);

    { create the connection }
    assign(ints, filename);

    { create the file }
    rewrite(ints);

    { read & write integers to the file }
    write('integer: ');
    readln(n);

    while (n <> 30000) do 
    begin
        write(ints, n);
        write('integer: ');
        readln(n);
    end;

    { close the file }
    close(ints);

    readln;
end.