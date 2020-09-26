--get some globals
local TUNING = GLOBAL.TUNING
local require = GLOBAL.require

--+++++++++++++++++++
-- FOOD RECIPES CHANGES
--+++++++++++++++++++
local recipesnerf =  GetModConfigData("recipesnerf")
local cooking = require"cooking"
--nerf baconeggs
local baconeggs = cooking.recipes.cookpot.baconeggs
baconeggs.test = function(cooker, names, tags) return tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and not tags.veggie and not tags.monster end
if recipesnerf then
	baconeggs.health = TUNING.HEALING_MED/2
	baconeggs.hunger = TUNING.CALORIES_HUGE*2/3
end
--nerf meatballs
local meatballs = cooking.recipes.cookpot.meatballs
meatballs.test = function(cooker, names, tags) return tags.meat and tags.meat >= 1 and not tags.inedible and not tags.frozen and not tags.monster end
if recipesnerf then
	meatballs.hunger = TUNING.CALORIES_SMALL*4
	meatballs.cooktime = 1.5
end
--nerf perogies
local perogies = cooking.recipes.cookpot.perogies
perogies.test = function(cooker, names, tags) return tags.egg and tags.meat and tags.veggie and not tags.inedible and not tags.monster end
if recipesnerf then
	perogies.health = TUNING.HEALING_MED
	perogies.perishtime = TUNING.PERISH_SLOW
end
--make monsterlasagna instead of wetgoo
local monsterlasagna = cooking.recipes.cookpot.monsterlasagna
monsterlasagna.test = function(cooker, names, tags) return (tags.monster and tags.monster >= 2 and not tags.inedible) or
														   (tags.egg and tags.meat and tags.veggie and tags.monster and not tags.inedible) or
														   (tags.egg and tags.egg > 1 and tags.meat and tags.meat > 1 and tags.monster and not tags.veggie)end
--+++++++++++++++++++
-- FOOD RECIPES CHANGES - END
--+++++++++++++++++++
--+++++++++++++++++++
-- BIRD CHANGES
--+++++++++++++++++++
AddPrefabPostInitAny(function(inst)
	if inst:HasTag("bird") then
		inst:AddComponent("weakstomach")
	end
end)
--+++++++++++++++++++
-- BIRD CHANGES - END
--+++++++++++++++++++
--+++++++++++++++++++
-- BIRDCAGE CHANGES
--+++++++++++++++++++
--old function container
local old_onaccept = nil		   

--kill the bird
local function BirdDeath(inst,bird)
	if bird and bird:IsValid() and bird.components.perishable then
		bird.components.perishable:SetPercent(0)
	end
end
local function OnGetItem(inst, giver, item,...)
	local bird = inst.components.occupiable and inst.components.occupiable:GetOccupant()
	--check if monstermeat is eaten
	if item.prefab == "cookedmonstermeat" or item.prefab == "monstermeat_dried" then
		if bird.components.weakstomach:GetWS() > 0 then
			bird.components.weakstomach:DecWS()
		end
	end
	--if enough monstermeat is eaten, the bird dies
	if bird.components.weakstomach:GetWS() == 0 and (item.prefab == "cookedmonstermeat" or item.prefab == "monstermeat_dried") then
		inst:KillTasks()
		inst.AnimState:PushAnimation("idle".."_bird", true)
		BirdDeath(inst, bird)
	--return old function, the bird survives
	elseif old_onaccept~=nil then
		return old_onaccept(inst,giver,item,...)
	end
end
local function AddOnAccept(inst)
	--save old function
	old_onaccept = inst.components.trader.onaccept
	inst.components.trader.onaccept = function(inst, giver, item,...) OnGetItem(inst, giver, item,...) end
end
AddPrefabPostInit("birdcage", AddOnAccept)
--+++++++++++++++++++
-- BIRDCAGE CHANGES - END
--+++++++++++++++++++
--+++++++++++++++++++
-- WEREPIG CHANGES
--+++++++++++++++++++
--old function container
local old_SetOnWereFn = nil
local function SetWerePig(inst,...)
	old_SetOnWereFn(inst,...)
	--loot nerf
	inst.components.lootdropper:SetLoot({ "meat", "pigskin" })
	inst.components.lootdropper.numrandomloot = 0
end
local function AddSetWerePig(inst)
	--save old function
	old_SetOnWereFn = inst.components.werebeast.onsetwerefn
	inst.components.werebeast:SetOnWereFn(SetWerePig)
end
AddPrefabPostInit("pigman", AddSetWerePig)
--+++++++++++++++++++
-- WEREPIG CHANGES - END
--+++++++++++++++++++








