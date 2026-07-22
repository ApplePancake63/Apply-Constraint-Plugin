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
local constraint_filter = {
	"UIAspectRatioConstraint",
	"UISizeConstraint",
	"UIScale",
	"UIPadding",
	"UIListLayout",
	"UIGridLayout",
	"UIPageLayout",
	"UITableLayout",
}
return function()
	local selected:{Instance} = selection:Get()
	for _, v in selected do
		for _, k in v:GetDescendants() do
			if not table.find(frame_filter, k.ClassName) or table.find(selected, k) then continue end
			table.insert(selected, k)
			print("k", k)
		end
		print("v", v)
	end
	local cached = {}
	for _, v:Frame in selected do
		print(v)
		if not table.find(frame_filter, v.ClassName) then warn(v, "is not a frame-like instance") continue end
		local cache = {frame=v}
		
		local parent:Frame = v.Parent
		cache["rot"]=v.Rotation
		
		v.Rotation = 0
		local parent_pos = parent.AbsolutePosition
		cache["size"]=UDim2.fromOffset(v.AbsoluteSize.X, v.AbsoluteSize.Y)
		cache["pos"]=UDim2.fromOffset(
			v.AbsolutePosition.X-parent_pos.X+v.AbsoluteSize.X*v.AnchorPoint.X,
			v.AbsolutePosition.Y-parent_pos.Y+v.AbsoluteSize.Y*v.AnchorPoint.Y
		)
		
		table.insert(cached, cache)
	end
	for _, v:{frame:Frame, size:UDim2, pos:UDim2} in cached do
		v.frame.Size = v.size
		v.frame.Position = v.pos
		v.frame.Rotation = v.rot
		for _, k in v.frame:GetChildren() do
			if not table.find(constraint_filter, k.ClassName) then print(k.ClassName) continue end
			k:Destroy()
		end
	end
end