require "TimedActions/ISBaseTimedAction"

CswgActionCutOpen = ISBaseTimedAction:derive("CswgActionCutOpen");

function CswgActionCutOpen:isValid()
	return true;
end--function

function ISPaintAction:waitToStart()
	self.character:faceThisObject(self.corpse or self.bottom);
	return self.character:shouldBeTurning();
end

function CswgActionCutOpen:update()
	self.character:faceThisObject(self.corpse or self.bottom);
end--function

function CswgActionCutOpen:start()
	self:setActionAnim("Loot");
	self.character:SetVariable("LootPosition", "Low");
	self.character:playSound("SliceMeat");
end--function

function CswgActionCutOpen:stop()
	ISBaseTimedAction.stop(self);
end--function

function CswgActionCutOpen:perform()	
	if self.character:HasTrait("Hemophobic") then
		self.character:getStats():setPanic(self.character:getStats():getPanic()+10);
	end--if
	addBloodSplat(self.square, ZombRand(30, 60));
	self.corpse:getModData().CutOpen = true;
	ISBaseTimedAction.perform(self);
end--function

function CswgActionCutOpen:new(character, corpse, square)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o.character = character;
	o.corpse = corpse;
	o.square = square;
	o.maxTime = 500;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	return o;
end--function
