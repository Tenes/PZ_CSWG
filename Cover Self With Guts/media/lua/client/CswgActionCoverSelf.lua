require "TimedActions/ISBaseTimedAction"

CswgActionCoverSelf = ISBaseTimedAction:derive("CswgActionCoverSelf");

function CswgActionCoverSelf:isValid()
	return true;
end

function ISPaintAction:waitToStart()
	self.character:faceThisObject(self.corpse or self.bottom);
	return self.character:shouldBeTurning();
end

function CswgActionCoverSelf:update()
	self.character:faceThisObject(self.corpse or self.bottom);
	self.actionAudio = Cswg_HandleAudioLoop(self.soundEmitter, self.actionSound, self.actionAudio);
end

function CswgActionCoverSelf:start()
	self.actionAudio = Cswg_HandleAudioStart(self.soundEmitter, self.actionSound);
	self:setActionAnim("WashFace");
	self.character:SetVariable("LootPosition", "Low");
end

function CswgActionCoverSelf:stop()
	ISBaseTimedAction.stop(self);
end

function CswgActionCoverSelf:perform()
	Cswg_HandleAudioPerform(self.soundEmitter, self.actionAudio);
	local visual = self.character:getHumanVisual();
	local inv = self.character:getInventory();
	addBloodSplat(self.character:getSquare(), ZombRand(60, 100));
	local clothingInventory = inv:getItemsFromCategory("Clothing");
	local item;
	local coveredParts;
	local part;
	for i=0, clothingInventory:size() - 1 do
		item = clothingInventory:get(i);
		if(self.character:isEquippedClothing(item)) then
			item:setBloodLevel(100);
			coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType());
			if coveredParts then
				for i=0,coveredParts:size()-1 do
					part = coveredParts:get(i)
					visual:setBlood(part, 100);
				end
			coveredParts = nil;
			end
		end
	end
	self.corpse:getModData().GutsUsed = true;
	ISBaseTimedAction.perform(self);
end

function CswgActionCoverSelf:new(character, corpse, square)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o.character = character;
	o.corpse = corpse;
	o.square = square;
	o.maxTime = 300;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.actionSound = "HeadStab";
	o.actionAudio = 0;
	o.soundEmitter = character:getEmitter();
	return o;
end
