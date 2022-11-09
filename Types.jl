#River point struct, contains the position of the point, the upstream and downstream points, and radius of curvature.  
mutable struct RiverPoint
    #The position of the point
    cord::Tuple{Float64,Float64}

    #upstrem point
    Upstream::Union{RiverPoint,Nothing}

    #downstrem point
    Downstream::Union{RiverPoint,Nothing}

    #radius, centerm and curviture of the circle fefined by the point and neigbors.  
    radius::Float64
    curvature::Float64
    center::Tuple{Float64,Float64}
end

#structure to define a billabong lake
struct Billabong
    Start::RiverPoint
    End::RiverPoint
end

#struct to define a river
mutable struct River
    Rivername::String    
    ErosionCoef::Float64
    CenterVelocity::Float64
    DownStreamStart::RiverPoint
    UpStreamStart::RiverPoint
    width::Union{Float64,Int64}
    numpoints::Int64
    Billabongs::Array{Billabong,1}
end

