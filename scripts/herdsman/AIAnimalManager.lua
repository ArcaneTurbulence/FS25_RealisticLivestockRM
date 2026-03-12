AIAnimalManager = {}

local AIAnimalManager_mt = Class(AIAnimalManager)


function AIAnimalManager.new(husbandry, isServer)

	local self = setmetatable({}, AIAnimalManager_mt)

	self.husbandry = husbandry
	self.isServer = isServer
	self.wage = 0
	self.isProfile = false

	self.ANIMAL_TYPE_TO_WAGE = {
		[AnimalType.COW]     = 20,
		[AnimalType.SHEEP]   = 12.5,
		[AnimalType.PIG]     = 10,
		[AnimalType.HORSE]   = 25,
		[AnimalType.CHICKEN] = 2
	}

	self.settings = {
		["buy"] = {
			["enabled"]    = false,
			["budget"] = {
				["type"]       = "fixed",
				["fixed"]      = 5000,
				["percentage"] = 1
			},
			["maxAnimals"] = 5,
			["breed"]      = "any",
			["diseases"]   = false,
			["gender"]     = "any",
			["age"]          = { ["min"] = 0,  ["max"] = 999 },
			["quality"]      = { ["min"] = 25, ["max"] = 175 },
			["health"]       = { ["min"] = 25, ["max"] = 175 },
			["fertility"]    = { ["min"] = 0,  ["max"] = 175 },
			["productivity"] = { ["min"] = 25, ["max"] = 175 },
			["metabolism"]   = { ["min"] = 25, ["max"] = 175 }
		},
		["sell"] = {
			["enabled"]    = false,
			["maxAnimals"] = 5,
			["mark"]       = false,
			["diseases"]   = false,
			["gender"]     = "any",
			["age"]          = { ["min"] = 0,  ["max"] = 999 },
			["quality"]      = { ["min"] = 25, ["max"] = 175 },
			["health"]       = { ["min"] = 25, ["max"] = 175 },
			["fertility"]    = { ["min"] = 0,  ["max"] = 175 },
			["productivity"] = { ["min"] = 25, ["max"] = 175 },
			["metabolism"]   = { ["min"] = 25, ["max"] = 175 }
		},
		["castrate"] = {
			["enabled"]    = false,
			["mark"]       = false,
			["diseases"]   = false,
			["age"]          = { ["min"] = 0,  ["max"] = 0   },
			["quality"]      = { ["min"] = 25, ["max"] = 175 },
			["health"]       = { ["min"] = 25, ["max"] = 175 },
			["fertility"]    = { ["min"] = 0,  ["max"] = 175 },
			["productivity"] = { ["min"] = 25, ["max"] = 175 },
			["metabolism"]   = { ["min"] = 25, ["max"] = 175 }
		},
		["naming"] = {
			["enabled"]    = false,
			["convention"] = "random",
			["previous"]   = nil
		},
		["ai"] = {
			["enabled"]    = false,
			["maxAnimals"] = 5,
			["mark"]       = false,
			["diseases"]   = false,
			["semen"]      = "any",
			["age"]          = { ["min"] = 0,  ["max"] = 999 },
			["quality"]      = { ["min"] = 25, ["max"] = 175 },
			["health"]       = { ["min"] = 25, ["max"] = 175 },
			["fertility"]    = { ["min"] = 0,  ["max"] = 175 },
			["productivity"] = { ["min"] = 25, ["max"] = 175 },
			["metabolism"]   = { ["min"] = 25, ["max"] = 175 }
		}
	}

	return self

end


function AIAnimalManager:saveToXMLFile(xmlFile, baseKey)

	local key = self.isProfile and baseKey or (baseKey .. ".AIAnimalManager")
	local s = self.settings

	if not self.isProfile then xmlFile:setFloat(key .. "#wage", self.wage) end


	-- BUY SETTINGS

	xmlFile:setBool(key .. ".buy#enabled",              s.buy.enabled)
	xmlFile:setString(key .. ".buy.budget#type",        s.buy.budget.type)
	xmlFile:setInt(key .. ".buy.budget#fixed",          s.buy.budget.fixed)
	xmlFile:setFloat(key .. ".buy.budget#percentage",   s.buy.budget.percentage)
	xmlFile:setInt(key .. ".buy#maxAnimals",            s.buy.maxAnimals)
	xmlFile:setString(key .. ".buy#breed",              s.buy.breed)
	xmlFile:setBool(key .. ".buy#diseases",             s.buy.diseases)
	xmlFile:setString(key .. ".buy#gender",             s.buy.gender)
	xmlFile:setInt(key .. ".buy.age#min",               s.buy.age.min)
	xmlFile:setInt(key .. ".buy.age#max",               s.buy.age.max)
	xmlFile:setInt(key .. ".buy.quality#min",           s.buy.quality.min)
	xmlFile:setInt(key .. ".buy.quality#max",           s.buy.quality.max)
	xmlFile:setInt(key .. ".buy.health#min",            s.buy.health.min)
	xmlFile:setInt(key .. ".buy.health#max",            s.buy.health.max)
	xmlFile:setInt(key .. ".buy.fertility#min",         s.buy.fertility.min)
	xmlFile:setInt(key .. ".buy.fertility#max",         s.buy.fertility.max)
	xmlFile:setInt(key .. ".buy.productivity#min",      s.buy.productivity.min)
	xmlFile:setInt(key .. ".buy.productivity#max",      s.buy.productivity.max)
	xmlFile:setInt(key .. ".buy.metabolism#min",        s.buy.metabolism.min)
	xmlFile:setInt(key .. ".buy.metabolism#max",        s.buy.metabolism.max)


	-- SELL SETTINGS

	xmlFile:setBool(key .. ".sell#enabled",             s.sell.enabled)
	xmlFile:setInt(key .. ".sell#maxAnimals",           s.sell.maxAnimals)
	xmlFile:setBool(key .. ".sell#mark",                s.sell.mark)
	xmlFile:setBool(key .. ".sell#diseases",            s.sell.diseases)
	xmlFile:setString(key .. ".sell#gender",            s.sell.gender)
	xmlFile:setInt(key .. ".sell.age#min",              s.sell.age.min)
	xmlFile:setInt(key .. ".sell.age#max",              s.sell.age.max)
	xmlFile:setInt(key .. ".sell.quality#min",          s.sell.quality.min)
	xmlFile:setInt(key .. ".sell.quality#max",          s.sell.quality.max)
	xmlFile:setInt(key .. ".sell.health#min",           s.sell.health.min)
	xmlFile:setInt(key .. ".sell.health#max",           s.sell.health.max)
	xmlFile:setInt(key .. ".sell.fertility#min",        s.sell.fertility.min)
	xmlFile:setInt(key .. ".sell.fertility#max",        s.sell.fertility.max)
	xmlFile:setInt(key .. ".sell.productivity#min",     s.sell.productivity.min)
	xmlFile:setInt(key .. ".sell.productivity#max",     s.sell.productivity.max)
	xmlFile:setInt(key .. ".sell.metabolism#min",       s.sell.metabolism.min)
	xmlFile:setInt(key .. ".sell.metabolism#max",       s.sell.metabolism.max)


	-- CASTRATE SETTINGS

	xmlFile:setBool(key .. ".castrate#enabled",         s.castrate.enabled)
	xmlFile:setBool(key .. ".castrate#mark",            s.castrate.mark)
	xmlFile:setBool(key .. ".castrate#diseases",        s.castrate.diseases)
	xmlFile:setInt(key .. ".castrate.age#min",          s.castrate.age.min)
	xmlFile:setInt(key .. ".castrate.age#max",          s.castrate.age.max)
	xmlFile:setInt(key .. ".castrate.quality#min",      s.castrate.quality.min)
	xmlFile:setInt(key .. ".castrate.quality#max",      s.castrate.quality.max)
	xmlFile:setInt(key .. ".castrate.health#min",       s.castrate.health.min)
	xmlFile:setInt(key .. ".castrate.health#max",       s.castrate.health.max)
	xmlFile:setInt(key .. ".castrate.fertility#min",    s.castrate.fertility.min)
	xmlFile:setInt(key .. ".castrate.fertility#max",    s.castrate.fertility.max)
	xmlFile:setInt(key .. ".castrate.productivity#min", s.castrate.productivity.min)
	xmlFile:setInt(key .. ".castrate.productivity#max", s.castrate.productivity.max)
	xmlFile:setInt(key .. ".castrate.metabolism#min",   s.castrate.metabolism.min)
	xmlFile:setInt(key .. ".castrate.metabolism#max",   s.castrate.metabolism.max)


	-- NAMING SETTINGS

	xmlFile:setBool(key .. ".naming#enabled",           s.naming.enabled)
	xmlFile:setString(key .. ".naming#convention",      s.naming.convention)
	if not self.isProfile and s.naming.previous ~= nil and s.naming.convention == "alphabetical" then
		xmlFile:setString(key .. ".naming#previous", s.naming.previous)
	end


	-- AI SETTINGS

	xmlFile:setBool(key .. ".ai#enabled",               s.ai.enabled)
	xmlFile:setInt(key .. ".ai#maxAnimals",             s.ai.maxAnimals)
	xmlFile:setBool(key .. ".ai#mark",                  s.ai.mark)
	xmlFile:setBool(key .. ".ai#diseases",              s.ai.diseases)
	xmlFile:setString(key .. ".ai#semen",               s.ai.semen)
	xmlFile:setInt(key .. ".ai.age#min",                s.ai.age.min)
	xmlFile:setInt(key .. ".ai.age#max",                s.ai.age.max)
	xmlFile:setInt(key .. ".ai.quality#min",            s.ai.quality.min)
	xmlFile:setInt(key .. ".ai.quality#max",            s.ai.quality.max)
	xmlFile:setInt(key .. ".ai.health#min",             s.ai.health.min)
	xmlFile:setInt(key .. ".ai.health#max",             s.ai.health.max)
	xmlFile:setInt(key .. ".ai.fertility#min",          s.ai.fertility.min)
	xmlFile:setInt(key .. ".ai.fertility#max",          s.ai.fertility.max)
	xmlFile:setInt(key .. ".ai.productivity#min",       s.ai.productivity.min)
	xmlFile:setInt(key .. ".ai.productivity#max",       s.ai.productivity.max)
	xmlFile:setInt(key .. ".ai.metabolism#min",         s.ai.metabolism.min)
	xmlFile:setInt(key .. ".ai.metabolism#max",         s.ai.metabolism.max)

end


function AIAnimalManager:loadFromXMLFile(xmlFile, baseKey)

	local key = self.isProfile and baseKey or (baseKey .. ".AIAnimalManager")
	local s = self.settings

	self.wage = xmlFile:getFloat(key .. "#wage", 0)


	-- BUY SETTINGS

	s.buy.enabled           = xmlFile:getBool(key .. ".buy#enabled",            s.buy.enabled)
	s.buy.budget.type       = xmlFile:getString(key .. ".buy.budget#type",      s.buy.budget.type)
	s.buy.budget.fixed      = xmlFile:getInt(key .. ".buy.budget#fixed",        s.buy.budget.fixed)
	s.buy.budget.percentage = xmlFile:getFloat(key .. ".buy.budget#percentage", s.buy.budget.percentage)
	s.buy.maxAnimals        = xmlFile:getInt(key .. ".buy#maxAnimals",          s.buy.maxAnimals)
	s.buy.breed             = xmlFile:getString(key .. ".buy#breed",            s.buy.breed)
	s.buy.diseases          = xmlFile:getBool(key .. ".buy#diseases",           s.buy.diseases)
	s.buy.gender            = xmlFile:getString(key .. ".buy#gender",           s.buy.gender)
	s.buy.age.min           = xmlFile:getInt(key .. ".buy.age#min",             s.buy.age.min)
	s.buy.age.max           = xmlFile:getInt(key .. ".buy.age#max",             s.buy.age.max)
	s.buy.quality.min       = xmlFile:getInt(key .. ".buy.quality#min",         s.buy.quality.min)
	s.buy.quality.max       = xmlFile:getInt(key .. ".buy.quality#max",         s.buy.quality.max)
	s.buy.health.min        = xmlFile:getInt(key .. ".buy.health#min",          s.buy.health.min)
	s.buy.health.max        = xmlFile:getInt(key .. ".buy.health#max",          s.buy.health.max)
	s.buy.fertility.min     = xmlFile:getInt(key .. ".buy.fertility#min",       s.buy.fertility.min)
	s.buy.fertility.max     = xmlFile:getInt(key .. ".buy.fertility#max",       s.buy.fertility.max)
	s.buy.productivity.min  = xmlFile:getInt(key .. ".buy.productivity#min",    s.buy.productivity.min)
	s.buy.productivity.max  = xmlFile:getInt(key .. ".buy.productivity#max",    s.buy.productivity.max)
	s.buy.metabolism.min    = xmlFile:getInt(key .. ".buy.metabolism#min",      s.buy.metabolism.min)
	s.buy.metabolism.max    = xmlFile:getInt(key .. ".buy.metabolism#max",      s.buy.metabolism.max)


	-- SELL SETTINGS

	s.sell.enabled          = xmlFile:getBool(key .. ".sell#enabled",           s.sell.enabled)
	s.sell.maxAnimals       = xmlFile:getInt(key .. ".sell#maxAnimals",         s.sell.maxAnimals)
	s.sell.mark             = xmlFile:getBool(key .. ".sell#mark",              s.sell.mark)
	s.sell.diseases         = xmlFile:getBool(key .. ".sell#diseases",          s.sell.diseases)
	s.sell.gender           = xmlFile:getString(key .. ".sell#gender",          s.sell.gender)
	s.sell.age.min          = xmlFile:getInt(key .. ".sell.age#min",            s.sell.age.min)
	s.sell.age.max          = xmlFile:getInt(key .. ".sell.age#max",            s.sell.age.max)
	s.sell.quality.min      = xmlFile:getInt(key .. ".sell.quality#min",        s.sell.quality.min)
	s.sell.quality.max      = xmlFile:getInt(key .. ".sell.quality#max",        s.sell.quality.max)
	s.sell.health.min       = xmlFile:getInt(key .. ".sell.health#min",         s.sell.health.min)
	s.sell.health.max       = xmlFile:getInt(key .. ".sell.health#max",         s.sell.health.max)
	s.sell.fertility.min    = xmlFile:getInt(key .. ".sell.fertility#min",      s.sell.fertility.min)
	s.sell.fertility.max    = xmlFile:getInt(key .. ".sell.fertility#max",      s.sell.fertility.max)
	s.sell.productivity.min = xmlFile:getInt(key .. ".sell.productivity#min",   s.sell.productivity.min)
	s.sell.productivity.max = xmlFile:getInt(key .. ".sell.productivity#max",   s.sell.productivity.max)
	s.sell.metabolism.min   = xmlFile:getInt(key .. ".sell.metabolism#min",     s.sell.metabolism.min)
	s.sell.metabolism.max   = xmlFile:getInt(key .. ".sell.metabolism#max",     s.sell.metabolism.max)


	-- CASTRATE SETTINGS

	s.castrate.enabled          = xmlFile:getBool(key .. ".castrate#enabled",        s.castrate.enabled)
	s.castrate.mark             = xmlFile:getBool(key .. ".castrate#mark",           s.castrate.mark)
	s.castrate.diseases         = xmlFile:getBool(key .. ".castrate#diseases",       s.castrate.diseases)
	s.castrate.age.min          = xmlFile:getInt(key .. ".castrate.age#min",         s.castrate.age.min)
	s.castrate.age.max          = xmlFile:getInt(key .. ".castrate.age#max",         s.castrate.age.max)
	s.castrate.quality.min      = xmlFile:getInt(key .. ".castrate.quality#min",     s.castrate.quality.min)
	s.castrate.quality.max      = xmlFile:getInt(key .. ".castrate.quality#max",     s.castrate.quality.max)
	s.castrate.health.min       = xmlFile:getInt(key .. ".castrate.health#min",      s.castrate.health.min)
	s.castrate.health.max       = xmlFile:getInt(key .. ".castrate.health#max",      s.castrate.health.max)
	s.castrate.fertility.min    = xmlFile:getInt(key .. ".castrate.fertility#min",   s.castrate.fertility.min)
	s.castrate.fertility.max    = xmlFile:getInt(key .. ".castrate.fertility#max",   s.castrate.fertility.max)
	s.castrate.productivity.min = xmlFile:getInt(key .. ".castrate.productivity#min",s.castrate.productivity.min)
	s.castrate.productivity.max = xmlFile:getInt(key .. ".castrate.productivity#max",s.castrate.productivity.max)
	s.castrate.metabolism.min   = xmlFile:getInt(key .. ".castrate.metabolism#min",  s.castrate.metabolism.min)
	s.castrate.metabolism.max   = xmlFile:getInt(key .. ".castrate.metabolism#max",  s.castrate.metabolism.max)


	-- NAMING SETTINGS

	s.naming.enabled    = xmlFile:getBool(key .. ".naming#enabled",     s.naming.enabled)
	s.naming.convention = xmlFile:getString(key .. ".naming#convention",s.naming.convention)
	s.naming.previous   = xmlFile:getString(key .. ".naming#previous",  s.naming.previous)


	-- AI SETTINGS

	s.ai.enabled          = xmlFile:getBool(key .. ".ai#enabled",          s.ai.enabled)
	s.ai.maxAnimals       = xmlFile:getInt(key .. ".ai#maxAnimals",        s.ai.maxAnimals)
	s.ai.mark             = xmlFile:getBool(key .. ".ai#mark",             s.ai.mark)
	s.ai.diseases         = xmlFile:getBool(key .. ".ai#diseases",         s.ai.diseases)
	s.ai.semen            = xmlFile:getString(key .. ".ai#semen",          s.ai.semen)
	s.ai.age.min          = xmlFile:getInt(key .. ".ai.age#min",           s.ai.age.min)
	s.ai.age.max          = xmlFile:getInt(key .. ".ai.age#max",           s.ai.age.max)
	s.ai.quality.min      = xmlFile:getInt(key .. ".ai.quality#min",       s.ai.quality.min)
	s.ai.quality.max      = xmlFile:getInt(key .. ".ai.quality#max",       s.ai.quality.max)
	s.ai.health.min       = xmlFile:getInt(key .. ".ai.health#min",        s.ai.health.min)
	s.ai.health.max       = xmlFile:getInt(key .. ".ai.health#max",        s.ai.health.max)
	s.ai.fertility.min    = xmlFile:getInt(key .. ".ai.fertility#min",     s.ai.fertility.min)
	s.ai.fertility.max    = xmlFile:getInt(key .. ".ai.fertility#max",     s.ai.fertility.max)
	s.ai.productivity.min = xmlFile:getInt(key .. ".ai.productivity#min",  s.ai.productivity.min)
	s.ai.productivity.max = xmlFile:getInt(key .. ".ai.productivity#max",  s.ai.productivity.max)
	s.ai.metabolism.min   = xmlFile:getInt(key .. ".ai.metabolism#min",    s.ai.metabolism.min)
	s.ai.metabolism.max   = xmlFile:getInt(key .. ".ai.metabolism#max",    s.ai.metabolism.max)

end


function AIAnimalManager:getSettings(type)

	return type == nil and self.settings or self.settings[type]

end


function AIAnimalManager:setSettings(settings, type)

	if type == nil then
		self.settings = settings
	else
		self.settings[type] = settings
	end

end


-- Maps a stored genetics floor value to the ceiling of that tier.
-- The slider saves the floor of the selected tier as the max (e.g. "veryHigh" -> 1.40),
-- but animals in that tier span up to the next tier's floor. This snaps the max up to
-- include the full tier, so selecting "veryHigh" correctly matches all veryHigh animals.
local GENETICS_TIER_FLOORS   = { 0, 0.35, 0.70, 0.90, 1.10, 1.40, 1.65 }
local GENETICS_TIER_CEILINGS = { 0.3499, 0.6999, 0.8999, 1.0999, 1.3999, 1.6499, math.huge }

local function geneticsTierCeiling(value)
	for i = #GENETICS_TIER_FLOORS, 1, -1 do
		if value >= GENETICS_TIER_FLOORS[i] then
			return GENETICS_TIER_CEILINGS[i]
		end
	end
	return math.huge
end


function AIAnimalManager:onDayChanged()

	if not self.isServer then return end

	local buy, sell, castrate, naming, ai = self.settings.buy, self.settings.sell, self.settings.castrate, self.settings.naming, self.settings.ai

	self.wage = 0

	if not buy.enabled and not sell.enabled and not castrate.enabled and not naming.enabled and not ai.enabled then return end

	local farmId          = self.husbandry:getOwnerFarmId()
	local farm            = g_farmManager:getFarmById(farmId)
	local animalSystem    = g_currentMission.animalSystem
	local animalTypeIndex = self.husbandry:getAnimalTypeIndex()
	local animalTypeToWage = self.ANIMAL_TYPE_TO_WAGE[animalTypeIndex] or 5
	local messages        = {}


	-- ####################### SELL #######################


	if sell.enabled and sell.maxAnimals > 0 then

		local animals   = self.husbandry:getClusters()
		local shortlist = {}

		local qualityMin,      qualityMax      = sell.quality.min / 100,      geneticsTierCeiling(sell.quality.max / 100)
		local fertilityMin,    fertilityMax    = sell.fertility.min / 100,    geneticsTierCeiling(sell.fertility.max / 100)
		local healthMin,       healthMax       = sell.health.min / 100,       geneticsTierCeiling(sell.health.max / 100)
		local metabolismMin,   metabolismMax   = sell.metabolism.min / 100,   geneticsTierCeiling(sell.metabolism.max / 100)
		local productivityMin, productivityMax = sell.productivity.min / 100, geneticsTierCeiling(sell.productivity.max / 100)

		for _, animal in pairs(animals) do

			if animal:getMarked("AI_MANAGER_SELL") then animal:setMarked("AI_MANAGER_SELL", false) end

			if sell.gender ~= "any" and animal.gender ~= sell.gender then continue end

			if animal.age < sell.age.min or animal.age > sell.age.max then continue end

			-- diseases=false: skip animals that have diseases. diseases=true: allow diseased animals.
			if not sell.diseases and animal.diseases ~= nil and #animal.diseases > 0 then continue end

			-- Sell if ANY stat falls within the sell range (OR logic). Stats left at defaults (25-175) act as "any".
			if animal.genetics == nil then continue end

			local inMetabolism   = animal.genetics.metabolism  >= metabolismMin   and animal.genetics.metabolism  <= metabolismMax
			local inQuality      = animal.genetics.quality     >= qualityMin      and animal.genetics.quality     <= qualityMax
			local inFertility    = animal.genetics.fertility   >= fertilityMin    and animal.genetics.fertility   <= fertilityMax
			local inHealth       = animal.genetics.health      >= healthMin       and animal.genetics.health      <= healthMax
			local inProductivity = animal.genetics.productivity ~= nil and (animal.genetics.productivity >= productivityMin and animal.genetics.productivity <= productivityMax)

			if not (inMetabolism or inQuality or inFertility or inHealth or inProductivity) then continue end

			local price = animal:getSellPrice() + animalSystem:getAnimalTransportFee(animal.subTypeIndex, animal.age)

			table.insert(shortlist, { ["animal"] = animal, ["price"] = price })

		end

		local soldAnimals, amountGained = {}, 0
		local mark = sell.mark

		table.sort(shortlist, function(a, b) return a.price > b.price end)

		for _, item in ipairs(shortlist) do

			if #soldAnimals >= sell.maxAnimals then break end

			amountGained = amountGained + item.price

			table.insert(soldAnimals, item.animal)

			if mark then item.animal:setMarked("AI_MANAGER_SELL", true) end

		end

		self.wage = self.wage + animalTypeToWage * #soldAnimals * (mark and 0.35 or 1) + animalTypeToWage * math.min(#shortlist, #soldAnimals * 5) * 0.15 * (mark and 0.35 or 1)

		if #soldAnimals > 0 and not mark then

			local errorCode = AIAnimalSellEvent.validate(self.husbandry, #soldAnimals, amountGained, farmId)

			if errorCode == nil then

				g_server:broadcastEvent(AIAnimalSellEvent.new(self.husbandry, soldAnimals, amountGained), true)

				if #soldAnimals == 1 then
					self.husbandry:addRLMessage("AI_MANAGER_SOLD_SINGLE", nil, { g_i18n:formatMoney(amountGained, 2, true, true) })
					table.insert(messages, { ["id"] = "AI_MANAGER_SOLD_SINGLE", ["args"] = { g_i18n:formatMoney(amountGained, 2, true, true) } })
				else
					self.husbandry:addRLMessage("AI_MANAGER_SOLD_MULTIPLE", nil, { #soldAnimals, g_i18n:formatMoney(amountGained, 2, true, true) })
					table.insert(messages, { ["id"] = "AI_MANAGER_SOLD_MULTIPLE", ["args"] = { #soldAnimals, g_i18n:formatMoney(amountGained, 2, true, true) } })
				end

			end

		elseif #soldAnimals > 0 then

			if #soldAnimals == 1 then
				self.husbandry:addRLMessage("AI_MANAGER_MARK_SELL_SINGLE")
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_SELL_SINGLE" })
			else
				self.husbandry:addRLMessage("AI_MANAGER_MARK_SELL_MULTIPLE", nil, { #soldAnimals })
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_SELL_MULTIPLE", ["args"] = { #soldAnimals } })
			end

		end

	end


	-- ####################### BUY #######################


	if buy.enabled and buy.maxAnimals > 0 then

		local budget = buy.budget.fixed

		if buy.budget.type == "percentage" then budget = math.floor(farm:getBalance() * (buy.budget.percentage / 100)) end

		budget = math.clamp(budget, 0, farm:getBalance())

		if budget > 0 then

			local animals   = animalSystem:getSaleAnimalsByTypeIndex(animalTypeIndex)
			local shortlist = {}

			local qualityMin,      qualityMax      = buy.quality.min / 100,      geneticsTierCeiling(buy.quality.max / 100)
			local fertilityMin,    fertilityMax    = buy.fertility.min / 100,    geneticsTierCeiling(buy.fertility.max / 100)
			local healthMin,       healthMax       = buy.health.min / 100,       geneticsTierCeiling(buy.health.max / 100)
			local metabolismMin,   metabolismMax   = buy.metabolism.min / 100,   geneticsTierCeiling(buy.metabolism.max / 100)
			local productivityMin, productivityMax = buy.productivity.min / 100, geneticsTierCeiling(buy.productivity.max / 100)

			for _, animal in pairs(animals) do

				if animal.reserved then continue end

				if buy.gender ~= "any" and animal.gender ~= buy.gender then continue end

				if buy.breed ~= "any" and animal.breed ~= buy.breed then continue end

				if animal.age < buy.age.min or animal.age > buy.age.max then continue end

				if not buy.diseases and #animal.diseases > 0 then continue end

				if animal.genetics == nil then continue end
			if animal.genetics.metabolism  < metabolismMin   or animal.genetics.metabolism  > metabolismMax   then continue end
				if animal.genetics.quality     < qualityMin      or animal.genetics.quality     > qualityMax      then continue end
				if animal.genetics.fertility   < fertilityMin    or animal.genetics.fertility   > fertilityMax    then continue end
				if animal.genetics.health      < healthMin       or animal.genetics.health      > healthMax       then continue end
				if animal.genetics.productivity ~= nil and (animal.genetics.productivity < productivityMin or animal.genetics.productivity > productivityMax) then continue end

				local price = animal:getSellPrice() * 1.075 + animalSystem:getAnimalTransportFee(animal.subTypeIndex, animal.age)

				if price > budget then continue end

				table.insert(shortlist, { ["animal"] = animal, ["price"] = price })

			end

			local boughtAnimals, amountSpent = {}, 0

			table.sort(shortlist, function(a, b) return a.price < b.price end)

			for _, item in ipairs(shortlist) do

				if item.price > budget or #boughtAnimals >= buy.maxAnimals then break end

				amountSpent          = amountSpent + item.price
				budget               = budget - item.price
				item.animal.reserved = true

				table.insert(boughtAnimals, item.animal)

			end

			if #boughtAnimals > 0 then

				local errorCode = AIAnimalBuyEvent.validate(self.husbandry, #boughtAnimals, amountSpent, farmId)

				if errorCode == nil then

					g_server:broadcastEvent(AIAnimalBuyEvent.new(self.husbandry, boughtAnimals, amountSpent), true)

					if #boughtAnimals == 1 then
						self.husbandry:addRLMessage("AI_MANAGER_BOUGHT_SINGLE", nil, { g_i18n:formatMoney(amountSpent, 2, true, true) })
						table.insert(messages, { ["id"] = "AI_MANAGER_BOUGHT_SINGLE", ["args"] = { g_i18n:formatMoney(amountSpent, 2, true, true) } })
					else
						self.husbandry:addRLMessage("AI_MANAGER_BOUGHT_MULTIPLE", nil, { #boughtAnimals, g_i18n:formatMoney(amountSpent, 2, true, true) })
						table.insert(messages, { ["id"] = "AI_MANAGER_BOUGHT_MULTIPLE", ["args"] = { #boughtAnimals, g_i18n:formatMoney(amountSpent, 2, true, true) } })
					end

				end

			end

			self.wage = self.wage + animalTypeToWage * #boughtAnimals + animalTypeToWage * math.min(#shortlist, #boughtAnimals * 5) * 0.15

		end

	end


	-- ####################### CASTRATE #######################


	if castrate.enabled and animalTypeIndex ~= AnimalType.CHICKEN then

		local animals      = self.husbandry:getClusters()
		local numCastrated = 0

		local qualityMin,      qualityMax      = castrate.quality.min / 100,      geneticsTierCeiling(castrate.quality.max / 100)
		local fertilityMin,    fertilityMax    = castrate.fertility.min / 100,    geneticsTierCeiling(castrate.fertility.max / 100)
		local healthMin,       healthMax       = castrate.health.min / 100,       geneticsTierCeiling(castrate.health.max / 100)
		local metabolismMin,   metabolismMax   = castrate.metabolism.min / 100,   geneticsTierCeiling(castrate.metabolism.max / 100)
		local productivityMin, productivityMax = castrate.productivity.min / 100, geneticsTierCeiling(castrate.productivity.max / 100)

		for _, animal in pairs(animals) do

			if animal:getMarked("AI_MANAGER_CASTRATE") then animal:setMarked("AI_MANAGER_CASTRATE", false) end

			if animal.gender == "female" or animal.isCastrated or animal.genetics.fertility == 0 then continue end

			if animal.age < castrate.age.min or animal.age > castrate.age.max then continue end

			-- diseases=false: skip animals that have diseases. diseases=true: allow diseased animals.
			if not castrate.diseases and animal.diseases ~= nil and #animal.diseases > 0 then continue end

			-- Castrate if ANY stat falls within the castrate range (OR logic).
			if animal.genetics == nil then continue end

			local inMetabolism   = animal.genetics.metabolism  >= metabolismMin   and animal.genetics.metabolism  <= metabolismMax
			local inQuality      = animal.genetics.quality     >= qualityMin      and animal.genetics.quality     <= qualityMax
			local inFertility    = animal.genetics.fertility   >= fertilityMin    and animal.genetics.fertility   <= fertilityMax
			local inHealth       = animal.genetics.health      >= healthMin       and animal.genetics.health      <= healthMax
			local inProductivity = animal.genetics.productivity ~= nil and (animal.genetics.productivity >= productivityMin and animal.genetics.productivity <= productivityMax)

			if not (inMetabolism or inQuality or inFertility or inHealth or inProductivity) then continue end

			if castrate.mark then
				animal:setMarked("AI_MANAGER_CASTRATE", true)
			else
				animal.isCastrated        = true
				animal.genetics.fertility = 0
			end

			self.wage    = self.wage + animalTypeToWage * 0.5 * (castrate.mark and 0.35 or 1)
			numCastrated = numCastrated + 1

		end

		if castrate.mark then
			if numCastrated == 1 then
				self.husbandry:addRLMessage("AI_MANAGER_MARK_CASTRATE_SINGLE")
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_CASTRATE_SINGLE" })
			elseif numCastrated > 0 then
				self.husbandry:addRLMessage("AI_MANAGER_MARK_CASTRATE_MULTIPLE", nil, { numCastrated })
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_CASTRATE_MULTIPLE", ["args"] = { numCastrated } })
			end
		else
			if numCastrated == 1 then
				self.husbandry:addRLMessage("AI_MANAGER_CASTRATE_SINGLE")
				table.insert(messages, { ["id"] = "AI_MANAGER_CASTRATE_SINGLE" })
			elseif numCastrated > 0 then
				self.husbandry:addRLMessage("AI_MANAGER_CASTRATE_MULTIPLE", nil, { numCastrated })
				table.insert(messages, { ["id"] = "AI_MANAGER_CASTRATE_MULTIPLE", ["args"] = { numCastrated } })
			end
		end

	end


	-- ####################### NAMING #######################


	if naming.enabled then

		local animals          = self.husbandry:getClusters()
		local animalNameSystem = g_currentMission.animalNameSystem
		local femaleNames      = animalNameSystem:getNamesAlphabetical("female")
		local maleNames        = animalNameSystem:getNamesAlphabetical("male")
		local numNamed         = 0

		for _, animal in pairs(animals) do

			if animal.name ~= nil and animal.name ~= "" then continue end

			if naming.convention == "random" then

				animal.name = animalNameSystem:getRandomName(animal.gender)
				self.wage   = self.wage + animalTypeToWage * 0.15
				numNamed    = numNamed + 1

			else

				local names = animal.gender == "female" and femaleNames or maleNames

				for i, name in ipairs(names) do

					if naming.previous == nil or (name ~= naming.previous and name >= naming.previous) or i == #names then

						if i == #names and naming.previous == name then
							animal.name     = names[1] .. ""
							naming.previous = names[1] .. ""
						else
							animal.name     = name .. ""
							naming.previous = name .. ""
						end

						self.wage = self.wage + animalTypeToWage * 0.15
						numNamed  = numNamed + 1
						break

					end

				end

			end

		end

		if numNamed == 1 then
			self.husbandry:addRLMessage("AI_MANAGER_NAMED_SINGLE")
			table.insert(messages, { ["id"] = "AI_MANAGER_NAMED_SINGLE" })
		elseif numNamed > 0 then
			self.husbandry:addRLMessage("AI_MANAGER_NAMED_MULTIPLE", nil, { numNamed })
			table.insert(messages, { ["id"] = "AI_MANAGER_NAMED_MULTIPLE", ["args"] = { numNamed } })
		end

	end


	-- ####################### AI (INSEMINATION) #######################


	if ai.enabled and ai.maxAnimals > 0 then

		local farmDewars = g_dewarManager:getDewarsByFarm(farmId)
		local dewars

		if ai.semen ~= "any" and farmDewars ~= nil then

			for _, dewar in pairs(farmDewars[animalTypeIndex] or {}) do

				if dewar:getUniqueId() == ai.semen then
					dewars = { dewar }
					break
				end

			end

		elseif farmDewars ~= nil then

			dewars = farmDewars[animalTypeIndex]

		end

		local animals           = self.husbandry:getClusters()
		local shortlist         = {}
		local dewarToStrawDelta = {}

		local qualityMin,      qualityMax      = ai.quality.min / 100,      geneticsTierCeiling(ai.quality.max / 100)
		local fertilityMin,    fertilityMax    = ai.fertility.min / 100,    geneticsTierCeiling(ai.fertility.max / 100)
		local healthMin,       healthMax       = ai.health.min / 100,       geneticsTierCeiling(ai.health.max / 100)
		local metabolismMin,   metabolismMax   = ai.metabolism.min / 100,   geneticsTierCeiling(ai.metabolism.max / 100)
		local productivityMin, productivityMax = ai.productivity.min / 100, geneticsTierCeiling(ai.productivity.max / 100)

		for _, animal in pairs(animals) do

			if animal:getMarked("AI_MANAGER_INSEMINATE") then animal:setMarked("AI_MANAGER_INSEMINATE", false) end

			if dewars == nil or #dewars == 0 then continue end

			if animal.age < ai.age.min or animal.age > ai.age.max then continue end

			-- diseases=false: skip animals that have diseases. diseases=true: allow diseased animals.
			if not ai.diseases and animal.diseases ~= nil and #animal.diseases > 0 then continue end

			if animal.genetics == nil then continue end
			if animal.genetics.metabolism  < metabolismMin   or animal.genetics.metabolism  > metabolismMax   then continue end
			if animal.genetics.quality     < qualityMin      or animal.genetics.quality     > qualityMax      then continue end
			if animal.genetics.fertility   < fertilityMin    or animal.genetics.fertility   > fertilityMax    then continue end
			if animal.genetics.health      < healthMin       or animal.genetics.health      > healthMax       then continue end
			if animal.genetics.productivity ~= nil and (animal.genetics.productivity < productivityMin or animal.genetics.productivity > productivityMax) then continue end

			local canBeInseminated = false
			local usedDewar

			for _, dewar in pairs(dewars) do

				if dewar.animal == nil or dewar.straws <= 0 then continue end

				if dewarToStrawDelta[dewar] ~= nil and dewar.straws - dewarToStrawDelta[dewar] <= 0 then continue end

				canBeInseminated = animal:getCanBeInseminatedByAnimal(dewar.animal)

				if canBeInseminated then
					usedDewar = dewar
					if dewarToStrawDelta[dewar] == nil then dewarToStrawDelta[dewar] = 0 end
					dewarToStrawDelta[dewar] = dewarToStrawDelta[dewar] + 1
					break
				end

			end

			if not canBeInseminated then continue end

			local genetics = animal.genetics.metabolism + animal.genetics.quality + animal.genetics.fertility + animal.genetics.health + (animal.genetics.productivity or 0)

			table.insert(shortlist, { ["animal"] = animal, ["genetics"] = genetics, ["dewar"] = usedDewar })

		end

		local inseminatedAnimals = {}
		local mark = ai.mark

		table.sort(shortlist, function(a, b) return a.genetics > b.genetics end)

		for _, item in ipairs(shortlist) do

			if #inseminatedAnimals >= ai.maxAnimals then break end

			table.insert(inseminatedAnimals, { ["animal"] = item.animal, ["dewar"] = item.dewar:getUniqueId() })

			if mark then item.animal:setMarked("AI_MANAGER_INSEMINATE", true) end

		end

		self.wage = self.wage + animalTypeToWage * #inseminatedAnimals * (mark and 0.45 or 1.2) + animalTypeToWage * math.min(#shortlist, #inseminatedAnimals * 5) * 0.2 * (mark and 0.35 or 1)

		if #inseminatedAnimals > 0 and not mark then

			g_server:broadcastEvent(AIAnimalInseminationEvent.new(self.husbandry, inseminatedAnimals), true)

			if #inseminatedAnimals == 1 then
				self.husbandry:addRLMessage("AI_MANAGER_INSEMINATED_SINGLE")
				table.insert(messages, { ["id"] = "AI_MANAGER_INSEMINATED_SINGLE" })
			else
				self.husbandry:addRLMessage("AI_MANAGER_INSEMINATED_MULTIPLE", nil, { #inseminatedAnimals })
				table.insert(messages, { ["id"] = "AI_MANAGER_INSEMINATED_MULTIPLE", ["args"] = { #inseminatedAnimals } })
			end

		elseif #inseminatedAnimals > 0 then

			if #inseminatedAnimals == 1 then
				self.husbandry:addRLMessage("AI_MANAGER_MARK_INSEMINATED_SINGLE")
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_INSEMINATED_SINGLE" })
			else
				self.husbandry:addRLMessage("AI_MANAGER_MARK_INSEMINATED_MULTIPLE", nil, { #inseminatedAnimals })
				table.insert(messages, { ["id"] = "AI_MANAGER_MARK_INSEMINATED_MULTIPLE", ["args"] = { #inseminatedAnimals } })
			end

		end

	end


	if #messages > 0 and g_server.netIsRunning then g_server:broadcastEvent(AIBulkMessageEvent.new(self.husbandry, messages)) end


end


function AIAnimalManager:createProfile()

	local profile     = AIAnimalManager.new(self.isServer)
	profile.settings  = table.clone(self.settings, 10)
	profile.isProfile = true

	return profile

end


function AIAnimalManager:copyProfile(profile)

	self.settings = table.clone(profile.settings, 10)

end


function InGameMenuStatisticsFrame:updateViewHandTools()

	local sortByColumnHandTools = self.sortByColumnHandTools
	local sortOrderHandTools    = self.sortOrderHandTools

	for column, icons in pairs(self.sortIconsHandTools) do

		local isActiveColumn = column == sortByColumnHandTools

		local descIcon = icons[InGameMenuStatisticsFrame.SORT_ORDER_DESC]
		descIcon:setVisible(isActiveColumn and sortOrderHandTools == InGameMenuStatisticsFrame.SORT_ORDER_DESC)

		local ascIcon = icons[InGameMenuStatisticsFrame.SORT_ORDER_ASC]
		ascIcon:setVisible(isActiveColumn and sortOrderHandTools == InGameMenuStatisticsFrame.SORT_ORDER_ASC)

	end

	table.sort(self.handTools, function(a, b)

		local aValue = a.columns[sortByColumnHandTools].value
		local bValue = b.columns[sortByColumnHandTools].value

		if aValue == bValue then
			aValue = a.columns[InGameMenuStatisticsFrame.COLUMN_NAME].value
			bValue = b.columns[InGameMenuStatisticsFrame.COLUMN_NAME].value

			if aValue == bValue then
				aValue = a.columns[InGameMenuStatisticsFrame.COLUMN_HOLDER].value
				bValue = b.columns[InGameMenuStatisticsFrame.COLUMN_HOLDER].value
			end
		end

		if sortOrderHandTools == InGameMenuStatisticsFrame.SORT_ORDER_DESC then return bValue < aValue end

		return aValue < bValue

	end)

	self.handToolsList:reloadData()

end
