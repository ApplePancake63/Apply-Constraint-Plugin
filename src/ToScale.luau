local selection = game:GetService("Selection")
local frame_filter = {
	"Frame",
	"ScrollingFrame",
	"ViewportFrame",
	"CanvasGroup",
	"TextLabel",
	"TextButton",
	"TextBox",
	"ImageLabel",
	"ImageButton"
}
local function add_parent(frame:Frame, rot_cache)
	if table.find(frame_filter, frame.ClassName) then
		table.insert(rot_cache, {frame=frame, rot=frame.Rotation})
		frame.Rotation = 0
		return add_parent(frame.Parent, rot_cache)
	else
		return rot_cache
	end
end
return function()
	local selected:{Instance} = selection:Get()
	for _, v:Frame in selected do
		if not table.find(frame_filter, v.ClassName) then warn(v, "is not a frame-like instance") continue end
		local parent:ScrollingFrame = v.Parent
		local parent_size = parent.AbsoluteSize
		local x_view, y_view = parent_size.X, parent_size.Y
		if parent:IsA("ScrollingFrame") then
			local parent_parent:Frame = parent.Parent
			local x_parent, y_parent = parent_parent.AbsoluteSize.X, parent_parent.AbsoluteSize.Y
			x_view = math.max(parent.CanvasSize.X.Offset+parent.CanvasSize.X.Scale*x_parent, parent.AbsoluteSize.X)
			y_view = math.max(parent.CanvasSize.Y.Offset+parent.CanvasSize.Y.Scale*y_parent, parent.AbsoluteSize.Y)
		end

		local rot_cache = add_parent(v, {})
		local x_size, y_size = v.AbsoluteSize.X, v.AbsoluteSize.Y
		local x_scale, y_scale = x_size/x_view, y_size/y_view
		v.Size = UDim2.fromScale(x_scale, y_scale)
		local x_pos = (v.AbsolutePosition.X-parent.AbsolutePosition.X+x_size*v.AnchorPoint.X)/x_view
		local y_pos = (v.AbsolutePosition.Y-parent.AbsolutePosition.Y+x_size*v.AnchorPoint.Y)/y_view
		v.Position = UDim2.fromScale(x_pos, y_pos)
		for _, v in rot_cache do
			v.frame.Rotation = v.rot
		end
	end
end
