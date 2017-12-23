unit base;

interface

uses crt;

procedure find(var f:text;cont:string);
procedure pinc(var pntr:pointer;qnty:byte);
procedure waitkey;
procedure quit;
procedure beep;

implementation

uses graph,hhangul;

procedure find(var f:text;cont:string);
var
 intext:string;
begin
 repeat
  readln(f,intext);
 until (intext=cont) or (eof(f));
 if intext<>cont then
  begin
   seugiln('_À‚¸w·¡ ¿¸´á¹v¯s“¡”a!');
   seugiln('_À‚ '+cont+'½¢·¡ ´ô¯s“¡”a!');
   close(f);
   quit;
  end;
end;

procedure pinc(var pntr:pointer;qnty:byte);
var pseg,pofs:word;
begin
 pseg:=seg(pntr^);
 pofs:=ofs(pntr^);
 inc(pofs,qnty);
 pntr:=ptr(pseg,pofs);
end;

procedure waitkey;
var
 garb:char;
begin
 mem[$0:$41a]:=mem[$0:$41c];
 garb:=#1;
 while (garb<>#32) and (garb<>#13) do
  garb:=readkey;
end;

procedure quit;
begin
seugiln('_•¡¯a¡ aˆa‰V¯s“¡”a.. [@]');
waitkey;
restorecrtmode;
writeln('Written by Aduccini, copyright reversed.(?)');
halt(0);
end;

procedure beep;
begin
  sound(400);
  delay(10);
  sound(340);
  delay(25);
  nosound;
end;

begin
 if false then write('iniccudA : renwo thgirypoC');  { copyright check }
end.
