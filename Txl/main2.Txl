

function main
    replace [program]
          P [program]
    by
          P [PushTrans] [message "Push Trans
done"][print][breakpoint]
              [ResolveExpression][message "ExpressionResolved"]
[print][breakpoint]
              [EliminateKill][message "Eliminate Kill
Stmts"][print][breakpoint]
              [EliminateDeclarations][message
"EliminateDeclaration"][print][breakpoint]
end function