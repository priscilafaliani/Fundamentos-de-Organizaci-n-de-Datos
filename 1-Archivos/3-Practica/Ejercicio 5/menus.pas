unit menus;

interface

procedure show_initial_menu();

implementation

procedure show_initial_menu();
begin

    writeln('----- CHOOSE AN OPTION -----');
    writeln;
    writeln('1. Create phones data file');
    writeln('2. Show phones where the current stock is less than the min stock');
    writeln('3. Show phones with a description');
    writeln('4. Export');
    writeln;
    writeln('----------------------------');
end;

end.