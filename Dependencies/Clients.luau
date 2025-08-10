local Library: { [any]: any } = {}

Library.__index = Library

local FindFirstChild : (any) = workspace.FindFirstChild
local FindFirstChildOfClass : (any) = workspace.FindFirstChildOfClass

local CloneReference : (any) = cloneref or function(...: any): any
	return ...
end

local Players: Players = CloneReference(game:GetService("Players"))
local UserInputService: UserInputService = CloneReference(game:GetService("UserInputService"))

local Camera: Camera = workspace.CurrentCamera
local LocalPlayer: Player = Players.LocalPlayer

Library.IsAlive = function(self, Player: Player): boolean
	local Character: Model = Library:GetCharacter(Player)

	if not Character then
		return false
	end

	local HumanoidRootPart: BasePart = Library:GetHumanoidRootPart(Character)
	local Humanoid: Humanoid = Library:GetHumanoid(Character)

	if not HumanoidRootPart or not Humanoid then
		return false
	end

	if Humanoid.Health < 0 then
		return false
	end

	return true, Character, HumanoidRootPart, Humanoid
end

Library.IsFriendly = function(self, Player: Player, SecondPlayer: Player, IncludeTeam: boolean?): boolean
	local Team1: Team = Player.Team
	local Team2: Team = SecondPlayer.Team
	local IsFriendly: boolean = Team1 == Team2

	return IsFriendly, Team1, Team2
end

Library.GetCharacter = function(self, Player: Player): Model?
	return Player.Character
end

Library.GetHumanoidRootPart = function(self, Character: Model?): Part?
	return FindFirstChild(Character, "HumanoidRootPart")
end

Library.GetHumanoid = function(self, Character: Model?): Humanoid?
	return FindFirstChildOfClass(Character, "Humanoid")
end

Library.GetHealth = function(self, Humanoid: Humanoid): number
	return Humanoid.Health, Humanoid.MaxHealth
end

Library.GetBodyParts = function(self, Character: Model, RootPart: Part?, Indexes: boolean?, Hitboxes: { string }) : {BasePart}
	local Parts: { [any]: any } = {}
	local BodyParts: { string } = Hitboxes or { "Head", "Torso", "Arms", "Legs" }

	for Index, Part in pairs(Character:GetChildren()) do
		if Part:IsA("BasePart") and Part ~= RootPart then
			if table.find(BodyParts, "Head") and Part.Name:lower():find("head") then
				Parts[Indexes and Part.Name or #Parts + 1] = Part
			elseif table.find(BodyParts, "Torso") and Part.Name:lower():find("torso") then
				Parts[Indexes and Part.Name or #Parts + 1] = Part
			elseif table.find(BodyParts, "Arms") and Part.Name:lower():find("arm") then
				Parts[Indexes and Part.Name or #Parts + 1] = Part
			elseif table.find(BodyParts, "Legs") and Part.Name:lower():find("leg") then
				Parts[Indexes and Part.Name or #Parts + 1] = Part
			elseif
				(table.find(BodyParts, "Arms") and Part.Name:lower():find("hand"))
				or (table.find(BodyParts, "Legs") and Part.Name:lower():find("foot"))
			then
				Parts[Indexes and Part.Name or #Parts + 1] = Part
			end
		end
	end

	return Parts
end

Library.GetClosestPlayer = function(self, Mode: string?, Validate: ( Player: Player, Magnitude: number, Character: Model?, HumanoidRootPart: BasePart?, Humanoid: Humanoid, CurrentPlayer: Player ) -> boolean ): Player
	Mode = Mode or "Mouse" -- // Mouse, Character
	Validate = Validate or function()
		return true
	end

	local Mouse: Vector2 = UserInputService:GetMouseLocation()
	local ClosestPlayer: Player = nil
	local PlayerMagnitude: number = math.huge

	if Mode == "Mouse" then
		for Index, Player in next, Players:GetChildren() do
			if Player == LocalPlayer then
				continue
			end
			local Alive, Character, HumanoidRootPart, Humanoid = Library:IsAlive(Player, true)
			if not Alive then
				continue
			end

			local ScreenPosition = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
			local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
			local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - MousePosition).Magnitude

			if not Validate(Player, Magnitude, Character, HumanoidRootPart, Humanoid, ClosestPlayer) then
				continue
			end

			if Magnitude > PlayerMagnitude then
				continue
			end

			ClosestPlayer = Player
			PlayerMagnitude = Magnitude
		end
	elseif Mode == "Character" then
		-- // uhh make the logic here!!1
	end

	return ClosestPlayer, PlayerMagnitude
end

Library.GetClosestBodyPart = function(self, Character: Model, List: { [any]: BasePart })
	local Mouse: Vector2 = UserInputService:GetMouseLocation()
	local ClosestPart: BasePart = nil
	local PartMagnitude: number = math.huge

	for _, Object in next, Character:GetChildren() do
		if Object:IsA("BasePart") then
			local Position = Camera:WorldToViewportPoint(Object.Position)
			local Magnitude = (Vector2.new(Position.X, Position.Y) - Mouse).Magnitude

			if Magnitude < PartMagnitude and table.find(List, Object) then
				ClosestPart = Object
				PartMagnitude = Magnitude
			end
		end
	end

	return ClosestPart, PartMagnitude
end

return Library