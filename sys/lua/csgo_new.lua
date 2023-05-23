-- Settings
droprate = 100				-- Default: 10
freekit = false				-- Default: false
freearmor = true			-- Default: true
refillAmmo = true			-- Default: true
allowMolotov = false		-- Default: false
waterSlowdown = false		-- Default: false
speedOffsetScopeIn = -10	-- Default: -10

displayTable = {
[1] = 'script by usgn#124616',
[2] = 'server name is '..game('sv_name')..'',
[3] = 'map name is '..game('sv_map')..'',
}

goldBoxPrice = 10000
silverBoxPrice = 5000
bronzeBoxPrice = 1000
goldKeyPrice = 10000
silverKeyPrice = 5000
bronzeKeyPrice = 1000
---------------------------------------------------------------------
--Script write by USGN#124616----------------------------------------
---------------------------------------------------------------------
parse('mp_mvp 0')
parse('cp_roundend 0')
parse('mp_hudscale 1')

function l(m)
	local array = {}
	for i = 1, m do
		array[i] = 0
	end
	return array
end
function ls(m, v)
	local array = {}
	for i = 1, m do
		array[i] = v
	end
	return array
end
function l2(m, a)
	local array = {}
	for i = 1, m do
		array[i] = {}
		for v = 1, a do
			array[i][v] = 0
		end
	end
	return array
end
function string.split(tt, b)
	local t = {}
	local matcher = '[^%s]+'
	if (type(b) == 'string') then 
		matcher = '[^'..b..']+'
	end
	for word in string.gmatch(tt, matcher) do
		table.insert(t, string.trim(word))
	end
	return t
end
function string.trim(str)
	local s = str:gsub('	',''):gsub(' ','')
	return s
end
function string.splitSpace(tt, b)
	local t = {}
	local matcher = '[^%s]+'
	if (type(b) == 'string') then 
		matcher = '[^'..b..']+'
	end
	for word in string.gmatch(tt, matcher) do
		table.insert(t, word)
	end
	return t
end

-- Set Bot Skill
if (tonumber(game('bot_skill')) == 0) then
	bskill = 1
else
	bskill = tonumber(game('bot_skill'))
end
print('[Server] Bot skill is set to : '..bskill)

-- Init WeaponData Table
WDAT = {
['ID'] = {},-- Does Weapon exists?
['HMin'] = {},-- Headshot Min
['HMax'] = {},-- Headshot Max
['AccRV'] = {},-- Accuracy Reset Value
['AccRT'] = {},-- Accuracy Reset Time(Ms)
['AccLW'] = {},-- Accuracy Lost Walking
['AccLR'] = {},-- Accuracy Lost Running
['AccLF'] = {},-- Accuracy Lost Fire
['AccLOR'] = {},-- Accuracy Lost OutOfRange
['DNH'] = {},-- Damage Dealt Without Helmet
['DH'] = {},-- Damage Dealt With Helmet
['MRX'] = {},-- Max Range X
['MRY'] = {},-- Max Range Y
['MRD'] = {},-- Max Range Damage Starts To Decrease
['AimO'] = {},-- Aim On Head Range Offset
-- Weapon Mode
['Mode'] = {},-- Does Weapon has another mode stat?
['M1H'] = {},-- Mode1 HMax Offset
['M1D'] = {},-- Mode1 Headshot Damage Offset
['M1R'] = {},-- Mode1 Recoil/Shot Offset
['M2H'] = {},-- Mode2 HMax Offset
['M2D'] = {},-- Mode2 Headshot Damage Offset
['M2R'] = {}-- Mode2 Recoil/Shot Offset
}

-- Read Weapon Data
function read_wpndat()
	local file = io.open('sys/lua/CSGO/Config/weapons.cfg', 'r')
	if (file ~= nil) then
	local dat_count = 0
	print('\169000255000Loading weapon data...')
		for line in file:lines() do
			if (line:match('#(%d+)') ~= nil) then
				dat_count = dat_count + 1
				local dat = string.split(line, ':')
				local i = tonumber(line:match('#(%d+)'))
				for k, v in pairs(dat) do
					--1 [WpnID]
					WDAT['ID'][i] = true
					--2 [WpnName]
					--3 [HS Min/Max]
					if (k == 3) then
						local value = string.split(v, ',')
						WDAT['HMin'][i] = tonumber(value[1])
						WDAT['HMax'][i] = tonumber(value[2])
					end
					--4 [AccReset]
					if (k == 4) then
						local value = string.split(v, ',')
						WDAT['AccRV'][i] = tonumber(value[1])
						WDAT['AccRT'][i] = tonumber(value[2])
					end
					--5 [AccLost]
					if (k == 5) then
						local value = string.split(v, ',')
						WDAT['AccLW'][i] = tonumber(value[1])
						WDAT['AccLR'][i] = tonumber(value[2])
						WDAT['AccLF'][i] = tonumber(value[3])
						WDAT['AccLOR'][i] = tonumber(value[4])
					end
					--6 [Dmg]
					if (k == 6) then
						local value = string.split(v, ',')
						WDAT['DNH'][i] = tonumber(value[1])
						WDAT['DH'][i] = tonumber(value[2])
					end
					--7 [Range]
					if (k == 7) then
						local value = string.split(v, ',')
						WDAT['MRX'][i] = tonumber(value[1])
						WDAT['MRY'][i] = tonumber(value[2])
						WDAT['MRD'][i] = tonumber(value[2])
					end
					--8 [Aim]
					if (k == 8) then
						WDAT['AimO'][i] = tonumber(v)
					end
					--9 [Weapon Mode]
					if (k == 9) then
						if (v ~= '') then
							WDAT['Mode'][i] = true
							-- Split M1H,D,R M2H,D,R
							local value = string.split(v, ',')
							if (value[1]) then
								WDAT['M1H'][i] = tonumber(value[1])
							end
							if (value[2]) then
								WDAT['M1D'][i] = tonumber(value[2])
							end
							if (value[3]) then
								WDAT['M1R'][i] = tonumber(value[3])
							end
							if (value[4]) then
								WDAT['M2H'][i] = tonumber(value[4])
							end
							if (value[5]) then
								WDAT['M2D'][i] = tonumber(value[5])
							end
							if (value[6]) then
								WDAT['M2R'][i] = tonumber(value[6])
							end
						end
					end
				end
			end
		end
		file:close()
		print('\169000255000'..dat_count..' Weapon data loaded')
	end
end
read_wpndat()

gold, red, pink, purple, blue = '255100000', '255000000', '255000255', '150000255', '000000255'
function applyColor(v)
	if (v == 'gold') then
		v = gold
	elseif (v == 'red') then
		v = red
	elseif (v == 'pink') then
		v = pink
	elseif (v == 'purple') then
		v = purple
	elseif (v == 'blue') then
		v = blue
	end
	return v
end

-- Init SkinsData Table
SDAT = {
['Change'] = {},-- Did Skin Change Base Weapon Data? (Auto Assigin When Loading Data)
['Name'] = {},-- Skin's Name
['ID'] = {},-- Skin's Base Weapon ID
['Rare'] = {},-- Skin's Rarity
['Icon'] = {},-- Skin's Kill Icon
['HMin'] = {},-- Headshot Min
['HMax'] = {},-- Headshot Max
['AccRV'] = {},-- Accuracy Reset Value
['AccRT'] = {},-- Accuracy Reset Time(Ms)
['AccLW'] = {},-- Accuracy Lost Walking
['AccLR'] = {},-- Accuracy Lost Running
['AccLF'] = {},-- Accuracy Lost Fire
['AccLOR'] = {},-- Accuracy Lost OutOfRange
['DNH'] = {},-- Damage Dealt Without Helmet
['DH'] = {},-- Damage Dealt With Helmet
['AimO'] = {},-- Aim On Head Range Offset
-- Weapon Mode
['Mode'] = {},-- Does Weapon has another mode stat?
['M1H'] = {},-- Mode1 HMax Offset
['M1D'] = {},-- Mode1 Headshot Damage Offset
['M1R'] = {},-- Mode1 Recoil/Shot Offset
['M2H'] = {},-- Mode2 HMax Offset
['M2D'] = {},-- Mode2 Headshot Damage Offset
['M2R'] = {}-- Mode2 Recoil/Shot Offset
}

-- Read Weapon Skins Data
function read_skindat()
	local file = io.open('sys/lua/CSGO/Config/skins.cfg', 'r')
	if (file ~= nil) then
	local i = 0
	print('\169000255000Loading skins data...')
		for line in file:lines() do
			if (line:match('#(%d+)') ~= nil) then
				i = i + 1
				local isChange = false
				local dat = string.split(line, ':')
				for k, v in pairs(dat) do
					--1 [Add]
					--2 [Skin Name]
					if (k == 2) then
						SDAT['Name'][i] = string.gsub(v, '%.', ' ')
					end
					--3 [WpnID]
					if (k == 3) then
						SDAT['ID'][i] = tonumber(v)
					end
					--4 [Rare]
					if (k == 4) then
						SDAT['Rare'][i] = applyColor(v)
					end
					--5 [Icon]
					if (k == 5) then
						SDAT['Icon'][i] = nil
						if (v ~= '') then
							SDAT['Icon'][i] = v
						end
					end
					--6 [HS Min/Max]
					if (k == 6) then
						-- Default Value From WDAT
						SDAT['HMin'][i] = WDAT['HMin'][SDAT['ID'][i]]
						SDAT['HMax'][i] = WDAT['HMax'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							local value = string.split(v, ',')
							SDAT['HMin'][i] = tonumber(value[1])
							SDAT['HMax'][i] = tonumber(value[2])
						end
					end
					--7 [AccReset]
					if (k == 7) then
						-- Default Value From WDAT
						SDAT['AccRV'][i] = WDAT['AccRV'][SDAT['ID'][i]]
						SDAT['AccRT'][i] = WDAT['AccRT'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							local value = string.split(v, ',')
							SDAT['AccRV'][i] = tonumber(value[1])
							SDAT['AccRT'][i] = tonumber(value[2])
						end
					end
					--8 [AccLost]
					if (k == 8) then
						-- Default Value From WDAT
						SDAT['AccLW'][i] = WDAT['AccLW'][SDAT['ID'][i]]
						SDAT['AccLR'][i] = WDAT['AccLR'][SDAT['ID'][i]]
						SDAT['AccLF'][i] = WDAT['AccLF'][SDAT['ID'][i]]
						SDAT['AccLOR'][i] = WDAT['AccLOR'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							local value = string.split(v, ',')
							SDAT['AccLW'][i] = tonumber(value[1])
							SDAT['AccLR'][i] = tonumber(value[2])
							SDAT['AccLF'][i] = tonumber(value[3])
							SDAT['AccLOR'][i] = tonumber(value[4])
						end
					end
					--9 [Dmg]
					if (k == 9) then
						-- Default Value From WDAT
						SDAT['DNH'][i] = WDAT['DNH'][SDAT['ID'][i]]
						SDAT['DH'][i] = WDAT['DH'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							local value = string.split(v, ',')
							SDAT['DNH'][i] = tonumber(value[1])
							SDAT['DH'][i] = tonumber(value[2])
						end
					end
					--10 [Aim]
					if (k == 10) then
						-- Default Value From WDAT
						SDAT['AimO'][i] = WDAT['AimO'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							SDAT['AimO'][i] = tonumber(v)
						end
					end
					--11 [Weapon Mode]
					if (k == 11) then
						-- Default Value From WDAT
						SDAT['Mode'][i] = WDAT['Mode'][SDAT['ID'][i]]
						SDAT['M1H'][i] = WDAT['M1H'][SDAT['ID'][i]]
						SDAT['M1D'][i] = WDAT['M1D'][SDAT['ID'][i]]
						SDAT['M1R'][i] = WDAT['M1R'][SDAT['ID'][i]]
						SDAT['M2H'][i] = WDAT['M2H'][SDAT['ID'][i]]
						SDAT['M2D'][i] = WDAT['M2D'][SDAT['ID'][i]]
						SDAT['M2R'][i] = WDAT['M2R'][SDAT['ID'][i]]
						-- If Not ''
						if (v ~= '') then
							isChange = true
							SDAT['Mode'][i] = true
							-- Split M1H,D,R M2H,D,R
							local value = string.split(v, ',')
							if (value[1]) then
								SDAT['M1H'][i] = tonumber(value[1])
							end
							if (value[2]) then
								SDAT['M1D'][i] = tonumber(value[2])
							end
							if (value[3]) then
								SDAT['M1R'][i] = tonumber(value[3])
							end
							if (value[4]) then
								SDAT['M2H'][i] = tonumber(value[4])
							end
							if (value[5]) then
								SDAT['M2D'][i] = tonumber(value[5])
							end
							if (value[6]) then
								SDAT['M2R'][i] = tonumber(value[6])
							end
						end
					end
				end
				-- Is Change?
				SDAT['Change'][i] = false
				if (isChange) then
					SDAT['Change'][i] = true
				end
			end
		end
		file:close()
		print('\169000255000'..i..' Skins loaded')
	end
end
read_skindat()

-- Team Win Image
function win_img(team)
	if (team == 1) then
		local img = image('gfx/GOGFX/trwinbar.png', 425, 130, 2)
	elseif (team == 2) then
		local img = image('gfx/GOGFX/ctwinbar.png', 425, 130, 2)
	end
end

MUSICKIT = {
[1] = {'AD8', 'Sean Murray'},
[2] = {'All I Want For Chrismas', 'Midnight Riders'},
[3] = {'Crimson Assault', 'Daniel Sadowski'},
[4] = {'Desert Fire', 'Austin Wintory'},
[5] = {'Disgusting', 'Beartooth'},
[6] = {'High Noon', 'Feed Me'},
[7] = {'Hotline Miami', 'Various Artists'},
[8] = {'Metal', 'Skog'},
[9] = {'Total Domination', 'Daniel Sadowski'},
[10] = {'Diamonds', 'Mord Fustang'},
[11] = {'Deaths Head Demolition', 'Dren'},
[12] = {'Battlepack', 'Proxy'},
[13] = {'For No Mankind', 'Mateo Messina'},
[14] = {'I Am', 'AWOLNATION'},
[15] = {'Invasion!', 'Michael Bross'},
[16] = {'IsoRhythm', 'Matt Lange'},
[17] = {'Lions Mouth', 'Ian Hultquist'},
[18] = {'Moments', 'Darude'},
[19] = {'Sharpened', 'Noisia'},
[20] = {'The 8-bit Kit', 'Daniel Sadowski'},
[21] = {'The Talos Principle', 'Damjan Mravunac'},
[22] = {'Uber Blasto Phone', 'Troels Folmann'},
[23] = {'II-Headshot', 'Skog'},
[24] = {'Insurgency', 'Robert Allaire'},
[25] = {'LNOE', 'Sasha'},
[26] = {'MOLOTOV', 'KiTheory'},
[27] = {'Sponge Fingerz', 'New Beat Fund'},
[28] = {'Java Havana Funkaloo', 'Lennie Moore'},
[29] = {'Aggressive', 'Beartooth'},
[30] = {'Backbone', 'Roam'},
[31] = {'Free', 'Hundredth'},
[32] = {'GLA', 'Twin Atlantic'},
[33] = {'III-Arena', 'Skog'},
[34] = {"Life's Not Out To Get You", 'Neck Deep'},
[35] = {'The Good Youth', 'Blitz Kids'},
[36] = {'Hazardous Environments', 'Kelly Bailey'},
}

adr = l(32)
mvpMusic = l(32)
defusing = l(32)
dmgDealt = l2(32, 32)
dmgShot = l2(32, 32)
-- Weapons Info
dropItemOwner = l2(192, 3) -- 1:Xilver's 2:DroppedPlayerID 3:SkinID
playerWpn = l2(32, 2) -- Slot1&Slot2
playerWpnOwner = l2(32, 2) -- String example: "Xilver's "
playerWpnOwnerID = l2(32, 2) -- ID
playerWpnDropDebug = l2(32, 2) -- Used to debug buy weapon and drop weapon stuff
playerWpnDropDebugParameters = l2(32, 2)
-- Weapon Mode
playerWpnMode = l2(32, 91)

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------
-- Remember to reset Table on leave !!!

addhook('startround', 'wpnMode_startround')
function wpnMode_startround(m)
	playerEquipedWpnSet()
	-- Reset droppedTable
	dropItemOwner = l2(192, 3)
	-- Fill everyone's ammo
	if (refillAmmo) then
		for id = 1, 32 do
			for w = 1, 91 do
				parse('setammo '..id..' '..w..' 999 999')
			end
		end
	end
end

function playerEquipedWpnSet()
	for i = 1, 32 do
		if (player(i, 'exists')) then
			-- Set player weapon to 0(=no skins equipped)
			if (playerWpnOwner[i][1] == 0) then
				playerWpn[i][1] = 0 -- Primary Weapon
			end
			if (playerWpnOwner[i][2] == 0) then
				playerWpn[i][2] = 0 -- Secondary Weapon
			end			
			-- Check if player equipped skins
			local wpnTable = playerweapons(i)
			for _, w in pairs(wpnTable) do
				if (WDAT['ID'][w]) then				
					local slot = itemtype(w, 'slot')					
					if (equiped_wpn[i][w] ~= 0 and playerWpnOwner[i][slot] == 0 and slot <= 2) then
						playerWpn[i][slot] = equiped_wpn[i][w]
					end				
				end
			end
		end	
	end
end

addhook('buy', 'wpnMode_buy')
function wpnMode_buy(i, w)
	if (WDAT['ID'][w]) then
		if (not playerCheckSameBuy(i, w)) then
			local slot = itemtype(w, 'slot')
			if (playerCheckSlotExist(i, slot)) then
				playerWpnDropDebug[i][slot] = playerWpn[i][slot]
				playerWpnDropDebugParameters[i][1] = i
				playerWpnDropDebugParameters[i][2] = w
			else
				buyAndSetSkin(i, w)
			end
		end
	end
	-- Replace flare with menu
	if (w == 54 and allowMolotov) then
		menu(i, 'Buy Menu,Molotov|1000$,Flare|150$,Cancel')
		return 1
	end
end

function playerCheckSlotExist(i, s)
	local wpnTable = playerweapons(i)
	for _, w in pairs(wpnTable) do
		if (itemtype(w, 'slot') == s) then
			return true
		end
	end
	return false
end

function playerCheckSameBuy(i, w)
	local wpnTable = playerweapons(i)
	for _, x in pairs(wpnTable) do
		if (itemtype(x, 'slot') <= 2) then
			if (x == w) then
				return true
			end
		end
	end
	return false
end

function buyAndSetSkin(i, w)
	if (WDAT['ID'][w]) then
		local slot = itemtype(w, 'slot')
		if (equiped_wpn[i][w] ~= 0) then
			playerWpn[i][slot] = equiped_wpn[i][w]
		else
			playerWpn[i][slot] = 0
		end
	end
end

addhook('collect', 'wpnMode_collect')
function wpnMode_collect(id, iid, t, ain, a, mode)
	if (WDAT['ID'][t]) then
		-- Weapon Mode
		playerWpnMode[id][t] = mode
		-- Weapon & Owner
		local slot = itemtype(t, 'slot')
		if (slot <= 2) then
			if (dropItemOwner[iid][2] ~= id) then
				-- Collect someone else's weapon
				playerWpn[id][slot] = dropItemOwner[iid][3] -- Skin ID or 0 for default
				playerWpnOwner[id][slot] = dropItemOwner[iid][1] -- String:Xilver's
				playerWpnOwnerID[id][slot] = dropItemOwner[iid][2] -- ID of Dropper
			else
				-- Collect your own weapon
				playerWpn[id][slot] = dropItemOwner[iid][3]
				playerWpnOwner[id][slot] = 0
				playerWpnOwnerID[id][slot] = 0
			end
		end
		-- Clear droppedTable
		dropItemOwner[iid][1] = 0
		dropItemOwner[iid][2] = 0
		dropItemOwner[iid][3] = 0
	end
end

addhook('drop', 'wpnMode_drop')
function wpnMode_drop(id, iid, t, ain, a, mode, x, y)
	if (WDAT['ID'][t]) then
		-- Weapon Mode
		playerWpnMode[id][t] = 0
		-- WeaponName & OwnerID
		local slot = itemtype(t, 'slot')
		if (playerWpnOwner[id][slot] == 0) then
			-- Your own weapon
			dropItemOwner[iid][1] = (player(id, 'name').."'s ")
			dropItemOwner[iid][2] = id
		else
			-- Others weapon
			dropItemOwner[iid][1] = playerWpnOwner[id][slot]
			dropItemOwner[iid][2] = playerWpnOwnerID[id][slot]
		end
		-- Skins Index
		if (playerWpnDropDebug[id][slot] ~= 0) then
			dropItemOwner[iid][3] = playerWpnDropDebug[id][slot]
			playerWpnDropDebug[id][slot] = 0
		else
			dropItemOwner[iid][3] = playerWpn[id][slot]
		end
		playerWpn[id][slot] = 0
		playerWpnOwner[id][slot] = 0
		playerWpnOwnerID[id][slot] = 0
		-- Some Debug
		if (playerWpnDropDebugParameters[id][1] ~= 0) then
			buyAndSetSkin(playerWpnDropDebugParameters[id][1], playerWpnDropDebugParameters[id][2])
			playerWpnDropDebugParameters[id][1] = 0
			playerWpnDropDebugParameters[id][2] = 0
		end
	end
end

addhook('attack2', 'wpnMode_attack2')
function wpnMode_attack2(i, m)
	-- Weapon Mode
	local w = player(i, 'weapontype')
	if (WDAT['ID'][w]) then
		playerWpnMode[i][w] = m
	end	
end

addhook('select', 'wpnMode_select')
function wpnMode_select(id, t, mode)
	-- Weapon Mode
	playerWpnMode[id][t] = mode
end

addhook('ms100', 'wpnMode_slowdown')
function wpnMode_slowdown()
	if (not waterSlowdown) then
		for i = 1, 32 do
			if (player(i, 'exists')) then
				local w = player(i, 'weapontype')
				if (w == 31 or w == 33 or w == 91 or (w >=34 and w <= 37)) then
					if (playerWpnMode[i][w] ~= 0) then
						-- ScopeIn
						parse('speedmod '..i..' '..speedOffsetScopeIn..'')
						return
					end				
				end
				parse('speedmod '..i..' 0')
			end
		end
	end
end

addhook('menu', 'csgoMoly_menu')
function csgoMoly_menu(i, t, a)
	if (t == 'Buy Menu') then
		if (a == 1) then
			if (player(i, 'money') >= 1000) then
				parse('setmoney '..i..' '..player(i, 'money') - 1000)
				parse('equip '..i..' 73')
				parse('setweapon '..i..' 73')
			end	
		elseif (a == 2) then
			if (player(i, 'money') >= 150) then
				parse('setmoney '..i..' '..player(i, 'money') - 150)
				parse('equip '..i..' 54')
				parse('setweapon '..i..' 54')
			end	
		end
	end
end

addhook('movetile', 'csgo_water')
function csgo_water(i, x, y)
	-- Tile property 14 is wet floor
	if (not waterSlowdown) then return end
	if (tile(player(i, 'tilex'), player(i, 'tiley'), 'property') == 14) then
		parse('speedmod '..i..' -5')
	else
		parse('speedmod '..i..' 0')
	end
end

--addhook('die', 'csgo_c4')
function csgo_c4(i)
	if player(i, 'bomb') then
		local pdx, pdy = player(i, 'tilex'), player(i, 'tiley')
		-- Tile property 50~53 is deadly tile
		if (tile(pdx, pdy, 'property') >= 50 and tile(pdx, pdy, 'property') <= 53) then
			local bspawn = {}
			if tile(pdx + 1, pdy, 'walkable') then
				bspawn[1] = pdx + 1
				bspawn[2] = pdy
			elseif tile(pdx, pdy + 1, 'walkable') then
				bspawn[1] = pdx
				bspawn[2] = pdy + 1
			elseif tile(pdx - 1, pdy, 'walkable') then
				bspawn[1] = pdx - 1
				bspawn[2] = pdy
			elseif tile(pdx, pdy - 1, 'walkable') then
				bspawn[1] = pdx
				bspawn[2] = pdy - 1
			end
			parse('spawnitem 55 '..bspawn[1]..' '..bspawn[2])
		end
	end
end

addhook('join', 'csgo_music')
function csgo_music(i)
	mvpMusic[i] = math.random(#MUSICKIT)
end

addhook('say', 'csgo_say')
function csgo_say(i, text)
	-- Change bot skill
	if (text:sub(1, 9) == '!botskill') then
		local temp = string.split(text)
		local value = tonumber(temp[2])
		if (value ~= nil) then
			if (value == 1) then
				msg('\169000255000[Server] Bot Skill Changed : Normal')
				bskill = 1
			elseif (value == 2) then
				msg('\169000255000[Server] Bot Skill Changed : High')
				bskill = 2
			elseif (value == 3) then
				msg('\169000255000[Server] Bot Skill Changed : Advanced')
				bskill = 3
			elseif (value == 4) then
				msg('\169000255000[Server] Bot Skill Changed : Beast')
				bskill = 4
			else
				msg2(i, '\169255000000[Server] Must enter a number from range 1~4')
			end
		else
			msg2(i, '\169000255000[Server] Current BotSkill : '..bskill)
		end
		return 1
	end
	-- Change droprate
	if (text:sub(1, 9) == '!droprate') then
		local temp = string.split(text)
		local value = tonumber(temp[2])
		if (value ~= nil) then
			if (value > 0 and value <= 100) then
				droprate = value
				msg2(i, '\169000255000[Server] Droprate Set : '..value..'%')
			else
				msg2(i, '\169255000000[Server] Must enter a number from range 1~100')
			end
		else
			msg2(i, '\169000255000[Server] Current DropRate : '..droprate)
		end
		return 1
	end
	-- Change free armor
	if (text:sub(1, 10) == '!freearmor') then
		local temp = string.split(text)
		local value = tonumber(temp[2])
		if (value == 1) then
			freearmor = true
			msg2(i, '\169000255000[Server] Enable Free Armor')
		elseif (value == 0) then
			freearmor = false
			msg2(i, '\169000255000[Server] Disable Free Armor')
		else
			msg2(i, '\169255000000[Server] Must enter 0 or 1')
		end
		return 1
	end
	-- Change free defuse kit
	if (text:sub(1, 8) == '!freekit') then
		local temp = string.split(text)
		local value = tonumber(temp[2])
		if (value == 1) then
			freekit = true
			msg2(i, '\169000255000[Server] Enable Free Defusekit')
		elseif (value == 0) then
			freekit = false
			msg2(i, '\169000255000[Server] Disable Free Defusekit')
		else
			msg2(i, '\169255000000[Server] Must enter 0 or 1')
		end
		return 1
	end
	-- Show message on top
	if (text:sub(1, 5) == '!msg@') then
		local temp = string.splitSpace(text, '@')
		local value = temp[2]
		if (value ~= nil and value ~= '') then
			displayChoose(value)
			displayChar = 1
		end
		return 1
	end
	-- Check player's ADR
	if (string.lower(text:sub(1, 5)) == '!adr@') then
		local temp = tonumber(text:match('@(%d+)'))
		if (player(temp, 'exists')) then
			msg2(i, '['..player(temp, 'name')..'] ADR: '..math.floor((adr[temp]/game('round'))))
		end
		return 1
	end
end

addhook('ms100', 'csgo_ms100')
function csgo_ms100()
	-- Show each team total alive player
	parse('hudtxt 1 "\169000255000'..#player(0, "team2living")..'" 356 21 1 1 18')
	parse('hudtxt 2 "\169000255000'..#player(0, "team1living")..'" 494 21 1 1 18')
	for i = 1, 32 do
		-- Process 2 means player defusing
		if (player(i, 'process') == 2) then
			defusing[i] = true
		else
			defusing[i] = false
		end
	end
end

addhook('startround', 'csgo_start')
function csgo_start(m)
	parse('hudtxt 3 "\169255255255'..game('score_ct')..'" 400 31 1 1 16')
	parse('hudtxt 4 "\169255255255'..game('score_t')..'" 450 31 1 1 16')
	local icon1 = image('gfx/GOGFX/cticon.png', 356, 20, 2)
	local icon2 = image('gfx/GOGFX/tricon.png', 494, 20, 2)
	local icon3 = image('gfx/GOGFX/bar.png', 425, 20, 2)
end

---------------------------------------------------------------------
--MVP System---------------------------------------------------------
---------------------------------------------------------------------

mvp, ace, c4Planter, c4Defuser, hostageRescuer, mostKillT, mostKillCT = nil, nil, nil, nil, nil, nil, nil
killNumT, killNumCT, totalT, totalCT = 0, 0, 0, 0
killCount = l(32)
theKiller = l(32)
mvpCount = l(32)

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

addhook('kill', 'mvp_kill')
function mvp_kill(src, victim, wpn)
	if (player(src, 'team') ~= player(victim, 'team')) then
		killCount[src] = killCount[src] + 1
		theKiller[victim] = src
		if (player(src, 'team') == 1) then
			if (killCount[src] > killNumT) then
				mostKillT = src
				killNumT = killNumT + 1
			end
			if (totalCT >= 5 and killCount[src] >= totalCT) then
				ace = src
			end
		end
		if (player(src, 'team') == 2) then
			if (killCount[src] > killNumCT) then
				mostKillCT = src
				killNumCT = killNumCT + 1
			end
			if (totalT >= 5 and killCount[src] >= totalT) then
				ace = src
			end
		end
	end
end

addhook('bombplant', 'mvp_bombPlant')
function mvp_bombPlant(i)
	c4Planter = i
	for _, v in pairs(player(0, 'team1')) do
		parse('setmoney '..v..' '..player(v, 'money') + 300)
		msg2(v, '\169000255000$300 for planting the bomb')
	end
end

addhook('bombdefuse','mvp_bombDefuse')
function mvp_bombDefuse(i)
	c4Defuser = i
end

addhook('hostagerescue','mvp_hostageRescue')
function mvp_hostageRescue(i)
	hostageRescuer = i
end

addhook('endround', 'mvp_endround')
function mvp_endround(m)
	--20 Bomb detonated
	if (m == 20) then
		mvp = c4Planter
		win_img(1)
		parse('hudtxt 5 "\169255255255MVP: '..player(mvp, 'name')..' for planting the bomb" 265 115 0')
		print('\169000255255MVP: '..player(mvp, 'name')..' for planting the bomb')
	--21 Bomb defused
	elseif (m == 21) then
		mvp = c4Defuser
		win_img(2)
		parse('hudtxt 5 "\169255255255MVP: '..player(mvp, 'name')..' for defusing the bomb" 265 115 0')
		print('\169000255255MVP: '..player(mvp, 'name')..' for defusing the bomb')
	--31 Hostages rescued
	elseif (m == 31) then
		mvp = hostageRescuer		
		win_img(2)
		parse('hudtxt 5 "\169255255255MVP: '..player(mvp, 'name')..' for rescuing the hostages" 265 115 0')
		print('\169000255255MVP: '..player(mvp, 'name')..' for rescuing the hostages')
	--1, 10, 12, 30 Terror Win
	elseif (m == 1 or m == 10 or m == 12 or m == 30) then
		win_img(1)
		if (mostKillT == nil) then
			parse('hudtxt 5 "" 265 115 0')
		else
			mvp = mostKillT
			parse('hudtxt 5 "\169255255255MVP: '..player(mvp, 'name')..' for most eliminations" 265 115 0')
			print('\169000255255MVP: '..player(mvp, 'name')..' for most eliminations')
		end
	--2, 22, 11 Counter-Terror Win	
	elseif m==2 or m==22 or m==11 then
		win_img(2)
		if (mostKillCT == nil) then
			parse('hudtxt 5 "" 265 115 0')
		else
			mvp = mostKillCT
			parse('hudtxt 5 "\169255255255MVP: '..player(mvp, 'name')..' for most eliminations" 265 115 0')
			print('\169000255255MVP: '..player(mvp, 'name')..' for most eliminations')
		end
	end
	-- Play music kit and show avatar
	if (mvp ~= nil) then
		mvpCount[mvp] = mvpCount[mvp] + 1
		checkmvp()
		if (player(mvp, 'bot')) then
			-- Mvp Image
			local botSkin,skinImg = player(mvp, 'look') + 1
			if (player(mvp, 'team') == 1) then
				skinImg = ('t'..botSkin)
			elseif (player(mvp, 'team') == 2) then
				skinImg = ('ct'..botSkin)
			end
			local mvpAvatar = image('<spritesheet:gfx/player/'..skinImg..'.bmp:32:32:m>', 213, 138, 2)
			imageframe(mvpAvatar, 3)
			-- Music & Hud
			local botkit = math.random(#MUSICKIT)
			parse('sv_sound GOSE/MVP/'..botkit..'.ogg')
			local musicImg = image('gfx/GOGFX/mkimg/'..botkit..'.png', 256, 148, 2)
			parse('hudtxt 6 "\169155155155'..MUSICKIT[botkit][1]..', '..MUSICKIT[botkit][2]..'" 278 140 0')
		else
			-- Mvp Image
			local mvpAvatar = image('<avatar:'..mvp..'>', 211, 137, 2)
			if (player(mvp, 'usgn') ~= 0 or player(mvp, 'steamid') ~= '0') then
				imagescale(mvpAvatar, .68, .68)
			else
				imagescale(mvpAvatar, 1.4, 1.4)
			end
			-- Music & Hud
			parse('sv_sound GOSE/MVP/'..mvpMusic[mvp]..'.ogg')
			local musicImg = image('gfx/GOGFX/mkimg/'..mvpMusic[mvp]..'.png', 256, 148, 2)
			parse('hudtxt 6 "\169155155155'..MUSICKIT[mvpMusic[mvp]][1]..', '..MUSICKIT[mvpMusic[mvp]][2]..'" 278 140 0')
		end
		-- Give a random item
		local randomdrop, randomitem = math.random(1, 100), math.random(1, 100)
		if (randomdrop <= droprate) then
			if (randomitem == 1 or randomitem == 2) then
				-- GoldBox 2%
				save_dat[mvp][6] = save_dat[mvp][6] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "GOLD BOX"')
			elseif (randomitem == 3 or randomitem == 4) then
				-- GoldKey 2%
				save_dat[mvp][7] = save_dat[mvp][7] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "GOLD KEY"')
			elseif (randomitem >= 5 and randomitem <= 14) then
				-- SilverBox 10%
				save_dat[mvp][4] = save_dat[mvp][4] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "SILVER BOX"')
			elseif (randomitem >= 15 and randomitem <= 24) then
				-- SilverKey 10%
				save_dat[mvp][5] = save_dat[mvp][5] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "SILVER KEY"')
			elseif (randomitem >= 25 and randomitem <= 62) then
				-- BronzeBox 38%
				save_dat[mvp][2] = save_dat[mvp][2] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "BRONZE BOX"')
			elseif (randomitem >= 63 and randomitem <= 100) then
				-- BronzeKey 38%
				save_dat[mvp][3] = save_dat[mvp][3] + 1
				msg('\169255255000"'..player(mvp, 'name')..'" receive a "BRONZE KEY"')
			end
		end
	end
end

addhook('startround', 'mvp_startround')
function mvp_startround(m)
	-- Reset and clear hud
	parse('hudtxt 5 "" 265 115 0')-- Show mvp's name
	parse('hudtxt 6 "" 278 140 0')-- Show mvp's music kit name
	mvp, ace, c4Planter, c4Defuser, hostageRescuer, mostKillT, mostKillCT = nil, nil, nil, nil, nil, nil, nil
	killNumT, killNumCT = 0, 0
	totalT = #player(0, 'team1')
	totalCT = #player(0, 'team2')
	for i = 1, 32 do
		killCount[i] = 0
		theKiller[i] = 0
	end
end

-- CS2D has a default mvp system, this function fix mvp count in scoreboard
function checkmvp()
	for i = 1, 32 do
		if player(i, 'exists') then
			if (player(i, 'mvp') > mvpCount[i]) then
				parse('setmvp '..i..' '..(player(i, 'mvp') - 1)..'')
			elseif (player(i, 'mvp') < mvpCount[i]) then
				parse('setmvp '..i..' '..(player(i, 'mvp') + 1)..'')
			end
		end
	end
end

---------------------------------------------------------------------
--Headshot & Show Damage & Kill Message------------------------------
---------------------------------------------------------------------

hsRecoilPastTime = l(32)
hsPlayerAttacking = l(32)-- boolean
hsPlayerMoving = l(32)-- boolean
hsnow = l(32)-- Accuracy
hslost = l(32)-- Accuracy lost instead
hsMovingOffset = l(32)

playerHsTotal = l(32)
roundHsRecord = 2
mostHsPlayer = nil
hsBotOffset = {0, 5, 10, 15}

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

-- Return if equiped weapon's skin change data
function skinChanged(i, w)
	--if (equiped_wpn[i][w] ~= 0) then
	if (playerWpn[i][itemtype(w, 'slot')] ~= 0) then
		--if (SDAT['Change'][equiped_wpn[i][w]]) then
		if (SDAT['Change'][playerWpn[i][itemtype(w, 'slot')]]) then
			return true
		end
		return false
	end
	return false
end

-- Some weapons have diffirent mode status
function getReturnValue(isSkin, skinID--[[WeaponID if not isSkin]], mode, toReturn)
	if (toReturn == 0) then -- MaxHS%
		-- Skin Version
		if (isSkin) then
			if (mode == 1) then
				return typeCheck(SDAT['M1H'][skinID])
			end
			if (mode == 2) then
				return typeCheck(SDAT['M2H'][skinID])
			end
		-- Normal Version
		else
			if (mode == 1) then
				return typeCheck(WDAT['M1H'][skinID])
			end
			if (mode == 2) then
				return typeCheck(WDAT['M2H'][skinID])
			end
		end
	end
	if (toReturn == 1) then -- HeadshotDmg
		-- Skin Version
		if (isSkin) then
			if (mode == 1) then
				return typeCheck(SDAT['M1D'][skinID])
			end
			if (mode == 2) then
				return typeCheck(SDAT['M2D'][skinID])
			end
		-- Normal Version
		else
			if (mode == 1) then
				return typeCheck(WDAT['M1D'][skinID])
			end
			if (mode == 2) then
				return typeCheck(WDAT['M2D'][skinID])
			end
		end
	end
	if (toReturn == 2) then -- Recoil/Shot
		-- Skin Version
		if (isSkin) then
			if (mode == 1) then
				return typeCheck(SDAT['M1R'][skinID])
			end
			if (mode == 2) then
				return typeCheck(SDAT['M2R'][skinID])
			end
		-- Normal Version
		else
			if (mode == 1) then
				return typeCheck(WDAT['M1R'][skinID])
			end
			if (mode == 2) then
				return typeCheck(WDAT['M2R'][skinID])
			end
		end
	end
	return 0
end

function typeCheck(toCheck)
	if (type(toCheck) ~= 'number') then
		return 0
	end
	return toCheck
end

-- Some weapons have diffirent mode status
function modeChange(int, w, i, toReturn)
	local m = playerWpnMode[i][w]
	if (skinChanged(i, w)) then
		-- Skin Version
		local skinID = playerWpn[i][itemtype(w, 'slot')]
		if (SDAT['Mode'][skinID]) then
			return int + getReturnValue(true, skinID, m, toReturn)
		end
	else
		-- Normal Version
		if (WDAT['Mode'][w]) then
			return int + getReturnValue(false, w, m, toReturn)
		end
	end
	return int
end

addhook('move', 'hs_move')
function hs_move(i, x, y, walking)
	hsPlayerMoving[i] = true
	local wpnID = player(i, 'weapontype')
	if (WDAT['ID'][wpnID] and hsPlayerMoving[i]) then
		if (skinChanged(i, wpnID)) then
			if (walking == 1) then
				--hsMovingOffset[i] = SDAT['AccLW'][equiped_wpn[i][wpnID]]
				hsMovingOffset[i] = SDAT['AccLW'][playerWpn[i][itemtype(wpnID, 'slot')]]
			else
				--hsMovingOffset[i] = SDAT['AccLR'][equiped_wpn[i][wpnID]]
				hsMovingOffset[i] = SDAT['AccLR'][playerWpn[i][itemtype(wpnID, 'slot')]]
			end
		else
			if (walking == 1) then
				hsMovingOffset[i] = WDAT['AccLW'][wpnID]
			else
				hsMovingOffset[i] = WDAT['AccLR'][wpnID]
			end
		end
	end
end

addhook('ms100', 'hs_100')
function hs_100()
	for i = 1, 32 do
		if player(i, 'exists') then
			local wpnID = player(i, 'weapontype')
			if (WDAT['ID'][wpnID]) then
				if (skinChanged(i, wpnID)) then
					-- Skin Version
					-- Moving
					if (hsPlayerMoving[i]) then
						--hsnow[i] = SDAT['HMax'][equiped_wpn[i][wpnID]] - hslost[i] - hsMovingOffset[i]
						hsnow[i] = SDAT['HMax'][playerWpn[i][itemtype(wpnID, 'slot')]] - hslost[i] - hsMovingOffset[i]
					-- Not Moving
					elseif (not hsPlayerMoving[i]) then
						--hsnow[i] = SDAT['HMax'][equiped_wpn[i][wpnID]] - hslost[i]
						hsnow[i] = SDAT['HMax'][playerWpn[i][itemtype(wpnID, 'slot')]] - hslost[i]
					end
					-- BOT Offset
					if (player(i, 'bot')) then
						hsnow[i] = hsnow[i] + hsBotOffset[bskill]
					end
					-- Weapon Mode
					hsnow[i] = modeChange(hsnow[i], wpnID, i, 0)
					-- Min Headshot%
					--if (hsnow[i] < SDAT['HMin'][equiped_wpn[i][wpnID]]) then
					if (hsnow[i] < SDAT['HMin'][playerWpn[i][itemtype(wpnID, 'slot')]]) then
						--hsnow[i] = SDAT['HMin'][equiped_wpn[i][wpnID]]
						hsnow[i] = SDAT['HMin'][playerWpn[i][itemtype(wpnID, 'slot')]]
					end
					-- Accuracy value reset
					--if (not hsPlayerAttacking[i] and hsRecoilPastTime[i] >= SDAT['AccRT'][equiped_wpn[i][wpnID]]) then
					if (not hsPlayerAttacking[i] and hsRecoilPastTime[i] >= SDAT['AccRT'][playerWpn[i][itemtype(wpnID, 'slot')]]) then
						hsRecoilPastTime[i] = 0
						--hslost[i] = hslost[i] - SDAT['AccRV'][equiped_wpn[i][wpnID]]
						hslost[i] = hslost[i] - SDAT['AccRV'][playerWpn[i][itemtype(wpnID, 'slot')]]
						if (hslost[i] < 0) then hslost[i] = 0 end
					end
				else
					-- Normal Version
					-- Moving
					if (hsPlayerMoving[i]) then
						hsnow[i] = WDAT['HMax'][wpnID] - hslost[i] - hsMovingOffset[i]
					-- Not Moving
					elseif (not hsPlayerMoving[i]) then
						hsnow[i] = WDAT['HMax'][wpnID] - hslost[i]
					end
					-- BOT Offset
					if (player(i, 'bot')) then
						hsnow[i] = hsnow[i] + hsBotOffset[bskill]
					end
					-- Weapon Mode
					hsnow[i] = modeChange(hsnow[i], wpnID, i, 0)
					-- Min Headshot%
					if (hsnow[i] < WDAT['HMin'][wpnID]) then
						hsnow[i] = WDAT['HMin'][wpnID]
					end
					-- Accuracy value reset
					if (not hsPlayerAttacking[i] and hsRecoilPastTime[i] >= WDAT['AccRT'][wpnID]) then
						hsRecoilPastTime[i] = 0
						hslost[i] = hslost[i] - WDAT['AccRV'][wpnID]
						if (hslost[i] < 0) then hslost[i] = 0 end
					end
				end
				parse('hudtxt2 '..i..' 10 "\169255255255'..hsnow[i]..'%" 700 462 2')
			else
				parse('hudtxt2 '..i..' 10 "" 720 462 2')
			end
			hsPlayerMoving[i] = false
			hsPlayerAttacking[i] = false
			hsRecoilPastTime[i] = hsRecoilPastTime[i] + 1
		end
	end
end

addhook('select', 'hs_select')
function hs_select(i, t, m)
	hslost[i] = 0
end

addhook('attack', 'hs_atk')
function hs_atk(i)
	local wpnID = player(i, 'weapontype')
	if (WDAT['ID'][wpnID]) then
		hsPlayerAttacking[i] = true
		hsRecoilPastTime[i] = 0
		if (skinChanged(i, wpnID)) then
			-- Skin Version
			--local recoilPerShot = SDAT['AccLF'][equiped_wpn[i][wpnID]] - recoilOffset(i)
			--local recoilPerShot = SDAT['AccLF'][playerWpn[i][itemtype(wpnID, 'slot')]] - recoilOffset(i)
			-- Weapon Mode
			local recoilPerShot = modeChange(SDAT['AccLF'][playerWpn[i][itemtype(wpnID, 'slot')]], wpnID, i, 2) - recoilOffset(i)
			if (recoilPerShot < 1) then recoilPerShot = 1 end
			hslost[i] = hslost[i] + recoilPerShot
			-- Max Headshot%
			--if (hslost[i] > SDAT['HMax'][equiped_wpn[i][wpnID]]) then hslost[i] = SDAT['HMax'][equiped_wpn[i][wpnID]] end
			if (hslost[i] > SDAT['HMax'][playerWpn[i][itemtype(wpnID, 'slot')]]) then hslost[i] = SDAT['HMax'][playerWpn[i][itemtype(wpnID, 'slot')]] end
		else
			-- Normal Version
			--local recoilPerShot = WDAT['AccLF'][wpnID] - recoilOffset(i)
			-- Weapon Mode
			local recoilPerShot = modeChange(WDAT['AccLF'][wpnID], wpnID, i, 2) - recoilOffset(i)
			if (recoilPerShot < 1) then recoilPerShot = 1 end
			hslost[i] = hslost[i] + recoilPerShot
			-- Max Headshot%
			if (hslost[i] > WDAT['HMax'][wpnID]) then hslost[i] = WDAT['HMax'][wpnID] end
		end
	end
end

-- Calculate recoil offset per shot, lower recoil when crosshair closer to player
function recoilOffset(i)
	if (not player(i, 'bot') and player(i, 'mousedist') ~= -1) then
		if (player(i, 'mousedist') <= 32) then
			return 3-- Lowest
		elseif (player(i, 'mousedist') <= 48) then
			return 2-- Lower
		elseif (player(i, 'mousedist') <= 80) then
			return 1-- Low
		else
			return 0-- Normal
		end
	end
	return 0
end

function aimonhead(i, s, w)
	local enemyposx, enemyposy = player(i, 'x') - player(s, 'x') + 425, player(i, 'y') - player(s, 'y') + 240
	if (not player(s, 'bot')) then
		if (skinChanged(s, w)) then
			--local offset = SDAT['AimO'][equiped_wpn[s][w]]
			local offset = SDAT['AimO'][playerWpn[s][itemtype(w, 'slot')]]
			if (player(s, 'mousex') >= enemyposx - offset and player(s, 'mousex') <= enemyposx + offset and player(s, 'mousey') >= enemyposy - offset and player(s, 'mousey') <= enemyposy + offset) then
				return true
			else
				return false
			end
		else
			local offset = WDAT['AimO'][w]
			if (player(s, 'mousex') >= enemyposx - offset and player(s, 'mousex') <= enemyposx + offset and player(s, 'mousey') >= enemyposy - offset and player(s, 'mousey') <= enemyposy + offset) then
				return true
			else
				return false
			end
		end
	end
	return false
end

addhook('hit', 'hs_hit')
function hs_hit(i, s, w, hpdmg, apdmg, rawdmg)
	if (s >= 1 and s <= 32 and player(s, 'team') ~= player(i, 'team')) then
		if (WDAT['ID'][w] and w ~= 50) then 
			local hsCalc = hsnow[s]
			local rangeX, rangeY = math.abs(player(s, 'x') - player(i, 'x')), math.abs(player(s, 'y') - player(i, 'y'))
			-- Out of range
			if (rangeX >= WDAT['MRX'][w] or rangeY >= WDAT['MRY'][w]) then
				if (skinChanged(s, w)) then
					-- Skin Version
					--hsCalc = hsCalc - SDAT['AccLOR'][equiped_wpn[s][w]]
					hsCalc = hsCalc - SDAT['AccLOR'][playerWpn[s][itemtype(w, 'slot')]]
					--if (hsCalc < SDAT['HMin'][equiped_wpn[s][w]]) then hsCalc = SDAT['HMin'][equiped_wpn[s][w]] end
					if (hsCalc < SDAT['HMin'][playerWpn[s][itemtype(w, 'slot')]]) then hsCalc = SDAT['HMin'][playerWpn[s][itemtype(w, 'slot')]] end
					--parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (OutRange-'..SDAT['AccLOR'][equiped_wpn[s][w]]..')" 215 462 0')
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (OutRange-'..SDAT['AccLOR'][playerWpn[s][itemtype(w, 'slot')]]..')" 215 462 0')
				else
					-- Normal Version
					hsCalc = hsCalc - WDAT['AccLOR'][w]
					if (hsCalc < WDAT['HMin'][w]) then hsCalc = WDAT['HMin'][w] end
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (OutRange-'..WDAT['AccLOR'][w]..')" 215 462 0')
				end
			-- CQB
			elseif (rangeX <= 32 and rangeY <= 32) then
				if aimonhead(i, s, w) then
					hsCalc = hsCalc + 25
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (Aim/CQB+25)" 215 462 0')
				else
					hsCalc = hsCalc + 5
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (CQB+5)" 215 462 0')
				end
			-- Normal
			else
				if aimonhead(i, s, w) then
					hsCalc = hsCalc + 20
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'% (Aim+20)" 215 462 0')
				else
					parse('hudtxt2 '..s..' 11 "\169255255255'..hsCalc..'%" 215 462 0')
				end
			end
			local isHeadShot = math.random(1, 100)
			if (isHeadShot <= hsCalc) then
				parse('sv_sound2 '..s..' Headshot/headshot'..math.random(1, 3)..'.wav')
				parse('sv_sound2 '..i..' Headshot/headshot'..math.random(1, 3)..'.wav')
				local hsDamage
				-- Damage decrease (Can add more control later...)
				local decrease_value = 1
				if (rangeX > WDAT['MRD'][w] or rangeY > WDAT['MRD'][w]) then
					local rangedecrease = math.ceil(math.max((rangeX - WDAT['MRD'][w]) / 64, (rangeY - WDAT['MRD'][w]) / 64))
					if (rangedecrease > 10) then rangedecrease = 10 end
					decrease_value = 1 - (rangedecrease * 0.02)
				end
				-- Calculate headshot damage
				-- Normal Version
				if (player(i, 'armor') > 65 and not skinChanged(s, w)) then
					--hsDamage = math.floor(WDAT['DH'][w] * decrease_value) - hpdmg
					-- Weapon Mode
					hsDamage = math.floor(modeChange(WDAT['DH'][w], w, s, 1) * decrease_value) - hpdmg
					parse('setarmor '..i..' '..(player(i, 'armor') - 35)..'')
				elseif (player(i, 'armor') <= 65 and not skinChanged(s, w)) then
					--hsDamage = math.floor(WDAT['DNH'][w] * decrease_value) - hpdmg
					-- Weapon Mode
					hsDamage = math.floor(modeChange(WDAT['DNH'][w], w, s, 1) * decrease_value) - hpdmg
				-- Skin Version
				elseif (player(i, 'armor') > 65 and skinChanged(s, w)) then
					--hsDamage = math.floor(SDAT['DH'][equiped_wpn[s][w]] * decrease_value) - hpdmg
					--hsDamage = math.floor(SDAT['DH'][playerWpn[s][itemtype(w, 'slot')]] * decrease_value) - hpdmg
					-- Weapon Mode
					hsDamage = math.floor(modeChange(SDAT['DH'][playerWpn[s][itemtype(w, 'slot')]], w, s, 1) * decrease_value) - hpdmg
					parse('setarmor '..i..' '..(player(i, 'armor') - 35)..'')
				elseif (player(i, 'armor') <= 65 and skinChanged(s, w)) then
					--hsDamage = math.floor(SDAT['DNH'][equiped_wpn[s][w]] * decrease_value) - hpdmg
					--hsDamage = math.floor(SDAT['DNH'][playerWpn[s][itemtype(w, 'slot')]] * decrease_value) - hpdmg
					-- Weapon Mode
					hsDamage = math.floor(modeChange(SDAT['DNH'][playerWpn[s][itemtype(w, 'slot')]], w, s, 1) * decrease_value) - hpdmg
				end
				local ihealth = player(i, 'health') - hpdmg - hsDamage
				dmgDealt[i][s] = dmgDealt[i][s] + hpdmg + hsDamage
				dmgShot[i][s] = dmgShot[i][s] + 1
				if (ihealth <= 0) then
					-- Headshot status
					playerHsTotal[s] = playerHsTotal[s] + 1
					if (playerHsTotal[s] > roundHsRecord) then
						mostHsPlayer = player(s, 'name')
						roundHsRecord = roundHsRecord + 1
					end
					-- Kill progress
					parse('customkill '..s..' "'..itemtype(w, 'name')..'(Headshot),gfx/Headshot/'..itemtype(w, 'name')..'_hs.bmp" '..i)
					showkillerinfo(s, i, w)
					-- Create dead body
					if (player(i, 'team') == 1) then
						local img = image('gfx/GOGFX/db/hst'..math.random(1, 2)..'.bmp', 0, 0, 0)
						imagepos(img, player(i, 'x'), player(i, 'y'), player(s, 'rot'))
						imagescale(img, 1, 1)
					else
						local img = image('gfx/GOGFX/db/hsct'..math.random(1, 2)..'.bmp', 0, 0, 0)
						imagepos(img, player(i, 'x'), player(i, 'y'), player(s, 'rot'))
						imagescale(img, 1, 1)
					end
				else
					-- Didn't kill player, set health instead
					parse('sethealth '..i..' '..ihealth)
					return 1
				end
			else
				-- No headshot stuff
				dmgDealt[i][s] = dmgDealt[i][s] + hpdmg
				dmgShot[i][s] = dmgShot[i][s] + 1
			end
		else
			-- No weapon data set for that weapon and not knife hit
			if (w ~= 50) then
				dmgDealt[i][s] = dmgDealt[i][s] + hpdmg
				dmgShot[i][s] = dmgShot[i][s] + 1
			end
		end
	end
end

addhook('startround', 'hs_start')
function hs_start(m)
	mostHsPlayer = nil
	roundHsRecord = 2
	for i = 1, 32 do
		playerHsTotal[i] = 0
		hslost[i] = 0
		parse('hudtxt2 '..i..' 11 "\1692552552550%" 215 462 0')
		parse('hudtxt2 '..i..' 12 "" 425 390 0')
		parse('hudtxt2 '..i..' 13 "" 425 405 0')
		parse('hudtxt2 '..i..' 14 "" 425 420 0')
		for ii = 1, 32 do
			dmgDealt[i][ii] = 0
			dmgShot[i][ii] = 0
		end
	end
end

addhook('endround', 'dmgInfo_end')
function dmgInfo_end(m)
	for i = 1, 32 do
		-- ADR
		for v = 1, 32 do
			adr[i] = adr[i] + dmgDealt[v][i]
		end
		-- ADR
		if (not player(i, 'bot') and m ~= 4 and m ~= 5) then
			for x = 1, 32 do
				-- dmgDealt to [i:victim] by [x:source] 
				if (dmgDealt[i][x] ~= 0) then
					if (theKiller[i] == x) then
						-- Highlight the killer
						msg2(i, "\169000255000Damage Taken from \169255000000'"..player(x, 'name').."' \169000255000- "..dmgDealt[i][x].." in "..dmgShot[i][x].." hits")
					else
						msg2(i, "\169000255000Damage Taken from '"..player(x, 'name').."' - "..dmgDealt[i][x].." in "..dmgShot[i][x].." hits")
					end
				end
			end
			msg2(i, '\169000255000--------------------------------')
			for x = 1, 32 do
				if (dmgDealt[x][i] ~= 0) then
					msg2(i, "\169000255000Damage Given to '"..player(x, 'name').."' - "..dmgDealt[x][i].." in "..dmgShot[x][i].." hits")
				end
			end
		end
	end
end

addhook('die', 'dmgInfo_die')
function dmgInfo_die(v)
	parse('hudtxt2 '..v..' 11 "" 215 462 0')
	--Print damage info in console
	if (not player(v, 'bot')) then
		for x = 1, 32 do
			if (dmgDealt[v][x] ~= 0) then
				print("\169000000000Damage Taken from '"..player(x, 'name').."' - "..dmgDealt[v][x].." in "..dmgShot[v][x].." hits")
			end
		end
		print("\169000000000--------------------------------")
		for x = 1, 32 do
			if (dmgDealt[x][v] ~= 0) then
				print("\169000000000Damage Given to '"..player(x, 'name').."' - "..dmgDealt[x][v].." in "..dmgShot[x][v].." hits")
			end
		end
	end
end

addhook('kill', 'killerInfo')
function killerInfo(k, v, w)
	if (player(v, 'team') ~= player(k, 'team') and w < 100) then
		showkillerinfo(k, v, w)
	end
end

function showkillerinfo(s, v, w)
	-- A window made to show skins :D
	parse('hudtxt2 '..v..' 13 "\169255255255Damage Taken : '..dmgDealt[v][s]..' in '..dmgShot[v][s]..' hits" 425 405 0')
	parse('hudtxt2 '..v..' 14 "\169255255255Damage Given  : '..dmgDealt[s][v]..' in '..dmgShot[s][v]..' hits" 425 420 0')
	parse('hudtxtalphafade '..v..' 13 5000 0.0')
	parse('hudtxtalphafade '..v..' 14 5000 0.0')
	local enemywpn, bgimg, frontimg
	-- Get killer used skin
	--for k, x in pairs(SDAT['ID']) do
		--if (SDAT['ID'][k] == w and save_storage[s][k] == 2) then
			--enemywpn = k
			if (itemtype(w, 'slot') <= 2) then
				enemywpn = playerWpn[s][itemtype(w, 'slot')]
			elseif (itemtype(w, 'slot') == 3) then
				for k, x in pairs(SDAT['ID']) do
					if (SDAT['ID'][k] == w and save_storage[s][k] == 2) then
						enemywpn = k
					end
				end
			else
				enemywpn = nil
			end
		--end
	--end
	--if (enemywpn ~= nil) then
	if (enemywpn ~= nil and enemywpn ~= 0) then
		-- With skins
		bgimg = image('gfx/GOGFX/killimg/kill_bg_'..SDAT['Rare'][enemywpn]..'.png', 520, 358, 2, v)
		--parse('hudtxt2 '..v..' 12 "\169255255255Weapon : \169'..SDAT['Rare'][enemywpn]..''..SDAT['Name'][enemywpn]..'" 425 390 0')
		if (playerWpnOwner[s][itemtype(w, 'slot')] ~= 0 and w ~= 50) then
			parse('hudtxt2 '..v..' 12 "\169255255255Weapon : \169'..SDAT['Rare'][enemywpn]..''..playerWpnOwner[s][itemtype(w, 'slot')]..''..SDAT['Name'][enemywpn]..'" 425 390 0')
		else
			parse('hudtxt2 '..v..' 12 "\169255255255Weapon : \169'..SDAT['Rare'][enemywpn]..''..SDAT['Name'][enemywpn]..'" 425 390 0')
		end
		--
		local wpnimg = io.open('gfx/GOGFX/killimg/'..SDAT['Name'][enemywpn]..'_kill.png')
		if (wpnimg) then
			frontimg = image('gfx/GOGFX/killimg/'..SDAT['Name'][enemywpn]..'_kill.png', 520, 333, 2, v)
		else
			frontimg = image('gfx/GOGFX/killimg/'..itemtype(w, 'name')..'_kill.png', 520, 333, 2, v)
		end
	else
		-- No skins
		bgimg = image('gfx/GOGFX/killimg/kill_bg_white.png', 520, 358, 2, v)
		--parse('hudtxt2 '..v..' 12 "\169255255255Weapon : '..itemtype(w, 'name')..'" 425 390 0')
		if (playerWpnOwner[s][itemtype(w, 'slot')] ~= 0 and enemywpn ~= nil) then
			parse('hudtxt2 '..v..' 12 "\169255255255Weapon : '..playerWpnOwner[s][itemtype(w, 'slot')]..''..itemtype(w, 'name')..'" 425 390 0')
		else
			parse('hudtxt2 '..v..' 12 "\169255255255Weapon : '..itemtype(w, 'name')..'" 425 390 0')
		end
		local wpnimg = io.open('gfx/GOGFX/killimg/'..itemtype(w, 'name')..'_kill.png')
		if (wpnimg) then
			frontimg = image('gfx/GOGFX/killimg/'..itemtype(w, 'name')..'_kill.png', 520, 333, 2, v)
		else
			frontimg = image('gfx/GOGFX/killimg/undefined.png', 520, 333, 2, v)
		end
	end
	tween_alpha(bgimg, 5000, 0.0)
	tween_alpha(frontimg, 5000, 0.0)
	parse('hudtxtalphafade '..v..' 12 5000 0.0')
end

---------------------------------------------------------------------
--Fun Fact-----------------------------------------------------------
---------------------------------------------------------------------

player15Kill = l(32)
playerGrenadeKill = l(32)
playerGrenadeDmg = l(32)
playerAsLastKill = l(32)
playerKnifeKill = l(32)
playerGetHurtBy = l(32)
playerTotalDmgDealt = l(32)
playerKillDefuser = l(32)

playerDeathThisRound = false
FF_PreventDefuse, roundMostDefuserKill, FF_15Killer, roundMost15Kill = nil, 2, nil, 3
FF_takingKnife, FF_mostKnifeKill, roundMostKnifeKill = nil, nil, 0
FF_mostGrenadeKill, FF_mostGrenadeDmg, roundMostGrenadeDmg = nil, nil, 299
FF_asLastPlayerKillTR, FF_asLastPlayerKillCT, asLastMostKillTR, asLastMostKillCT = nil, nil, 2, 2
FF_roundTotalFire, FF_roundTimePass = 0, 0

displayTime = 0
displayChar = 1
displayText = nil
displayLength = nil

function displayChoose(str)
	if (str) then
		displayText = ('          '..str..'          ')
		displayLength = string.len(displayText)
	else
		local rnd = displayTable[math.random(#displayTable)]
		displayText = ('          '..rnd..'          ')
		displayLength = string.len(displayText)
	end
end

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

addhook('kill', 'funInfo_kill')
function funInfo_kill(k, v, w)
	if (player(k, 'team') ~= player(v, 'team')) then
		playerDeathThisRound = true
		-- Kills when HP Lower than 15
		if (player(k, 'health') <= 15) then
			player15Kill[k] = player15Kill[k] + 1
			if (player15Kill[k] > roundMost15Kill) then
				FF_15Killer = player(k, 'name')
				roundMost15Kill = roundMost15Kill + 1
			end
		end
		-- Knife kills
		if (w == 50 and w ~= 51) then
			playerKnifeKill[k] =playerKnifeKill[k] + 1
			if (playerKnifeKill[k] > roundMostKnifeKill) then
				FF_mostKnifeKill = player(k, 'name')
				roundMostKnifeKill = roundMostKnifeKill + 1
			end
		end
		-- Grenade kills
		if (w == 51) then
			playerGrenadeKill[k] = playerGrenadeKill[k] + 1
			if (playerGrenadeKill[k] >= 5) then
				FF_mostGrenadeKill = k
			end
		end
		-- Taking knife
		if (player(v, 'weapontype') == 50) then
			FF_takingKnife = player(v, 'name')
		end
		-- Kill defuser
		if (defusing[v]) then
			playerKillDefuser[k] = playerKillDefuser[k] + 1
			if (playerKillDefuser[k] > roundMostDefuserKill) then
				FF_PreventDefuse = player(k, 'name')
				roundMostDefuserKill = roundMostDefuserKill + 1
			end
		end
		-- Kills as last player
		local aliveTR, aliveCT = #player(0, 'team1living'), #player(0, 'team2living')
		if (aliveTR == 1 and player(k, 'team') == 1) then
			playerAsLastKill[k] = playerAsLastKill[k] + 1
			if (playerAsLastKill[k] > asLastMostKillTR) then
				FF_asLastPlayerKillTR = player(k, 'name')
				asLastMostKillTR = asLastMostKillTR + 1
			end
		end
		if (aliveCT == 1 and player(k, 'team') == 2) then
			playerAsLastKill[k] = playerAsLastKill[k] + 1
			if (playerAsLastKill[k] > asLastMostKillCT) then
				FF_asLastPlayerKillCT = player(k, 'name')
				asLastMostKillCT = asLastMostKillCT + 1
			end
		end
	end
end

addhook('hit', 'funInfo_hit')
function funInfo_hit(i, s, w, hpdmg, apdmg, rawdmg)
	if (s >= 1 and s <= 32 and player(s, 'team') ~= player(i, 'team')) then
		-- Total grenade damage done by player
		if (w == 51) then
			playerGrenadeDmg[s] = playerGrenadeDmg[s] + hpdmg
		end
		if (playerGrenadeDmg[s] > roundMostGrenadeDmg) then
			roundMostGrenadeDmg = playerGrenadeDmg[s]
			FF_mostGrenadeDmg = player(s, 'name')
		end
	end
end

addhook('attack', 'funInfo_attack')
function funInfo_attack(i)
	local w = player(i, 'weapontype')
	-- How many bullets fired this round
	if (WDAT['ID'][w] and w ~= 50) then
		FF_roundTotalFire = FF_roundTotalFire + 1
	end
end

-- Display fun info
addhook('endround', 'funInfo_end')
function funInfo_end(m)
	local roundTime = FF_roundTimePass - tonumber(game('mp_freezetime'))
	local hasLastPlayerKill, noCasualties = false, false
	local surviveFrom5Enemies, noKillDone = {}, {}
	-- Check if anyone did 300+ damage and get no kills
	-- Check if anyone survive from 5 diffirent enemies attacks
	for v = 1, 32 do
		playerGetHurtBy[v] = 0
		playerTotalDmgDealt[v] = 0
		for s = 1, 32 do
			if (player(v, 'exists') and dmgDealt[v][s] ~= 0) then
				playerGetHurtBy[v] = playerGetHurtBy[v] + 1
			end
			if (player(s,'exists') and dmgDealt[s][v] ~= 0) then
				playerTotalDmgDealt[v] = playerTotalDmgDealt[v] + dmgDealt[s][v]
			end
		end
		if (playerGetHurtBy[v] >= 5 and player(v, 'health') > 0) then
			table.insert(surviveFrom5Enemies, v)
		end
		if (playerTotalDmgDealt[v] >= 300 and killCount[v] == 0) then
			table.insert(noKillDone, v)
		end
	end
	-- Display fun info
	if (ace ~= nil) then
		parse('hudtxt 7 "\169255255255Ace!  '..player(ace, 'name')..' killed the entire enemy team." 425 170 1')
		print('\169000255255Ace!  '..player(ace, 'name')..' killed the entire enemy team.')
	end
	if (ace == nil and m ~= 4 and m ~= 5) then
		if (m == 1 or m == 10 or m == 12 or m == 20 or m == 30) then
			local totalTR = player(0, 'team1')
			if (#player(0, 'team1living') == #totalTR and #totalTR >= 5) then
				noCasualties = true
				parse('hudtxt 7 "\169255255255Terrorists won without taking any casualties." 425 170 1')
				print('\169000255255Terrorists won without taking any casualties.')
			end
		elseif (m == 2 or m == 11 or m == 21 or m == 22 or m == 31) then
			local totalCT = player(0, 'team2')
			if (#player(0, 'team2living') == #totalCT and #totalCT >= 5) then
				noCasualties = true
				parse('hudtxt 7 "\169255255255Counter-Terrorists won without taking any casualties." 425 170 1')
				print('\169000255255Counter-Terrorists won without taking any casualties.')
			end
		end
		-- Kill with headshot
		if (mostHsPlayer ~= nil and not noCasualties) then
			parse('hudtxt 7 "\169255255255'..mostHsPlayer..' killed '..roundHsRecord..' enemies with headshot that round." 425 170 1')
			print('\169000255255'..mostHsPlayer..' killed '..roundHsRecord..' enemies with headshot that round.')
		end
		-- Kills as last alive
		if (mostHsPlayer == nil and FF_asLastPlayerKillCT ~= nil and not noCasualties) then
			if (m == 2 or m == 21 or m == 22) then
				hasLastPlayerKill = true
				parse('hudtxt 7 "\169255255255As the last member alive, '..FF_asLastPlayerKillCT..' killed '..asLastMostKillCT..' enemies and won." 425 170 1')
				print('\169000255255As the last member alive, '..FF_asLastPlayerKillCT..' killed '..asLastMostKillCT..' enemies and won.')
			end
		end
		if (mostHsPlayer == nil and FF_asLastPlayerKillTR ~= nil and not noCasualties) then
			if (m == 1 or m == 20) then
				hasLastPlayerKill = true
				parse('hudtxt 7 "\169255255255As the last member alive, '..FF_asLastPlayerKillTR..' killed '..asLastMostKillTR..' enemies and won." 425 170 1')
				print('\169000255255As the last member alive, '..FF_asLastPlayerKillTR..' killed '..asLastMostKillTR..' enemies and won.')
			end
		end
		-- Survived from 5 diffirent attackers
		if (surviveFrom5Enemies[1] ~= nil and mostHsPlayer == nil and not hasLastPlayerKill and not noCasualties) then
			local rnd = surviveFrom5Enemies[math.random(#surviveFrom5Enemies)]
			parse('hudtxt 7 "\169255255255'..player(rnd, 'name')..' survived attacks from '..playerGetHurtBy[rnd]..' different enemies." 425 170 1')
			print('\169000255255'..player(rnd, 'name')..' survived attacks from '..playerGetHurtBy[rnd]..' different enemies.')
		end
		-- No kills done, but did lots of damage
		if (noKillDone[1] ~= nil and surviveFrom5Enemies[1] == nil and mostHsPlayer == nil and not hasLastPlayerKill and not noCasualties) then
			local rnd = noKillDone[math.random(#noKillDone)]
			parse('hudtxt 7 "\169255255255'..player(rnd, 'name')..' had no kills, but did '..playerTotalDmgDealt[rnd]..' damage." 425 170 1')
			print('\169000255255'..player(rnd, 'name')..' had no kills, but did '..playerTotalDmgDealt[rnd]..' damage.')
		end
		-- Else info
		if (surviveFrom5Enemies[1] == nil and noKillDone[1] == nil and mostHsPlayer == nil and not hasLastPlayerKill and not noCasualties) then
			-- Defend the bomb from being defused
			if (FF_PreventDefuse ~= nil) then
				parse('hudtxt 7 "\169255255255'..FF_PreventDefuse..' defended the planted bomb from '..roundMostDefuserKill..' enemies." 425 170 1')
				print('\169000255255'..FF_PreventDefuse..' defended the planted bomb from '..roundMostDefuserKill..' enemies.')
			end
			-- Most grenade kill
			if (FF_mostGrenadeKill ~= nil and roundMostKnifeKill <= 1 and FF_PreventDefuse == nil) then
				parse('hudtxt 7 "\169255255255'..player(FF_mostGrenadeKill, 'name')..' killed '..playerGrenadeKill[FF_mostGrenadeKill]..' enemies with grenades." 425 170 1')
				print('\169000255255'..player(FF_mostGrenadeKill, 'name')..' killed '..playerGrenadeKill[FF_mostGrenadeKill]..' enemies with grenades.')
			end
			-- Grenade damage
			if (FF_mostGrenadeDmg ~= nil and roundMostKnifeKill <= 1 and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil) then
				parse('hudtxt 7 "\169255255255'..FF_mostGrenadeDmg..' did '..roundMostGrenadeDmg..' total damage with grenades." 425 170 1')
				print('\169000255255'..FF_mostGrenadeDmg..' did '..roundMostGrenadeDmg..' total damage with grenades.')
			end
			-- 1 knife kill
			if (FF_mostKnifeKill ~= nil and roundMostKnifeKill == 1 and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil) then
				parse('hudtxt 7 "\169255255255'..FF_mostKnifeKill..' killed an enemy with the knife." 425 170 1')
				print('\169000255255'..FF_mostKnifeKill..' killed an enemy with the knife.')
			end
			-- More than 1 knife kill
			if (FF_mostKnifeKill ~= nil and roundMostKnifeKill > 1 and FF_PreventDefuse == nil) then
				parse('hudtxt 7 "\169255255255'..FF_mostKnifeKill..' had '..roundMostKnifeKill..' knife kills this round." 425 170 1')
				print('\169000255255'..FF_mostKnifeKill..' had '..roundMostKnifeKill..' knife kills this round.')
			end
			-- Kill when lower than 15hp
			if (FF_15Killer ~= nil and FF_mostKnifeKill == nil and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil) then
				parse('hudtxt 7 "\169255255255'..FF_15Killer..' killed '..roundMost15Kill..' enemies while under 15 health." 425 170 1')
				print('\169000255255'..FF_15Killer..' killed '..roundMost15Kill..' enemies while under 15 health.')
			end
			-- Fast round
			if (roundTime <= 25 and FF_mostKnifeKill == nil and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil and FF_15Killer == nil) then
				parse('hudtxt 7 "\169255255255That round took only '..roundTime..' seconds!" 425 170 1')
				print('\169000255255That round took only '..roundTime..' seconds!')
			end
			-- Someone brought knife to a gunfight
			if (FF_takingKnife ~= nil and roundTime > 25 and FF_mostKnifeKill == nil and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil and FF_15Killer == nil) then
				parse('hudtxt 7 "\169255255255'..FF_takingKnife..' brought a knife to a gunfight." 425 170 1')
				print('\169000255255'..FF_takingKnife..' brought a knife to a gunfight.')
			end
			-- Shots fired
			if (roundTime > 25 and playerDeathThisRound == true and FF_mostKnifeKill == nil and FF_takingKnife == nil and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil and FF_15Killer == nil) then
				parse('hudtxt 7 "\169255255255'..FF_roundTotalFire..' shots were fired that round." 425 170 1')
				print('\169000255255'..FF_roundTotalFire..' shots were fired that round.')
			end
			-- BlaBlaBla
			if (roundTime > 25 and playerDeathThisRound == false and FF_mostKnifeKill == nil and FF_takingKnife == nil and FF_mostGrenadeDmg == nil and FF_PreventDefuse == nil and FF_mostGrenadeKill == nil and FF_15Killer == nil) then
				local rnd = math.random(1, 2)
				if (rnd == 1) then
					parse('hudtxt 7 "\169255255255The cake is a lie." 425 170 1')
					print('\169000255255The cake is a lie.')
				else
					parse('hudtxt 7 "\169255255255Yawn." 425 170 1') 
					print('\169000255255Yawn.')
				end
			end
		end
	end
end

addhook('startround', 'funInfo_start')
function funInfo_start(m)
	parse('hudtxt 7 "" 425 170 1') 
	playerDeathThisRound = false
	FF_PreventDefuse, roundMostDefuserKill, FF_15Killer, roundMost15Kill = nil, 2, nil, 3
	FF_takingKnife, FF_mostKnifeKill, roundMostKnifeKill = nil, nil, 0
	FF_mostGrenadeKill, FF_mostGrenadeDmg, roundMostGrenadeDmg = nil, nil, 299
	FF_asLastPlayerKillTR, FF_asLastPlayerKillCT, asLastMostKillTR, asLastMostKillCT = nil, nil, 2, 2
	FF_roundTotalFire, FF_roundTimePass = 0, 0	
	for i = 1, 32 do
		player15Kill[i] = 0
		playerGrenadeKill[i] = 0
		playerGrenadeDmg[i] = 0
		playerAsLastKill[i] = 0
		playerKnifeKill[i] = 0
		playerKillDefuser[i] = 0
		if (freearmor) then
			parse('setarmor '..i..' 100')
		end
		if (freekit and (string.sub(string.lower(map('name')),1,3)=='de_')) then
			if (player(i, 'team') == 2) then
				parse('spawnitem 56 '..player(i, 'tilex')..' '..player(i, 'tiley')..'')
			end
		end
	end
end

addhook('second', 'funInfo_sec')
function funInfo_sec()
	FF_roundTimePass = FF_roundTimePass + 1
end

addhook('ms100', 'funInfo_ms100')
function funInfo_ms100()
	-- Text to display on top screen
	displayTime = displayTime + 1
	if (displayTime >= 3) then
		displayTime = 0
		if (displayText ~= nil and displayLength ~= nil) then
			if (displayChar + 9 >= #displayText) then
				displayChoose()
				displayChar = 1
			else
				displayChar = displayChar + 1
			end
			if (displayChar < math.floor(displayLength / 2)) then
				parse('hudtxt 8 "\169255255255'..displayText:sub(0 + displayChar, 9 + displayChar)..'" 470 8 2 1 16')
			elseif (displayChar > math.floor(displayLength / 2)) then
				parse('hudtxt 8 "\169255255255'..displayText:sub(0 + displayChar, 9 + displayChar)..'" 380 8 0 1 16')
			else
				parse('hudtxt 8 "\169255255255'..displayText:sub(0 + displayChar, 9 + displayChar)..'" 425 8 1 1 16')
			end
		else
			displayChoose()
		end
	end
end
---------------------------------------------------------------------
--Back Stab----------------------------------------------------------
---------------------------------------------------------------------

addhook('hit', 'bs_hit')
function bs_hit(i, s, w, hpdmg, apdmg, rawdmg)
	if (s >= 1 and s <= 32 and player(s, 'team') ~= player(i, 'team')) then
		-- Right click (dmg>60)
		if (w == 50 and rawdmg >= 60) then
			local rotBetween = math.abs(player(s, 'rot') - player(i, 'rot'))
			--Skin Knife is more powerful
			local rot1, rot2
			if (equiped_wpn[s][50] == 0) then
				rot1, rot2 = 330, 30
			else
				rot1, rot2 = 320, 40
			end
			if (rotBetween >= rot1 or rotBetween <= rot2) then
				-- If rotBetween >= 330 or rotBetween <= 30
				dmgDealt[i][s] = dmgDealt[i][s] + 100
				dmgShot[i][s] = dmgShot[i][s] + 1
				playerKnifeKill[s] = playerKnifeKill[s] + 1
				if (playerKnifeKill[s] > roundMostKnifeKill) then
					FF_mostKnifeKill = player(s, 'name')
					roundMostKnifeKill = roundMostKnifeKill + 1
				end
				if (equiped_wpn[s][50] == 0) then
					parse('customkill '..s..' "BackStab,gfx/GOGFX/BS.bmp" '..i)
				else
					parse('customkill '..s..' "'..SDAT['Name'][equiped_wpn[s][50]]..' (BackStab),gfx/GOGFX/'..SDAT['Icon'][equiped_wpn[s][50]]..'_k.bmp" '..i)
				end
				showkillerinfo(s, i, w)
			else
				dmgDealt[i][s] = dmgDealt[i][s] + hpdmg
				dmgShot[i][s] = dmgShot[i][s] + 1
				if (equiped_wpn[s][50] ~= 0) then
					local playerHealth = player(i, 'health')
					if (playerHealth - hpdmg <= 0) then
						playerKnifeKill[s] = playerKnifeKill[s] + 1
						if (playerKnifeKill[s] > roundMostKnifeKill) then
							FF_mostKnifeKill = player(s, 'name')
							roundMostKnifeKill = roundMostKnifeKill + 1
						end
						parse('customkill '..s..' "'..SDAT['Name'][equiped_wpn[s][50]]..',gfx/GOGFX/'..SDAT['Icon'][equiped_wpn[s][50]]..'_k.bmp" '..i)
						showkillerinfo(s, i, w)
					end
				end
			end
		-- Left click (dmg<60)
		elseif (w == 50 and rawdmg < 60) then
			dmgDealt[i][s] = dmgDealt[i][s] + hpdmg
			dmgShot[i][s] = dmgShot[i][s] + 1
			if (equiped_wpn[s][50] ~= 0) then
				local playerHealth = player(i, 'health')
				if (playerHealth - hpdmg <= 0) then
					playerKnifeKill[s] = playerKnifeKill[s] + 1
					if (playerKnifeKill[s] > roundMostKnifeKill) then
						FF_mostKnifeKill = player(s, 'name')
						roundMostKnifeKill = roundMostKnifeKill + 1
					end
					parse('customkill '..s..' "'..SDAT['Name'][equiped_wpn[s][50]]..',gfx/GOGFX/'..SDAT['Icon'][equiped_wpn[s][50]]..'_k.bmp" '..i)
					showkillerinfo(s, i, w)
				end
			end
		end
	end
end

---------------------------------------------------------------------
--Menu---------------------------------------------------------------
---------------------------------------------------------------------

addhook('serveraction', 'csgo_serveraction')
function csgo_serveraction(i, a)
	if (a == 1) then
		menu(i, 'Choose an action,Inventory,Loadout,Shop,Musickit|'..MUSICKIT[mvpMusic[i]][1]..'')
	end
end

addhook('menu', 'csgo_menu')
function csgo_menu(i, t, a)
	--
	if (t == 'Choose an action') then
		if (a == 1) then
			menu(i, 'Inventory,Medal : '..save_dat[i][1]..',Bronze Box (Key) : '..save_dat[i][2]..' ('..save_dat[i][3]..'),Silver Box (Key) : '..save_dat[i][4]..' ('..save_dat[i][5]..'),Gold Box (Key) : '..save_dat[i][6]..' ('..save_dat[i][7]..')')
		elseif (a == 2) then
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		elseif (a == 3) then
			menu(i, 'Shop,Gold Box |10000Medal,Silver Box |5000Medal,Bronze Box |1000Medal,Gold Key |10000Medal,Silver Key |5000Medal,Bronze Key |1000Medal')
		elseif (a == 4) then
			menu(i, 'Music Kit 1/5@b,AD8,All I Want For Chrismas,Crimson Assault,Desert Fire,Disgusting,High Noon,Hotline Miami,Metal,Next Page')
		end
	end
	if (t == 'Inventory' or t == 'Shop' or t == 'Music Kit 1/5' or t == 'Music Kit 2/5' or t == 'Music Kit 3/5' or t == 'Music Kit 4/5' or t == 'Music Kit 5/5') then
		if (a == 0) then
			menu(i, 'Choose an action,Inventory,Loadout,Shop,Musickit|'..MUSICKIT[mvpMusic[i]][1]..'')
		end
	end
	if (t == 'Inventory') then
		if (a == 2) then-- Bronze
			open_box(i, 1)
		elseif (a == 3) then-- Silver
			open_box(i, 2)
		elseif (a == 4) then-- Gold
			open_box(i, 3)
		end
	end
	if (t == 'Shop') then
		if (a == 1) then-- Gold Box
			if (save_dat[i][1] >= goldBoxPrice) then
				save_dat[i][1] = save_dat[i][1] - goldBoxPrice
				save_dat[i][6] = save_dat[i][6] + 1
				msg2(i, '\169000255000[Server] You purchase a Gold Box')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		elseif (a == 2) then-- Silver Box
			if (save_dat[i][1] >= silverBoxPrice) then
				save_dat[i][1] = save_dat[i][1] - silverBoxPrice
				save_dat[i][4] = save_dat[i][4] + 1
				msg2(i, '\169000255000[Server] You purchase a Silver Box')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		elseif (a == 3) then-- Bronze Box
			if (save_dat[i][1] >= bronzeBoxPrice) then
				save_dat[i][1] = save_dat[i][1] - bronzeBoxPrice
				save_dat[i][2] = save_dat[i][2] + 1
				msg2(i, '\169000255000[Server] You purchase a Bronze Box')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		elseif (a == 4) then
			if (save_dat[i][1] >= goldKeyPrice) then
				save_dat[i][1] = save_dat[i][1] - goldKeyPrice
				save_dat[i][7] = save_dat[i][7] + 1
				msg2(i, '\169000255000[Server] You purchase a Gold Key')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		elseif (a == 5) then
			if (save_dat[i][1] >= silverKeyPrice) then
				save_dat[i][1] = save_dat[i][1] - silverKeyPrice
				save_dat[i][5] = save_dat[i][5] + 1
				msg2(i, '\169000255000[Server] You purchase a Silver Key')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		elseif (a == 6) then
			if (save_dat[i][1] >= bronzeKeyPrice) then
				save_dat[i][1] = save_dat[i][1] - bronzeKeyPrice
				save_dat[i][3] = save_dat[i][3] + 1
				msg2(i, '\169000255000[Server] You purchase a Bronze Key')
			else
				msg2(i, '\169255000000[Server] You need more medal to purchase')
			end
		end
	end
	if (t == 'Weapon Loadout') then
		if (a == 1) then-- Pistol
			menu(i, 'Pistol Loadout,USP,GLOCK,DEAGLE,P228,ELITE,FIVESEVEN')
		elseif (a == 2) then-- Shotgun
			menu(i, 'Shotgun Loadout,M3,XM1014')
		elseif (a == 3) then-- SMG
			menu(i, 'SMG Loadout,MP5,TMP,P90,MAC10,UMP45')
		elseif (a == 4) then -- Rifle
			menu(i, 'Rifle Loadout,AK47,SG552,GALIL,M4A1,AUG,FAMAS')
		elseif (a == 5) then-- Sniper
			menu(i, 'Sniper Loadout,SCOUT,AWP,G3SG1,SG550')
		elseif (a == 6) then-- LMG
			menu(i, 'LMG Loadout,M249')
		elseif (a == 7) then-- Knife
			func_list(i, 50, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Choose an action,Inventory,Loadout,Shop,Musickit|'..MUSICKIT[mvpMusic[i]][1]..'')
		end
	end
	if (t == 'Pistol Loadout') then
		if (a == 1) then-- USP
			func_list(i, 1, 1)
		elseif (a == 2) then-- GLOCK
			func_list(i, 2, 1)
		elseif (a == 3) then-- DEAGLE
			func_list(i, 3, 1)
		elseif (a == 4) then-- P228
			func_list(i, 4, 1)
		elseif (a == 5) then-- ELITE
			func_list(i, 5, 1)
		elseif (a == 6) then-- FIVESEVEN
			func_list(i, 6, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	if (t == 'Shotgun Loadout') then
		if (a == 1) then-- M3
			func_list(i, 10, 1)
		elseif (a == 2) then-- XM1014
			func_list(i, 11, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	if (t == 'SMG Loadout') then
		if (a == 1) then-- MP5
			func_list(i, 20, 1)
		elseif (a == 2) then-- TMP
			func_list(i, 21, 1)
		elseif (a == 3) then-- P90
			func_list(i, 22, 1)
		elseif (a == 4) then-- MAC10
			func_list(i, 23, 1)
		elseif (a == 5) then-- UMP45
			func_list(i, 24, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	if (t == 'Rifle Loadout') then
		if (a == 1) then-- AK47
			func_list(i, 30, 1)
		elseif (a == 2) then-- SG552
			func_list(i, 31, 1)
		elseif (a == 3) then-- GALIL
			func_list(i, 38, 1)
		elseif (a == 4) then-- M4A1
			func_list(i, 32, 1)
		elseif (a == 5) then-- AUG
			func_list(i, 33, 1)
		elseif (a == 6) then-- FAMAS
			func_list(i, 39, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	if (t == 'Sniper Loadout') then
		if (a == 1) then-- SCOUT
			func_list(i, 34, 1)
		elseif (a == 2) then-- AWP
			func_list(i, 35, 1)
		elseif (a == 3) then-- G3SG1
			func_list(i, 36, 1)
		elseif (a == 4) then-- SG550
			func_list(i, 37, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	if (t == 'LMG Loadout') then
		if (a == 1) then-- M249
			func_list(i, 40, 1)
		elseif (a == 0) then-- RETURN
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		end
	end
	--IMPORTANT
	local page = tonumber(string.match(t, '%SPage (%d+)%S')) or 0
	for k, v in pairs(WDAT['ID']) do
		if (t == ''..itemtype(k, 'name')..' Loadout (Page '..page..')') then
			if (a == 0) then
				menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
			elseif (a == 9) then
				func_list(i, k, page + 1)
			else
				inventory_equip(k, a, page, i)
			end
		end
	end
	if (t == 'Knife Loadout (Page '..page..')') then
		if (a == 0) then
			menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
		elseif (a == 9) then
			func_list(i, 50, page + 1)
		else
			inventory_equip(50, a, page, i)
		end
	end
	--
	if (t == 'Music Kit 1/5') then
		if (a >= 1 and a <= 8) then
			mvpMusic[i] = a
			msg2(i, '\169000255255[Server] Musickit set : '..MUSICKIT[mvpMusic[i]][1])
		elseif (a == 9) then
			menu(i, 'Music Kit 2/5@b,Total Domination,Diamonds,Deaths Head Demolition,Battlepack,For No Mankind,I Am,Invasion!,Previous Page,Next Page')
		end
	end
	if (t == 'Music Kit 2/5') then
		if (a >= 1 and a <= 7) then
			mvpMusic[i] = a + 8
			msg2(i, '\169000255255[Server] Musickit set : '..MUSICKIT[mvpMusic[i]][1])
		elseif (a == 8) then
			menu(i, 'Music Kit 1/5@b,AD8,All I Want For Chrismas,Crimson Assault,Desert Fire,Disgusting,High Noon,Hotline Miami,Metal,Next Page')
		elseif (a == 9) then
			menu(i, 'Music Kit 3/5@b,IsoRhythm,Lions Mouth,Moments,Sharpened,The 8-bit Kit,The Talos Principle,Uber Blasto Phone,Previous Page,Next Page')
		end
	end
	if (t == 'Music Kit 3/5') then
		if (a >= 1 and a <= 7) then
			mvpMusic[i] = a + 15
			msg2(i, '\169000255255[Server] Musickit set : '..MUSICKIT[mvpMusic[i]][1])
		elseif (a == 8) then
			menu(i, 'Music Kit 2/5@b,Total Domination,Diamonds,Deaths Head Demolition,Battlepack,For No Mankind,I Am,Invasion!,Previous Page,Next Page')
		elseif (a == 9) then
			menu(i, 'Music Kit 4/5@b,II-Headshot,Insurgency,LNOE,MOLOTOV,Sponge Fingerz,Java Havana Funkaloo,Aggressive,Previous Page,Next Page')
		end
	end
	if (t == 'Music Kit 4/5') then
		if (a >= 1 and a <= 7) then
			mvpMusic[i] = a + 22
			msg2(i, '\169000255255[Server] Musickit set : '..MUSICKIT[mvpMusic[i]][1])
		elseif (a == 8) then
			menu(i, 'Music Kit 3/5@b,IsoRhythm,Lions Mouth,Moments,Sharpened,The 8-bit Kit,The Talos Principle,Uber Blasto Phone,Previous Page,Next Page')
		elseif (a == 9) then
			menu(i, "Music Kit 5/5@b,Backbone,Free,GLA,III-Arena,Life's Not Out To Get You,The Good Youth,Hazardous Environments,Previous Page")
		end
	end
	if (t == 'Music Kit 5/5') then
		if (a >= 1 and a <= 7) then
			mvpMusic[i] = a + 29
			msg2(i, '\169000255255[Server] Musickit set : '..MUSICKIT[mvpMusic[i]][1])
		elseif (a == 8) then
			menu(i, 'Music Kit 4/5@b,II-Headshot,Insurgency,LNOE,MOLOTOV,Sponge Fingerz,Java Havana Funkaloo,Aggressive,Previous Page,Next Page')
		end
	end
end

function func_list(i, wi, p)
	local temp_table = {}
	for k, v in pairs(SDAT['ID']) do
		if (v == wi) then
			if (save_storage[i][k] == 1) then
				table.insert(temp_table, SDAT['Name'][k])
			elseif (save_storage[i][k] == 2) then
				table.insert(temp_table, SDAT['Name'][k]..'|Equiped')
			end
		end
	end
	-- [pi]: page index 1,9,17... [l]: 0~7 [pi+l]: 1+0~1+7, 9+0~9+7 Got index of every page
	local pi, l = 1 + (p - 1) * 8, 0
	for x = 1, 8, 1 do
		if (temp_table[pi + l] == nil) then
			temp_table[pi + l] = '(EMPTY)'
			l = l + 1
		else
			l = l + 1
		end
	end
	if (wi == 50) then
		menu(i, 'Knife Loadout (Page '..p..'),'..temp_table[pi]..','..temp_table[pi+1]..','..temp_table[pi+2]..','..temp_table[pi+3]..','..temp_table[pi+4]..','..temp_table[pi+5]..','..temp_table[pi+6]..','..temp_table[pi+7]..',Next Page')
	else
		menu(i, ''..itemtype(wi, 'name')..' Loadout (Page '..p..'),'..temp_table[pi]..','..temp_table[pi+1]..','..temp_table[pi+2]..','..temp_table[pi+3]..','..temp_table[pi+4]..','..temp_table[pi+5]..','..temp_table[pi+6]..','..temp_table[pi+7]..',Next Page')
	end
end

function inventory_equip(wi, a, page, i)
	local temp_table = {}
	for k, v in pairs(SDAT['ID']) do
		if (v == wi and save_storage[i][k] >= 1) then
			table.insert(temp_table, k)
		end
	end
	-- Uneqip all first
	for k, v in pairs(save_storage[i]) do
		if (SDAT['ID'][k] == wi and save_storage[i][k] == 2) then
			save_storage[i][k] = 1
		end
	end
	save_storage[i][temp_table[a + (page - 1) * 8]] = 2-- 0=Not Owned 1=Owned 2=Equiped
	msg2(i, '\169000255255[Server] Equip '..itemtype(wi, 'name')..' with skin : \169'..SDAT['Rare'][temp_table[a + (page - 1) * 8]]..''..SDAT['Name'][temp_table[a + (page - 1) * 8]]..'')
	storage_array(i)
	menu(i, 'Weapon Loadout,Pistol,Shotgun,SMG,Rifle,Sniper,LMG,Knife')
end

---------------------------------------------------------------------
--Inventory----------------------------------------------------------
---------------------------------------------------------------------

isLoading = ls(32, false)
save_dat = l2(32, 7)
save_count = 7
save_storage = l2(32, #SDAT['Name'])
equiped_wpn = l2(32, 91)

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function storage_array(i)
	for k, v in pairs(equiped_wpn[i]) do
		equiped_wpn[i][k] = 0
	end
	for v = 1, #SDAT['Name'] do
		if (save_storage[i][v] == 2) then
			equiped_wpn[i][SDAT['ID'][v]] = v
		end
	end
end

addhook('ms100', 'skin_hudshow')
function skin_hudshow()
	for i = 1, 32 do
		if (not player(i, 'bot') and player(i, 'exists')) then
			if (player(i, 'health') > 0) then
				local wpnID, wpnheld = player(i, 'weapontype')
				if (WDAT['ID'][wpnID]) then
					--if (equiped_wpn[i][wpnID] ~= 0) then
						--wpnheld = ('\169'..SDAT['Rare'][equiped_wpn[i][wpnID]]..''..SDAT['Name'][equiped_wpn[i][wpnID]])
					--else
						--wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
					--end
					if (playerWpn[i][itemtype(wpnID, 'slot')] ~= 0) then
						if (playerWpnOwner[i][itemtype(wpnID, 'slot')] ~= 0) then
							wpnheld = ('\169'..SDAT['Rare'][playerWpn[i][itemtype(wpnID, 'slot')]]..''..playerWpnOwner[i][itemtype(wpnID, 'slot')]..''..SDAT['Name'][playerWpn[i][itemtype(wpnID, 'slot')]])
						else
							wpnheld = ('\169'..SDAT['Rare'][playerWpn[i][itemtype(wpnID, 'slot')]]..''..SDAT['Name'][playerWpn[i][itemtype(wpnID, 'slot')]])
						end
					else
						if (playerWpnOwner[i][itemtype(wpnID, 'slot')] ~= 0) then
							wpnheld = ('\169255255255'..playerWpnOwner[i][itemtype(wpnID, 'slot')]..itemtype(wpnID, 'name'))
						else
							wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
						end
					end
					parse('hudtxt2 '..i..' 22 "'..wpnheld..'" 660 462 2')
				else
					parse('hudtxt2 '..i..' 22 "" 660 462 2')
				end
				if (wpnID == 50) then
					if (equiped_wpn[i][wpnID] ~= 0) then
						wpnheld = ('\169'..SDAT['Rare'][equiped_wpn[i][wpnID]]..''..SDAT['Name'][equiped_wpn[i][wpnID]])
					else
						wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
					end
					parse('hudtxt2 '..i..' 22 "'..wpnheld..'" 820 457 2')
				end
			else
				local spec = player(i, 'spectating')
				local wpnID, wpnheld = player(spec, 'weapontype')
				if (WDAT['ID'][wpnID]) then
					--if (equiped_wpn[spec][wpnID] ~= 0) then
						--wpnheld = ('\169'..SDAT['Rare'][equiped_wpn[spec][wpnID]]..''..SDAT['Name'][equiped_wpn[spec][wpnID]])
					--else
						--wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
					--end
					if (playerWpn[spec][itemtype(wpnID, 'slot')] ~= 0) then
						if (playerWpnOwner[spec][itemtype(wpnID, 'slot')] ~= 0) then
							wpnheld = ('\169'..SDAT['Rare'][playerWpn[spec][itemtype(wpnID, 'slot')]]..''..playerWpnOwner[spec][itemtype(wpnID, 'slot')]..''..SDAT['Name'][playerWpn[spec][itemtype(wpnID, 'slot')]])
						else
							wpnheld = ('\169'..SDAT['Rare'][playerWpn[spec][itemtype(wpnID, 'slot')]]..''..SDAT['Name'][playerWpn[spec][itemtype(wpnID, 'slot')]])
						end
					else
						if (playerWpnOwner[spec][itemtype(wpnID, 'slot')] ~= 0) then
							wpnheld = ('\169255255255'..playerWpnOwner[spec][itemtype(wpnID, 'slot')]..itemtype(wpnID, 'name'))
						else
							wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
						end
					end
					parse('hudtxt2 '..i..' 22 "'..wpnheld..'" 820 430 2')
				else
					parse('hudtxt2 '..i..' 22 "" 820 430 2')
				end
				if (wpnID == 50) then
					if (equiped_wpn[spec][wpnID] ~= 0) then
						wpnheld = ('\169'..SDAT['Rare'][equiped_wpn[spec][wpnID]]..''..SDAT['Name'][equiped_wpn[spec][wpnID]])
					else
						wpnheld = ('\169255255255'..itemtype(wpnID, 'name'))
					end
					parse('hudtxt2 '..i..' 22 "'..wpnheld..'" 820 430 2')
				end
			end
		end
	end
end

addhook('team', 'dataLoad_team')
function dataLoad_team(i, t)
	if (t ~= 0 and not isLoading[i]) then
		isLoading[i] = true
		local sav = player(i, 'name')
		if (player(i, 'usgn') ~= 0) then
			sav = player(i, 'usgn')
		end
		if (player(i, 'steamid') ~= '0') then
			sav = player(i, 'steamid')
		end
		-- Load
		msg2(i, '\169000255000[Server] Loading save files : '..sav)
		local file = io.open('sys/lua/CSGO/'..sav..'.sav', 'r')
		local file_storage = io.open('sys/lua/CSGO/'..sav..'.storage', 'r')
		if (not file) then
			msg2(i, '\169255000000[Server] Failed to load data')
		else
			for v = 1, save_count do
				save_dat[i][v] = file:read('\*n')
			end
			file:close()
		end
		if (not file_storage) then
			msg2(i, '\169255000000[Server] Failed to load inventory')
		else
			for v = 1, #SDAT['Name'] do
				save_storage[i][v] = file_storage:read('\*n')
				if (save_storage[i][v] == nil) then save_storage[i][v] = 0 end
			end
			file_storage:close()
			storage_array(i)
		end
		isLoading[i] = false
	end
end

addhook('startround', 'dataSave_startround')
function dataSave_startround(m)
	for i = 1, 32 do
		if (player(i, 'exists') and player(i, 'team') ~= 0 and not isLoading[i]) then
			isLoading[i] = true
			local sav = player(i, 'name')
			if (player(i, 'usgn') ~= 0) then
				sav = player(i, 'usgn')
			end
			if (player(i, 'steamid') ~= '0') then
				sav = player(i, 'steamid')
			end
			-- Load
			local file = io.open('sys/lua/CSGO/'..sav..'.sav', 'w')
			local file_storage = io.open('sys/lua/CSGO/'..sav..'.storage', 'w')
			if (not file) then
				msg2(i, '\169255000000[Server] Failed to save data')
			else
				for v = 1, save_count do
					file:write(save_dat[i][v]..'\n')
				end
				file:close()
			end
			if (not file_storage) then
				msg2(i, '\169255000000[Server] Failed to save inventory')
			else
				for v = 1, #SDAT['Name'] do
					file_storage:write(save_storage[i][v]..'\n')
				end
				file_storage:close()
			end
			isLoading[i] = false
		end
	end
end

function open_box(i, lv)
	local igold, ired, ipink, ipurple, iblue, imedal
	if (lv == 1) then-- Bronze
		igold, ired, ipink, ipurple, iblue, imedal = 0, 1, 3, 6, 20, 70
		if (save_dat[i][2] >= 1 and save_dat[i][3] >= 1) then
			--Open
			random_item(igold, ired, ipink, ipurple, iblue, imedal, i)
			save_dat[i][2] = save_dat[i][2] - 1
			save_dat[i][3] = save_dat[i][3] - 1
		else
			--Not enough item
			msg2(i, '\169255000000[Server] You need more box or key to open.')
		end
	elseif (lv == 2) then-- Silver
		igold, ired, ipink, ipurple, iblue, imedal = 0, 2, 6, 12, 30, 50
		if (save_dat[i][4] >= 1 and save_dat[i][5] >= 1) then
			--Open
			random_item(igold, ired, ipink, ipurple, iblue, imedal, i)
			save_dat[i][4] = save_dat[i][4] - 1
			save_dat[i][5] = save_dat[i][5] - 1
		else
			--Not enough item
			msg2(i, '\169255000000[Server] You need more box or key to open.')
		end
	elseif (lv == 3) then-- Gold
		igold, ired, ipink, ipurple, iblue, imedal = 1, 2, 8, 24, 35, 30
		if (save_dat[i][6] >= 1 and save_dat[i][7] >= 1) then
			--Open
			random_item(igold, ired, ipink, ipurple, iblue, imedal, i)
			save_dat[i][6] = save_dat[i][6] - 1
			save_dat[i][7] = save_dat[i][7] - 1
		else
			--Not enough item
			msg2(i, '\169255000000[Server] You need more box or key to open.')
		end
	end
end

function random_item(g, r, pi, pu, b, m, i)
	local pick = {}
	local tempg, tempr, temppi, temppu, tempb = {}, {}, {}, {}, {}
	for k, v in pairs(SDAT['Rare']) do
		if (v == gold) then
			table.insert(tempg, '\169255100000'..SDAT['Name'][k])
		elseif (v == red) then
			table.insert(tempr, '\169255000000'..SDAT['Name'][k])
		elseif (v == pink) then
			table.insert(temppi, '\169255000255'..SDAT['Name'][k])
		elseif (v == purple) then
			table.insert(temppu, '\169150000255'..SDAT['Name'][k])
		elseif (v == blue) then
			table.insert(tempb, '\169000000255'..SDAT['Name'][k])
		end
	end
	if (g >= 1) then
		for t = 1, g, 1 do
			table.insert(pick, tempg[math.random(#tempg)])
		end
	end
	for t = 1, r, 1 do
		table.insert(pick, tempr[math.random(#tempr)])
	end
	for t = 1, pi, 1 do
		table.insert(pick, temppi[math.random(#temppi)])
	end
	for t = 1, pu, 1 do
		table.insert(pick, temppu[math.random(#temppu)])
	end
	for t = 1, b, 1 do
		table.insert(pick, tempb[math.random(#tempb)])
	end
	if (m >= 1) then
		for t = 1, m, 1 do
			table.insert(pick, '\169255255255Medal 50')
		end
	end
	--Mix up pick[]
	for m = 1, 100 do
		local no = math.random(100)
		local origin = pick[m]
		pick[m] = pick[no]
		pick[no] = origin
	end
	for m = 1, 7 do
		table.insert(pick, 1, '')
	end
	--Start animation hud:15 16 17 18 19 20 21
	local case_img = image('gfx/GOGFX/case_bar.png', 770, 248, 2, i)
	local rotating, x, speeddown = math.random(47, 77), 1, 1
	local percent80 = math.ceil(rotating * 0.8)
	parse('sv_sound2 '..i..' GOSE/crate_open.ogg')
	for a = 1, rotating do
		if (a >= percent80) then
			speeddown = speeddown + 0.02
		end
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 15 "'..pick[x]..'" 840 195 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 16 "'..pick[x+1]..'" 840 210 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 17 "'..pick[x+2]..'" 840 225 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 18 "'..pick[x+3]..'" 840 240 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 19 "'..pick[x+4]..'" 840 255 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 20 "'..pick[x+5]..'" 840 270 2')
		timer(100*x*speeddown,'parse','hudtxt2 '..i..' 21 "'..pick[x+6]..'" 840 285 2')
		x=x+1
	end
	timer(100*x*speeddown,'parse','msg \169000255255[Server] '..player(i,'name')..' received : '..pick[x+2]..'')
	timer(200*x*speeddown,'freeimage',case_img)
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 15 "" 840 195 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 16 "" 840 210 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 17 "" 840 225 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 18 "" 840 240 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 19 "" 840 255 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 20 "" 840 270 2')
	timer(200*x*speeddown,'parse','hudtxt2 '..i..' 21 "" 840 285 2')
	if (pick[x+2] == '\169255255255Medal 50') then
		timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_medal.ogg')
		save_dat[i][1] = save_dat[i][1] + 50
	end
	for k, v in pairs(SDAT['Name']) do
		local color = SDAT['Rare'][k]
		local wpn_name = ('\169'..color..''..v)
		if (pick[x+2] == wpn_name) then
			if (save_storage[i][k] == 0) then
				save_storage[i][k] = 1
				--Add sound effect
				if (color == gold) then
					timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_gold.ogg')
				elseif (color == red) then
					timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_red.ogg')
				elseif (color == pink) then
					timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_pink.ogg')
				elseif (color == purple) then
					timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_purple.ogg')
				elseif (color == blue) then
					timer(100*x*speeddown,'parse','sv_sound2 '..i..' GOSE/crate_blue.ogg')
				end
			--Change to Medal
			elseif (save_storage[i][k] == 1 or save_storage[i][k] == 2) then
				if (color == gold) then-- 2000
					save_dat[i][1] = save_dat[i][1] + 2000
					timer(100*x*speeddown,'parse','sv_msg2 '..i..' \169000255000[Server] You earned this skin already, exchange for 2000 Medal!')
				elseif (color == red) then-- 1200
					save_dat[i][1] = save_dat[i][1] + 1200
					timer(100*x*speeddown,'parse','sv_msg2 '..i..' \169000255000[Server] You earned this skin already, exchange for 1200 Medal!')
				elseif (color == pink) then-- 500
					save_dat[i][1] = save_dat[i][1] + 500
					timer(100*x*speeddown,'parse','sv_msg2 '..i..' \169000255000[Server] You earned this skin already, exchange for 500 Medal!')
				elseif (color == purple) then-- 200
					save_dat[i][1] = save_dat[i][1] + 200
					timer(100*x*speeddown,'parse','sv_msg2 '..i..' \169000255000[Server] You earned this skin already, exchange for 200 Medal!')
				elseif (color == blue) then-- 100
					save_dat[i][1] = save_dat[i][1] + 100
					timer(100*x*speeddown,'parse','sv_msg2 '..i..' \169000255000[Server] You earned this skin already, exchange for 100 Medal!')
				end
			end
		end
	end
end

addhook('endround', 'bot_equip_open')
function bot_equip_open()
	for i = 1, 32 do
		if (player(i, 'exists') and player(i, 'bot') and player(i, 'team') ~= 0) then
			--Buy Box or Key
			if (save_dat[i][1] >= math.max(bronzeBoxPrice, bronzeKeyPrice)) then
				local buyWhat = math.random(1, 2)
				if (buyWhat == 1) then-- Box
					save_dat[i][1] = save_dat[i][1] - bronzeBoxPrice
					save_dat[i][2] = save_dat[i][2] + 1
				elseif (buyWhat == 2) then-- Key
					save_dat[i][1] = save_dat[i][1] - bronzeKeyPrice
					save_dat[i][3] = save_dat[i][3] + 1
				end
			end
			if (save_dat[i][6] >= 1 and save_dat[i][7] >= 1) then
				--Open Gold
				open_box(i, 3)
			elseif (save_dat[i][4] >= 1 and save_dat[i][5] >= 1) then
				--Open Silver
				open_box(i, 2)
			elseif (save_dat[i][2] >= 1 and save_dat[i][3] >= 1) then
				--Open Bronze
				open_box(i, 1)
			end
			--Equip Weapon
			for k0, v0 in pairs(WDAT['ID']) do
				local bot_temp_wpn = {}
				for k, v in pairs(save_storage[i]) do
					if (save_storage[i][k] >= 1 and SDAT['ID'][k] == k0) then
						save_storage[i][k] = 1
						table.insert(bot_temp_wpn, k)
					end
				end
				if (bot_temp_wpn[1] ~= nil) then
					local rnd = math.random(#bot_temp_wpn)
					save_storage[i][bot_temp_wpn[rnd]] = 2
					equiped_wpn[i][k0] = bot_temp_wpn[rnd]
				end
			end
			--Equip Knife
			local bot_temp_knife = {}
			for k, v in pairs(save_storage[i]) do
				if (save_storage[i][k] >= 1 and SDAT['ID'][k] == 50) then
					save_storage[i][k] = 1
					table.insert(bot_temp_knife, k)
				end
			end
			if (bot_temp_knife[1] ~= nil) then
				local rnd = math.random(#bot_temp_knife)
				save_storage[i][bot_temp_knife[rnd]] = 2
				equiped_wpn[i][50] = bot_temp_knife[rnd]
			end
		end
	end
end
