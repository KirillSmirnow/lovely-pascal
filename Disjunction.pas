var
  i, j, k, N, X, q, answerN: integer;
  suit: boolean;
  Xbin, qbin: array[1..50] of integer;
  answers: array[1..100000] of integer;

function decToBin(dec: integer): array[1..50] of integer;
var
  i: integer;
  result: array[1..50] of integer;
begin
  i := 1;
  while dec > 0 do
  begin
    result[i] := dec mod 2;
    dec := dec div 2;
    i := i + 1;
  end;
  decToBin := result;
end;
  
begin
  readln(N, X);
  Xbin := decToBin(X);
  
  for i := 1 to N do
  begin
    readln(q);
    qbin := decToBin(q);
    suit := true;
    for j:= 1 to 50 do
      if (Xbin[j] = 0) and (qbin[j] = 1) then suit := false;
      
    if suit then
    begin
      answerN := answerN + 1;
      answers[answerN] := q;
    end;
  end;
  
  if answerN = 0 then writeln(-1)
  else begin
    k := answers[1];
    for j := 2 to answerN do
      k := k or answers[j];
    if k <> X then writeln(-1)
    else begin
      for j := 1 to answerN do
        write(answers[j], ' ');
      writeln;
    end;
  end;
end.
