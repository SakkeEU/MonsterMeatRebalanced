local WeakStomach = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("weakstomach")
	self.ws = 2
	self.inst:WatchWorldState("isday", function(inst) self.ws = 2 end)
end)
function WeakStomach:GetWS()
	return self.ws
end
function WeakStomach:DecWS()
	self.ws = self.ws - 1
end
return WeakStomach