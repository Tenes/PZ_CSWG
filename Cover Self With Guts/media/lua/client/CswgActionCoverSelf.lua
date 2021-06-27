require "TimedActions/ISBaseTimedAction"

CswgActionCoverSelf = ISBaseTimedAction:derive("CswgActionCoverSelf");

function CswgActionCoverSelf:isValid()
	return true;
end--function

function ISPaintAction:waitToStart()
	self.character:faceThisObject(self.corpse or self.bottom);
	return self.character:shouldBeTurning();
end

function CswgActionCoverSelf:update()
	self.character:faceThisObject(self.corpse or self.bottom);
end--function

function CswgActionCoverSelf:start()
	self:setActionAnim("WashFace");
	self.character:SetVariable("LootPosition", "Low");
	self.character:playSound("HeadStab");
end--function

function CswgActionCoverSelf:stop()
	ISBaseTimedAction.stop(self);
end--function

function CswgActionCoverSelf:perform()	
	local inv = self.character:getInventory();
	addBloodSplat(self.character, ZombRand(30, 60));
	-- for i=0,BloodBodyPartType.MAX:index()-1 do
	-- 	local part = BloodBodyPartType.FromIndex(i);
	-- 	part:setBloodLevel(100);
	-- end--for
	self.corpse:getModData().GutsUsed = true;
	ISBaseTimedAction.perform(self);
end--function

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
	return o;
end--function
