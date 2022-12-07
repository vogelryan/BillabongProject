#code for updating code inlcuding adding points and changing points

#timestep is in years

function update(river::River, timestep::Float64)
    p = river.DownStreamStart.Upstream
    while p.Upstream.Upstream !== nothing
        c,s = Findcxcy(p)
        dx = river.ErosionCoef * river.CenterVelocity * river.width * p.curvature * c * timestep
        dy = river.ErosionCoef * river.CenterVelocity * river.width * p.curvature * s * timestep

        if dx === NaN || dy === NaN
            dx = 0
            dy = 0
        end

        p.cord = (p.cord[1]+dx, p.cord[2] + dy)
        p = p.Upstream
    end
end

#function to update the river for a given number of time steps, defult timestep is 1 unit of time, can also plot if you want
function NTimeSteps(river::River, n::Int64, timestep::Float64 = 1, plotGIF::Bool = false)

    #how often wee save plot
    num = floor(n/600)

    #creating the gif
    if plotGIF
        a = Animation()
    end

    for i in 1:n
        #print(river.DownStreamStart.Upstream.Upstream.cord, "\n")
        update(river, timestep)
        updateLinkedList(river)
        findLakes(river)

        if i % num == 0 && plotGIF
            p = PlotRiver(river, i)
            frame(a, p)
        end
    end
    if plotGIF
        gif(a, string(river.Rivername,".gif"), fps = 60)
    end
end