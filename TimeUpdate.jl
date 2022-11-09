#code for updating code inlcuding adding points and changing points

#timestep is in years

function update(river::River, timestep::Int64)
    p = river.DownStreamStart.Upstream
    while p.Upstream.Upstream !== nothing
        ct, st = FindCosSin(p)
        dx = river.ErosionCoef * river.CenterVelocity * river.width * p.curvature * ct * timestep
        dy = river.ErosionCoef * river.CenterVelocity * river.width * p.curvature * st * timestep
        p.cord = (p.cord[1] + dx, p.cord[2] + dy)

        p = p.Upstream
    end
    updateLinkedList(river)
    findLakes(river)
end

function NTimeSteps(river::River, n::Int64)
    for i in 1:n
        update(river, 1)
    end
    plotPoints(river)
end