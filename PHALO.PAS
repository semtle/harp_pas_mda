unit phalo;
interface
uses
  graph,crt,base;

procedure initing;
procedure resreadput(resfname:string;picname:string;page:byte);
procedure cutput(cutindx:string);
procedure erasestill;

implementation

procedure initing;
var
  gd,gm,gr:integer;
begin
  gd:=hercmono;gm:=0;
  initgraph(gd,gm,'');

  gr:=graphresult;
  if gr<>0 then
  begin
    writeln(grapherrormsg(gr));
    halt(0);
  end;
end;

procedure resreadput(resfname:string;picname:string;page:byte);

var
  picbfr,bfrbackup:pointer;
  resfile:file;
  flag,subflag:byte;
  size,indx,segm,ofst:word;
  indxname:string[20];

procedure picpinc(var pntr:pointer;qnty:byte);
begin
 pinc(pntr,qnty);
 inc(indx,qnty);   {for easy check}
end;

begin
  ofst:=0;flag:=$01;indx:=0;
  if page = 0 then segm:=$b000 else segm:=$b800;

  assign(resfile,resfname);
  {i-}
  reset(resfile,1);
  repeat
   blockread(resfile,indxname,20);
   blockread(resfile,size,2);
   if indxname<>picname then
    seek(resfile,filepos(resfile)+size);
  until indxname=picname;
  getmem(picbfr,size);
  blockread(resfile,picbfr^,size);
  close(resfile);
  {i+}

  bfrbackup:=picbfr;
  {picpinc(bfrbackup,10);}
  repeat
    flag:=byte(bfrbackup^);
    picpinc(bfrbackup,1);

    if flag=$80 then
    begin
      if (indx mod 2)=1 then picpinc(bfrbackup,1);
    end
    else
    if flag<128 then
    begin
      subflag:=flag;
      while subflag>0 do
      begin
        mem[segm:ofst]:=byte(bfrbackup^);
        inc(ofst);picpinc(bfrbackup,1);dec(subflag);
      end;
    end
    else
    begin
      subflag:=flag-128;
      while subflag>0 do
      begin
        mem[segm:ofst]:=byte(bfrbackup^);
        inc(ofst);dec(subflag);
      end;
      picpinc(bfrbackup,1);
    end;        {of if}
  until flag=0;

freemem(picbfr,size);

end;            {of proc.}

procedure cutput(cutindx:string);
var
 code:string[20];
 x,y:byte;
 garb:integer;
 trans:pointer;
begin
 delete(cutindx,1,3);      { '$s 23' -> '23'   (example of 2 and 3..)   }

 code:=cutindx;
 delete(code,2,1);         { '23' -> '2' }
 val(code,x,garb);         { returning x index of cutpic }

 code:=cutindx;
 delete(code,1,1);         { '23' -> '3' }
 val(code,y,garb);         { returning y indx of cutpic  }

 setactivepage(1);
 getmem(trans,4);
 getimage(240*(x-1),87*(y-1),240*x-1,87*y-1,trans^);
 setactivepage(0);
 putimage(70,200,trans^,copyput);
 freemem(trans,4);
end;

procedure erasestill;
begin
 bar(71,201,308,285);
end;
begin
 if false then write('Copyright owner : Aduccini'); { copyright check }
end.
