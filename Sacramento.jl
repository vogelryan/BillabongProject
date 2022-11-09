using Plots
using Interpolations

include("Types.jl")
include("GeometryFunctions.jl")
include("RiverPointClass.jl")
include("BillabongClass.jl")
include("RiverClass.jl")
include("TimeUpdate.jl")


Sac = CSVtoRiver("Sacramento.csv", 10, true, "Sacramento", .0004, 1.34112, 100.0)

plotPoints(Sac)

NTimeSteps(Sac, 100000)
#findLakes(Sac)

#plotPoints(Sac)

#print(length(Sac.Billabongs))
