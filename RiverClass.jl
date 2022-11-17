include("CSVCord.jl")

#initiation function of the River struct, starts with one point
function River(Rivername::String, point::RiverPoint, rocktype::Float64, width::Union{Float64,Int64}, Velocity::Float64)
    r = River(Rivername, rocktype, Velocity, point, point, width, 1, Billabong[])
    return r
end

#function to add a point to the end of a river. 
function addEndpoint!(River::River, cord::Tuple{Float64,Float64}, isUpstream::Bool)
    if isUpstream
        p = RiverPoint(cord, nothing, River.UpStreamStart)
        River.UpStreamStart = p
    else
        p = RiverPoint(cord, River.DownStreamStart, nothing)
        River.DownStreamStart = p
    end
    River.numpoints += 1
end

#function to print the points of a river
function printPoints(River::River)
    r = River.DownStreamStart
    while true
        print("cord ", r.cord, " radius ", r.radius, " curvature ", r.curvature, " center ", r.center, "\n")
        if r.Upstream === nothing
            break
        end
        r = r.Upstream
    end
end

#function to read in a csv file and create a river from it, defult up stream, but can be downstream, north is in norther hemispere, upstream indecates points go from down to upstream
function CSVtoRiver(filename::String, UTMZone::Int64, north::Bool, Rivername::String, ErosionCoef::Float64, Velocity::Float64, RiverWidth::Union{Float64,Int64}, upstream = true)
#=
    filename: name of the csv file
    UTMZone: UTM zone of the data
    north: true if in northern hemispere
    Rivername: name of the river
    ErosionCoef: erosion coefficient
    Velocity: velocity of the river
    RiverWidth: width of the river
    upstream: true if the points go from downstream to upstream
    
    returns a river struct
=#

    #reading in the csv file and converting to a Utm
    data = ConvertToUTM(filename, UTMZone, north)

    #creating the first point
    r = River(Rivername, RiverPoint(Tuple(data[1,:]), nothing, nothing), ErosionCoef, RiverWidth, Velocity)

    #adding the rest of the points
    for i in 2:size(data)[1]
        addEndpoint!(r, Tuple(data[i,:]), upstream)
    end

    return r
end

function updateLinkedList(river::River)
    p = river.DownStreamStart.Upstream
    while p.Upstream !== nothing
        p.radius = radius_of_circle(p.Downstream.cord, p.cord, p.Upstream.cord)
        p.curvature = 1/p.radius
        p.center = center_of_circle(p.Downstream.cord, p.cord, p.Upstream.cord)
        p = p.Upstream
    end
end

#plots the points in Rivers
function PlotRiver(River::River, version::Union{Int64, Nothing} = nothing)
    x = []
    y = []
    r = River.DownStreamStart.Upstream
    while r.Upstream.Upstream !== nothing
        push!(x, r.cord[1])
        push!(y, r.cord[2])
        r = r.Upstream
    end

    xx = River.DownStreamStart.cord[1]
    yy = River.DownStreamStart.cord[2]

    for i in eachindex(x)
        x[i] = x[i] - xx
        y[i] = y[i] - yy
    end

    P = plot(x, y, seriestype = :scatter, label = "points")

    #interpolating the points
    t = 0:length(x)-1
    A = hcat(x,y)
    itp = Interpolations.scale(interpolate(A, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), t, 1:2)
    tfine = 0:.01:length(x)-1
    xs, ys = [itp(t,1) for t in tfine], [itp(t,2) for t in tfine]
    plot!(xs, ys, label = "Interpolation")

    #making scales be the Same
    difx = maximum(x) - minimum(x)
    dify = maximum(y) - minimum(y)

    dif = maximum([difx, dify])

    xlims = (minimum(x)- dif*0.1, maximum(x)+ dif*0.1)
    ylims = (minimum(y) - dif*0.1, maximum(y)+dif*0.1)

    plot!(xlims = xlims, ylims = ylims)

    #axis labels
    xlabel!("meters")
    ylabel!("meters")
    
    #saving the figure
    #savefig(string(River.Rivername, version, ".png"))

    return P
end