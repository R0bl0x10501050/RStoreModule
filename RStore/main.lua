--// Prerequisites \\--

local DSS = game:GetService("DataStoreService")
local RS = game:GetService("RunService")

local Class = require(script.Class)

local _SIS

--// Module \\--

local RStore = {}
RStore["Stores"] = {}
RStore.__index = RStore

--// LOCAL FUNCTIONS

local function cprint(msg)
	if script:GetAttribute("CONFIG_PRINTDEBUG") == true then
		print(msg)
	end
end

local function iprint(msg)
	if script:GetAttribute("CONFIG_PRINTIMPORTANT") == true then
		print(msg)
	end
end

function checkIfInstance(obj)
	local s1, r1 = pcall(function()
		if not obj.Parent then return false end -- check instance
	end)
	
	if s1 then
		local s2, r2 = pcall(function()
			if not obj.Name then return false end -- check instance
		end)
		
		if s2 then return true end
	end
	
	return false
end

function checkIfPlayer(obj)
	if not checkIfInstance(obj) then return false end -- check instance
	
	local s1, r1 = pcall(function()
		if not obj.UserId then return false end -- check player
	end)
	
	if s1 then
		local s2, r2 = pcall(function()
			if not obj.Name then return false end -- check instance
		end)
		
		if s2 then
			local s3, r3 = pcall(function()
				if not obj.DisplayName then return false end -- check player
			end)
			
			if s3 then return true end
		end
	end
	
	return false
end

function determineObjType(obj)
	if checkIfPlayer(obj) then
		return 'plr'
	elseif checkIfInstance(obj) then
		return 'obj'
	else
		return 'neither'
	end
end

function checkForNewObj(self, obj)
	if table.find(self["Objs"], obj) then return false end
	table.insert(self["Objs"], #self["Objs"]+1, obj)
	return true
end

function getKey(obj, dkey)
	local typofobj = determineObjType(obj)
	local key = game.PlaceId
	
	if typofobj == "plr" then
		key = key .. obj.UserId .. dkey
	elseif typofobj == "obj" then
		key = key .. obj.Name .. dkey
	elseif typofobj == "neither" then
		key = key .. obj .. dkey
	end
	
	return key
end

local function update(self, obj)
	if not self.Callbacks["OnUpdate"] then return end
	self.Callbacks["OnUpdate"](self:Get(obj, 0))
end

--// RDataStore CLASS

local RDataStore = Class{
	__init__ = function(self, datakey)
		self.DataKey = datakey
		self.Objs = {}
		self.Callbacks = {}
	end,
	
	GetAsync = function(self, obj)
		local key = getKey(obj, self.DataKey)
		local _potentialData
		
		local s, r = pcall(function()
			cprint("GET KEY: "..key)
			_potentialData = DSS:GetDataStore(key):GetAsync("data")
		end)
		
		cprint("GetAsync Output Begin")
		cprint(s)
		cprint(r)
		cprint("GetAsync Output End")
		
		return _potentialData
	end,
	
	Get = function(self, obj, defval)
		checkForNewObj(self, obj)
		local key = getKey(obj, self.DataKey)
		local res
		
		if not self[key] then -- if not in cache
			cprint("not in cache")
			local APIRes = self:GetAsync(obj)
			
			if not APIRes then -- if not in API
				cprint("not in api")
				self[key] = defval
				res = defval
			else
				res = APIRes
				self[key] = APIRes
			end
		else
			cprint("in cache")
			res = self[key]
		end
		
		return res
	end,
	
	Set = function(self, obj, data)
		checkForNewObj(self, obj)
		local _cache
		local key = getKey(obj, self.DataKey)
		
		if typeof(data) == "table" then
			_cache = self:Get(obj, {})
		elseif typeof(data) == "number" then
			_cache = self:Get(obj, 0)
		elseif typeof(data) == "string" then
			_cache = self:Get(obj, "")
		end
		
		if _cache == data then return _cache end
		
		if typeof(data) == "table" then
			for _, v in ipairs(data) do
				table.insert(_cache, #_cache, v)
			end
		else
			_cache = data
		end
		
		self[key] = _cache
		
		update(self, obj)
		
		return _cache
	end,
	
	Increment = function(self, obj, amt)
		local currData = self:Get(obj)
		if not typeof(currData) == "number" or not typeof(currData) == "float" then warn("You can only :Increment() an integer/float!") return end
		self:Set(obj, currData + tonumber(amt))
		return self:Get(obj)
	end,
	
	Save = function(self, obj)
		checkForNewObj(self, obj)
		
		if (RS:IsStudio() and _SIS == true) or (not RS:IsStudio()) then
			local key = getKey(obj, self.DataKey)
			
			if not self[key] then iprint(key.." | Cache No Longer Exists!") return end
			
			local currData = self[key]
			
			local s, r = pcall(function()
				cprint("Entered Save PCall")
				cprint("SAVE KEY: "..key)
				cprint(currData)
				DSS:GetDataStore(key):SetAsync("data", currData)
			end)
			
			cprint("Save Output Begin")
			cprint(s)
			cprint(r)
			cprint("Save Output End")
			
			if s then return end
			cprint(r)
			
			return currData
		else
			return
		end
	end,
	
	SaveAll = function(self)
		local objs = self["Objs"]
		
		cprint(objs)
		for _, v in ipairs(objs) do
			self:Save(v)
		end
	end,
	
	OnUpdate = function(self, callbackFunc)
		self.Callbacks["OnUpdate"] = callbackFunc
	end,
}

function RStore.new(datakey)
	local newStore = RDataStore.new(datakey)
	table.insert(RStore["Stores"], #RStore["Stores"]+1, newStore)
	return newStore
end


game:BindToClose(function()
	for i, rDS in ipairs(RStore["Stores"]) do
		cprint(rDS)
		rDS:SaveAll()
	end
end)

-- Game Loaded

function onLoaded()
	if not RS:IsStudio() then return end
	local sis = game.ServerStorage:FindFirstChild("SaveInStudio")
	if not sis or not sis:IsA("BoolValue") then
		warn("game.ServerStorage.SaveInStudio is nonexistant or not a BoolValue - data will not save in Studio!")
		_SIS = false
	elseif sis.Value == true then
		_SIS = true
	end
end

onLoaded()

return RStore
