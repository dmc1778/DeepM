include "sliceCgrm.Grm"
include "sliceCgrmExt.Grm"

#if not STATIC_SLICER_TXL
#define STATIC_SLICER_TXL

function static_slice
      replace [program]
              P [program] 
      by
            P [PropagateMarkup]
              [removeUnmarkedStatements]
              [stripMarkup]
              [RegigIfElse] [message "Static Sliced."] [print]
end function
 
rule PropagateMarkupTop
      replace [program]
            P [program]
      construct NP [program]
            P [PropagateMarkup]
      deconstruct not NP
            P
      by
            NP
end rule


rule PropagateMarkup
      replace [program]
            P [program]
      construct NP [program]
            P [backPropagateAssignment]
              [MarkStatementsModifyLoopInvariant] % in while loop
              [whilePropogateMarkup]
      % [whilePropogateMarkupIn]
              [MarkDeepAssignments]
      % [MarkOuterStatement]
      % [MarkOuterStatemetsContainsMarkedStmts]
      % we stop when NP = P.
      deconstruct not NP
            P
      by
            NP
end rule


rule whilePropogateMarkup
      replace $ [statement]
              while ( E [expression] ) S [statement]
construct MarkedS [marked_statement*]
              _ [^ S]
construct MarkedE [expression*]
              _ [^ MarkedS]
      by
              while ( E )
              S [markAssignmentsTo each MarkedE]
end rule

rule whilePropogateMarkupIn
      replace $ [statement*]
            while ( E [expression] ) S [statement]
            MoreS [statement*]
      construct MarkedMoreS [marked_statement*]
            _ [^ MoreS]
      construct MarkedMoreE [expression*]
            _ [^ MarkedMoreS]
      by
            while ( E )
                  S [markAssignmentsTo each MarkedMoreE]
            MoreS
end rule


rule IfPropagateMarkupIn
      replace $ [statement*]
            'if ( E [expression] ) { S [statement*]}
            MoreS [statement*]
      construct MarkedMoreS [marked_statement*]
            _ [^ MoreS]
      construct MarkedMoreE [expression*]
            _ [^ MarkedMoreS]
      by
            'if ( E ) {
                  S [markAssignmentsTo each MarkedMoreE]
            }
            MoreS
end rule


rule IfElsePropagateMarkupIn
      replace $ [statement*]
            'if ( E [expression] ) { S [statement*]} 'else {ElseS
[statement*]}
            MoreS [statement*]
      construct MarkedMoreS [marked_statement*]
            _ [^ MoreS]
      construct MarkedMoreE [expression*]
            _ [^ MarkedMoreS]
      by
            'if ( E ) {
                  S [markAssignmentsTo each MarkedMoreE]
            }
            'else {
                  ElseS [markAssignmentsTo each MarkedMoreE]
            }
            MoreS
end rule

% Mark all the statements inside the loop that modify the
% loop invariants.
rule MarkStatementsModifyLoopInvariant
      replace $ [statement]
            Stmt [statement]
      deconstruct Stmt
            'while ( E [expression] ) S [statement]
      where
            S [hasMarkedStmtInside]
      by
            'while ( E )
                  S [markAssignmentsTo E]
end rule

function SubLoopInvariant E [expression]
      replace [statement*]
            All [statement*]
      where
            All [hasMarkedStmtInside]
      by
            All [markAssignmentsTo E]
end function


rule markAssignmentsTo Exp [expression]
      skipping [marked_statement]
      replace [statement*]
            X [id] Op [assignment_operator] E
      [assignment_expression];
            More [statement*]
      deconstruct * [id] Exp
            X
      by
            <mark> X Op E ; </mark>
            More
end rule

rule MarkDeepAssignments
      replace $ [statement*]
            S [statement]
            More [statement*]
      construct ExpStmts [expression_statement*]
            _ [^ S]
      construct N [number]
            _ [length ExpStmts]
      deconstruct not N
            0
      by
            S [MarkAssignmentToID More each ExpStmts]
            More
end rule

rule MarkAssignmentToID More [statement*] ExpStmt
[expression_statement]
      skipping [marked_statement]
      replace [statement]
            S [statement]
      deconstruct S
            ExpStmt
      deconstruct S
            X [id] Op [assignment_operator] E
[assignment_expression];
      where
            More [hasMarkedUse X]
                 [hasWhileConditionUse X]
                 [hasIfConditionUse X]
      by
            <mark>S </mark>
end rule


rule backPropagateAssignment
      skipping [marked_statement]
            
      replace [statement*]
                  X [id] Op [assignment_operator] E
      [assignment_expression];
                  More [statement*]
      where
                  More [hasMarkedUse X]
                       [hasWhileConditionUse X]
                       [hasIfConditionUse X]
      by
                  <mark> X Op E ; </mark>
                  More
end rule


function hasMarkedUse X [id]
      match * [marked_statement]
            M [marked_statement]
      deconstruct * [expression] M
            E [expression]
      deconstruct * [id] E
            X
end function


function hasIfConditionUse X [id]
      match * [if_statement]
            If [if_statement]
      deconstruct * [marked_statement] If
            _ [marked_statement]
      deconstruct If
            'if ( E [expression] ) _ [statement] _ [opt
else_statement]
      deconstruct * [id] E
            X
end function

function hasWhileConditionUse X [id]
      match * [while_statement]
            W [while_statement]
      deconstruct * [marked_statement] W
            _ [marked_statement]
      deconstruct W
            'while '( E [expression] ') _ [statement]
      deconstruct * [id] E
            X
end function

function hasMarkedStmtInside
      skipping [marked_statement]
      match * [marked_statement]
            _ [marked_statement]
end function

rule removeUnmarkedStatements
      replace [statement*]
            S [statement]
            More [statement*]
      deconstruct not S
            _ [marked_statement]
      where not
            S [hasMarkedStmtInside]
      by
            More
end rule


rule stripMarkup
      replace [statement]
            < _ [id] > S[statement] </ _ [id] >
      by
            S
end rule

rule MarkOuterStatemetsContainsMarkedStmts
      replace [statement*]
            S [statement]
            More [statement*]
      deconstruct not S
            _ [marked_statement]
      construct Subs [marked_statement*]
            _ [^ S]
      construct N [number]
            _ [length Subs]
      where
            N [ > 0]
      by
            <mark> S </mark>
            More
end rule

rule MarkOuterStatement
      replace [statement*]
            S [statement]
            More [statement*]
      deconstruct not S
            _ [marked_statement]
      deconstruct * [marked_statement] S
            _ [marked_statement]
      by
            <mark> S </mark>
            More
end rule


rule RegigIfElse
      replace [statement*]
            S [statement]
            More [statement*]
      deconstruct S
            'if ( exp [expression] ) { } 'else { ElseBody [statement]
}
      construct NewIf [statement]
            'if ( ! ( exp ) ) { ElseBody }
      by
            NewIf
            More
end rule

#endif