
local rotSpeed = -10
while true do
	wait()
	script.Parent.Rotation = script.Parent.Rotation + EulerDegree(0,rotSpeed,0)
end