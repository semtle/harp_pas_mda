unit hhangul;              {   TurboPascal Hangul unit hidden ver 1.0  }
                           {  *only for hidden Harp.  1993/5/4   7:12p }
interface                  {   Use this unit with unit pMap.  She has  }
                           {  a routine that reads fonts.              }
uses                       {  If string starts with '_', hidden is off.}
  crt,graph,base;

const
  CR=$0d;
  LF=$0a;
  TAB=384;           {  384,30    --    656,286  }
  Iniy=30;           {   x  (line):17    ,     y (column):16 }
  Hanfsize=36;
  ascfsize=20;
  hanfno=66;
  ascfno=96;

var
  hanfont:array [1..66] of pointer;
  ascfont:array [1..96] of pointer;
  gulx,guly:word;
  hidden:boolean;
  codeadd:byte;


procedure seugi(gul:string);
procedure rippage;
procedure seugiln(gul:string);

implementation


procedure seugi(gul:string);

var
  loop,nat1,nat2:byte;

 procedure hanput(han1,han2:byte);
 var
   chosung,jungsung,lastsung,adding:byte;
 const
   jungsungcode:array [3..29] of byte=(20,21,22,23,24,0,0,25,26,27,28,29,30,
                                     0,0,31,32,33,34,35,36,0,0,37,38,39,40);
   lastsungcode:array [2..29] of byte=(41,42,43,44,45,46,47,48,49,50,51,0,52,
                                53,54,55,0,56,57,58,59,60,61,62,63,64,65,66);

 function getchosung(hanfront:byte):byte;
  begin
    getchosung:=(hanfront and $7c) shr 2;
  end;

 function getjungsung(hanfront,hanback:byte):byte;
  begin
    getjungsung:=((hanfront and $3) shl 3) or ((hanback and$e0) shr 5);
  end;

 function getlastsung(hanback:byte):byte;
  begin
    getlastsung:=hanback and $1f;
  end;

 begin
   if hidden then codeadd:=1 else codeadd:=0;
   chosung:=getchosung(han1)-codeadd;
   jungsung:=getjungsung(han1,han2)+codeadd;
   lastsung:=getlastsung(han2)-codeadd;
   adding:=0;
   case jungsung of
        13,19,20,26,27:adding:=1;
   end;
   if chosung<>1 then
      putimage(gulx+adding,guly,hanfont[chosung-1]^,andput);
   if jungsung<>2 then
      putimage(gulx,guly,hanfont[jungsungcode[jungsung]]^,andput);
   if lastsung<>1 then
      putimage(gulx,guly,hanfont[lastsungcode[lastsung]]^,andput);
 end;

 procedure ascput(asc:byte);
 begin
        putimage(gulx,guly,ascfont[asc-31]^,andput);
 end;

begin
  loop:=1;
  while loop<=ord(gul[0]) do
   begin
     nat1:=ord(gul[loop]);
     if nat1>128 then
       begin
         nat2:=ord(gul[loop+1]);
         hanput(nat1,nat2);
         inc(loop,2);
         inc(gulx,16);
       end
     else
       begin
         ascput(nat1);
         inc(loop);
         inc(gulx,8);
       end;
   end;
end;

procedure rippage;
 begin
   setcolor(1);
   bar(384,30,656,286);
   gulx:=tab;
   guly:=iniy;
 end;

procedure seugiln(gul:string);
 begin
   if gul[1]='_' then hidden:=false else hidden:=true;
   seugi(gul);
   gulx:=tab;
   inc(guly,16);
   if guly>255 then
       begin
        seugi('... [@]');
        waitkey;
        rippage;
       end;
 end;

begin
  gulx:=tab;
  guly:=iniy;
  if false then write('Copyright owner : Aduccini'); { copyright check }
end.
