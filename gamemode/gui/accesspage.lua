local BASE = "page"

GUI.BaseName = BASE

GUI.RoomView = nil
GUI.DoorViews = nil

function GUI:Initialize()
	self.Super[BASE].Initialize(self)

	self.RoomView = gui.Create(self, "roomview")
	self.RoomView:SetCurrentRoom(self:GetRoom())

	self.DoorViews = {}
	if self:GetRoom() then
		for _, door in ipairs(self:GetRoom().Doors) do
			local doorview = gui.Create(self, "doorview")
			doorview:SetCurrentDoor(door)
			self.DoorViews[door] = doorview
		end
	end

	if CLIENT then
		local width = self.Screen.Width
		local height = self.Screen.Height
		local margin = 16

		self.RoomView:SetBounds(-width / 2 + margin, -height / 2 + margin,
			width - margin * 2, height - margin * 2)

		for door, doorview in pairs(self.DoorViews) do
			doorview:ApplyTransform(self.RoomView:GetAppliedTransform())
		end
	end
end
