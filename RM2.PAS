program resourcemaker;
 type
  resourcetype = record
                  name:string[20];
                  size:word;
                  contptr:pointer;
                 end;

 var
  resource              :array [1..10] of resourcetype;
  filetoread,filetowrite:file;
  number,i              :byte;
  resoname,picname      :string[20];
  garbage               :array [1..10] of byte;

 begin
  writeln('�e�w�a�A�a, �e�s�s���a. �a������ �e�i�������a.');
  write('�a������ ���q���� �ẁ�A�a.(Enter resource name:)');
  readln(resoname);
  assign(filetowrite,resoname);
  rewrite(filetowrite,1);
  write('���A ���i �a�� �����e�a?(Enter file number to add:)');
  readln(number);
  write('�a �a��..');
  for i:=1 to number do
   begin
    write(i,'�弁 �a������ ���q�e�a? (File name',i,'?) ');
    readln(resource[i].name);
    assign(filetoread,resource[i].name);
    reset(filetoread,1);
    with resource[i] do
         begin
           size:=filesize(filetoread)-10;
           getmem(contptr,size);
           blockread(filetoread,garbage,10);
           blockread(filetoread,contptr^,size);

           blockwrite(filetowrite,name,20);
           blockwrite(filetowrite,size,2);
           blockwrite(filetowrite,contptr^,size);
         end;
   close(filetoread);
   end;
  close(filetowrite);
  writeln('�A, �a �A���s���a!! (Done!!)');
  end.
