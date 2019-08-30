library lib;
uses SysUtils;
function smpl_op(f_op, s_op: Real; c_op: char): real;

begin

  try
    case (c_op) of
      '+': result := f_op + s_op;
      '-': result := f_op - s_op;
      '*': result := f_op * s_op;
      '/': result := f_op / s_op;
      '^': if (f_op = 0) and (s_op = 0) then
          result := 1
        else if f_op = 0 then
          result := 0
            //else if (Trunc(s_op) = s_op)and(s_op<0) then result:=1/(exp( (-s_op)*ln(f_op)))
        else
          result := exp(s_op * ln(f_op));
      //x^y(x ? ??????? y)=exp(y*ln(x))
    end;
  except writeln;
  end;

end;

function readfile(s: string): string;
var
  i: Integer;
  c: string;
  fle: TextFile;
begin

  AssignFile(fle, s);
  Reset(fle);
  result := '';
  while not Eof(fle) do
  begin
    readln(fle, c);
    if c <> '' then
      Result := Result + c + ';';
  end;
  closefile(fle);
  AssignFile(Input, '');
end;

function hrd_op(ops: string; c_op: char): real;
const
  puls = Ord('a') - 1;
var op:Real;
begin
  Randomize;
  if ops = 'n' then begin
  case (Ord(c_op) - puls) of
  3: Result := Pi;
  6: result:=Random;
  else
  Result := Ln(-1);
  end;
  exit;
  end;
  op:=strtofloat(ops);
  case (Ord(c_op) - puls) of
    1: Result := Sin(op);
    2: Result := cos(op);

    4: Result := Sin(op)/cos(op);
    5: Result := Cos(op)/Sin(op);
    6: if Trunc(op)=op then result:=Random(Trunc(op));
    7: Result := Sqrt(op);
    8: Result := Ln(op);
    9: Result := Exp(op);
  else
    Result :=Ln(-1);
  end;

end;
exports smpl_op, readfile, hrd_op;
end.

