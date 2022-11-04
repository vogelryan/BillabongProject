
function nextPoint(river, point, downStream::Bool=true)
    if downStream
        npoint = point.Downstream
    else
        npoint = point.Upstream
    end
    if npoint === nothing
        return nothing
    end
    while distance(npoint.cord, point.cord) < river.width
        #print(distance(npoint.cord, point.cord),"\n")
        if downStream
            npoint = npoint.Downstream
        else
            npoint = npoint.Upstream
        end
        if npoint === nothing
            return nothing
        end
    end
    return npoint
end

#helper, sees if the points are close enough to be a lake an returns bilabong type, else nothing
function isLake(width::Union{Int64,Float64}, point1, point2)
    if point1 === nothing || point2 === nothing
        return false
    end
    if distance(point1.cord, point2.cord) < width
        return true
    end
    return false
end

#finds all the lakes in a river
function findLakes(river)
    fpoint = river.UpStreamStart
    while fpoint !== nothing
        spoint = nextPoint(river, fpoint)
        while spoint !== nothing
            if isLake(river.width, fpoint, spoint)
                push!(river.Billabongs, Billabong(fpoint.Downstream, spoint.Upstream))
                fpoint.Downstream = spoint
                spoint.Upstream = fpoint
                fpoint = spoint
                break
            end
            spoint = spoint.Downstream
        end
        fpoint = fpoint.Downstream
    end
end