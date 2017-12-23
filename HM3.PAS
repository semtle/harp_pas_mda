program hiddenmaker3;               { hm3 by aduccini, 1993/6/5          }
var                                 { no need of extension at file name! }
ftohide,fhidden:file;               { automatically *.doc & *.hrp        }
answer:char;
chartohide,
han1,han2:byte;
fnamethd,fnamehdn:string;

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

procedure writehidhan(han1,han2:byte);
var
chosung,jungsung,lastsung:byte;

begin
 chosung:=getchosung(han1)+1;
 jungsung:=getjungsung(han1,han2)-1;
 lastsung:=getlastsung(han2)+1;

 han1:=$80 or ((chosung shl 2) or ($3 and (jungsung shr 3)));
 han2:=((jungsung shl 5) and $e0) or lastsung;

 blockwrite(fhidden,han1,1);
 blockwrite(fhidden,han2,1);
end;

{------------------------------------------------------------}

begin
 write('Enter file name to Hide (WITHOUT EXTENSION!!) :');
 readln(fnamethd);
{
 write('Enter file name to make (Enter for same):');
 readln(fnamehdn);
 if (fnamehdn='') or (fnamehdn=fnamethd) then
 begin
  writeln('WARNING!! Original file will be deleted!');
  write('enter to continue or "q" to undo.');
  readln(answer);
  if (answer='q') or (answer='Q') then halt(1);
 end;
}
 fnamehdn:=fnamethd+'.hrp';
 fnamethd:=fnamethd+'.doc';

 assign(ftohide,fnamethd);
 assign(fhidden,fnamehdn);
 reset(ftohide,1);
 rewrite(fhidden,1);

 while not eof(ftohide) do
 begin
 blockread(ftohide,chartohide,1);
 if chartohide > 128 then
 begin
   han1:=chartohide;
   blockread(ftohide,han2,1);
   writehidhan(han1,han2);
 end
 else
 blockwrite(fhidden,chartohide,1);
 end;
 close(fhidden);
 close(ftohide);
end.
