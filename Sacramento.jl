using Plots
using Interpolations

include("Types.jl")
include("GeometryFunctions.jl")
include("CSVCord.jl")
include("RiverPointClass.jl")
include("BillabongClass.jl")
include("RiverClass.jl")


Sac = CSVtoRiver("Sacramento.csv", 10, true, "Sacramento", "Q", 100)

plotPoints(Sac)

Sac.width = 900

findLakes(Sac)

plotPoints(Sac)

print(length(Sac.Billabongs))
