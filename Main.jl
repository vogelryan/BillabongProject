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


Esc = CSVtoRiver("CB.csv", 12, true, "Escalante", 1.0E-8, 42293560.32, 10.0)
#p1 = PlotRiver(Esc, "red")
#NTimeSteps(Esc, 2000, .01, true)
#p2 = PlotRiver(Esc, "blue")

#overlay plots
#plot(p2)
#plot!(p1)









