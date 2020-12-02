#if not POINTER_TXL
#define POINTER_TXL

include "sliceCgrm.Grm"
include "sliceCgrmExt.Grm"
include "if_else.Txl"

function RemovePointersMain
    replace [program]
          P [program]
    by
          P [RemovePointers]
            [EliminateAddressAssignments]
            [RemoveProcessedTag]
            [RemoveCopyTag]
            [RemoveEmptyElse]
            [RemoveEmptyIfElse]
end function

rule RemovePointers
    replace [program]
          P [program]

    construct New [program]
          P [ReplaceDereference]
            [ReplaceWithIfElse]
            [UnmarkAddressAssignments]

    deconstruct not New
          P
    by
          New
end rule


rule ReplaceWithIfElse
      replace    [statement*]
            S    [statement]
            More [statement*]

      deconstruct S 
            IfStmt [if_statement]

      deconstruct IfStmt
            'if ( exp [expression] ) IfBody [statement] _else
            % [obt else_statement]

      construct NewMore [statement*]
                More [ReplaceWithIf exp IfBody]
                     [ReplaceWithElse IfStmt]
                     [ReplaceWithNegatedIf IfStmt]
                     [EliminateEmptyElse]

      deconstruct not NewMore
            More

      where not
            More [HasAddressAssign]
      by
            S [MarkAddressAssignments]
            NewMore
end rule

rule ReplaceDereference
    replace [statement*]
          S [statement]
          More [statement*]
    deconstruct S
            Pointer [unary_expression] _op [assignment_operator] '&
Target [unary_expression];
    
    where not
          More [HasAddressAssign]
    by
          '<done> S '</done>
          More [Replace Pointer Target]
               [ReplaceInMarked Pointer Target]
end rule


function HasAddressAssign
    skipping [marked_statement]

    match * [statement]
          S [statement]

    deconstruct S
    _ [unary_expression] _ [assignment_operator] '& t
[unary_expression];
end function

rule Replace Pointer [unary_expression] Target [unary_expression]
    replace [statement*]
          S [statement]
          More [statement*]

    deconstruct not S
           '<done> InnerS [statement] '</done>

    construct New [statement]
          S [ReplaceSub Pointer Target]

    deconstruct not S
          New
    by
          New
          More
end rule

rule ReplaceInMarked Pointer [unary_expression] Target
[unary_expression]
    replace [statement*]
          S [statement]
          More [statement*]

    deconstruct S
          '<done> InnerS [statement] '</done>

    construct New [statement]
          InnerS [ReplaceSub Pointer Target]

    deconstruct not New
          InnerS
    by
          New
          More
end rule


rule ReplaceSub Pointer [unary_expression] Target [unary_expression]
    replace [unary_expression]
          U [unary_expression]

    deconstruct U
          UnaryOp [unary_operator] Pointer

    deconstruct UnaryOp
          '*
    by
          Target
end rule

rule UnmarkAddressAssignments
    replace [statement*]
          S [statement]
          More [statement*]

    deconstruct S
          '<done> InnerS [statement] '</done>
    by
          InnerS
          More
end rule

rule EliminateAddressAssignments
    replace [statement*]
            S [statement]
            More [statement*]
    deconstruct S
        _ [unary_expression] _ [assignment_operator] '& t
[unary_expression];
    by
            More
end rule

rule RemoveEmptyElse
        replace [statement*]
                stmt [if_statement]
                Rest [statement*]
        deconstruct stmt
                'if ( exp [expression] ) if_body [statement] _else
[opt
else_statement]
        deconstruct _else
                'else { }
        by
                'if ( exp ) if_body
                Rest
end rule

rule RemoveEmptyIfElse
    replace [statement+]
            stmt [if_statement]
            Rest [statement*]
    deconstruct stmt
            'if( exp [expression] ) {}
    by
            Rest
end rule


#endif