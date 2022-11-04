#function to find the cente of the circle
function center_of_circle(point1, point2, point3)
    #find the slope of the lines
    m1 = (point2[2] - point1[2])/(point2[1] - point1[1])
    m2 = (point3[2] - point2[2])/(point3[1] - point2[1])

    #find the center of the circle
    x = (m1*m2*(point1[2] - point3[2]) + m2*(point1[1] + point2[1]) - m1*(point2[1] + point3[1]))/(2*(m2-m1))
    y = (-1/m1)*(x - (point1[1] + point2[1])/2) + (point1[2] + point2[2])/2

    return (x,y)
end
    
#function to find the radius of the circle
function radius_of_circle(point1, point2, point3)
    x,y = center_of_circle(point1, point2, point3)
    r = sqrt((point1[1] - x)^2 + (point1[2] - y)^2)
end

#function to find the curvature of the river
function curvature(radius)
    return 1/radius
end

function distance(point1::Tuple, point2::Tuple)
    return sqrt((point1[1] - point2[1])^2 + (point1[2] - point2[2])^2)
end

