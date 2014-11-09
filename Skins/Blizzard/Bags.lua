local AS = unpack(AddOnSkins)

local name = 'Blizzard_Bags'
function AS:Blizzard_Bags()
	if Tukui and Tukui[2]["Bags"]["Enable"] then return end

	for i = 1, 12 do -- There is 13 Total..
		local Bag = _G["ContainerFrame"..i]
		AS:SkinBackdropFrame(Bag, nil, true)
		for j = 1, 36 do
			local ItemButton = _G["ContainerFrame"..i.."Item"..j]
			AS:SkinFrame(ItemButton)
			AS:SkinTexture(ItemButton.icon)
			ItemButton.icon:SetInside()

			ItemButton.NewItemTexture:SetAtlas(nil)
			ItemButton.NewItemTexture.SetAtlas = AS.Noop

			-- This shit is hax.
			ItemButton:CreateBackdrop()
			local Backdrop = ItemButton.Backdrop or ItemButton.backdrop
			hooksecurefunc(ItemButton.NewItemTexture, 'Show', function()
				Backdrop:Show()
			end)
			hooksecurefunc(ItemButton.NewItemTexture, 'Hide', function()
				Backdrop:Hide()
			end)
			Backdrop:SetAllPoints()
			Backdrop:SetFrameStrata(ItemButton:GetFrameStrata())
			Backdrop:SetFrameLevel(ItemButton:GetFrameLevel() + 4)
			Backdrop:SetBackdropColor(0, 0, 0, 0)
			Backdrop:SetScript('OnUpdate', function(self)
				local r, g, b = ItemButton.IconBorder:GetVertexColor()
				local a = ItemButton.NewItemTexture:GetAlpha()
				ItemButton:SetBackdropBorderColor(unpack(AS.BorderColor))
				self:SetBackdropBorderColor(r, g, b, a)
			end)
			Backdrop:SetScript('OnHide', function(self)
				ItemButton:SetBackdropBorderColor(ItemButton.IconBorder:GetVertexColor())
			end)
			-- End of hax.

			ItemButton.searchOverlay:SetAllPoints(ItemButton.icon)
			ItemButton.searchOverlay:SetTexture(0, 0, 0, .8)

			ItemButton:SetNormalTexture(nil)
			ItemButton:StyleButton()
			hooksecurefunc(ItemButton.IconBorder, 'SetVertexColor', function(self, r, g, b, a)
				ItemButton:SetBackdropBorderColor(r, g, b)
			end)
			hooksecurefunc(_G["ContainerFrame"..i.."Item"..j].IconBorder, 'Hide', function(self)
				ItemButton:SetBackdropBorderColor(unpack(AS.BorderColor))
			end)
		end

		Bag.Backdrop:Point("TOPLEFT", 4, -2)
		Bag.Backdrop:Point("BOTTOMRIGHT", 1, 1)
		_G["ContainerFrame"..i.."BackgroundTop"]:Kill()
		_G["ContainerFrame"..i.."BackgroundMiddle1"]:Kill()
		_G["ContainerFrame"..i.."BackgroundMiddle2"]:Kill()
		_G["ContainerFrame"..i.."BackgroundBottom"]:Kill()
		AS:SkinCloseButton(_G["ContainerFrame"..i.."CloseButton"])
		AS:SkinButton(Bag.PortraitButton)
		Bag.PortraitButton.Highlight:Kill()
	end

	local function UpdateBagIcon()
		for i = 1, 12 do
			local Portrait = _G["ContainerFrame"..i.."PortraitButton"]
			if i == 1 then
				Portrait:SetNormalTexture("Interface\\ICONS\\INV_Misc_Bag_36")
			elseif i <= 5 and i >= 2 then
				Portrait:SetNormalTexture(_G["CharacterBag"..(i - 2).."SlotIconTexture"]:GetTexture())
			elseif i <= 12 and i >= 6 then
				Portrait:SetNormalTexture(BankSlotsFrame["Bag"..(i-5)].icon:GetTexture())
			end
			if Portrait:GetNormalTexture() then
				AS:SkinTexture(Portrait:GetNormalTexture())
				Portrait:GetNormalTexture():SetInside()
			end
		end
	end

	hooksecurefunc('BankFrameItemButton_Update', UpdateBagIcon)
	hooksecurefunc('ContainerFrame_Update', UpdateBagIcon)

	AS:SkinEditBox(BagItemSearchBox)
	BackpackTokenFrame:StripTextures()

	AS:SkinButton(BagItemAutoSortButton)
	BagItemAutoSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
	BagItemAutoSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
	AS:SkinTexture(BagItemAutoSortButton:GetNormalTexture())
	BagItemAutoSortButton:GetNormalTexture():SetInside()
	AS:SkinTexture(BagItemAutoSortButton:GetPushedTexture())
	BagItemAutoSortButton:GetPushedTexture():SetInside()
	BagItemAutoSortButton:Size(22)

	BagItemAutoSortButton:SetScript('OnShow', function(self)
		local a, b, c, d, e = self:GetPoint()
		self:SetPoint(a, b, c, d - 3, e - 1)
		self.SetPoint = AS.Noop
		self:SetScript('OnShow', nil)
	end)

	for i = 1, 3 do
		local Token = _G["BackpackTokenFrameToken"..i]
		AS:SkinTexture(Token.icon)
		Token:CreateBackdrop("Default")
		local Backdrop = Token.Backdrop or Token.backdrop
		Backdrop:SetOutside(Token.icon)
		Token.icon:Point("LEFT", Token.count, "RIGHT", 3, 0)
	end
end

AS:RegisterSkin(name, AS.Blizzard_Bags)