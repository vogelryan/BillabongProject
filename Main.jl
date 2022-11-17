using Plots
using Interpolations

include("Types.jl")
include("GeometryFunctions.jl")
include("RiverPointClass.jl")
include("BillabongClass.jl")
include("RiverClass.jl")
include("TimeUpdate.jl")


#Sac = CSVtoRiver("Sacramento.csv", 10, true, "Sacramento", .01, 1.34112, 100.0)
#printPoints(Sac)
#plotPoints(Sac)

#NTimeSteps(Sac, 30000)




Esc = CSVtoRiver("Escalante.csv", 12, true, "Escalante", 1.8E-5, 1.34112, 10.0)
NTimeSteps(Esc, 3000000, 1, true)
