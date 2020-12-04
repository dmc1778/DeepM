function UMARules
    replace [program]
        P [program]
    by
        P [UMADriver]
end function

function UMADriver
    replace [program]
        P [program]
    by
        P [removeNullStmt]
          [replaceCallocMalloc]
          [replaceKCallocMalloc]
          [replaceXCallocMalloc]
end function

%--->
%rule removeNullDec
%    replace $ [init_declarator]
%       D [declarator]'= 'NULL
%    by
%      D
%end rule

rule replaceCallocMalloc
    replace $ [assignment_expression]
        A[any]'calloc '( AE1 [assignment_expression], AE2 [assignment_expression] ')
    construct E1 [expression] AE1
    construct E2 [expression] AE2
    by
        A'malloc '('(E1') * '(E2') ')
end rule

rule replaceKCallocMalloc
    replace $ [assignment_expression]
        A[any]'kcalloc '( AE1 [assignment_expression], AE2 [assignment_expression] ')
    construct E1 [expression] AE1
    construct E2 [expression] AE2
    by
        A'kmalloc '('(E1') * '(E2') ')
end rule

rule replaceXCallocMalloc
    replace $ [assignment_expression]
        A[any]'xcalloc '( AE1 [assignment_expression], AE2 [assignment_expression] ')
    construct E1 [expression] AE1
    construct E2 [expression] AE2
    by
        A'xmalloc '('(E1') * '(E2') ')
end rule

