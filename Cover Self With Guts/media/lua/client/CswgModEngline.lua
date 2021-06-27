local _cuttingItemNames = {
	"MeatCleaver",
	"HandAxe",
	"HandScythe",
	"Machete",
	"Katana",
	"AxeStone",
	"Shovel",
	"Shovel2",
	"GardenHoe",
	"PickAxe",
	"Axe",
	"WoodAxe",
	"SmashedBottle",
	"HandFork",
	"HuntingKnife",
	"FlintKnife",
	"LetterOpener",
	"Scissors",
	"Scalpel",
	"KitchenKnife",
	"GardenFork",
	"SpearLetterOpener",
	"SpearScalpel",
	"SpearScissors",
	"SpearHandFork",
	"SpearHuntingKnife",
	"SpearMachete",
	"SpearKnife",
	"Fork",
	"Spoon"
}


---------------------------------------- World Context Menus ----------------------------------------

-- Checks wether or not the item is broken
local function Cswg_PredicateNotBroken(item)
	return not item:isBroken();
end--function

-- Add the option to the UI world menu
function Cswg_BuildZombieWM(playerNum, context, worldobjects, test)
    local player = getSpecificPlayer(playerNum);
	local inv = player:getInventory();
	local square = player:getCurrentSquare();
    for _, v in ipairs(worldobjects) do
		local sq = v:getSquare();
		if sq then
            for y = sq:getY()-1, sq:getY()+1 do
				for x = sq:getX()-1, sq:getX()+1 do
					local square = getCell():getGridSquare(x, y, sq:getZ());
					if not(square) then
						break;
					end--if
					for i = 0, square:getStaticMovingObjects():size()-1 do
						local obj = square:getStaticMovingObjects():get(i);
						if not(obj:getModData().CutOpen) and instanceof(obj, "IsoDeadBody") then
							local option = context:addOption(getText("ContextMenu_CswgCutOpen"), player, Cswg_WMOnCutOpen, obj, square, nil, nil);
							Cswg_CreateCutOpenTooltip(option, inv);
						end--if
						if obj:getModData().CutOpen and not(obj:getModData().GutsUsed) then
							local option = context:addOption(getText("ContextMenu_CswgCoverSelf"), player, Cswg_WMOnCoverSelf, obj, square, nil, nil);
							Cswg_CreateCoverSelfTooltip(option, player);
						end--if
					end--for
				end--for
			end--for
        end--if
    end--for
end--function

-- Add check line for the option tooltip
function Cswg_CreateCheckTooltip(option, inventory, moduleName, itemTypes, count, noBroken)
	local n = 0;
	for _, v in ipairs(itemTypes) do
		if noBroken then
			n = n+inventory:getCountTypeEvalRecurse(v, Cswg_PredicateNotBroken);
		else
			n = n+inventory:getItemCountRecurse(v);
		end--if
	end--for
	return n >= count;
end--function

-- Create Cut Open option tooltip
function Cswg_CreateCutOpenTooltip(option, inventory)
	local tooltip = ISInventoryPaneContextMenu.addToolTip();
	option.toolTip = tooltip;
	tooltip.description = tooltip.description..getText("ContextMenu_CswgMustHaveItems");
	option.notAvailable = not(Cswg_CreateCheckTooltip(option, inventory, "Base", _cuttingItemNames, 1, true));
end--function

-- Create Cover Self option tooltip
function Cswg_CreateCoverSelfTooltip(option, player)
	local tooltip = ISInventoryPaneContextMenu.addToolTip();
	option.toolTip = tooltip;
	tooltip.description = tooltip.description..getText("ContextMenu_CswgCoverSelfRequirement");
	option.notAvailable = player:HasTrait("Hemophobic");
end--function

-- Cut Open the zombie
function Cswg_WMOnCutOpen(player, corpse, square, top, bottom)
	if (corpse and luautils.walkAdj(player, corpse:getSquare())) or luautils.walkAdj(player, bottom:getSquare()) then
		local inv = player:getInventory();
		local weapon = nil; 
		for _, weaponName in ipairs(_cuttingItemNames) do
			weapon = inv:getFirstTypeEvalRecurse(weaponName, Cswg_PredicateNotBroken);
			if weapon then
				break;
			end--if
		end--for
		ISInventoryPaneContextMenu.equipWeapon(weapon, true, false, player:getPlayerNum());
		ISTimedActionQueue.add(CswgActionCutOpen:new(player, corpse, square));
	end--if
end--function

-- Cover Self with guts
function Cswg_WMOnCoverSelf(player, corpse, square, top, bottom)
	if (corpse and luautils.walkAdj(player, corpse:getSquare())) or luautils.walkAdj(player, bottom:getSquare()) then
		ISTimedActionQueue.add(CswgActionCoverSelf:new(player, corpse, square));
	end--if
end--function

---------------------------------------- Events ----------------------------------------
Events.OnFillWorldObjectContextMenu.Add(Cswg_BuildZombieWM);