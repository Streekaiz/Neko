local Library: { [any]: any } = {}

Library.__index = Library

local CloneReference : (any) = cloneref or function(...: any)
	return ...
end

Library.Create = function(self, Signal: RBXScriptSignal, Callback: (any), Name: string): RBXScriptConnection
	local Connection: RBXScriptConnection = Signal:Connect(Callback)
	Library[Name or #Library + 1] = Connection

	return Connection
end

Library.BindToRenderStep = function(self, Callback : (any), Priority : number, Name : string) : RBXScriptConnection
    local Connection : RBXScriptConnection = CloneReference(game:GetService("RunService")):BindToRenderStep(Name, Priority, Callback)
    Library[Name or #Library + 1] = Connection

    return Connection 
end 

Library.Disconnect = function(self, Name: string)
	self[Name]:Disconnect()
end

Library.Register = function(self, Connection: RBXScriptConnection, Name: string): RBXScriptConnection
	Library[Name or #Library + 1] = Connection

	return Connection
end

Library.Clean = function(self)
	for Index, Connection in next, Library do
		Connection:Disconnect()
	end
end

return Library
