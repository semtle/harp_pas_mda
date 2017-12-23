program vgatest;
uses
 vgraph2;

procedure main;

var
 f:file;
 no:string[10];
 i,j:byte;
 map:array [0..99,0..99] of byte;

begin
writeln('Map no.?');
readln(no);
no:=no+'.hrp';
assign(f,no);
reset(f,100);
blockread(f,map,100);
close(f);

set256mode;
for j:=0 to 99 do
 for i:=0 to 99 do
  bar(j*2,i*2,j*2+2,i*2+2,map[i,j]);

  {screen^[i,j]:=map[i,j];}
readln;
settextmode;
end;
begin
main;
end.
