#initiation function of the River Point struct
function RiverPoint(cord::Tuple{Float64,Float64}, Upstream::Union{RiverPoint,Nothing}, Downstream::Union{RiverPoint,Nothing})
    #if true we cant caluate radius.
    if Upstream === nothing || Downstream === nothing
        radius = NaN
        curvature = NaN
        center = (NaN,NaN)
    else
        radius = radius_of_circle(Upstream.cord, cord, Downstream.cord)
        curvature = curvature(radius)
        center = center_of_circle(Upstream.cord, cord, Downstream.cord)
    end
    p =  RiverPoint(cord, Upstream, Downstream, radius, curvature, center)

    #by adding p, we might now be able to find the radius of the upstream or downstream points.
    if Upstream !== nothing
        Upstream.Downstream = p
        if Upstream.Upstream !== nothing
            Upstream.radius = radius_of_circle(Upstream.Upstream.cord, Upstream.cord, Upstream.Downstream.cord)
            Upstream.curvature = curvature(Upstream.radius)
            Upstream.center = center_of_circle(Upstream.Upstream.cord, Upstream.cord, Upstream.Downstream.cord)
        end
    end

    if Downstream !== nothing
        Downstream.Upstream = p
        if Downstream.Downstream !== nothing
            Downstream.radius = radius_of_circle(Downstream.Upstream.cord, Downstream.cord, Downstream.Downstream.cord)
            Downstream.curvature = 1/Downstream.radius
            Downstream.center = center_of_circle(Downstream.Upstream.cord, Downstream.cord, Downstream.Downstream.cord)
        end
    end
    return p
end
