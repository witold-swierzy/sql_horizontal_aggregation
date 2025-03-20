create or replace type hlist_impl as object
(
  return_value CLOB,
  
  static function ODCIAggregateInitialize(sctx IN OUT hlist_impl) 
                                          return number,
  
  member function ODCIAggregateIterate(self IN OUT hlist_impl, 
                                       value IN varchar2) 
                                       return number,
  
  member function ODCIAggregateTerminate(self IN hlist_impl, 
                                         returnValue OUT CLOB, 
                                         flags IN number) 
                                         return number,
  
  member function ODCIAggregateMerge(self IN OUT hlist_impl, 
                                     ctx2 IN hlist_impl) 
                                     return number
);
/

create or replace type body hlist_impl is 

  static function ODCIAggregateInitialize(sctx IN OUT hlist_impl) 
                                          return number 
  is 
  begin
    sctx := hlist_impl('');
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT hlist_impl, 
                                       value IN varchar2) 
                                       return number 
  is
  begin
    if self.return_value is null then
        self.return_value := value;
    else
        self.return_value := self.return_value||','||value;
    end if;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateTerminate(self IN hlist_impl,
                                         returnValue OUT CLOB, 
                                         flags IN number) 
                                         return number 
  is
  begin
    returnValue := self.return_value;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT hlist_impl, 
                                     ctx2 IN hlist_impl) 
                                     return number 
  is
  begin
    return ODCIConst.Success;
  end;
end;
/

CREATE FUNCTION hlist(input varchar2) RETURN clob 
PARALLEL_ENABLE AGGREGATE USING hlist_impl;