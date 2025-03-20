create or replace type json_arr_impl as object
(
  return_value CLOB,
  
  static function ODCIAggregateInitialize(sctx IN OUT json_arr_impl) 
                                          return number,
  
  member function ODCIAggregateIterate(self IN OUT json_arr_impl, 
                                       value IN varchar2) 
                                       return number,

  member function ODCIAggregateIterate(self IN OUT json_arr_impl, 
                                       value IN number) 
                                       return number,  
  
  member function ODCIAggregateTerminate(self IN json_arr_impl, 
                                         returnValue OUT CLOB, 
                                         flags IN number) 
                                         return number,
  
  member function ODCIAggregateMerge(self IN OUT json_arr_impl, 
                                     ctx2 IN json_arr_impl) 
                                     return number
);
/

create or replace type body json_arr_impl is 

  static function ODCIAggregateInitialize(sctx IN OUT json_arr_impl) 
                                          return number 
  is 
  begin
    sctx := json_arr_impl('');
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT json_arr_impl, 
                                       value IN varchar2) 
                                       return number 
  is
  begin
    if self.return_value is null then
        self.return_value := '["'||value||'"';
    else
        self.return_value := self.return_value||',"'||value||'"';
    end if;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT json_arr_impl, 
                                       value IN number) 
                                       return number 
  is
  begin
    if self.return_value is null then
        self.return_value := '['||value||;
    else
        self.return_value := self.return_value||','||value;
    end if;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateTerminate(self IN json_arr_impl,
                                         returnValue OUT CLOB, 
                                         flags IN number) 
                                         return number 
  is
  begin
    returnValue := self.return_value||']';
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT json_arr_impl, 
                                     ctx2 IN json_arr_impl) 
                                     return number 
  is
  begin
    return ODCIConst.Success;
  end;
end;
/

CREATE OR REPLACE FUNCTION json_arr_vc(input varchar2) RETURN clob 
PARALLEL_ENABLE AGGREGATE USING json_arr_impl;

CREATE OR REPLACE FUNCTION json_arr_n(input number) RETURN clob 
PARALLEL_ENABLE AGGREGATE USING json_arr_impl;

