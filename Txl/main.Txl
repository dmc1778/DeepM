include "sliceCgrm.Grm"
include "sliceCgrmExt.Grm"
include "static_slicer.Txl"
include "pointer.Txl"
include "declarations.Txl"

function main
    replace [program]
          P [program]
    by
          P [RemovePointersMain][message "Pointers Eliminated."]
[print][breakpoint]
            [static_slice] [message "Static Slice done"]
[print][breakpoint]
            [EliminateDeclarations]
end function