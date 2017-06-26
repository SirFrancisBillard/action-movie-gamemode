
MASKMENU = {}

surface.CreateFont("MaskMenu", {
	size = ScreenScale(24),
	weight = 800,
	antialias = true,
	shadow = false,
	font = "Arial"
})

function MASKMENU:SendMask(mask)
	local m = tonumber(mask)
	if not isnumber(mask) then return end
	net.Start("ttt_sendperk")
	net.WriteInt(m)
	net.SendToServer()
end

function MASKMENU:Build()
	self:Destroy()

	self.Panel = vgui.Create("DFrame")
	self.Panel:SetTitle("Select Mask")
	self.Panel:SetSize(1000, 600)
	self.Panel:Center()
	self.Panel:MakePopup()

	local Scroll = vgui.Create("DScrollPanel", self.Panel)
	Scroll:SetSize(950, 550)
	Scroll:SetPos(10, 30)

	local List	= vgui.Create("DIconLayout", Scroll)
	List:SetSize(900, 500)
	List:SetPos(0, 0)
	List:SetSpaceY(5)
	List:SetSpaceX(5)

	for k, v in pairs(gPerks) do
		local ListPanel = List:Add("DPanel")
		ListPanel:SetSize(250, 350)

		local ListImage = vgui.Create("DModelPanel", ListPanel)
		ListImage:SetSize(250, 250)
		ListImage:SetImage("vgui/masks/" .. v.Image)
		ListImage.DoClick = function()
			chat.AddText("Mask has been set. You can change your perk at any time by typing \"action_mask\" in console.")
			self:SendPerk(v.ID)
		end

		local ListLabel = vgui.Create("DLabel", ListPanel)
		ListLabel:SetSize(250, 100)
		ListLabel:SetPos(ListLabel:GetPos(), select(2, ListLabel:GetPos()) + 250)
		ListLabel:SetText(v.Name .. "\n" .. v.Desc)
		ListLabel:SetTextColor(color_black)
	end
end

function MASKMENU:Destroy()
	if IsValid(MASKMENU.Panel) and type(MASKMENU.Panel.Remove) == "function" then
		MASKMENU.Panel:Remove()
	end
end

concommand.Add("action_mask", function(ply, cmd, args, argsStr)
	MASKMENU:Build()
end)
