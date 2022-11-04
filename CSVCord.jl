using Geodesy
using CSV
using DataFrames

#read CSV
function readCSV(filename::String)
    data = CSV.read(filename, delim=",", DataFrame, header=false)
    data = data[:, 1:2]
    return data
end

function ConvertToUTM(filename::String, zone::Int64, north::Bool)
    data = readCSV(filename)
    utm = UTMfromLLA(zone, north, wgs84)
    for i in eachindex(data[:,1])
        lla = LLA(data[i,1], data[i,2])
        utm_cord = utm(lla)
        data[i,1] = utm_cord.x
        data[i,2] = utm_cord.y
    end
    return data
end
