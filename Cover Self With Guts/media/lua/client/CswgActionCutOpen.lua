require "TimedActions/ISBaseTimedAction"

CswgActionCutOpen = ISBaseTimedAction:derive("CswgActionCutOpen");

CswgCutOpenAction.soundDelay = 3
CswgCutOpenAction.soundTime = 0

function CswgActionCutOpen:isValid()
	return true;
end

function ISPaintAction:waitToStart()
	self.character:faceThisObject(self.corpse or self.bottom);
	return self.character:shouldBeTurning();
end

function CswgActionCutOpen:update()
	self.character:faceThisObject(self.corpse or self.bottom);
	self.actionAudio = Cswg_HandleAudioLoop(self.soundEmitter, self.actionSound, self.actionAudio);
end

function CswgActionCutOpen:start()
	self.actionAudio = Cswg_HandleAudioStart(self.soundEmitter, self.actionSound);
	self:setActionAnim("Loot");
	self.character:SetVariable("LootPosition", "Low");
end

function CswgActionCutOpen:stop()
	ISBaseTimedAction.stop(self);
end

function CswgActionCutOpen:perform()
	Cswg_HandleAudioPerform(self.soundEmitter, self.actionAudio);
	if self.character:HasTrait("Hemophobic") then
		self.character:getStats():setPanic(self.character:getStats():getPanic()+10);
	end
	addBloodSplat(self.corpse:getSquare(), ZombRand(200, 300));
	self.corpse:getModData().CutOpen = true;
	ISBaseTimedAction.perform(self);
end

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
	o.actionSound = "SliceMeat";
	o.actionAudio = 0;
	o.soundEmitter = character:getEmitter();
	return o;
end
