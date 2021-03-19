program ejercicio1;

type
    int_file = file of integer;

var
    filepath : string;
    ints : int_file;

    less_than_1500 : integer;
    average : integer;

    actual_int : integer;
begin

    { get the filepath from the user }
    write('filepath: ');
    readln(filepath);

    { create the connection }
    assign(ints, filepath);

    { open the file}
    reset(ints);

    { data processing }
    less_than_1500 := 0;
    average := 0;

    write('numbers in the file: ');
    while (not eof(ints)) do
    begin
        read(ints, actual_int);

        writeln(actual_int, ' ');

        if (actual_int < 1500) then
            less_than_1500 := less_than_1500 + 1;

        average := average + actual_int;
    end;

    writeln('amount of integers that were less than 1500: ', less_than_1500);
    writeln('average of all the integers: ', average / filesize(ints));
    
    readln;
end.