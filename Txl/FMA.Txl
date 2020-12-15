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
        P 
          [removeNullDecl]
          [removeNullStmt]
          [removeFree]
          [removeKFree]
          [removePFree]
          [removeReFree]
          [removeFreeBuffer]
          [removeVfree]
          [replace_realloc_W_N]
          [replace_realloc2_W_N]
          [replace_malloc_W_N]
          [replace_vmalloc_W_N]
          [replace_kmalloc_W_N]
          [replace_kmalloc2_W_N]
          [replace_xmalloc_W_N]
          [replace_calloc_W_N]
          [replace_kcalloc_W_N]
end function

rule removeNullDecl
    replace $ [init_declarator]
            D [declarator]'= 'NULL
    by
            D	
end rule

rule removeNullStmt
    replace $ [statement]
        AE [assignment_expression] '= 'NULL ';
    by
        AE;
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

rule removePFree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'pfree '( MA [macro_arguments] ') ';
    by
        Tail
end rule

rule removeReFree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 're_free '( MA [macro_arguments] ') ';
    by
        Tail
end rule

rule removeFreeBuffer
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'free_buffer '( MA [macro_arguments] ') ';
    by
        Tail
end rule

rule removeVfree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'vfree '( MA [macro_arguments] ') ';
    by
        Tail
end rule

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
        A[any]'malloc '( AE [list argument_expression] ')
    by
        'NULL
end rule

rule replace_vmalloc_W_N
    replace $ [assignment_expression]
        A[any]'vmalloc '( AE [list argument_expression] ')
    by
        'NULL
end rule

rule replace_kmalloc_W_N
    replace $ [assignment_expression]
        A[any]'kmalloc '( AE [list argument_expression] ')
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
        A[any]'xmalloc '( AE [list argument_expression] ')
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

