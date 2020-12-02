#if not IF_ELSE_TXL
#define IF_ELSE_TXL

include "sliceCgrm.Grm"
include "sliceCgrmExt.Grm"

define add_assign_statement
       [unary_expression] [assignment_operator] '&
[unary_expression];
end define

redefine statement
    [add_assign_statement]
    | ...
end redefine

function ReplaceConditionalDereferenceMain
    replace [program]
          p [program]
    by
          p [ReplaceConditionalDereference]
end function

rule ReplaceConditionalDereference
      replace [statement*]
            IfStmt [if_statement]
            More [statement*]

    deconstruct IfStmt
            'if ( exp [expression] ) IfBody [statement] _else [opt
else_statement]

    construct NewMore [statement*]
          More [ReplaceWithIf exp IfBody]
               [ReplaceWithElse IfStmt]
               [ReplaceWithNegatedIf IfStmt]
               [EliminateEmptyElse]

    deconstruct not NewMore
          More
    by
          IfStmt [MarkAddressAssignments]
          NewMore

end rule

rule ReplaceWithIf exp [expression] IfBody [statement]
    replace [statement*]
          Stmt [statement]
          More [statement*]

    construct AddAssignStmts [add_assign_statement*]
          _ [^ IfBody]

    construct NewStmt [statement]
          Stmt [ReplaceDereferenceIf each AddAssignStmts]

    deconstruct not Stmt
          NewStmt

    construct NewIf [if_statement]
          'if (exp) { NewStmt } 'else { '<copy> Stmt '</copy> }

    by
          '<processed> NewIf '</processed>
          More
end rule

rule ReplaceWithElse IfStmt [if_statement]
      deconstruct IfStmt
            'if ( exp [expression] ) IfBody [statement] Else [opt
else_statement]

    deconstruct Else
          'else ElseBody [statement]

    construct AddAssignStmts [add_assign_statement*]
          _ [^ ElseBody]

    replace [else_statement]
          'else { MarkedS [marked_statement] }

    deconstruct MarkedS
          '<copy> InnerS [statement] '</copy>

    construct NewS [statement]
          InnerS [ReplaceDereferenceIf each AddAssignStmts]

    deconstruct not NewS
          InnerS
    by
          'else { NewS }
end rule

rule ReplaceWithNegatedIf IfStmt [if_statement]
    deconstruct IfStmt
            'if ( exp [expression] ) IfBody [statement] _else [opt
else_statement]
    
    deconstruct _else
            'else ElseBody [statement]
            
    construct AddAssignStmts [add_assign_statement*]
            _ [^ ElseBody]
    replace [statement*]
            _stmt [statement]
            More [statement*]

    construct stmt_n [statement]
            _stmt [ReplaceDereferenceIf each AddAssignStmts]
    
    where not
            stmt_n [=_stmt]
    by
            'if ( !(exp) ) { stmt_n}
            More
end rule

rule ReplaceDereferenceIf _add_assign_stmt [add_assign_statement]
    skipping [marked_statement]
    replace [unary_expression]
          '* p [unary_expression]

    deconstruct _add_assign_stmt

           p _ [assignment_operator] '& _t [unary_expression];
    by
           _t
end rule

rule EliminateEmptyElse
      replace [statement*]
            IfStmt [if_statement]
            More [statement*]

    deconstruct IfStmt
            'if ( exp [expression] ) IfBody [statement] _else [opt
else_statement]

    % deconstruct _else
    % 'else ElseBody [marked_statement]
    deconstruct _else
            'else '<copy> InnerS [statement] '</copy>
    construct NewIf [if_statement]
            'if ( exp ) IfBody 'else InnerS
    by
            NewIf
            More
end rule

rule MarkAddressAssignments
    replace [statement*]
          S [statement]
          More [statement*]

    deconstruct S
          _ [add_assign_statement]
    by
          '<done> S '</done>
end rule

rule RemoveProcessedTag
      replace [statement*]
            S [statement]
            More [statement*]
    
    deconstruct S
          '<processed> InnerS [statement] '</processed>
    by
          InnerS
          More
end rule

rule RemoveCopyTag
      replace [statement*]
            S [statement]

            More [statement*]
      deconstruct S
            '<copy> InnerS [statement] '</copy>
    by
            InnerS
            More
end rule

#endif