unit pmap;

interface
uses graph,crt,phalo,hhangul,base;

type
  sprite=array [0..1] of pointer;

var
  maptile:array[1..100,1..100] of byte;
  mapfont:array [1..43] of sprite;
  harpfont:array [0..1,1..4,0..1] of sprite;
  place,mapx,mapy,folk,direc,move:byte;

procedure readallfont;
procedure readtile(tilefname:string);
procedure putsprite(x,y:word;fonts:sprite);
procedure displaying;

implementation

procedure readallfont;

var
  x,y,loop,drc,indx,folk:word;

begin
  resreadput('prepare.hrp','font.pic',1);
  x:=0;y:=0;
  setactivepage(1);

  for loop:=1 to 66 do                        { Hangul font reading...}
  begin
    getmem(hanfont[loop],36);
    getimage(x,y,x+15,y+15,hanfont[loop]^);
    inc(x,16);
    if x>=720 then begin
                     x:=0;
                     inc(y,16);
                   end;
  end;

  for loop:=1 to 96 do                        { Ascii font reading...}
  begin
  getmem(ascfont[loop],20);
  getimage(x,y,x+7,y+15,ascfont[loop]^);
  inc(x,8);
  if x>=720 then begin
                   x:=0;
                   inc(y,16);
                 end;
  end;

  x:=0;inc(y,16);

  for indx:=0 to 1 do                         { Map font reading...}
  for loop:=1 to 43 do
  begin
    getmem(mapfont[loop,indx],196);
    getimage(x,y,x+31,y+47,mapfont[loop,indx]^);
    inc(x,32);
    if x>=704 then begin
                     x:=0;
                     inc(y,48);
                   end;
    end;

    for folk:=0 to 1 do
    for indx:=0 to 1 do
    for drc:=1 to 4 do                       { Harp font reading...}
    for loop:=0 to 1 do
    begin
      getmem(harpfont[folk,drc,loop,indx],196);
      getimage(x,y,x+31,y+47,harpfont[folk,drc,loop,indx]^);
      inc(x,32);
      if x>=704 then begin
                       x:=0;
                       inc(y,48);
                     end;
    end;
  end;

procedure readtile(tilefname:string);

var
  f:file;
  tempmap:array[1..100,1..100]of byte;
  x,y:byte;
begin
  assign(f,tilefname);
  reset(f,100);
  if ioresult<>0 then         { read maptile file error }
   begin
    seugiln('_»¡•¡ Èa·© ·ª‹¡ µAœá, ÑÁ·©·¡Ÿq:');
    seugiln(tilefname);
    quit;
   end;
   blockread(f,tempmap,100);
  close(f);
  for y:=1 to 100 do
   for x:=1 to 100 do
    maptile[x,y]:=tempmap[y,x];
end;

procedure putsprite(x,y:word;fonts:sprite);
begin
  putimage(x,y,fonts[1]^,andput);
  putimage(x,y,fonts[0]^,orput);
end;

procedure displaying;

const
  UX=16;
  UY=8;

var
  x,y:shortint;
  ax,ay,ix,iy:word;
  trans      :pointer;

begin
  setactivepage(1);
  setcolor(0);
  bar(96,0,320,144);
  ix:=96;iy:=0;
  getmem(trans,4036);
  for y:=-3 to 3 do begin
  for x:=3 downto -3 do
  begin
    ax:=ix+(x+3)*ux;
    ay:=iy+(-x+3)*uy;
    putsprite(ax,ay,mapfont[maptile[mapx+x,mapy+y]]);
    if (x=0) and (y=0) then putsprite(ax,ay,harpfont[folk,direc,move]);
  end;
  inc(ix,ux);
  inc(iy,uy);
  end;
  getimage(96,0,320,144,trans^);
  setactivepage(0);
  putimage(80,25,trans^,copyput);
  freemem(trans,4036);
end;

begin
  folk:=0; direc:=2; move:=1;    { Harp is Butterfly, facing west }
end.
