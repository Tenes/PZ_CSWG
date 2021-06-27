-- Add the option to the UI world menu
function Cswg_BuildZombieWM(playerNum, context, worldobjects, test)
    local player = getSpecificPlayer(playerNum);
	local inv = player:getInventory();
	local square = player:getCurrentSquare();
	local subMenu = nil;
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
						if instanceof(obj, "IsoDeadBody") then
							if not(subMenu) then
								subMenu = ISContextMenu:getNew(context);
								context:addSubMenu(context:addOption(getText("ContextMenu_CswgCutOpen"), worldobjects, nil), subMenu);
							end--if
						end--if
					end--for
				end--for
			end--for
        end--if
    end--for
end--function

---------------------------------------- Events ----------------------------------------
Events.OnFillWorldObjectContextMenu.Add(Cswg_BuildZombieWM);