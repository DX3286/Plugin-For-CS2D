--Lua by Dragon Lore--

--HOOK USEBUTTON
addhook('usebutton','Tstorm_ammobox')
function Tstorm_ammobox(id,x,y)
-------------------------------------------------
-------------------------------------------------
--ammo box 0--
if entity(x,y,"typename")=="Trigger_Use" and entity(x,y,"name")=="w0_boxopen" then
parse('sv_sound2 '..id..' T-Storm/metal_box_open.ogg')
local a0 = math.random(1,10)
if a0 == 1 then
parse('spawnitem 62 33 82')
elseif a0 == 2 then
parse('spawnitem 62 33 82')
elseif a0 == 3 then
parse('spawnitem 62 33 82')
elseif a0 == 4 then
parse('spawnitem 62 33 82')
elseif a0 == 5 then
parse('spawnitem 65 33 82')
elseif a0 == 6 then
parse('spawnitem 65 33 82')
elseif a0 == 7 then
parse('spawnitem 65 33 82')
elseif a0 == 8 then
parse('spawnitem 64 33 82')
elseif a0 == 8 then
parse('spawnitem 64 33 82')
elseif a0 == 8 then
parse('spawnitem 31 33 82')
end
end
-------------------------------------------------
-------------------------------------------------
--supply box 1--
if entity(x,y,"typename")=="Trigger_Use" and entity(x,y,"name")=="w1_boxopen" then
parse('sv_sound2 '..id..' T-Storm/metal_box_open.ogg')
parse('spawnitem 61 45 130')
parse('spawnitem 51 45 131')
end
-------------------------------------------------
-------------------------------------------------
--supply box 2--
if entity(x,y,"typename")=="Trigger_Use" and entity(x,y,"name")=="w2_boxopen" then
parse('sv_sound2 '..id..' T-Storm/metal_box_open.ogg')
local a1=math.random(1,5)
if a1==5 then
parse('spawnitem 34 95 69')
parse('spawnitem 69 96 69')
else
parse('spawnitem 69 95 69')
parse('spawnitem 62 96 69')
end
end
-------------------------------------------------
-------------------------------------------------
--Function完
end