function FMARules
    replace [program]
        P [program]
    by
        P [FMADriver]
end function

function FMADriver
    replace [program]
        P [program]
    by
        P [replace_realloc_W_N]
          [replace_realloc2_W_N]
          [replace_malloc_W_N]
          [replace_vmalloc_W_N]
          [replace_kmalloc_W_N]
          [replace_kmalloc2_W_N]
          [replace_xmalloc_W_N]
          [replace_calloc_W_N]
          [replace_kcalloc_W_N]
end function

rule replace_realloc_W_N
    replace $ [assignment_expression]
        A[any]'realloc '( AE1 [argument_expression], AE2 [argument_expression] ')
    by
        'NULL
end rule

rule replace_realloc2_W_N
    replace $ [assignment_expression]
        A[any]'krealloc '( AE1 [argument_expression], AE2 [argument_expression], AE3 [argument_expression] ')
    by
        'NULL
end rule

rule replace_malloc_W_N
    replace $ [assignment_expression]
        A[any]'malloc '( AE[list argument_expression] ')
    by
        'NULL
end rule

rule replace_vmalloc_W_N
    replace $ [assignment_expression]
        A[any]'vmalloc '( AE[list argument_expression] ')
    by
        'NULL
end rule

rule replace_kmalloc_W_N
    replace $ [assignment_expression]
        A[any]'kmalloc '( AE[list argument_expression] ')
    by
        'NULL
end rule

rule replace_kmalloc2_W_N
    replace $ [assignment_expression]
        A[any]'kmalloc '( AE1 [argument_expression],AE2 [argument_expression] ')
    by
        'NULL
end rule

rule replace_xmalloc_W_N
    replace $ [assignment_expression]
        A[any]'xmalloc '( AE[list argument_expression] ')
    by
        'NULL
end rule


rule replace_calloc_W_N
    replace $ [assignment_expression]
        A[any]'calloc '( AE1 [argument_expression],AE2 [argument_expression] ')
    by
        'NULL
end rule

rule replace_kcalloc_W_N
    replace $ [assignment_expression]
        A[any]'kcalloc '( AE1 [argument_expression],AE2 [argument_expression] ')
    by
        'NULL
end rule

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
