program sapper;

uses sounds,graphabc,events;

const
  n=16;   {9*9 - 10;}
  bq=40;   {16*16 - 40}
  size=25;
  
var
  i,j,d,c:integer;
  f:array[-1..n+1,-1..n+1]of record
                               s:-1..8;
                               o,c:boolean;
                             end;

procedure checkwin;
  var b:boolean;
begin
  b:=true;
  for i:=1 to n do
    for j:=1 to n do
    begin
      if (f[i,j].s>-1)and not f[i,j].o then b:=false;
      if (f[i,j].s=-1)and not f[i,j].c then b:=false;
    end;
  if b then
  begin
    setfontcolor(clred);
    textout((size*n) div 4,(size*n) div 3,'You have won!');
    d:=loadsound('Xylophone.wav');
    playsound(d);
    sleep(1000);
    destroysound(d);
    halt;
  end;
end;
                       
procedure ocec;                          {opening connected empty cells}
  var k:integer;
begin
  for k:=1 to n*n div 2 do
    for i:=1 to n do
      for j:=1 to n do
        if (f[i,j].s>-1)AND
          (
           ( (f[i+1,j].s=0)and f[i+1,j].o )or
           ( (f[i-1,j].s=0)and f[i-1,j].o )or
           ( (f[i,j+1].s=0)and f[i,j+1].o )or
           ( (f[i,j-1].s=0)and f[i,j-1].o )or
           ( (f[i+1,j+1].s=0)and f[i+1,j+1].o )or
           ( (f[i+1,j-1].s=0)and f[i+1,j-1].o )or
           ( (f[i-1,j+1].s=0)and f[i-1,j+1].o )or
           ( (f[i-1,j-1].s=0)and f[i-1,j-1].o )
          )   then
          begin
            f[i,j].o:=true;
            floodfill(j*size-1,i*size-1,clwhite);
            if f[i,j].s>0 then textout(j*size-2*size div 3,(i-1)*size+1,inttostr(f[i,j].s));
            if f[i,j].c then
            with f[i,j] do
              begin
                setpencolor(clwhite);
                c:=false;
                line((j-1)*size+2,(i-1)*size+2,j*size-2,i*size-2);
                line((j-1)*size+2,i*size-2,j*size-2,(i-1)*size+2);
              end;
          end;
end;

procedure press(x,y,z:integer);
begin
  for i:=1 to n do
    for j:=1 to n do
      if ((j-1)*size<x)and(x<j*size) and ((i-1)*size<y)and(y<i*size) then
        with f[i,j] do
          begin
            if z=1 then
            begin
              o:=true;
              floodfill(j*size-1,i*size-1,clwhite);
              d:=loadsound('letter.wav');
              playsound(d);
              
              if s=-1 then     {bomb}
              begin
                sleep(100);
                destroysound(d);
                d:=loadsound('expl.wav');
                playsound(d);
                floodfill(j*size-1,i*size-1,clred);
                for i:=1 to n do
                  for j:=1 to n do
                    if f[i,j].s=-1 then floodfill(j*size-1,i*size-1,cldkgray);
                sleep(1500);
                destroysound(d);
                halt;
              end
                else
                begin
                  if s>0 then textout(j*size-2*size div 3,(i-1)*size+1,inttostr(s));  {number}
                  if s=0 then ocec;    {empty}
                  sleep(100);
                  destroysound(d);
                end;
            end;

            if (z=2)and o then
            begin
               d:=loadsound('Neg.wav');
               playsound(d);
               sleep(500);
               destroysound(d);
            end;
            if (z=2)and not o then                     {cross}
            begin
              if c then
              begin
                setpencolor(clskyblue);                 {-}
                c:=false;
              end
                else
                begin
                  setpencolor(clred);                   {+}
                  c:=true;
                end;
              line((j-1)*size+2,(i-1)*size+2,j*size-2,i*size-2);
              line((j-1)*size+2,i*size-2,j*size-2,(i-1)*size+2);
            end;

            break;
          end;
  checkwin;
end;
                       
begin
  while c<>bq do              {putting bombs}
    for i:=1 to n do
      for j:=1 to n do
        if (random(100)=0)and(c<bq) then
        begin
          f[i,j].s:=-1;
          c:=c+1;
        end;
  
  for i:=1 to n do                    {putting numbers}
    for j:=1 to n do
      if f[i,j].s<>-1 then
      begin
        c:=0;
        if f[i+1,j].s=-1 then c:=c+1;
        if f[i-1,j].s=-1 then c:=c+1;
        if f[i,j+1].s=-1 then c:=c+1;
        if f[i,j-1].s=-1 then c:=c+1;
        if f[i+1,j+1].s=-1 then c:=c+1;
        if f[i+1,j-1].s=-1 then c:=c+1;
        if f[i-1,j+1].s=-1 then c:=c+1;
        if f[i-1,j-1].s=-1 then c:=c+1;
        f[i,j].s:=c;
      end;
  
  setwindowsize(size*n,size*n);          {field}
  setwindowtitle('Saper');
  setfontsize(size-10);
  clearwindow(clskyblue);
  for i:=1 to n do
  begin
    line(0,i*size,size*n,i*size);
    line(i*size,0,i*size,n*size);
  end;
  setpenwidth(2);

  onmousedown:=press;
end.
