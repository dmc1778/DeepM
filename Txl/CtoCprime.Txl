include "CL.Grm"
include "FHM.Txl"

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
        P [FHMRules]
end function
