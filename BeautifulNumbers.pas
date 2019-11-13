var
  N, W: string;
  firstDigitChar: char;
  digitsCount, firstDigit, i: integer;
  A, B, C, beautifulDigitsCount: integer;
  
begin
  readln(N);

  digitsCount := Length(N);
  A := (digitsCount - 1) * 9;
  
  firstDigitChar := N[1];
  firstDigit := ord(firstDigitChar) - ord('0');
  B := firstDigit - 1;

  W := '';
  for i := 1 to digitsCount do
    W := W + firstDigitChar;
    
  if N >= W
    then C := 1
    else C := 0;

  beautifulDigitsCount := A + B + C;
  writeln(beautifulDigitsCount);
end.
