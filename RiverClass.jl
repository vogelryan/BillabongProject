#initiation function of the River struct, starts with one point
function River(Rivername::String, point::RiverPoint, rocktype::String, width::Union{Float64,Int64})
    r = River(Rivername, rocktype, point, point, width, 1, Billabong[])
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

#plots the points in River and the radius of the circles
function plotPoints(River::River)
    x = []
    y = []
    rad = []
    r = River.DownStreamStart
    while true
        push!(x, r.cord[1])
        push!(y, r.cord[2])
        #=if r.radius != NaN
            push!(rad, r.radius)
        else
            push!(rad, 0)
        end
        =#
        if r.Upstream === nothing
            break
        end
        r = r.Upstream
    end

    #scaling for graphing purposus
    xx = x[1]
    yy = y[1]
    for i in eachindex(x)
        x[i] = x[i] - xx
        y[i] = y[i] - yy
    end
    plot(x, y, seriestype = :scatter, label = "points")

    #interpolating the points
    t = 0:length(x)-1
    A = hcat(x,y)
    itp = Interpolations.scale(interpolate(A, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), t, 1:2)
    tfine = 0:.01:length(x)-1
    xs, ys = [itp(t,1) for t in tfine], [itp(t,2) for t in tfine]
    plot!(xs, ys, label = "Interpolation")

    #making scales be the Same
    xlims = (minimum(x), maximum(x))
    ylims = (minimum(y), maximum(y))

    min = minimum([xlims[1], ylims[1]]) - abs(minimum([xlims[1], ylims[1]]) * .1)
    max = maximum([xlims[2], ylims[2]]) + abs(maximum([xlims[2], ylims[2]]) * .1)
    plot!(xlims = (min, max), ylims = (min, max))

    #axis labels
    xlabel!("meters")
    ylabel!("meters")
    
    #saving the figure
    savefig(string(River.Rivername, ".png"))
end

#function to read in a csv file and create a river from it, defult up stream, but can be downstream 
function CSVtoRiver(filename::String, zone::Int64, north::Bool, Rivername::String, rocktype::String, width::Union{Float64,Int64}, upstream = true)

    #reading in the csv file and converting to a Utm
    data = ConvertToUTM(filename, zone, north)

    #creating the first point
    r = River(Rivername, RiverPoint(Tuple(data[1,:]), nothing, nothing), rocktype, width)

    #adding the rest of the points
    for i in 2:size(data)[1]
        addEndpoint!(r, Tuple(data[i,:]), upstream)
    end
    return r
end

