--Change the game setting
parse('mp_timelimit 100')
parse('mp_roundtime 100')
parse('bot_jointeam 1')
parse('bot_autofill 0')
parse('mp_autoteambalance 0')
parse('sv_gamemode 4')
parse('mp_zombierecover 0')
parse('mp_zombiespeedmod 0')
parse('sv_fow 3')
parse('mp_dropgrenades 0')
parse('mp_deathdrop 3')
for x=1,(28-tonumber(game('bot_count'))) do
parse('bot_add_t')
end

function T(a,b)
local array={}
for z=1,a do
array[z]={}
for x=1,b do
array[z][x]=0
end
end
return array
end

--This two func create spawnpoint and insert in table (Spawnpoint: Info_BotNode, Named as 'T.spawn (x)')
function create_ent_table()
local entxy,entn={},{},{}
local spawn_list=entitylist()
for _,u in pairs(spawn_list) do
if entity(u.x,u.y,'typename')=='Info_BotNode' and entity(u.x,u.y,'name'):sub(1,7)=='T.spawn' then
local n=tonumber(entity(u.x,u.y,'name'):match('T%.spawn%s+(%d+)'))
if n then
table.insert(entxy,''..u.x..'.'..u.y..'')
table.insert(entn,n)
end
end
end
local array=ent_merge(entxy,entn)
return array
end
function ent_merge(entxy,entn)
local t={}
for _,v in pairs(entn) do
t[v]={}
end
for k1,v1 in ipairs(entn) do
for k2,v2 in ipairs(entxy) do
if k1==k2 then
table.insert(t[v1],v2)
end
end
end
return t
end
--									T.spawn (x)	tilex.tiley	tilex.tiley	tilex.tiley#3 entity call 'T.spawn 1', got 3 table value
spawnpoint=create_ent_table()--Ex:	[1]		  ={'30.10',	'30.11',	'30.12'}

--This func checks if item is in item_list
item_list={1,2,3,4,5,6,10,11,20,21,22,23,24,30,31,32,33,34,35,36,37,38,39,40,45,46,47,48,49,50,51,52,53,54,59,60,61,62,69,72,73,78,85,90,91}
function check_item(iid)
for _,v in pairs(item_list) do
if v==iid then
return true
end
end
return false
end
------------------------------------------------------------
--[1]:HP(All) [2]:ATK(ZB)/AimEventMeter(H) [3]:IsDown?(H) [4]TimeDown(H)/ZombieType(ZB) [5]ItemList(H)/TriggerOnDead(ZB) [6]Image(H)
--[7]DownTileX(H) [8]DownTileY(H) [9]RespawnMeter(H) [10]:ActionTarget(H) [11]:Medkit(H) [12]:Pills(H) [13]:Adrenalineshot(H)
--[14]:MedkitOut?(H) [15]:TempHealth(H) [16]:SpeedBoosting?(H) [17]:ConditionTable(All)
playerstats=T(32,17)

action_que={}--Include spawn event
enemy_waiting={}--Players who can be spawn
deadman={}--Players who cant change team
Tcounter={}--Counter event

gotwounded=0--Down players count (>0 then MS100 will check)
img_table_count=6 --[6]Image(H): Table==>[1]DownMask [2]SideBar [3]Medkit [4]Pills/Adrenalineshot [5]TargetImage [6]HoldMedkit
hudtxt_count=40--Hudtxt ID:40+ (1~32:Hudtxt2 33:ItemName 34:HelpPlayer 35~37:ServerAction1~3 38:TargetName 39:HealPlayer 40:AimEvent)

zb_def_speed=-3--Default zombie speed
zb_target_speed=1--Zombie speed when target on human
h_knife_speed=2--Human speed when holding knife(#50)
------------------------------------------------------------

addhook('usebutton','T_usebtn')---------------ADDHOOK USEBUTTON
function T_usebtn(i,x,y)
if check_condition(i,entity(x,y,'trigger'),true) then
local e=entity(x,y,'name')
------------------------------
local Twpn=tonumber(e:match('T%.wpn%((%d+)%)'))
local Tmsg=e:match('T%.msg%((.+)%)')
local Titem1,Titem2=e:match('T%.item%((%d+)%.(.+)%)')
local Tcon1,Tcon2,Tcon3=entity(x,y,'trigger'):match('T%.con%((.+)%.(%d+)%.(%-?%d+)%)')
------------------------------

--Get item script #Entity:Name: 'T.wpn(iid)'
if Twpn and check_item(Twpn) then
local wpnslot,itemlist=itemtype(Twpn,'slot'),playerweapons(i)
for _,iid in pairs(itemlist) do
if itemtype(iid,'slot')==wpnslot and wpnslot<4 and iid~=50 then parse('strip '..i..' '..iid..'') end
end
parse('sv_sound2 '..i..' T.virus/itempickup.wav')
parse('equip '..i..' '..Twpn..'')
parse('setweapon '..i..' '..Twpn..'')
end

--Fast message script #Entity:Name: 'T.msg(message)'
if Tmsg then msg(Tmsg) end

--Get medkit/pills/adrenalineshot script #Entity:Name: 'T.item(1~3.TriggerOnUse)'
if Titem1 and Titem2 then
if Titem1=='1' and not playerstats[i][11] then
parse('triggerposition '..x..' '..y..'')
parse('trigger "'..Titem2..'"')
playerstats[i][11]=true
playerstats[i][6][3]=image('gfx/T.virus/Script/Medkit.png',837,190,2,i)
imagealpha(playerstats[i][6][3],0.5)
elseif Titem1=='2' and not playerstats[i][12] then
parse('triggerposition '..x..' '..y..'')
parse('trigger "'..Titem2..'"')
playerstats[i][12],playerstats[i][13]=true,false
if playerstats[i][6][4]~=nil then freeimage(playerstats[i][6][4]) end
playerstats[i][6][4]=image('gfx/T.virus/Script/Pills.png',837,240,2,i)
imagealpha(playerstats[i][6][4],0.5)
elseif Titem1=='3' and not playerstats[i][13] then
parse('triggerposition '..x..' '..y..'')
parse('trigger "'..Titem2..'"')
playerstats[i][13],playerstats[i][12]=true,false
if playerstats[i][6][4]~=nil then freeimage(playerstats[i][6][4]) end
playerstats[i][6][4]=image('gfx/T.virus/Script/Adrenaline.png',837,240,2,i)
imagealpha(playerstats[i][6][4],0.5)
end
end

--Condition script #Entity:Trigger: 'T.con(TableID.Who? 0:Who use btn 1:All TR 2:All CT.+-value)'
if Tcon1 and Tcon2 and Tcon3 then
for _,pl in pairs(player(0,'table')) do
if playerstats[pl][17][Tcon1]==nil then
playerstats[pl][17][Tcon1]=0
end
end
if Tcon2=='0' then--Player who use btn
playerstats[i][17][Tcon1]=playerstats[i][17][Tcon1]+tonumber(Tcon3)
elseif Tcon2=='1' then--All TR
for _,pl in pairs(player(0,'team1')) do
playerstats[pl][17][Tcon1]=playerstats[pl][17][Tcon1]+tonumber(Tcon3)
end
elseif Tcon2=='2' then--All CT
for _,pl in pairs(player(0,'team2')) do
playerstats[pl][17][Tcon1]=playerstats[pl][17][Tcon1]+tonumber(Tcon3)
end
end
end
end
end

addhook('ms100','T_ms100')---------------ADDHOOK MS100
function T_ms100()
for _,i in pairs(player(0,'team2living')) do
if not player(i,'bot') then
local mx,my=player(i,'tilex')+math.floor((player(i,'mousex')-409)/32),player(i,'tiley')+math.floor((player(i,'mousey')-224)/32)
local fx,fy=(player(i,'mousex')+10),player(i,'mousey')

--Show entity name script #Entity:Name: 'T.wpn(iid)' or 'T.item(1~3.TriggerOnUse)'
if entity(mx,my,'exists') and not entity(mx,my,'state') then
local iid=tonumber(entity(mx,my,'name'):match('T%.wpn%((%d+)%)'))
local Titem=entity(mx,my,'name'):match('T%.item%((%d+)%.')
if check_item(iid) then
parse('hudtxt2 '..i..' 33 "[E] '..itemtype(iid,'name')..'" '..fx..' '..fy..' 1')
elseif Titem then
if Titem=='1' then parse('hudtxt2 '..i..' 33 "[E] Medkit" '..fx..' '..fy..' 1')
elseif Titem=='2' then parse('hudtxt2 '..i..' 33 "[E] Pills" '..fx..' '..fy..' 1')
elseif Titem=='3' then parse('hudtxt2 '..i..' 33 "[E] Adrenalineshot" '..fx..' '..fy..' 1')
else parse('hudtxt2 '..i..' 33 "" 0 0 1')
end
else parse('hudtxt2 '..i..' 33 "" 0 0 1')
end
else parse('hudtxt2 '..i..' 33 "" 0 0 1')
end

--Help down teammate script (Stand nearby and aim for 5 seconds)
if gotwounded>0 and not playerstats[i][3] and not playerstats[i][14] then
local id=playerstats[i][10]
if player(id,'exists') and playerstats[id][7]~=nil and playerstats[id][8]~=nil and playerstats[id][3] and check_aim_spot(i,mx,my,playerstats[id][7],playerstats[id][8],false) then
parse('hudtxt2 '..i..' 34 "['..(playerstats[i][9]*2)..'%] Helping '..player(id,'name')..'" '..fx..' '..fy..' 1')
playerstats[i][9]=playerstats[i][9]+1
parse('setweapon '..i..' 50')
if playerstats[i][9]>50 then
help_and_spawn(i,id)
playerstats[i][9]=0
parse('hudtxt2 '..i..' 34 "" 0 0 1')
end
else
playerstats[i][9]=0
parse('hudtxt2 '..i..' 34 "" 0 0 1')
end
else
parse('hudtxt2 '..i..' 34 "" 0 0 1')
end

--Use medkit script (Stand nearby and aim for 5 seconds)
if playerstats[i][14] and not playerstats[i][3] then
local id=playerstats[i][10]
if player(id,'exists') and player(id,'health')>0 and player(id,'health')<100 and not playerstats[id][3] then
local cc
if id==i then cc=check_aim_spot(i,mx,my,player(id,'tilex'),player(id,'tiley'),true) end
if id~=i then cc=check_aim_spot(i,mx,my,player(id,'tilex'),player(id,'tiley'),false) end
if cc then
parse('hudtxt2 '..i..' 39 "['..(playerstats[i][9]*2)..'%] Healing '..player(id,'name')..'" '..fx..' '..fy..' 1')
playerstats[i][9]=playerstats[i][9]+1
if playerstats[i][9]>50 then
heal_and_spawn(i,id)
playerstats[i][9]=0
parse('hudtxt2 '..i..' 39 "" 0 0 1')
end
else
playerstats[i][9]=0
parse('hudtxt2 '..i..' 39 "" 0 0 1')
end
else
playerstats[i][9]=0
parse('hudtxt2 '..i..' 39 "" 0 0 1')
end
else
parse('hudtxt2 '..i..' 39 "" 0 0 1')
end

--Aim at entity script #Entity:Trigger: 'T.aim(Time.Tip.Trigger)'
if entity(mx,my,'exists') and not entity(mx,my,'state') and entity(mx,my,'trigger'):match('T%.aim') and not playerstats[i][3] and check_condition(i,entity(mx,my,'trigger'),false) then
local Taim1,Taim2,Taim3=entity(mx,my,'trigger'):match('T%.aim%((%d+)%.(%w+)%.(.+)%)')
if Taim1 and Taim2 and Taim3 then
if check_aim_spot(i,mx,my,mx,my,false) then
parse('hudtxt2 '..i..' 40 "['..math.floor(playerstats[i][2]*(100/tonumber(Taim1)))..'%] '..Taim2..'" '..fx..' '..fy..' 1')
playerstats[i][2]=playerstats[i][2]+1
if playerstats[i][2]>tonumber(Taim1) then
playerstats[i][2]=0
parse('trigger "'..Taim3..'"')
parse('hudtxt2 '..i..' 40 "" 0 0 1')
check_condition(i,entity(mx,my,'trigger'),true)
end
end
end
else
playerstats[i][2]=0
parse('hudtxt2 '..i..' 40 "" 0 0 1')
end
end
end
end

--This func checks if aiming on specific player and standing around him (Value 'around_or_at': True=at, False=around)
function check_aim_spot(s,mx,my,ix,iy,around_or_at)
local x,y=player(s,'tilex'),player(s,'tiley')
if around_or_at then
if math.abs(x-ix)==0 and math.abs(y-iy)==0 then
if mx==ix and my==iy then
return true
end
end
else
if math.abs(x-ix)<=1 and math.abs(y-iy)<=1 and not (x-ix==0 and y-iy==0) then
if mx==ix and my==iy then
return true
end
end
end
return false
end

--This func resets down player stats when rescued
function help_and_spawn(i,id)
msg2(id,'Yor were rescue by: '..player(i,'name')..' @C')
gotwounded=gotwounded-1
playerstats[id][4]=playerstats[id][4]+1
playerstats[id][1],playerstats[id][3],playerstats[id][7],playerstats[id][8]=100-playerstats[id][4]*25,false,nil,nil
freeimage(playerstats[id][6][1])
for _,v in pairs(playerstats[id][5]) do
if v~=50 then parse('strip '..id..' '..v) end
end
for _,v in pairs(playerstats[id][5]) do
if v~=50 then parse('equip '..id..' '..v) end
end
playerstats[id][5]=0
if playerstats[id][4]==2 then
playerstats[id][6][1]=image('gfx/T.virus/Script/Down_mask.bmp',425,240,2,id)
imagealpha(playerstats[id][6][1],0.5)
end
end

--This func do all thing when heal someone
function heal_and_spawn(i,id)
msg2(id,'Yor were heal by: '..player(i,'name')..' @C')
if playerstats[id][1]+50>100 then
playerstats[id][1]=100
else
playerstats[id][1]=playerstats[id][1]+50
end
playerstats[i][11],playerstats[i][14]=false,false
parse('hudtxt2 '..i..' 35 "1" 820 182 2')
freeimage(playerstats[i][6][3])
freeimage(playerstats[i][6][6])
if playerstats[id][4]==2 then
freeimage(playerstats[id][6][1])
playerstats[id][4]=1
end
end

addhook('trigger','T_trigger')---------------ADDHOOK TRIGGER
function T_trigger(n,s)
--Spawn enemy #Entity:Trigger: 'Ts.spawn point.how many players.health.speed.atk.zbtype.(triggerondead)'
--About ZBTYPE: 0:Normal 1:Boomer 2:Smoker 3:Tank ANY:Custom
if n:sub(1,2)=='Ts' then
local c=spawn_split_check(n)
if c then
local spawn,players,health,speed,atk=tonumber(c[2]),tonumber(c[3]),tonumber(c[4]),tonumber(c[5]),tonumber(c[6])
local zbtype=tonumber(c[7]) or c[7]
local ondead=c[8] or nil
if players<=#enemy_waiting then
pick_player(spawn,players,health,speed,atk,zbtype,ondead)
else
--Not enough player to spawn, add spawn event to que
table.insert(action_que,n)
end
else
msg('\169255000000[Error] Invalid format')
end
end

--Counter Event #Entity:Trigger: 'T.cnt(CounterName.TargetNumber.Tip?(1:Yes).TriggerOnReach)'
local Cnt1,Cnt2,Cnt3,Cnt4=n:match('T%.cnt%((.+)%.(%d+)%.(%d+)%.(.+)%)')
if Cnt1 and Cnt2 and Cnt3 and Cnt4 then
if Tcounter[Cnt1]==nil then
Tcounter[Cnt1]={1,tonumber(Cnt2),Cnt4}
else
Tcounter[Cnt1][1]=Tcounter[Cnt1][1]+1
if Tcounter[Cnt1][1]>=Tcounter[Cnt1][2] then
if Cnt3=='1' then
msg('['..Cnt1..']: '..Tcounter[Cnt1][1]..' / '..Tcounter[Cnt1][2]..'')
end
parse('trigger "'..Tcounter[Cnt1][3]..'"')
Tcounter[Cnt1]=nil
end
end
if Tcounter[Cnt1]~=nil and Cnt3=='1' then
msg('['..Cnt1..']: '..Tcounter[Cnt1][1]..' / '..Tcounter[Cnt1][2]..'')
end
end
end
--This func checks entity trigger format above
function spawn_split_check(s)
local cache={}
for m in s:gmatch('[^%.]+') do table.insert(cache,m) end
if (#cache~=7 and #cache~=8) or tonumber(cache[2])==nil or tonumber(cache[3])==nil or tonumber(cache[4])==nil or tonumber(cache[5])==nil or tonumber(cache[6])==nil then return false end
if spawnpoint[tonumber(cache[2])]==nil or tonumber(cache[3])<1 or tonumber(cache[4])<1 then return false end
return cache
end

addhook('second','T_second')---------------ADDHOOK SECOND
function T_second()
--If there are spawn event in que, trigger them
if action_que[1]~=nil then
local c={}
for m in action_que[1]:gmatch('[^%.]+') do table.insert(c,m) end
if tonumber(c[3])<=#enemy_waiting then
local spawn,players,health,speed,atk=tonumber(c[2]),tonumber(c[3]),tonumber(c[4]),tonumber(c[5]),tonumber(c[6])
local zbtype=tonumber(c[7]) or c[7]
local ondead=c[8] or nil
pick_player(spawn,players,health,speed,atk,zbtype,ondead)
table.remove(action_que,1)
end
end
--Drop health every seconds when down or use pills/adrenaline
for _,i in pairs(player(0,'team2living')) do
if playerstats[i][3] then
playerstats[i][1]=playerstats[i][1]-1
end
if playerstats[i][15]~=0 then
if playerstats[i][1]>playerstats[i][15] then
playerstats[i][1]=playerstats[i][1]-1
else
playerstats[i][15]=0
end
end
end
--Check if Bots on teleport entity
for _,i in pairs(player(0,'team1living')) do
local px,py=player(i,'tilex'),player(i,'tiley')
if entity(px,py,'exists') then
local tx,ty=entity(px,py,'trigger'):match('T%.tel%((%d+)%.(%d+).*%)')
local tt=entity(px,py,'trigger'):match('T%.tel%(%d+%.%d+%.([12])%)')
if tx and ty then
if tt==nil then
parse('setpos '..i..' '..(tonumber(tx)*32+16)..' '..(tonumber(ty)*32+16)..'')
elseif tt=='1' and player(i,'team')==1 then
parse('setpos '..i..' '..(tonumber(tx)*32+16)..' '..(tonumber(ty)*32+16)..'')
end
end
end
end
end

addhook('startround_prespawn','T_startround')---------------ADDHOOK STARTROUND_PRESPAWN
function T_startround()
--Reset table & var
enemy_waiting,action_que,deadman,Tcounter={},{},{},{}
gotwounded=0
end

addhook('endround','T_endround')---------------ADDHOOK ENDROUND
function T_endround()
--Reset Bots TriggerOnDead
for _,i in pairs(player(0,'team1')) do
playerstats[i][5]=0
end
end

addhook('spawn','T_spawn')---------------ADDHOOK SPAWN
function T_spawn(i)
--For Bots
if player(i,'team')==1 and player(i,'bot') then
table.insert(enemy_waiting,i)
playerstats[i][1],playerstats[i][2],playerstats[i][4],playerstats[i][5],playerstats[i][6]=100,2,0,0,{}
playerstats[i][17]={}
parse('speedmod '..i..' '..zb_def_speed)
end
--For Players
if player(i,'team')==2 and not player(i,'bot') then
playerstats[i][1],playerstats[i][3],playerstats[i][4],playerstats[i][5],playerstats[i][6]=100,false,0,0,{}
playerstats[i][7],playerstats[i][8],playerstats[i][9],playerstats[i][10]=nil,nil,0,i
playerstats[i][11],playerstats[i][12],playerstats[i][13],playerstats[i][14]=false,false,false,false
playerstats[i][15],playerstats[i][16],playerstats[i][17]=0,false,{}
parse('setmaxhealth '..i..' 200')
parse('speedmod '..i..' 0')
playerstats[i][6][2]=image('gfx/T.virus/Script/SideBar.png<n>',836,240,2,i)
imagescale(playerstats[i][6][2],1.5,1.5)
parse('hudtxt2 '..i..' 35 "1" 820 182 2')
parse('hudtxt2 '..i..' 36 "2" 820 233 2')
parse('hudtxt2 '..i..' 37 "3" 820 282 2')
playerstats[i][6][5]=image('<spritesheet:gfx/player/ct'..(player(playerstats[i][10],'look')+1)..'.bmp:32:32:m>',837,286,2,i)
imagescale(playerstats[i][6][5],0.85,0.85)
imagealpha(playerstats[i][6][5],0.3)
parse('hudtxt2 '..i..' 38 "\169000255000'..playerstats[i][10]..'" 848 300 2')
end
end

addhook('die','T_die')---------------ADDHOOK DIE
function T_die(i,k,w)
--When killed by Non-Player, remove from enemy_waiting table
if player(i,'team')==1 and player(i,'bot') and player(k,'team')~=2 then
remove_from_waiting(i)
end
--When die, if "playerstats[i][5] (For Bots: TriggerOnDead)" got value trigger it
if player(i,'team')==1 and player(i,'bot') and playerstats[i][5]~=0 then
parse('trigger "'..playerstats[i][5]..'"')
end
--Boomer and Smoker effect
if player(i,'team')==1 and player(i,'bot') then
if playerstats[i][4]==1 then--Boomer
parse('explosion '..player(i,'x')..' '..player(i,'y')..' 128 30 '..i..'')
elseif playerstats[i][4]==2 then--Smoker
parse('spawnprojectile '..i..' 72 '..player(i,'x')..' '..player(i,'y')..' 1 '..player(i,'rot')..'')
end
end
--When player die, make spec
if player(i,'team')==2 and not player(i,'bot') then
if playerstats[i][3] then
gotwounded=gotwounded-1
end
parse('makespec '..i)
table.insert(deadman,i)
remove_player_stat(i)
end
end

addhook('leave','T_leave')---------------ADDHOOK LEAVE
function T_leave(i)
--For table and var debug
if player(i,'team')==1 and player(i,'bot') then
remove_from_waiting(i)
end
if player(i,'team')==2 and not player(i,'bot') then
if playerstats[i][3] then
gotwounded=gotwounded-1
end
remove_player_stat(i)
end
end

--This func simply remove BOTS from enemy_waiting table
function remove_from_waiting(i)
for k,v in pairs(enemy_waiting) do
if v==i then
table.remove(enemy_waiting,k)
break
end
end
end

--This func reset players stat (Ex: Down?)
function remove_player_stat(i)
for x=1,img_table_count do
if playerstats[i][6][x]~=nil then
freeimage(playerstats[i][6][x])
end
end
for _,v in pairs(player(0,'team2living')) do
if not player(playerstats[v][10],'exists') or player(playerstats[v][10],'team')~=2 then playerstats[v][10]=v end
end
for x=1,hudtxt_count do
parse('hudtxt2 '..i..' '..x..' "" 0 0 2')
end
playerstats[i][3],playerstats[i][6],playerstats[i][7],playerstats[i][8],playerstats[i][14]=false,{},nil,nil,false
playerstats[i][15],playerstats[i][16]=0,false
end

addhook('team','T_team')---------------ADDHOOK TEAM
function T_team(i,t)
if player(i,'bot') and t==2 then
parse('maket '..i..'')
return 1
end
if not player(i,'bot') and t==1 then
parse('makect '..i..'')
return 1
end
if not player(i,'bot') and t==2 then
if check_deadman(i) then
return 0
else
return 1
end
end
end
--This func checks player from teamchange above
function check_deadman(i) 
if #deadman~=0 then
for _,v in pairs(deadman) do
if i==v then
return false
end
end
end
return true
end

--This func is for spawn event, random pick player to spawn
function pick_player(spawn,players,health,speed,atk,zbtype,ondead)
for x=1,players do
local who,spot=math.random(#enemy_waiting),spawnpoint[spawn][math.random(#spawnpoint[spawn])]
playerstats[enemy_waiting[who]][1]=health
playerstats[enemy_waiting[who]][4]=zbtype
parse('setpos '..enemy_waiting[who]..' '..split_spot(spot,1)..' '..split_spot(spot,2)..'')
if speed~=0 then parse('speedmod '..enemy_waiting[who]..' '..speed..'') end
if atk==0 then playerstats[enemy_waiting[who]][2]=2 else playerstats[enemy_waiting[who]][2]=atk end
if ondead~=nil then playerstats[enemy_waiting[who]][5]=ondead end
table.remove(enemy_waiting,who)
end
end
--This func makes string '30.11' to number 30&11
function split_spot(t,v)
local cache={}
for m in t:gmatch('[^%.]+') do table.insert(cache,m*32+16) end
if v==1 then return cache[1] end
if v==2 then return cache[2] end
end

addhook('always','T_always')---------------ADDHOOK ALWAYS
function T_always()
for _,i in pairs(player(0,'tableliving')) do
--Always set health to table value
parse('sethealth '..i..' '..playerstats[i][1]..'')
--When player is down, make him freeze and pistol only
if player(i,'team')==2 then
if playerstats[i][3]==true then
local pis=get_only_pistol(i)
parse('speedmod '..i..' -100')
parse('equip '..i..' '..pis)
parse('setweapon '..i..' '..pis)
imagealpha(playerstats[i][6][1],(10-playerstats[i][1]/20)/10)
end
if playerstats[i][16]==true and playerstats[i][3]==false then
parse('speedmod '..i..' 5')
elseif playerstats[i][16]==true and playerstats[i][4]==2 and playerstats[i][3]==false then
parse('speedmod '..i..' -5')
elseif playerstats[i][16]==false and playerstats[i][4]==2 and playerstats[i][3]==false then
parse('speedmod '..i..' -10')
end
if player(i,'weapontype')==50 and playerstats[i][4]~=2 and playerstats[i][3]==false and playerstats[i][16]==false then
parse('speedmod '..i..' '..h_knife_speed)
elseif player(i,'weapontype')~=50 and playerstats[i][4]~=2 and playerstats[i][3]==false and playerstats[i][16]==false then
parse('speedmod '..i..' 0')
end
if playerstats[i][14]==true then
parse('setweapon '..i..' 50')
end
end
--Make BOTS always attack near player
if player(i,'team')==1 and player(i,'bot') then
for _,v in pairs(player(0,'team2living')) do
if player(i,'speedmod')==zb_def_speed or player(i,'speedmod')==zb_target_speed then
if ai_freeline(i,player(v,'x'),player(v,'y')) then 
parse('speedmod '..i..' '..zb_target_speed)
else
parse('speedmod '..i..' '..zb_def_speed)
end
end
local tar=ai_findtarget(i)
if tar~=0 then
if math.abs(player(i,'x')-player(tar,'x'))<=64 and math.abs(player(i,'y')-player(tar,'y'))<=64 then
--ai_goto(i,player(tar,'tilex'),player(tar,'tiley'))
ai_aim(i,player(tar,'x'),player(tar,'y'))
ai_attack(i)
end
end
end
end
end
end

addhook('hit','T_hit')---------------ADDHOOK HIT
function T_hit(i,s,w,h,a,r)
--Smoker/Boomer debug
if (w==72 or w==251) and player(s,'team')==1 and player(i,'team')==1 then return 1 end
--Attack enemies
if player(i,'team')~=player(s,'team') and check_item(w) then
--BOT attack
if player(s,'team')==1 then
local thp
--With Claw(#78)
if w==78 then
thp=math.floor(playerstats[i][1]-playerstats[s][2])
if playerstats[i][3] and playerstats[s][2]>5 and playerstats[s][4]~=3 then thp=math.floor(playerstats[i][1]-5) end
if playerstats[i][3] and playerstats[s][4]==3 and playerstats[s][2]>5 then thp=math.floor(playerstats[i][1]-playerstats[s][2]/2) end
if not playerstats[i][3] and playerstats[s][4]==3 then knockback(s,i,96,true) end
--With Gas(#72)(Smoker)
elseif w==72 then
thp=math.floor(playerstats[i][1]-3)
end
if thp<=0 and not playerstats[i][3] and playerstats[i][4]~=2 then
toggle_dying(i)
else
playerstats[i][1]=thp
end
--Player attack
elseif player(s,'team')==2 then
--If attack with knife(#50) knockback (Except Tank)
if playerstats[i][4]~=3 then
if w==50 and r>=60 then
knockback(s,i,40)
r=0
elseif w==50 and r<60 then
knockback(s,i,24)
r=0
end
end
--Headshots?
if check_aimonhead(i,s,w) then
playerstats[i][1]=math.floor(playerstats[i][1]-r*2)
parse('sv_sound2 '..s..' Headshot/headshot'..math.random(1,3)..'.wav')
else
playerstats[i][1]=math.floor(playerstats[i][1]-r)
end
if playerstats[i][1]<=0 then
parse('sv_sound2 '..s..' player/zm_die.wav')
parse('customkill '..s..' "'..itemtype(w,'name'):gsub('-',''):gsub(' ','')..',gfx/weapons/'..itemtype(w,'name'):gsub('-',''):gsub(' ','')..'_k.bmp" '..i)
end
end
return 1
end
--For friendly fire (CT)
if player(i,'team')==2 and player(s,'team')==2 and check_item(w) and tonumber(game('sv_friendlyfire'))==1 then
if w==50 then r=0 end
local thp=math.floor(playerstats[i][1]-r*0.1)
if thp<=0 and not playerstats[i][3] and playerstats[i][4]~=2 then
msg(''..player(s,'name')..' knock down '..player(i,'name')..' @C')
toggle_dying(i)
elseif thp<=0 and (playerstats[i][3] or playerstats[i][4]==2) then
parse('customkill '..s..' "'..itemtype(w,'name'):gsub('-',''):gsub(' ','')..',gfx/weapons/'..itemtype(w,'name'):gsub('-',''):gsub(' ','')..'_k.bmp" '..i)
else
playerstats[i][1]=thp
end
return 1
end
--Special damage (239:Entity 251:Explosion)
if w==239 or w==251 then
local thp=math.floor(playerstats[i][1]-r)
if thp<=0 and not playerstats[i][3] and playerstats[i][4]~=2 and not player(i,'bot') then
toggle_dying(i)
else
playerstats[i][1]=thp
end
return 1
end
end
--This func check if headshot for above *Player attack 
function check_aimonhead(i,s,w)
local enemyposx,enemyposy=player(i,'x')-player(s,'x')+425,player(i,'y')-player(s,'y')+240
if not player(s,'bot') and player(s,'mousex')>=enemyposx-6 and player(s,'mousex')<=enemyposx+6 and player(s,'mousey')>=enemyposy-6 and player(s,'mousey')<=enemyposy+6 then
if w>=1 and w<=40 or w==90 or w==91 then
return true
else
return false
end
else
return false
end
end

--This func set all the value when player is down
function toggle_dying(i)
parse('sv_sound2 '..i..' T.virus/down.wav')
gotwounded=gotwounded+1--For MS100 to know when to run scripts
playerstats[i][7],playerstats[i][8]=player(i,'tilex'),player(i,'tiley')
playerstats[i][6][1]=image('gfx/T.virus/Script/Down_mask.bmp',425,240,2,i)
imagealpha(playerstats[i][6][1],0)
playerstats[i][15],playerstats[i][16]=0,false
playerstats[i][1],playerstats[i][3]=200,true
if playerstats[i][14] then
freeimage(playerstats[i][6][6])
parse('hudtxt2 '..i..' 35 "1" 820 182 2')
playerstats[i][14]=false
end
playerstats[i][5]=playerweapons(i)
for _,iid in pairs(playerstats[i][5]) do
if iid~=50 then parse('strip '..i..' '..iid) end
end
end

--This func checks player inventory and return pistol id
function get_only_pistol(i)
for _,v in pairs(playerstats[i][5]) do
if v>=1 and v<=6 then
return v
else
return 1
end
end
end

addhook('move','T_move')---------------ADDHOOK MOVE
function  T_move(i,x,y)
local px,py=player(i,'tilex'),player(i,'tiley')
if not player(i,'bot') then
playerstats[i][9]=0
end
if entity(px,py,'exists') then
local tx,ty=entity(px,py,'trigger'):match('T%.tel%((%d+)%.(%d+).*%)')
local tt=entity(px,py,'trigger'):match('T%.tel%(%d+%.%d+%.([12])%)')
if tx and ty then
if tt==nil then
parse('setpos '..i..' '..(tonumber(tx)*32+16)..' '..(tonumber(ty)*32+16)..'')
elseif tt=='1' and player(i,'team')==1 then
parse('setpos '..i..' '..(tonumber(tx)*32+16)..' '..(tonumber(ty)*32+16)..'')
elseif tt=='2' and player(i,'team')==2 then
parse('setpos '..i..' '..(tonumber(tx)*32+16)..' '..(tonumber(ty)*32+16)..'')
end
end
end
end

addhook('serveraction','T_serveraction')---------------ADDHOOK SERVERACTION
function T_serveraction(i,a)
if player(i,'health')>0 then
--Medkit
if a==1 then
if playerstats[i][11] and not playerstats[i][3] then
if not playerstats[i][14] then
playerstats[i][14]=true
parse('hudtxt2 '..i..' 35 "\1690002550001" 820 182 2')
playerstats[i][6][6]=image('gfx/T.virus/Script/Medkit_hold.png',1,1,200+i)
imagescale(playerstats[i][6][6],0.7,0.7)
else
playerstats[i][14]=false
parse('hudtxt2 '..i..' 35 "1" 820 182 2')
freeimage(playerstats[i][6][6])
end
end
--Pills&Adrenalineshot
elseif a==2 then
local id=playerstats[i][10]
if player(id,'exists') and not playerstats[i][3] then
pills_n_shot(i,id)
end
--Select Target
elseif a==3 then
local you,total,player_list=nil,#player(0,'team2'),{}
for k,v in ipairs(player(0,'team2')) do
table.insert(player_list,v)
if v==playerstats[i][10] then you=k end
end
if you~=nil then
if player_list[you+1]~=nil and you~=total and total~=1 then
playerstats[i][10]=player_list[you+1]
elseif player_list[you+1]==nil and you==total and total~=1 then
playerstats[i][10]=player_list[1]
end
end
if not player(playerstats[i][10],'exists') or player(playerstats[i][10],'team')~=2 then playerstats[i][10]=i end
--Show select target image
if playerstats[i][6][5]~=nil then freeimage(playerstats[i][6][5]) end
playerstats[i][6][5]=image('<spritesheet:gfx/player/ct'..(player(playerstats[i][10],'look')+1)..'.bmp:32:32:m>',837,286,2,i)
imagescale(playerstats[i][6][5],0.85,0.85)
imagealpha(playerstats[i][6][5],0.3)
if playerstats[playerstats[i][10]][3] then
parse('hudtxt2 '..i..' 38 "\169255000000'..playerstats[i][10]..'" 848 300 2')
elseif playerstats[playerstats[i][10]][1]<=30 then
parse('hudtxt2 '..i..' 38 "\169255255000'..playerstats[i][10]..'" 848 300 2')
else
parse('hudtxt2 '..i..' 38 "\169000255000'..playerstats[i][10]..'" 848 300 2')
end
end
end
end

--This func do the job of use/give pills/adrenalineshot
function pills_n_shot(i,id)
local mx,my=player(i,'tilex')+math.floor((player(i,'mousex')-409)/32),player(i,'tiley')+math.floor((player(i,'mousey')-224)/32)
--Pills
if playerstats[i][12] then
if id==i then
if playerstats[id][15]==0 then playerstats[id][15]=playerstats[id][1] end
playerstats[id][1]=playerstats[id][1]+50
playerstats[id][12]=false
freeimage(playerstats[id][6][4])
playerstats[id][6][4]=nil
msg2(i,'Temporary add 50 Health @C')
elseif id~=i then
if check_aim_spot(i,mx,my,player(id,'tilex'),player(id,'tiley'),false) then
if not playerstats[id][12] and not playerstats[id][13] then
msg2(i,'Give pills to: '..player(id,'name')..' @C')
playerstats[i][12]=false
freeimage(playerstats[i][6][4])
playerstats[i][6][4]=nil
msg2(id,''..player(i,'name')..' gives you pills @C')
playerstats[id][12]=true
playerstats[id][6][4]=image('gfx/T.virus/Script/Pills.png',837,240,2,id)
imagealpha(playerstats[id][6][4],0.5)
else
msg2(i,'Can\'t give pills to: '..player(id,'name')..' @C')
end
end
end
end
--Adrenaline
if playerstats[i][13] then
if id==i then
if playerstats[id][15]==0 then playerstats[id][15]=playerstats[id][1] end
playerstats[id][1]=playerstats[id][1]+25
playerstats[id][16]=true
playerstats[id][13]=false
freeimage(playerstats[id][6][4])
playerstats[id][6][4]=nil
timer(5000,'parse','lua "close_speedboost('..id..')"')
msg2(i,'Temporary add 25 Health & Speedup for 5 seconds @C')
elseif id~=i then
if check_aim_spot(i,mx,my,player(id,'tilex'),player(id,'tiley'),false) then
if not playerstats[id][12] and not playerstats[id][13] then
msg2(i,'Give adrenalineshot to: '..player(id,'name')..' @C')
playerstats[i][13]=false
freeimage(playerstats[i][6][4])
playerstats[i][6][4]=nil
msg2(id,''..player(i,'name')..' gives you adrenalineshot @C')
playerstats[id][13]=true
playerstats[id][6][4]=image('gfx/T.virus/Script/Adrenaline.png',837,240,2,id)
imagealpha(playerstats[id][6][4],0.5)
else
msg2(i,'Can\'t give adrenalineshot to: '..player(id,'name')..' @C')
end
end
end
end
end
--This func cancel speedboost of adrenalineshot
function close_speedboost(id)
playerstats[id][16]=false
end

--This two func is for knockback
function knockback(s,v,p,tank)
local knock,rot=p,player(s,'rot')
if (rot<-90) then rot=rot+360 end
local angle=math.rad(math.abs(rot+90))-math.pi
local x=player(v,'x')+math.cos(angle)*knock
local y=player(v,'y')+math.sin(angle)*knock
if (not knockcheck(player(v,'x'),player(v,'y'),angle,knock,tank)) then
parse('setpos '..v..' '..x..' '..y)
end
end
function knockcheck(x,y,rot,knock,tank)
local col,dist,dx,dy
for dist=5,math.ceil(knock),2 do
dx=x+math.cos(rot)*dist
dy=y+math.sin(rot)*dist
if not tank then
if (not tile(math.ceil(dx/32)-1,math.ceil(dy/32)-1,'walkable')) then
col=true
break
end
else
--Knockback by Tank (Will set you on deadly tile!!!)
if (not tile(math.ceil(dx/32)-1,math.ceil(dy/32)-1,'deadly')) then
if (not tile(math.ceil(dx/32)-1,math.ceil(dy/32)-1,'walkable')) then
col=true
break
end
end
end
end
return col
end

addhook('always','T_always_hud')---------------ADDHOOK ALWAYS (HUD)
function T_always_hud()
for _,i in pairs(player(0,'team2living')) do
if not player(i,'bot') then
for _,t in pairs(player(0,'table')) do
if playerstats[t][1]>0 then
local x,y=player(t,'x')-player(i,'x')+425,player(t,'y')-player(i,'y')+240-24
if player(t,'team')==2 and playerstats[t][3] then
parse('hudtxt2 '..i..' '..t..' "\169255000000Down" '..x..' '..y..' 1')
elseif player(t,'team')==2 and not playerstats[t][3] then
parse('hudtxt2 '..i..' '..t..' "" 0 0 1')
end
if player(t,'team')==1 then
if playerstats[t][4]==0 then--Normal
parse('hudtxt2 '..i..' '..t..' "" 0 0 1')
elseif playerstats[t][4]==1 then--Boomer
parse('hudtxt2 '..i..' '..t..' "\169000255000Boomer" '..x..' '..y..' 1')
elseif playerstats[t][4]==2 then--Smoker
parse('hudtxt2 '..i..' '..t..' "\169000255000Smoker" '..x..' '..y..' 1')
elseif playerstats[t][4]==3 then--Tank
parse('hudtxt2 '..i..' '..t..' "\169000255000Tank" '..x..' '..y..' 1')
else
parse('hudtxt2 '..i..' '..t..' "\169000255000'..playerstats[t][4]..'" '..x..' '..y..' 1')
end
end
else
parse('hudtxt2 '..i..' '..t..' "" 0 0 1')
end
end
end
end
end

--This func check if an entity has condition to be trigger #Entity:Trigger: 'T.con?(TableID.">/=/<".Value.Message:False or 0.(Table "+-= Value"))'
--Important !!! Only used at Trigger_Use and AimEvent
function check_condition(i,n,t_change)
local con1,con2,con3,con4=n:match('T%.con%?%((.+)%.([>=<])%.(%d+)%.(.+).*%)')
local con5=n:match('T%.con%?%(.+%.[>=<]%.%d+%..+%.([%+%-=]%d+)%)')
local bool=false
if con1 and con2 and con3 and con4 then
if playerstats[i][17][con1]~=nil then
if con2=='>' then
if playerstats[i][17][con1]>tonumber(con3) then	bool=true end
elseif con2=='=' then
if playerstats[i][17][con1]==tonumber(con3) then bool=true end
elseif con2=='<' then
if playerstats[i][17][con1]<tonumber(con3) then	bool=true end
end
if con5 and bool and t_change then
if con5:sub(1,1)=='+' then
playerstats[i][17][con1]=playerstats[i][17][con1]+tonumber(con5:match('(%d+)'))
elseif con5:sub(1,1)=='-' then
playerstats[i][17][con1]=playerstats[i][17][con1]-tonumber(con5:match('(%d+)'))
elseif con5:sub(1,1)=='=' then
playerstats[i][17][con1]=tonumber(con5:match('(%d+)'))
end
end
end
if not bool and con4:match('[^%.]+')~='0' then msg2(i,con4:match('[^%.]+')) end
else
bool=true
end
return bool
end