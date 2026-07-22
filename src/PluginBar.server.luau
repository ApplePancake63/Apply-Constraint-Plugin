local bar = plugin:CreateToolbar("ApplyConstraint")

local apply_button = bar:CreateButton(
	"Apply",
	"Apply Constraint by ianekifir",
	"http://www.roblox.com/asset/?id=139437522"
)
local apply = require(script.Parent.Apply)
apply_button.Click:Connect(apply)

local to_scale_button = bar:CreateButton(
	"To Scale",
	"Apply Constraint by ianekifir",
	"http://www.roblox.com/asset/?id=139437522"
)
local to_scale = require(script.Parent.ToScale)
to_scale_button.Click:Connect(to_scale)