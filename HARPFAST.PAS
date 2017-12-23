program harp;
uses
 graph,crt,base,phalo,hhangul,pmap;

const
 funmessage:array[1..5]of string =(
                           '_µá e i´a ”a“© ® ´ô·iŒa?',
                           '_á¢ ˆé´á¬á ¤i·¡ ´aÌa!',
                            '_»³·¡œw ¥b—i·¡ ¸iv´á!',
                           '_»¡‹qŒõ Ðe¡•¡ ¡µ  â´ö¸g´a!',
                           '_Ð“e ´å¹A »¡“e ˆéŒa?');
var
 cheat              :boolean;
 arrow,ar2          :char;
 oldmx,oldmy,i,lang,
 step,msgno         :byte;
 garb,dfdly         :integer;
 hibuly             :array[0..50] of boolean;
 f                  :text;

procedure goharp;
begin
 readln(f,oldmx,oldmy);
 mapx:=oldmx;mapy:=oldmy;
end;

procedure truebuly;
var
 bulyno:byte;
begin
 readln(f,bulyno);
 hibuly[bulyno]:=true;
end;

procedure falsebuly;
var
 bulyno:byte;
begin
 readln(f,bulyno);
 hibuly[bulyno]:=false;
end;

procedure maptileread;
var
 tilename:string;
begin
 readln(f,place);
 str(place,tilename);
 tilename:=tilename+'.hrp';
 readtile(tilename);
end;

procedure doublejump;
begin
 case direc of
      1:dec(oldmy,2);
      4:inc(oldmy,2);
      3:inc(oldmx,2);
      2:dec(oldmx,2);
 end;
end;

procedure changeharp;
begin
 if (folk=0) then folk:=1
 else if (folk=1) then folk:=0;
end;

procedure happening;
var
 iore:integer;
 no1,no2:byte;
 filename,indx,talks:string;
 comnd:char;

  procedure esccode(spcomnd:string);

    procedure setdelay;
    begin
     delete(spcomnd,1,3);
     val(spcomnd,dfdly,garb);
     dfdly:=dfdly*10;
    end;

  begin
   case spcomnd[2] of
        'l':begin
             delete(spcomnd,1,3);
             resreadput('stillres.hrp',spcomnd,1);
            end;
        'p':waitkey;
        's':begin
             cutput(spcomnd);
             delay(dfdly);
            end;
        'd':setdelay;
        'e':erasestill;
        'z':begin;
             delete(spcomnd,1,3);
             resreadput('endres.hrp',spcomnd,0);
             rippage;
            end;
   end;
  end;

begin
 rippage;
 str(place*100+lang,filename);
 filename:=filename+'.hrp';
 assign(f,filename);

 {$i-}
 reset(f);
 {$i+}
 iore:=ioresult;
 if iore<>0 then
 begin
   rippage;
   seugiln('_¯aÇaŸ³Ëa ÑÁ·©·¡ ·¡¬wÐs“¡”a!!');
   seugiln('_ÑÁ·©¡w:'+filename);
   seugiln('_ÑÂ·¥ Ò ”a¯¡ ¯©Ð—¯¡Åa º¯³¯¡µ¡.');
   seugiln('                     [@]');
   waitkey;
   quit;
 end;

 str(mapx*100+mapy,indx);
 indx:=indx+'.talk';
 find(f,indx);
 readln(f,no1,no2);
 if hibuly[no1] then
    if hibuly[no2] then
       find(f,indx+'3')
    else
       find(f,indx+'1')
 else
    if hibuly[no2] then
       find(f,indx+'2');

 repeat
  readln(f,talks);
  if talks[1]='$' then
   esccode(talks)
  else
   seugiln(talks);
 until talks='$x';
 repeat
  read(f,comnd);
  case comnd of
       'g':Goharp;
       't':Truebuly;
       'r':maptileRead;
       'f':Falsebuly;
       'd':Doublejump;
       'c':Changeharp;
  end;
 until comnd='n';
 close(f);
 erasestill;
 step:=0;
end;

procedure bookmenu;

 procedure savegame;
  var
   f:file;
   i:byte;
  begin
   seugiln('_µa‹¡µA À‚ˆiÏ¡Ÿi ¡¶‰V¯s“¡”a..');
   assign(f,'bookmark.hrp');
   rewrite(f,1);
   blockwrite(f,lang,1);
   blockwrite(f,place,1);
   blockwrite(f,mapx,1);
   blockwrite(f,mapy,1);
   blockwrite(f,folk,1);
   blockwrite(f,direc,1);
   for i:=0 to 30 do
    blockwrite(f,hibuly[i],1);
   close(f);
   beep;
   seugiln('_–A´ö¯s“¡”a.');
  end;


 procedure loadgame;
  var
   f:file;
   i:byte;
   tilename:string;
  begin
   seugiln('_À‚ˆiÏ¡Ÿi Àx‰¡ ·¶¯s“¡”a..');
   assign(f,'bookmark.hrp');
   reset(f,1);
   blockread(f,lang,1);
   blockread(f,place,1);
   blockread(f,mapx,1);
   blockread(f,mapy,1);
   blockread(f,folk,1);
   blockread(f,direc,1);
   for i:=0 to 30 do
    blockread(f,hibuly[i],1);
   close(f);

   str(place,tilename);
   tilename:=tilename+'.hrp';
   readtile(tilename);

   setvisualpage(0);
   resreadput('prepare.hrp','book2.pic',1);
   setvisualpage(1);
   delay(600);
   resreadput('prepare.hrp','book1.pic',0);
   setvisualpage(0);
   setactivepage(0);
   displaying;
   rippage;
  end;


var
keyin:char;

begin
rippage;
seugiln('_1: À‚ˆiÏ¡ ¸‹¡');
seugiln('_2: À‚ˆiÏ¡ Àx‹¡');
seugiln('_0: À‚ ”ü‹¡');
seugiln('_´á“aˆõ?');
seugiln('_”aŸe ´a¢ ‹i®A : Âá­¡');

keyin:=readkey;
rippage;
case keyin of
      '1':savegame;
      '2':loadgame;
      '0':quit;
      else begin
           beep;
           end;
      end;
step:=0;
end;

begin                          { of main   }

lang:=1;                       { This is the rest from language selection }
dfdly:=0;

mem[$0:$41a]:=mem[$0:$41c];            { Keyboard clear }

initing;
readallfont;
clearviewport;
setvisualpage(1);
{
resreadput('stillres.hrp','logo.pic',1);
delay(2000);
resreadput('stillres.hrp','logob.pic',1);
resreadput('prepare.hrp','book3.pic',0);   } { Flipping book animation } {
setvisualpage(0);
waitkey;
resreadput('prepare.hrp','book2.pic',1);
setvisualpage(1);
delay(1000);
}
resreadput('prepare.hrp','book1.pic',0);
setvisualpage(0);
setactivepage(0);

for i:=0 to 50 do hibuly[i]:=false;          { Initialization of booleans }

seugiln('_ áŸ¡ i·i ·ª·a¯¡‰V·s“¡Œa?');
seugiln('');
seugiln('_¯°´á   :N');
seugiln('_¹½´a   :”aŸe ´a¢ ‹i®A');

ar2:=upcase(readkey);
if (ar2<>'N') then
   begin                                    { Opening Demonstration }
      if ar2=#0 then ar2:=arrow;
      place:=1;
      mapx:=1;mapy:=1;
      rippage;
      happening;                            { It's only a 5 line! }
   end;

seugiln('_   .....[¸qŒe]');
cheat:=false;
place:=1;
mapx:=20;
mapy:=90;
readtile('1.hrp');

displaying;
step:=0;
msgno:=1;

repeat                                     { Here we go.. real main routine }
mem[$0:$41a]:=mem[$0:$41c];
arrow:=readkey;
if arrow =#0 then
 begin
   inc(move);
   move:=move mod 2;
   ar2:=readkey;
   case ar2 of
        #71:begin                                { Up }
             inc(step);
             oldmx:=mapx;oldmy:=mapy;        { Actually, they are NOT 'up' }
             direc:=1;                       { 'North' is right }
             dec(mapy);
            end;
        #81:begin                     { Down (south) }
             inc(step);
             oldmx:=mapx;oldmy:=mapy;
             direc:=4;
             inc(mapy);
            end;
        #79:begin                                { Left (west) }
             inc(step);
             oldmx:=mapx;oldmy:=mapy;
             direc:=2;
             dec(mapx);
            end;
        #73:begin                                { Right (east) }
             inc(step);
             oldmx:=mapx;oldmy:=mapy;
             direc:=3;
             inc(mapx);
            end;
   end;
  case maptile[mapx,mapy] of
      3,6..43:begin                            { Blocking the way? }
               case maptile[mapx,mapy] of        { And.. Chatter? }
                    3,19,32,41..43:happening;      { What's Happening? }
               end;
               if not cheat then                     { Just For Me!!!, #213 }
               begin
                mapx:=oldmx;
                mapy:=oldmy;
               end;
              end;
  end;
  displaying;
 end;
if step=5 then rippage;
if step=69 then
 begin
  seugiln(funmessage[msgno]);
  inc(msgno);if msgno=6 then msgno:=1;
  step:=0;
 end;
if arrow=#27 then bookmenu;                    { Need Pause, Phew! }
if arrow=#213 then begin beep; cheat:=not cheat; end;
until (ar2=#45) or (hibuly[50]);  { Alt-X or endgame }
if hibuly[50] then
 begin
  place:=3;
  mapx:=1;mapy:=1;
  happening;
 end;                            { This is endgame! only 3 line?! }

quit;
end.                                     { Already end???  What a game! }
