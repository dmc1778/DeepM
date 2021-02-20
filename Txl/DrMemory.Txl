function DrMemory
    replace [program]
        P [program]
    by
        P [malloc_replace]
end function

function malloc_replace
    replace [program]
        P [program]
    by
        P 
          %[replace_malloc_W_N]
          %[replace_xmalloc_W_N]
          [replace_malloc_size_W_zero]
          %[replace_xmalloc_size_W_zero]
          %[replace_calloc_W_malloc]
          %[replace_xcalloc_W_xmalloc]
          %[replace_malloc_W_alloca]
          %[replace_xmalloc_W_alloca]
          %[replace_calloc_W_alloca]
          %[replace_xcalloc_W_alloca]  
          %[removeFree]
end function

rule removeFree
    replace [repeat declaration_or_statement]
        Head[declaration_or_statement]
        Tail[repeat declaration_or_statement]
    deconstruct Head 'free '( MA [macro_arguments] ') ';
    by
        Tail
end rule

rule replace_malloc_W_alloca
	replace $[assignment_expression]
		A[any]'malloc '( AL [list argument_expression] ')
	by
		A'alloca '( AL ')
end rule

rule replace_xmalloc_W_alloca
	replace $[assignment_expression]
		A[any]'xmalloc '( AL [list argument_expression] ')
	by
		A'alloca '( AL ')
end rule


rule replace_calloc_W_alloca 
	replace $ [assignment_expression]
		A[any]'calloc '( AE1 [assignment_expression],AE2 [assignment_expression] ')
	construct E1 [expression] AE1
	construct E2 [expression] AE2
	by
		A'alloca '('(E1') * '(E2') ')
end rule

rule replace_xcalloc_W_alloca
	replace $ [assignment_expression]
		A[any]'xcalloc '( AE1 [assignment_expression],AE2 [assignment_expression] ')
	construct E1 [expression] AE1
	construct E2 [expression] AE2
	by
		A'alloca '('(E1') * '(E2') ')
end rule 



rule replace_calloc_W_malloc
	replace $ [assignment_expression]
		A[any]'calloc '( AE1 [assignment_expression],AE2 [assignment_expression] ')
	construct E1 [expression] AE1
	construct E2 [expression] AE2
	by
		A'malloc '('(E1') * '(E2') ')
end rule 

rule replace_xcalloc_W_xmalloc
	replace $ [assignment_expression]
		A[any]'xcalloc '( AE1 [assignment_expression],AE2 [assignment_expression] ')
	construct E1 [expression] AE1
	construct E2 [expression] AE2
	by
		A'xmalloc '('(E1') * '(E2') ')
end rule 

rule replace_malloc_size_W_zero
	replace $[assignment_expression]
		A[any]'malloc '( AL [list argument_expression] ')
	by
		A'malloc '( 0 ')
end rule

rule replace_xmalloc_size_W_zero
	replace $[assignment_expression]
		A[any]'xmalloc '( AL [list argument_expression] ')
	by
		A'xmalloc '( 0 ')
end rule



rule replace_malloc_W_N
    replace $ [assignment_expression]
        A[any]'malloc '( AE [list argument_expression] ')
    by
        'NULL
end rule

rule replace_xmalloc_W_N
    replace $ [assignment_expression]
        A[any]'xmalloc '( AE [list argument_expression] ')
    by
        'NULL
end rule

% freeeeeeeeee


