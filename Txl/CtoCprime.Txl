include "CL.Grm"
include "FMA.Txl"

function main
    replace [program]
        P [program]
    by
        P [MutationDriver]
end function

function MutationDriver
    replace [program]
        P [program]
    by
        P [preparationTransformations]
end function

function preparationTransformations
    replace [program]
        P [program]
    by
        P [FMARules]
end function
