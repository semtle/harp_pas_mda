program mapmaker;
uses crt;                     {  Map tile file maker  v0.9     }
const                         {     programmed by aduccini     }
_up  = #72;                   {                  1992-7-30     }
_dn  = #80;                   {   This runs in text mode.      }
_ri  = #77;
_lf  = #75;
_f1  = #59;
_f2  = #60;
_f3  = #61;
_f10 = #68;

var
map: array [1..100,1..100] of byte;
mx,my,                     {100*100    real coordination of Map     }
sx,sy,                     {20*20      map coord. of current Screen }
cx,cy,                     {50*..25?   real Coord. of screen        }
px,py,                     {5*5        current Plane                }
defaultno:byte;
keyin,key2:char;

function value(digi:string):byte;
var
 a,code:integer;
begin
 val(digi,a,code);
 value:=a;
end;

procedure clearing;
var
 i,j:byte;
begin
clrscr;
for i:=1 to 100 do
 for j:=1 to 100 do
  map[i,j]:=1;
mx:=1;my:=1;
sx:=1;sy:=1;
cx:=1;cy:=1;
px:=1;py:=1;
defaultno:=1;
for i:=1 to 20  do
 begin
 for j:=1 to 20 do
  write(' 1 ');
 writeln;
 end;
gotoxy(70,3);write('X :  1');
gotoxy(70,5);write('Y :  1');
gotoxy(70,9);write('Fl: 0');
gotoxy(1,1);
end;

procedure changeplane;
var
 i,j:byte;
begin
 gotoxy(1,1);
 for i:=1 to 20 do
  begin
   for j:=1 to 20 do
     write(map[(px-1)*20+j,(py-1)*20+i]:2,' ');
   writeln;
  end;
end;

procedure upproc;
begin
 dec(my);
 if my<=0 then my:=1;
 sy:=my-(py-1)*20;
 if sy<=0 then begin
                 sy:=20;
                 dec(py);
                 changeplane;
               end;
 cy:=sy;
 gotoxy(70,5);write('Y :',my:3);
 gotoxy(cx,cy);
end;

procedure dnproc;
begin
 inc(my);
 if my>=101 then my:=100;
 sy:=my-(py-1)*20;
 if sy>=21 then begin
                 sy:=1;
                 inc(py);
                 changeplane;
                end;
 cy:=sy;
 gotoxy(70,5);write('Y :',my:3);
 gotoxy(cx,cy);
end;

procedure lfproc;
begin
 dec(mx);
 if mx<=0 then mx:=1;
 sx:=mx-(px-1)*20;
 if sx<=0 then begin
                sx:=20;
                dec(px);
                changeplane;
               end;
 cx:=(sx-1)*3+1;
 gotoxy(70,3);write('X :',mx:3);
 gotoxy(cx,cy);
end;

procedure riproc;
begin
 inc(mx);
 if mx>=101 then mx:=100;
 sx:=mx-(px-1)*20;
 if sx>=21 then begin
                 sx:=1;
                 inc(px);
                 changeplane;
                end;
 cx:=(sx-1)*3+1;
 gotoxy(70,3);write('X :',mx:3);
 gotoxy(cx,cy);
end;

procedure setfont;
begin
 gotoxy(1,23);
 write('Default Tile Number(current:',defaultno:2,')? ');
 readln(defaultno);
 gotoxy(1,23);
 write('                                          ');
 gotoxy(70,9);write('Fl:',defaultno:2);
 gotoxy(cx,cy);
end;

procedure fillhori;
var
baseno,savecx,a:byte;
begin
 a:=mx;
 baseno:=map[a,my];savecx:=cx;
 repeat
  map[a,my]:=defaultno;gotoxy(cx,cy);write(defaultno:2);
  inc(a);inc(cx,3);
 until (map[a,my]<>baseno) or (cx>60);
 cx:=savecx;
 gotoxy(cx,cy);
end;

procedure fillvrti;
var
baseno,savecy,a:byte;
begin
 a:=my;
 baseno:=map[mx,a];savecy:=cy;
 repeat
  map[mx,a]:=defaultno;gotoxy(cx,cy);write(defaultno:2);
  inc(a);inc(cy);
 until (map[mx,a]<>baseno) or (cy>20);
 cy:=savecy;
 gotoxy(cx,cy);
end;

procedure saving;
var
 f:file;
 fname:string;
 i,j:byte;
begin
 gotoxy(1,23);
 write('Map saving file name (Enter for cancel) ? ');
 readln(fname);
 if fname<>'' then
 begin
  assign(f,fname);
  {$i-}
  rewrite(f,1);
  {$i+}
  if ioresult=0 then
   begin
    for j:=1 to 100 do
    for i:=1 to 100 do
    blockwrite(f,map[i,j],1);
    close(f);
   end
  else
   begin
    gotoxy(1,23);
    write('»¡•¡ ¸á¸w•¡º—µA µAœáˆa v·s“¡”a!!         ');
    delay(2000);
   end;
  end;
  gotoxy(1,23);
  write('                                                       ');
  gotoxy(cx,cy);
end;

procedure loading;
var
 f:file;
 fname:string;
 i,j:byte;
begin
 gotoxy(1,23);
 write('Map loaing file name (Enter for cancel) ? ');
 readln(fname);
 if fname<>'' then
 begin
  assign(f,fname);
  {$i-}
  reset(f,1);
  {$i+}
  if ioresult=0 then
   begin
    for j:=1 to 100 do
    for i:=1 to 100 do
    blockread(f,map[i,j],1);
    close(f);
   end
  else
   begin
   gotoxy(1,23);
   write('»¡•¡ ¦‰œáµ¡‹¡ •¡º—µA µAœáˆa!!         ');
   delay(2000);
   end;
 end;
 gotoxy(1,23);
 write('                                                       ');
 gotoxy(1,1);
 mx:=1;my:=1;
 sx:=1;sy:=1;
 cx:=1;cy:=1;
 px:=1;py:=1;
 for i:=1 to 20  do
  begin
  for j:=1 to 20 do
   write(map[j,i]:2,' ');
  writeln;
  end;
 gotoxy(1,1);
end;


begin
clearing;
repeat
keyin:=readkey;
if (keyin >= '0') and (keyin <= '9') then
    begin
      write('   ');
      gotoxy(cx,cy);
      write(keyin);
      key2:=readkey;
      case key2 of
           '0'..'9':begin
                      write(key2);
                      map[mx,my]:=value(keyin)*10+value(key2);
                    end;
           else
                    begin
                     map[mx,my]:=value(keyin);
                     keyin:=key2;
                    end;
      end;
    end;
    case keyin of
         #0:begin
              keyin:=readkey;
              case keyin of
                   _up:upproc;
                   _dn:dnproc;
                   _lf:lfproc;
                   _ri:riproc;
                   _f1:setfont;
                   _f2:saving;
                   _f3:loading;
              end;
             end;
         's':fillhori;
         'z':fillvrti;
         'n':clearing;
    end;
until keyin=_f10 ;
clrscr;
writeln('(sangyong johap)µA´á¢·i µi‰¡ aˆe ®…ˆe..');
writeln;
end.


