program InerCode;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  lp = '>>>';
  n = 30;
  h_c_op = 9;
  filename = 'per.txt';
  hard = 'hfun.txt';
  sl1 = 'lib.dll';
  puls = ord('a') - 1;
function smpl_op(f_op, s_op: Real; c_op: char): real; external sl1;
function readfile(s: string): string; external sl1;
function hrd_op(ops: string; c_op: char): real; external sl1;

type
  tvar = record
    name: string;
    data: real;
  end;
  h_op = record
    name: string;
  end;
var
  //
  fle: textfile;
  h_op_ar: array[1..h_c_op] of h_op;
  sofv: Byte = 0;
  ind: byte;
  tvr: array[0..n] of tvar;
  sz: string = ';)(+-*/^';
  i, j: Integer;
  iner: Boolean = False;
  oorv: Boolean = True;
  per: array of array of Byte;
  r, l: Byte;
  sti: array[0..n] of Real;
  si: Byte = 0;
  sto: array[0..n] of char;
  so: Byte = 1;
  sper: string = '';
  smain: string;
  res: Real;
  bs: set of Char = ['a'..'z'];
  //sk:set of char = ['(',')'];
  nb: set of Char = [',', 'a'..'z', '0'..'9'];
  al: set of Char = ['+', '-', '*', '/', '^', '0'..'9', ' ', ';', ',', '(', ')',
    'a'..'z' {,'\'}];
  newvar: string = '';
  z: set of Char = ['+', '-', '*', '/', '^', ';', ')'];
  sc: byte = 0;
  hop: string;
begin
  Assignfile(Input, filename);
  Reset(Input);
  readln(r, l);
  SetLength(per, r, l);
  for i := 0 to r - 1 do
    for j := 0 to l - 1 do
      if j <> l - 1 then
        read(per[i, j])
      else
        readln(per[i, j]);
  closefile(input);
  AssignFile(Input, '');
  // ; ) ( ^ + - * /
  //^^^^^^^^^^operatinon jamp array/////////////
  Assignfile(fle, hard);
  Reset(fle);
  for i := 1 to h_c_op do
    Readln(fle, h_op_ar[i].name);
  closefile(fle);
  AssignFile(fle, '');
  // ; ) ( ^ + - * /
  //^^^^^^^^^^^^^^^^^^hard function array
  randomize;
  Writeln('InerCode 0.9.1', #10, 'Print "help" and nothing will happen');
  //write(lp);
  //Readln(smain);
  sto[0] := ';';
  smain := ';';
  hop := '';
  while smain <> '' do
  begin

    ///////////////////////////////////
    i := 0;
    while i<(Length(smain)) do
    begin

      inc(i);
      /////////////////////////////
      if smain = 'vis;' then
      begin
        for j := 0 to Length(sti) - 1 do
          write(sti[j]: 2: 0);
        Writeln;
        break;
      end;
      /////////////////////////////
                        case smain[i] of
                          '.': smain[i] := ',';
                          ' ': Continue;
                          '(':
                            begin
                              sc := 0;
                              if sper = '' then
                              begin
                                sto[so] := smain[i];
                                inc(so);
                                inc(sc);
                              end
                              else
                                for j := 1 to h_c_op do
                                  if h_op_ar[j].name = sper then
                                  begin
                                    sto[so] := char(j + puls);
                                    inc(so);
                                    sto[so] := smain[i];
                                    inc(so);
                                    inc(sc);
                                    sper := '';
                                    Break;
                                  end;
                              if sc = 0 then
                              begin
                                Writeln('Mystery Function');
                                Break;
                              end;
                              Continue;
                            end;
                          '=': if sper[1] in bs then
                            begin
                              sc := 1;
                              for j := 1 to sofv do
                                if sper = tvr[j].name then
                                begin
                                  newvar := tvr[j].name;
                                  ind := j;
                                  sc := 0;
                                  Break;
                                end;
                              if sc = 1 then
                              begin
                                Inc(sofv);
                                ind := 0;
                                tvr[ind].name := sper;
                                newvar := sper;
                              end;
                              oorv := false;
                              sper := '';
                              continue;
                            end;

                        end;
      if not (smain[i] in al) then
      begin
        Writeln(smain);
        writeln('^': i);
        Writeln('invalid syntaxis');
        sper := '';
        Break;
      end;
      if smain[i] in nb then
      begin
        sper := sper + smain[i];
        Continue;
      end;
            if (sto[so - 1] = ')') then
            begin
              Dec(so, 2);
              if not (sto[so - 1] in z) then
              begin
                //function \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                try
                  if hop = '' then
                    hop := floattostr(sti[si - 1]);
                  sti[si - 1] := hrd_op(hop, sto[so - 1]);
                  Dec(so);
                  hop := '';
                except writeln('#', random(100), ' Function error');
                  break;
                end;
              end;
//               else begin writeln('#', random(100), ' Void brackets error');
//                  break; end;
            end
                else if (sper = '') then
                  case smain[i] of
                    '-': case sto[so - 1] of
                        '(', ';', '=': sper := '0';
                      else
                        begin
                          writeln('#01 operation error (-)');
                          break;
                        end;
                      end;
                    '+': case sto[so - 1] of
                        '(', ';', '=': sper := '0';
                      else
                        begin
                          writeln('#01b operation error (+)');
                          break;
                        end;
                      end;
                    ';': if si = 0 then
                    begin
                        newvar := '';
                        sper := '';
                        oorv := True;
                        iner := true;
                        si := 0;
                        so := 1;

                        continue;

                        end;
                    ')': if not (sto[so - 2] in z) then
                    begin
                        hop := 'n';
                        inc(si);
                        end;
                  else
                    begin
                      begin
                        Writeln(smain, #10, '^': i, #10, 'invalid syntaxis(neponatno)');
                        break;
                      end;
                    end;
                  end;
      try
        if sper <> '' then
        begin
          sti[si] := StrToFloat(sper);
          Inc(si);
        end;
      except
        if sper[1] in bs then
        begin
          sc := 1;
          for j := 1 to sofv do
            if sper = tvr[j].name then
            begin
              sti[si] := tvr[j].data;
              Inc(si);
              sc := 0;
              Break;
            end;
          if sc = 1 then
          begin
            Writeln('invalid syntaxis in number(notfind)');
            Break;
          end;
        end
        else
        begin
          Writeln('invalid syntaxis in number(transp)');
          Break;
        end;

      end;
      sper := '';

      case per[Pos(sto[so - 1], sz) - 1, Pos(smain[i], sz) - 1] of
        1:
          begin
            sto[so] := smain[i];
            Inc(so);
          end;

        2:
          begin
            Dec(so);
            Dec(si);
            try
              sti[si - 1] := smpl_op(sti[si - 1], sti[si], sto[so]);
            except Writeln('operation error');
              Break;
            end;
            sto[so] := smain[i];
            Inc(so);

          end;
        3:
          begin
            Writeln('skobki error');
            Break;
          end;
        4:
          begin

            while ((Pos(smain[i], sz) - 1)<=(Pos(sto[so - 1], sz) - 1)) and
              (sto[so - 1] <> ';') and (sto[so - 1] <> '(') do
            begin
              Dec(so);

              Dec(si);
              try
                sti[si - 1] := smpl_op(sti[si - 1], sti[si], sto[so]);
              except Writeln('operation error');
                Break;
              end;
            end;
            begin
              sto[so] := smain[i];
              Inc(so);
            end;
            if (smain[i] = ';') and (sto[so - 2] = '(') then
            begin
              Writeln('Too many open brackets');
              Break;
            end;

          end;
        5:
          begin
            Dec(so);
            sper := floattostr(sti[si - 1]);
            dec(sc)
          end;
      end;
      if per[Pos(sto[so - 1], sz) - 1, Pos(smain[i], sz) - 1] = 0 then
      begin
        res := sti[0];
        iner := false;
        if oorv then
        begin
          writeln(res: 1: 2);
        end;
      end;

      if not (oorv) and not (iner) then
      begin
        if ind = 0 then
        begin
          tvr[sofv].name := newvar;
          tvr[sofv].data := res;
        end
        else
          tvr[ind].data := res;
      end;

      if not (iner) then
      begin
        newvar := '';
        sper := '';
        oorv := True;
        iner := true;
        si := 0;
        so := 1;
      end;
    end;
    ///////////////////////////////////
    newvar := '';
    sper := '';
    oorv := True;
    iner := true;
    si := 0;
    so := 1;
    write(lp);
    Readln(smain);
    if Copy(smain, 1, 5) = 'open ' then
      smain := readfile(Copy(smain, 6, Length(smain)))
    else
      smain := smain + ';';
  end;

end.

