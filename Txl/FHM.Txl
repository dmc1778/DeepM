
function FHMRules
    replace [program]
        P [program]
    by
        P [FHMDriver]
end function

function FHMDriver
    replace [program]
        P [program]
    by
        P 
          [removeNullStmt]
          [removeFree]
          [removeKFree]
          [replaceMallocAlloc]
          [replace_kmalloc2_W_N]
          [replaceCallocAlloc]
          [replaceKCallocAlloc]
end function


rule removeNullStmt
    replace $ [statement]
        AE [assignment_expression] '= 'NULL ';
    by
        AE ';
end rule


rule removeFree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'free '( MA [macro_arguments] ') ';
    by
        Tail
end rule

rule removeKFree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'kfree '( MA [macro_arguments] ') ';
    by
        Tail
end rule


rule replaceMallocAlloc
    replace $ [assignment_expression]
        A[any]'malloc '( AL [list argument_expression] ')
    by
        A'alloca '( AL ')
end rule


rule replace_kmalloc2_W_N
    replace $ [assignment_expression]
        A[any]'kmalloc '( AE1 [argument_expression],AE2 [argument_expression] ')
    by
        A'alloca '( AL ')
end rule


rule replaceCallocAlloc
    replace $ [assignment_expression]
        A[any]'calloc '( AE1 [assignment_expression], AE2 [assignment_expression] ')
    construct E1 [expression] AE1
    construct E2 [expression] AE2
    by
       A'alloca '('(E1') * '(E2') ')
end rule

rule replaceKCallocAlloc
    replace $ [assignment_expression]
        A[any]'kcalloc '( AE1 [assignment_expression], AE2 [assignment_expression] ')
    construct E1 [expression] AE1
    construct E2 [expression] AE2
    by
        A'alloca '('(E1') * '(E2') ')
end rule