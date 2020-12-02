#if not DECLARATIONS_TXL
#define DECLARATIONS_TXL

include "CL.Grm"
%rule EliminateDeclarations


rule EliminateDeclarations
    replace [program]
          P [program]
    construct NP [program]
          P [EliminateUnusedVarDeclarations]
            [EliminateEmptyDeclaration]
    deconstruct not NP
          P
    by
          NP
end rule

rule EliminateUnusedVarDeclarations
      replace [compound_statement_body]
            Decl [declaration]
            Body [compound_statement_body]
    
    deconstruct Decl
            Spec [decl_specifiers] DeclList [list init_declarator];
    
    construct NewList [list init_declarator]
          DeclList[EliminateRedundants Body]
    
    deconstruct not DeclList
          NewList
    by
          Spec NewList;
          Body
end rule

rule EliminateEmptyDeclaration
      replace $ [compound_statement_body]
            Decl [declaration]
            Body [compound_statement_body]
      deconstruct Decl
            Spec [decl_specifiers] DeclList [list init_declarator];

      construct N [number]
            _ [length DeclList]
      
      deconstruct N
            0
      by
            Body
end rule

% and eliminate if any of them are not being used, from the list.
rule EliminateRedundants Body [compound_statement_body]
      replace [list init_declarator]
            First [init_declarator],
            More [list init_declarator]

    deconstruct First
            _ [ptr_operator*] Id [id]

    where not
          Body [IsUsingVariable Id]
    by
          More
end rule

rule IsUsingVariable Id [id]
      match * [expression]
            E [expression]
      deconstruct * [id] E
            Id
end rule

rule EliminateSub2
      replace [compound_statement_body]
           Decl [declaration]
           Body [compound_statement_body]
      deconstruct Decl
           Spec [decl_specifiers] DecList[list init_declarator];

    deconstruct DecList
           Id [id]

    where not
           Body [IsUsingVariable Id]
    by
           Body
end rule

#endif