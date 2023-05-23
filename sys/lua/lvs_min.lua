winexp=5		--勝利加成經驗值
loseexp=1		--失敗加成經驗值
killexp=1		--普殺加成經驗值
kkillexp=5		--刀殺加成經驗值
kbskillexp=8	--背殺加成經驗值
pkillexp=2		--手槍殺加成經驗值
hekillexp=2		--手雷殺加成經驗值
mvpexp=5		--MVP加成經驗值
aceexp=20		--ACE加成經驗值
hsexp=5			--暴頭獎勵經驗值

if tonumber(game('bot_skill'))==0 then
bskill=1
else
bskill=tonumber(game('bot_skill'))
end
print('[Server] Bot skill is set to : '..bskill)

mvpmusic=true
botmvpmusic=true
--botskill,mvpmusic,botmvpm

---------------------------------------------------------------------
--System-------------------------------------------------------------
---------------------------------------------------------------------

function l(m)
local array={}
for i=1,m do
array[i]=0
end
return array
end

function l2(m,a)
local array={}
for i=1,m do
array[i]={}
for v=1,a do
array[i][v]=0
end
end
return array
end

function string.split(tt,b)
	local t = {}
	local match = "[^%s]+"
	if type(b) == "string" then match = "[^"..b.."]+" end
	for word in string.gmatch(tt, match) do table.insert(t, word) end
	return t
end

function trwin_img()
local img=image('gfx/GOGFX/trwinbar.png',320,110,2)
end

function ctwin_img()
local img=image('gfx/GOGFX/ctwinbar.png',320,110,2)
end

---------------------------------------------------------------------
--Main System--------------------------------------------------------
---------------------------------------------------------------------

addhook('always','lvs_ms100_name')
addhook('ms100','lvs_ms100')
addhook('endround','lvs_end')
addhook('kill','lvs_kill')
addhook('join','lvs_join_reset')
addhook('say','lvs_s')
addhook('startround','lvs_tip_sr')
addhook('team','lvs_team_load')

save=l2(32,87)
save_c=87
loading=l(32)
dmg_ch=l2(32,32)
dmg_cs=l2(32,32)

kill_round=l(32)
ding=l(32)
firstblood=0

hs_mm={
[1]={3,26,'USP',51},
[2]={3,23,'GLOCK',52},
[3]={5,16,'DEAGLE',53},
[4]={3,20,'P228',54},
[5]={4,20,'ELITE',55},
[6]={3,23,'FIVESEVEN',56},
[10]={5,10,'M3',57},
[11]={5,10,'XM1014',58},
[20]={3,28,'MP5',59},
[21]={3,23,'TMP',60},
[22]={3,21,'P90',61},
[23]={3,23,'MAC10',62},
[24]={3,20,'UMP45',63},
[30]={3,16,'AK47',64},
[31]={3,20,'SG552',65},
[32]={3,23,'M4A1',66},
[33]={3,20,'AUG',67},
[34]={15,42,'SCOUT',70},
[35]={20,42,'AWP',71},
[36]={18,38,'G3SG1',72},
[37]={18,38,'SG550',73},
[38]={3,20,'GALIL',68},
[39]={3,20,'FAMAS',69},
[40]={4,15,'M249',74},
[90]={4,10,'M134'},
[91]={3,30,'FNF2000'},
[50]={0,0,'KNIFE',75},
}

hs_min_skill={0,0,-1,-2}
hs_max_skill={0,15,30,60}

color={
'©000255000',--綠[1]
'©255128000',--橘[2]
'©255000000',--紅[3]
'©000000000',--黑[4]
}

musickit={
[1]={'AD8','Sean Murray'},
[2]={'All I Want For Chrismas','Midnight Riders'},
[3]={'Crimson Assault','Daniel Sadowski'},
[4]={'Desert Fire','Austin Wintory'},
[5]={'Disgusting','Beartooth'},
[6]={'High Noon','Feed Me'},
[7]={'Hotline Miami','Various Artists'},
[8]={'Metal','Skog'},
[9]={'Total Domination','Daniel Sadowski'},
[10]={'Diamonds','Mord Fustang'},
[11]={'Deaths Head Demolition','Dren'},
[12]={'Battlepack','Proxy'},
[13]={'For No Mankind','Mateo Messina'},
[14]={'I Am','AWOLNATION'},
[15]={'Invasion!','Michael Bross'},
[16]={'IsoRhythm','Matt Lange'},
[17]={'Lions Mouth','Ian Hultquist'},
[18]={'Moments','Darude'},
[19]={'Sharpened','Noisia'},
[20]={'The 8-bit Kit','Daniel Sadowski'},
[21]={'The Talos Principle','Damjan Mravunac'},
[22]={'Uber Blasto Phone','Troels Folmann'},
[23]={'II-Headshot','Skog'},
[24]={'Insurgency','Robert Allaire'},
[25]={'LNOE','Sasha'},
[26]={'MOLOTOV','KiTheory'},
[27]={'Sponge Fingerz','New Beat Fund'},
[28]={'Java Havana Funkaloo','Lennie Moore'},
[29]={'Aggressive','Beartooth'},
[30]={'Backbone','Roam'},
[31]={'Free','Hundredth'},
[32]={'GLA','Twin Atlantic'},
[33]={'III-Arena','Skog'},
[34]={"Life's Not Out To Get You",'Neck Deep'},
[35]={'The Good Youth','Blitz Kids'},
[36]={'Hazardous Environments','Kelly Bailey'},
}

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

addhook('movetile','water_move')
function water_move(i,x,y)
if tile(player(i,'tilex'),player(i,'tiley'),'property')==14 then
parse('speedmod '..i..' -5')
else
parse('speedmod '..i..' 0')
end
end

addhook('die','bomb_debug')
function bomb_debug(i)
if player(i,'bomb') then
local pdx,pdy=player(i,'tilex'),player(i,'tiley')
if tile(pdx,pdy,'property')>=50 and tile(pdx,pdy,'property')<=53 then
local bspawn={}
if tile(pdx+1,pdy,'walkable') then
bspawn[1]=pdx+1
bspawn[2]=pdy
elseif tile(pdx,pdy+1,'walkable') then
bspawn[1]=pdx
bspawn[2]=pdy+1
elseif tile(pdx-1,pdy,'walkable') then
bspawn[1]=pdx-1
bspawn[2]=pdy
elseif tile(pdx,pdy-1,'walkable') then
bspawn[1]=pdx
bspawn[2]=pdy-1
end
parse('spawnitem 55 '..bspawn[1]..' '..bspawn[2])
end
end
end

function lvs_join_reset(id)
loading[id]=true
for v=1,save_c do
save[id][v]=0
end
save[id][1]=1
save[id][3]=20
save[id][14]=math.random(#musickit)
loading[id]=false
end

function lvs_team_load(id,team)
if team~=0 and not loading[id] then
loading[id]=true
if player(id,'usgn')~=0 then
local file=io.open("sys/lua/Lvs/Save/"..player(id,"usgn")..".sav", "r")
if not file then
msg2(id,'\169255000000[Server] Failed Loading Level Data, Create new one')
else
for v=1,save_c do
save[id][v]=file:read("\*n")
end
file:close()
msg2(id,'\169000255000[Server] Level Data Loaded')
end
end
if player(id,'usgn')==0 then
local file=io.open("sys/lua/Lvs/Save/"..player(id,"name")..".sav", "r")
if not file then
msg2(id,'\169255000000[Server] Failed Loading Level Data, Create new one')
else
for v=1,save_c do
save[id][v]=file:read("\*n")
end
file:close()
msg2(id,'\169000255000[Server] Level Data Loaded')
end
end
loading[id]=false
end
end

function lvs_ms100_name()
for id=1,32 do
if player(id,'exists') and player(id,'health')>0 and not player(id,'bot') then
for i=1,32 do
if player(i,'exists') and player(i,'health')>0 and i~=id then
if player(i,'team')~=player(id,'team') then
parse('hudtxt2 '..id..' '..i..' "" 0 0')
else
local x=player(i,'x')-player(id,'x')+320-12
local y=player(i,'y')-player(id,'y')+240+16
if player(i,'health')>=70 then
parse('hudtxt2 '..id..' '..i..' "'..color[1]..'Lv'..save[i][1]..'" '..x..' '..y)
elseif player(i,'health')>=40 and player(i,'health')<70 then
parse('hudtxt2 '..id..' '..i..' "'..color[2]..'Lv'..save[i][1]..'" '..x..' '..y)
elseif player(i,'health')>=10 and player(i,'health')<40 then
parse('hudtxt2 '..id..' '..i..' "'..color[3]..'Lv'..save[i][1]..'" '..x..' '..y)
elseif player(i,'health')<10 and player(i,'health')>0 then
parse('hudtxt2 '..id..' '..i..' "'..color[4]..'Lv'..save[i][1]..'" '..x..' '..y)
end
end
else
parse('hudtxt2 '..id..' '..i..' "" 0 0')
end
end
else
for i=1,32 do
parse('hudtxt2 '..id..' '..i..' "" 0 0')
end
end
end
end

function lvs_s(i,t)
if (string.sub(t,1,8)=='botskill') then
local parses=string.split(t)
local bot=tonumber(parses[2])
if bot~=nil then
if bot==1 then
msg('\169000255000[Server] Bot Skill Changed : Normal')
bskill=1
elseif bot==2 then
msg('\169000255000[Server] Bot Skill Changed : High')
bskill=2
elseif bot==3 then
msg('\169000255000[Server] Bot Skill Changed : Advanced')
bskill=3
elseif bot==4 then
msg('\169000255000[Server] Bot Skill Changed : Beast')
bskill=4
else
msg2(i,'\169255000000[Server] Must enter a number from 1~4')
end
else
msg2(i,'\169255000000[Server] Must enter a number from 1~4')
end
return 1
end
if (string.sub(t,1,8)=='mvpmusic') then
local parses=string.split(t)
local oo=tonumber(parses[2])
if oo~=nil then
if oo==0 then
msg('\169000255000[Server] Play MVP Music : Off')
mvpmusic=false
elseif oo==1 then
msg('\169000255000[Server] Play MVP Music : On')
mvpmusic=true
else
msg2(i,'\169255000000[Server] Must enter a number 0 or 1')
end
else
msg2(i,'\169255000000[Server] Must enter a number 0 or 1')
end
return 1
end
if (string.sub(t,1,7)=='botmvpm') then
local parses=string.split(t)
local ox=tonumber(parses[2])
if ox~=nil then
if ox==0 then
msg('\169000255000[Server] Random MVP Music For Bot : Off')
botmvpmusic=false
elseif ox==1 then
msg('\169000255000[Server] Random MVP Music For Bot : On')
botmvpmusic=true
else
msg2(i,'\169255000000[Server] Must enter a number 0 or 1')
end
else
msg2(i,'\169255000000[Server] Must enter a number 0 or 1')
end
return 1
end
end

function lvs_ms100()
parse('hudtxt 44 "\169255255255'..#player(0,"team2living")..'" 271 8 1')
parse('hudtxt 45 "\169255255255'..#player(0,"team1living")..'" 367 8 1')
for id=1,32 do
if player(id,'exists') and not player(id,'bot') and player(id,'team')~=0 and player(id,'health')~=0 then
local idwpn,lvpa=player(id,'weapontype'),(math.floor((save[id][2]/save[id][3])*10000))/100
if hs_mm[idwpn] and hs_mm[idwpn][4]~=nil then
parse('hudtxt2 '..id..' 33 "'..color[1]..'Level : '..save[id][1]..' ('..lvpa..'%) '..hs_mm[idwpn][3]..' : '..save[id][hs_mm[idwpn][4]]..'" 10 420 -1')
else
parse('hudtxt2 '..id..' 33 "'..color[1]..'Level : '..save[id][1]..' ('..lvpa..'%)" 10 420 -1')
end
else
parse('hudtxt2 '..id..' 33 "" 10 420 -1')
end
if save[id][2]>=save[id][3] and save[id][2]~=0 then
save[id][1]=save[id][1]+1
save[id][2]=save[id][2]-save[id][3]
save[id][3]=math.ceil(save[id][1]*20+save[id][1])
msg('\169000255255[Server] '..player(id,'name')..' is now level '..save[id][1])
parse('hudtxt2 '..id..' 42 "\169000255255Level Up" 10 420 -1')
parse('hudtxtmove '..id..' 42 500 10 400')
parse('hudtxtalphafade '..id..' 42 5500 0.0')
end
if player(id,'process')==2 then
ding[id]=true
else
ding[id]=false
end
end
end

function lvs_kill(k,v,w)
if player(k,'team')~=player(v,'team') then
save[k][10]=save[k][10]+1
save[v][11]=save[v][11]+1
kill_round[v]=0
kill_round[k]=kill_round[k]+1
save[k][2]=save[k][2]+kill_round[k]
save[k][4]=save[k][4]+kill_round[k]
local killer
if save[k][76]==0 then
killer='Lv'..save[k][1]..'.'
else
killer='\169255255000['..achievement[save[k][76]][4]..'] \169000255000'
end
if firstblood==1 and kill_round[k]==1 then
parse('hudtxt2 '..k..' 41 "'..color[1]..'FirstKill" 320 280 1')
end
if firstblood==0 and kill_round[k]==1 then
firstblood=1
save[k][38]=save[k][38]+1
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' score the firstblood" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'FirstBlood" 320 280 1')
end
if kill_round[k]==2 then
save[k][39]=save[k][39]+1
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' doublekill" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'DoubleKill" 320 280 1')
end
if kill_round[k]==3 then
save[k][40]=save[k][40]+1
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' triplekill" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'TripleKill" 320 280 1')
end
if kill_round[k]==4 then
save[k][41]=save[k][41]+1
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' ultrakill" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'UltraKill" 320 280 1')
end
if kill_round[k]==5 then
save[k][42]=save[k][42]+1
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' unstoppable" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'Unstoppable" 320 280 1')
end
if kill_round[k]==6 then
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' killingspree" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'KillingSpree" 320 280 1')
end
if kill_round[k]>6 then
parse('hudtxt 34 "'..color[1]..''..killer..''..player(k,'name')..' killingspree ('..kill_round[k]..'K)" 320 420 1')
parse('hudtxt2 '..k..' 41 "'..color[1]..'KillingSpree ('..kill_round[k]..'K)" 320 280 1')
end
parse('hudtxtalphafade '..k..' 41 3000 0.0')
if w~=50 and w~=51 and w>6 then
save[k][2]=save[k][2]+killexp
save[k][4]=save[k][4]+killexp
elseif w==50 then
save[k][2]=save[k][2]+kkillexp
save[k][4]=save[k][4]+kkillexp
elseif w==51 then
save[k][2]=save[k][2]+hekillexp
save[k][4]=save[k][4]+hekillexp
elseif w>=1 and w<=6 then
save[k][2]=save[k][2]+pkillexp
save[k][4]=save[k][4]+pkillexp
end
if w>=1 and w<=6 then
save[k][17]=save[k][17]+1
elseif w==10 or w==11 then
save[k][18]=save[k][18]+1
elseif w>=20 and w<=24 then
save[k][19]=save[k][19]+1
elseif w>=30 and w<=33 or w==38 or w==39 then
save[k][20]=save[k][20]+1
elseif w>=34 and w<=37 then
save[k][21]=save[k][21]+1
elseif w==40 then
save[k][22]=save[k][22]+1
elseif w==50 then
save[k][23]=save[k][23]+1
elseif w==51 then
save[k][24]=save[k][24]+1
elseif w>=45 and w<=49 or w>=69 and w<=91 then
save[k][46]=save[k][46]+1
end
if player(k,'team')==1 and w==32 then
save[k][35]=save[k][35]+1
elseif player(k,'team')==2 and w==30 then
save[k][36]=save[k][36]+1
end
if hs_mm[w] and hs_mm[w][4] then
save[k][hs_mm[w][4]]=save[k][hs_mm[w][4]]+1
end
end
end

function lvs_end(m)
local r_time=rtime-tonumber(game('mp_freezetime'))
for i=1,32 do
if player(i,'exists') then
if player(i,'team')==1 then
if m==1 or m==20 or m==10 or m==12 or m==30 then
save[i][2]=save[i][2]+winexp
save[i][4]=save[i][4]+winexp
save[i][5]=save[i][5]+1
if m==1 then
save[i][7]=save[i][7]+1
elseif m==20 then
save[i][8]=save[i][8]+1
elseif m==30 or m==10 or m==12 then
save[i][87]=save[i][87]+1
end
if r_time<=25 then
save[i][37]=1
end
elseif m==2 or m==21 or m==22 or m==11 or m==31 then
save[i][2]=save[i][2]+loseexp
save[i][4]=save[i][4]+loseexp
save[i][6]=save[i][6]+1
end
if #player(0,"team1")>=5 and #player(0,"team1living")==1 and player(i,'health')>0 then
save[i][81]=1
end
end
if player(i,'team')==2 then
if m==2 or m==21 or m==22 or m==11 or m==31 then
save[i][2]=save[i][2]+winexp
save[i][4]=save[i][4]+winexp
save[i][5]=save[i][5]+1
if m==2 then
save[i][7]=save[i][7]+1
elseif m==21 then
save[i][9]=save[i][9]+1
save[i][77]=1
elseif m==22 then
save[i][9]=save[i][9]+1
elseif m==11 or m==31 then
save[i][79]=1
save[i][87]=save[i][87]+1
end
if r_time<=25 then
save[i][37]=1
end
elseif m==1 or m==20 or m==10 or m==12 or m==30 then
save[i][2]=save[i][2]+loseexp
save[i][4]=save[i][4]+loseexp
save[i][6]=save[i][6]+1
end
if #player(0,"team2")>=5 and #player(0,"team2living")==1 and player(i,'health')>0 then
save[i][81]=1
end
end
if player(i,'health')==1 then
save[i][43]=1
end
end
end
if m==1 or m==2 or m==20 or m==21 or m==22 or m==10 or m==12 or m==30 or m==11 or m==31 then
for id=1,32 do
if player(id,'exists') and player(id,'team')~=0 and not loading[id] then
loading[id]=true
if player(id,'usgn')~=0 then
local file=io.open ("sys/lua/Lvs/Save/"..player(id,"usgn")..".sav", "w")
if file==nil then
msg2(id,'[Server] Failed saving data')
else
for v=1,save_c do
file:write(save[id][v].."\n")
end
file:close()
end
end
if player(id,'usgn')==0 then
local file=io.open ("sys/lua/Lvs/Save/"..player(id,"name")..".sav", "w")
if file==nil then
msg2(id,'[Server] Failed saving data')
else
for v=1,save_c do
file:write(save[id][v].."\n")
end
file:close()
end
end
loading[id]=false
end
end
print('[Server] Stats auto saved')
end
end

function lvs_tip_sr(m)
parse('hudtxt 36 "\169255255255'..game('score_ct')..'" 305 17 1')
parse('hudtxt 37 "\169255255255'..game('score_t')..'" 335 17 1')
local icon=image('gfx/GOGFX/cticon.png',272,16,2)
local icon=image('gfx/GOGFX/tricon.png',368,16,2)
local icon=image('gfx/GOGFX/bar.png',320,16,2)
parse('hudtxt 34 "" 320 420 1')
firstblood=0
for i=1,32 do
kill_round[i]=0
end
end

---------------------------------------------------------------------
--MVP System---------------------------------------------------------
---------------------------------------------------------------------

addhook('kill','mvp_k')
addhook('endround','mvp_e')
addhook('startround','mvp_s')
addhook('bombplant','mvp_bp')
addhook('bombdefuse','mvp_bd')
addhook('hostagerescue','mvp_hr')

kk=l(32)
mvp=nil
bper=nil
bder=nil
hrer=nil
kkert=nil
kkerct=nil
knum1=0
knum2=0
ttp=0
tctp=0
ace=nil

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function mvp_k(k,v,w)
if player(k,'team')~=player(v,'team') then
if player(k,'team')==1 then
kk[k]=kk[k]+1
if kk[k]>knum1 then
kkert=k
knum1=knum1+1
end
if tctp>=5 and kk[k]==tctp then
ace=k
if p_hst[k]==tctp then
save[k][49]=1
end
end
if kk[k]==5 then
save[k][80]=1
end
end
if player(k,'team')==2 then
kk[k]=kk[k]+1
if kk[k]>knum2 then
kkerct=k
knum2=knum2+1
end
if ttp>=5 and kk[k]==ttp then
ace=k
if p_hst[k]==ttp then
save[k][49]=1
end
end
if kk[k]==5 then
save[k][80]=1
end
end
if ding[v] and w==51 then
save[k][44]=1
end
if w==50 and player(v,'weapontype')==50 then
save[k][82]=save[k][82]+1
end
if player(k,'health')==1 then save[k][83]=1 end
end
end

function mvp_bp(id)
local r_time=rtime-tonumber(game('mp_freezetime'))
bper=id
save[id][33]=save[id][33]+1
if r_time<=25 then
save[id][45]=1
end
end

function mvp_bd(id)
bder=id
save[id][34]=save[id][34]+1
end

function mvp_hr(id)
hrer=id
end

function mvp_e(m)
if m==20 then
mvp=bper
trwin_img()
parse('hudtxt 38 "\169255255255MVP: '..player(mvp,'name')..' for planting the bomb" 160 95 0')
elseif m==21 then
mvp=bder
ctwin_img()
parse('hudtxt 38 "\169255255255MVP: '..player(mvp,'name')..' for defusing the bomb" 160 95 0')
elseif m==31 then
mvp=hrer
ctwin_img()
parse('hudtxt 38 "\169255255255MVP: '..player(mvp,'name')..' for rescuing the hostages" 160 95 0')
elseif m==1 or m==10 or m==12 or m==30 then
if kkert==nil then
trwin_img()
parse('hudtxt 38 "" 160 95 0')
else
mvp=kkert
trwin_img()
parse('hudtxt 38 "\169255255255MVP: '..player(mvp,'name')..' for most eliminations" 160 95 0')
end
elseif m==2 or m==22 or m==11 then
if kkerct==nil then
ctwin_img()
parse('hudtxt 38 "" 160 95 0')
else
mvp=kkerct
ctwin_img()
parse('hudtxt 38 "\169255255255MVP: '..player(mvp,'name')..' for most eliminations" 160 95 0')
end
end
if mvp~=nil then
save[mvp][13]=save[mvp][13]+1
save[mvp][2]=save[mvp][2]+mvpexp
save[mvp][4]=save[mvp][4]+mvpexp
parse('hudtxt 43 "\169000000000'..save[mvp][1]..'" 83 92 0')
local pskin,skinimg=player(mvp,'look')+1
if player(mvp,'team')==1 then
skinimg=('t'..pskin)
elseif player(mvp,'team')==2 then
skinimg=('ct'..pskin)
end
local mvpavatar=image('<spritesheet:gfx/player/'..skinimg..'.bmp:32:32:m>',108,122,2)
imageframe(mvpavatar,3)
end
local botrandommusic=math.random(#musickit)
if mvp~=nil and mvpmusic then
if player(mvp,'bot') and botmvpmusic then
parse('sv_sound GOSE/MVP/'..botrandommusic..'.ogg')
local mvp_img=image('gfx/GOGFX/mkimg/'..botrandommusic..'.png',149,128,2)
parse('hudtxt 40 "\169155155155'..musickit[botrandommusic][1]..', '..musickit[botrandommusic][2]..'" 170 120 0')
elseif player(mvp,'bot') and not botmvpmusic then
parse('sv_sound GOSE/MVP/'..save[mvp][14]..'.ogg')
local mvp_img=image('gfx/GOGFX/mkimg/'..save[mvp][14]..'.png',149,128,2)
parse('hudtxt 40 "\169155155155'..musickit[save[mvp][14]][1]..', '..musickit[save[mvp][14]][2]..'" 170 120 0')
elseif not player(mvp,'bot') then
parse('sv_sound GOSE/MVP/'..save[mvp][14]..'.ogg')
local mvp_img=image('gfx/GOGFX/mkimg/'..save[mvp][14]..'.png',149,128,2)
parse('hudtxt 40 "\169155155155'..musickit[save[mvp][14]][1]..', '..musickit[save[mvp][14]][2]..'" 170 120 0')
end
end
if ace~=nil then
parse('hudtxt 39 "\169255255255Ace!  '..player(ace,'name')..' killed the entire enemy team." 320 150 1')
save[ace][2]=save[ace][2]+aceexp
save[ace][4]=save[ace][4]+aceexp
save[ace][31]=save[ace][31]+1
end
end

function mvp_s(m)
parse('hudtxt 38 "" 160 95 0')
parse('hudtxt 39 "" 320 150 1')
parse('hudtxt 40 "" 165 120 0')
parse('hudtxt 43 "" 82 92 0')
mvp=nil
bper=nil
bder=nil
hrer=nil
kkert=nil
kkerct=nil
knum1=0
knum2=0
ace=nil
ttp=#player(0,"team1living")
tctp=#player(0,"team2living")
for i=1,32 do
kk[i]=0
end
end

---------------------------------------------------------------------
--Headshot-----------------------------------------------------------
---------------------------------------------------------------------

addhook('hit','hs_hit')
addhook('startround','hs_sr')
addhook('move','hs_move')
addhook('second','hs_sec')

armor=50		--裝甲大於65時，攻擊力加成dmg*armor/100
noarmor=100		--裝甲小於65時，攻擊力加成dmg*noarmor/100

hsrmax=l(32)	--最遠暴頭範圍(小於)
hsrmin=l(32)	--最近暴頭範圍(大於)

p_hst=l(32)
hsplus=l(32)
hsplusw=l(32)
hsplayer=nil
r_hst=2

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function hs_move(i,x,y,w)
hsplus[i]=0
if w==1 then
hsplusw[i]=3
else
hsplusw[i]=0
end
end

function hs_sec()
for i=1,32 do
if player(i,'exists') and hsplus[i]<=10 then
hsplus[i]=hsplus[i]+5
end
end
end

function hs_hit(i,s,w,hpdmg,apdmg,rawdmg)
if s>=1 and s<=32 and player(s,'team')~=player(i,'team') then
if hs_mm[w] and w~=50 then 
save[s][16]=save[s][16]+1
if not player(s,'bot') then
hsrmin[s]=hs_mm[w][1]
hsrmax[s]=hs_mm[w][2]+hsplus[s]+hsplusw[s]
else
hsrmin[s]=hs_mm[w][1]+hs_min_skill[bskill]
hsrmax[s]=hs_mm[w][2]+hsplus[s]+hsplusw[s]+hs_max_skill[bskill]
end
local dx,dy=player(s,'x')-player(i,'x'),player(s,'y')-player(i,'y')
local hsx,hsy=math.abs(dx),math.abs(dy)
local hss=math.ceil(math.sqrt(hsx*hsx+hsy*hsy))
if hss<1 then hss=1 end
local hs=math.random(hss)
if hs>=hsrmin[s] and hs<=hsrmax[s] then
local hs_sound=math.random(1,3)
parse('sv_sound2 '..s..' Headshot/headshot'..hs_sound..'.wav')
parse('sv_sound2 '..i..' Headshot/headshot'..hs_sound..'.wav')
local hsdmg
if player(i,'armor')>=65 then
hsdmg=math.ceil((rawdmg*armor)/100)
else
hsdmg=math.ceil((rawdmg*noarmor)/100)
end
local ihealth=player(i,'health')-hpdmg-hsdmg
dmg_ch[i][s]=dmg_ch[i][s]+hpdmg+hsdmg
dmg_cs[i][s]=dmg_cs[i][s]+1
if ihealth<=0 then
save[s][2]=save[s][2]+hsexp
save[s][4]=save[s][4]+hsexp
save[s][12]=save[s][12]+1
p_hst[s]=p_hst[s]+1
if w>=1 and w<=6 then
save[s][17]=save[s][17]+1
save[s][25]=save[s][25]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w==10 or w==11 then
save[s][18]=save[s][18]+1
save[s][26]=save[s][26]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w>=20 and w<=24 then
save[s][19]=save[s][19]+1
save[s][27]=save[s][27]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w>=30 and w<=33 or w==38 or w==39 then
save[s][20]=save[s][20]+1
save[s][28]=save[s][28]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w>=34 and w<=37 then
save[s][21]=save[s][21]+1
save[s][29]=save[s][29]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w==40 then
save[s][22]=save[s][22]+1
save[s][30]=save[s][30]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
elseif w==90 or w==91 then
save[s][46]=save[s][46]+1
save[s][47]=save[s][47]+1
end
if p_hst[s]>=5 then save[s][86]=1 end
if p_hst[s]>r_hst then
hsplayer=player(s,'name')
r_hst=r_hst+1
end
parse('customkill '..s..' "'..itemtype(w,'name')..'(Headshot),gfx/Headshot/'..itemtype(w,'name')..'_hs.bmp" '..i)
if player(i,'team')==1 then
local img=image('gfx/GOGFX/db/hst'..math.random(1,2)..'.bmp',0,0,0)
imagepos(img,player(i,'x'),player(i,'y'),player(s,'rot'))
imagescale(img,1,1)
else
local img=image('gfx/GOGFX/db/hsct'..math.random(1,2)..'.bmp',0,0,0)
imagepos(img,player(i,'x'),player(i,'y'),player(s,'rot'))
imagescale(img,1,1)
end
else
parse('sethealth '..i..' '..ihealth)
return 1
end
else
dmg_ch[i][s]=dmg_ch[i][s]+hpdmg
dmg_cs[i][s]=dmg_cs[i][s]+1
end
else
if w~=50 then
dmg_ch[i][s]=dmg_ch[i][s]+hpdmg
dmg_cs[i][s]=dmg_cs[i][s]+1
end
end
end
end

function hs_sr(m)
hsplayer=nil
r_hst=2
for i=1,32 do
p_hst[i]=0
for ii=1,32 do
dmg_ch[i][ii]=0
dmg_cs[i][ii]=0
end
end
end

addhook('endround','dmgcc_er')
function dmgcc_er(m)
for i=1,32 do
if not player(i,'bot') and m~=4 and m~=5 then
msg2(i,'\169000255255------------------------')
for x=1,32 do
if dmg_ch[i][x]~=0 then
msg2(i,"\169000255255Damage Taken from '"..player(x,'name').."' - "..dmg_ch[i][x].." in "..dmg_cs[i][x].." hits")
end
end
msg2(i,'\169000255255------------------------')
for x=1,32 do
if dmg_ch[x][i]~=0 then
msg2(i,"\169000255255Damage Given to '"..player(x,'name').."' - "..dmg_ch[x][i].." in "..dmg_cs[x][i].." hits")
save[i][78]=save[i][78]+dmg_ch[x][i]
end
end
msg2(i,'\169000255255------------------------')
end
end
end

---------------------------------------------------------------------
--Fun Fact-----------------------------------------------------------
---------------------------------------------------------------------

addhook('hit','ff_h')
addhook('kill','ff_k')
addhook('endround','ff_e')
addhook('startround','ff_s')
addhook('second','ff_sec')
addhook('attack','ff_atk')

killdefuser=l(32)
kill_defuse_num=2
prevent_defuse=nil
p_knife=l(32)
p_he=l(32)
takingk=nil
knifer=nil
heer=nil
fire=0
r_knife=0
rtime=0
hedmg=l(32)
maxhedmg=299
maxhedmgp=nil
lastp_k_namet=nil
lastp_k_namect=nil
lastp_knumt=2
lastp_knumct=2
lastpk=l(32)
playerdeath=false
gethurtby=l(32)
totaldmg=l(32)
k25=l(32)
k25er=nil
r_k25=3

display_chr=1
display_text={}
display_array={
[1]='Script by USGN124616',
[2]='Server name is '..game('sv_name')..'',
[3]='Map name is '..game('sv_map')..'',
[4]='To perform headshots, fire closer to your enemies'
}

function display_exp()
display_text={}
local a=display_array[math.random(#display_array)]
for i1=1,7 do
table.insert(display_text,' ')
end
for i2 in string.gmatch(a,'.') do
table.insert(display_text,i2)
end
for i3=1,7 do
table.insert(display_text,' ')
end
end

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function ff_k(k,v,w,x,y)
if player(k,'team')~=player(v,'team') then
playerdeath=true
if player(k,'health')<=15 then
k25[k]=k25[k]+1
if k25[k]>r_k25 then
k25er=player(k,'name')
r_k25=r_k25+1
end
end
if w==50 and w~=51 then
p_knife[k]=p_knife[k]+1
if p_knife[k]>r_knife then
knifer=player(k,'name')
r_knife=r_knife+1
end
end
if w==51 then
p_he[k]=p_he[k]+1
if p_he[k]>=5 then
heer=k
end
end
if player(v,'weapontype')==50 then
takingk=player(v,'name')
end
if ding[v] then
killdefuser[k]=killdefuser[k]+1
save[k][48]=save[k][48]+1
if killdefuser[k]>kill_defuse_num then
prevent_defuse=player(k,'name')
kill_defuse_num=kill_defuse_num+1
end
end
local talive,ctalive=#player(0,"team1living"),#player(0,"team2living")
if talive==1 and player(k,'team')==1 then
lastpk[k]=lastpk[k]+1
if lastpk[k]>lastp_knumt then
lastp_k_namet=player(k,'name')
lastp_knumt=lastp_knumt+1
end
end
if ctalive==1 and player(k,'team')==2 then
lastpk[k]=lastpk[k]+1
if lastpk[k]>lastp_knumct then
lastp_k_namect=player(k,'name')
lastp_knumct=lastp_knumct+1
end
end
if w==51 and player(k,'health')<=0 then
save[k][50]=1
end
end
end

function ff_h(i,s,w,hpdmg,apdmg,rawdmg)
if s>=1 and s<=32 and player(s,'team')~=player(i,'team') then
if w==51 then
hedmg[s]=hedmg[s]+hpdmg
end
if hedmg[s]>maxhedmg then
maxhedmg=hedmg[s]
maxhedmgp=player(s,'name')
end
end
end

function ff_e(m)
local r_time=rtime-tonumber(game('mp_freezetime'))
local lastpk_state,nocasualties=false,false
--!
local surv,nok={},{}
for v=1,32 do
gethurtby[v]=0
totaldmg[v]=0
for s=1,32 do
if player(v,'exists') and dmg_ch[v][s]~=0 then
gethurtby[v]=gethurtby[v]+1
end
if player(s,'exists') and dmg_ch[s][v]~=0 then
totaldmg[v]=totaldmg[v]+dmg_ch[s][v]
end
end
if gethurtby[v]>=5 and player(v,'health')>0 then
table.insert(surv,v)
save[v][84]=1
end
if totaldmg[v]>=300 and kk[v]==0 then
table.insert(nok,v)
end
end
--!
if ace==nil and m~=4 and m~=5 then
--!
if m==1 or m==10 or m==12 or m==20 or m==30 then
local tr=player(0,"team1")
if #player(0,"team1living")==#tr and #tr>=5 then
nocasualties=true
parse('hudtxt 39 "\169255255255Terrorists won without taking any casualties." 320 150 1')
for _,id in pairs(tr) do
save[id][85]=1
end
end
elseif m==2 or m==11 or m==21 or m==22 or m==31 then
local ct=player(0,"team2")
if #player(0,"team2living")==#ct and #ct>=5 then
nocasualties=true
parse('hudtxt 39 "\169255255255Counter-Terrorists won without taking any casualties." 320 150 1')
for _,id in pairs(ct) do
save[id][85]=1
end
end
end
--!
if hsplayer~=nil and not nocasualties then
parse('hudtxt 39 "\169255255255'..hsplayer..' killed '..r_hst..' enemies with headshot that round." 320 150 1')
end
if hsplayer==nil and lastp_k_namect~=nil and not nocasualties then
if m==2 or m==21 or m==22 then
lastpk_state=true
parse('hudtxt 39 "\169255255255As the last member alive, '..lastp_k_namect..' killed '..lastp_knumct..' enemies and won." 320 150 1')
end
end
if hsplayer==nil and lastp_k_namet~=nil and not nocasualties then
if m==1 or m==20 then
lastpk_state=true
parse('hudtxt 39 "\169255255255As the last member alive, '..lastp_k_namet..' killed '..lastp_knumt..' enemies and won." 320 150 1')
end
end
--!
if surv[1]~=nil and hsplayer==nil and lastpk_state==false and not nocasualties then
local surv2=surv[math.random(#surv)]
parse('hudtxt 39 "\169255255255'..player(surv2,'name')..' survived attacks from '..gethurtby[surv2]..' different enemies." 320 150 1')
end
if nok[1]~=nil and surv[1]==nil and hsplayer==nil and lastpk_state==false and not nocasualties then
local nok2=nok[math.random(#nok)]
parse('hudtxt 39 "\169255255255'..player(nok2,'name')..' had no kills, but did '..totaldmg[nok2]..' damage." 320 150 1')
end
--!
if surv[1]==nil and nok[1]==nil and hsplayer==nil and not lastpk_state and not nocasualties then
if prevent_defuse~=nil then
parse('hudtxt 39 "\169255255255'..prevent_defuse..' defended the planted bomb from '..kill_defuse_num..' enemies." 320 150 1')
end
if heer~=nil and r_knife<=1 and prevent_defuse==nil then
parse('hudtxt 39 "\169255255255'..player(heer,'name')..' killed '..p_he[heer]..' enemies with grenades." 320 150 1')
end
if maxhedmgp~=nil and r_knife<=1 and prevent_defuse==nil and heer==nil then
parse('hudtxt 39 "\169255255255'..maxhedmgp..' did '..maxhedmg..' total damage with grenades." 320 150 1')
end
if knifer~=nil and r_knife==1 and maxhedmgp==nil and prevent_defuse==nil and heer==nil then
parse('hudtxt 39 "\169255255255'..knifer..' killed an enemy with the knife." 320 150 1')
end
if knifer~=nil and r_knife>1 and prevent_defuse==nil then
parse('hudtxt 39 "\169255255255'..knifer..' had '..r_knife..' knife kills this round." 320 150 1')
end
if k25er~=nil and knifer==nil and maxhedmgp==nil and prevent_defuse==nil and heer==nil then
parse('hudtxt 39 "\169255255255'..k25er..' killed '..r_k25..' enemies while under 15 health." 320 150 1')
end
if r_time<=25 and knifer==nil and maxhedmgp==nil and prevent_defuse==nil and heer==nil and k25er==nil then
parse('hudtxt 39 "\169255255255That round took only '..r_time..' seconds!" 320 150 1')
end
if takingk~=nil and r_time>25 and knifer==nil and maxhedmgp==nil and prevent_defuse==nil and heer==nil and k25er==nil then
parse('hudtxt 39 "\169255255255'..takingk..' brought a knife to a gunfight." 320 150 1')
end
if r_time>25 and playerdeath==true and knifer==nil and takingk==nil and maxhedmgp==nil and prevent_defuse==nil and heer==nil and k25er==nil then
parse('hudtxt 39 "\169255255255'..fire..' shots were fired that round." 320 150 1')
end
if r_time>25 and playerdeath==false and knifer==nil and takingk==nil and maxhedmgp==nil and prevent_defuse==nil and heer==nil and k25er==nil then
local rd=math.random(1,2)
if rd==1 then
parse('hudtxt 39 "\169255255255The cake is a lie." 320 150 1')
else
parse('hudtxt 39 "\169255255255Yawn." 320 150 1') 
end
end
end
end
end

function ff_s(m)
prevent_defuse=nil
kill_defuse_num=2
playerdeath=false
takingk=nil
knifer=nil
heer=nil
k25er=nil
r_k25=3
r_knife=0
rtime=0
fire=0
maxhedmg=299
maxhedmgp=nil
lastp_k_namet=nil
lastp_k_namect=nil
lastp_knumt=2
lastp_knumct=2
for i=1,32 do
killdefuser[i]=0
p_knife[i]=0
p_he[i]=0
k25[i]=0
hedmg[i]=0
lastpk[i]=0
parse('setarmor '..i..' 100')
end
end

function ff_sec()
rtime=rtime+1
if display_text[1]~=nil then
if display_chr+6>=#display_text then
display_exp()
display_chr=1
else
display_chr=display_chr+1
end
parse('hudtxt 35 "\169255255255'..display_text[display_chr]..''..display_text[display_chr+1]..''..display_text[display_chr+2]..''..display_text[display_chr+3]..''..display_text[display_chr+4]..''..display_text[display_chr+5]..''..display_text[display_chr+6]..'" 350 0 2')
else
display_exp()
parse('hudtxt 35 "" 320 0 1')
end
end

function ff_atk(i)
local w=player(i,'weapontype')
if hs_mm[w] and w~=50 then
fire=fire+1
save[i][15]=save[i][15]+1
end
end

---------------------------------------------------------------------
--Knife From Behind--------------------------------------------------
---------------------------------------------------------------------

addhook('hit','kfb_hit')

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function kfb_hit(i,s,w,hpdmg,apdmg,rawdmg)
if s>=1 and s<=32 and player(s,'team')~=player(i,'team') then
if w==50 and rawdmg>=60 then
local sr=player(s,'rot')
local vr=player(i,'rot')
local svr=math.abs(sr-vr)
if svr>=330 or svr<=30 then
dmg_ch[i][s]=dmg_ch[i][s]+100
dmg_cs[i][s]=dmg_cs[i][s]+1
save[s][2]=save[s][2]+kbskillexp
save[s][4]=save[s][4]+kbskillexp
save[s][23]=save[s][23]+1
save[s][32]=save[s][32]+1
save[s][hs_mm[w][4]]=save[s][hs_mm[w][4]]+1
p_knife[s]=p_knife[s]+1
if p_knife[s]>r_knife then
knifer=player(s,'name')
r_knife=r_knife+1
end
parse('customkill '..s..' "BackStab,gfx/GOGFX/BS.bmp" '..i)
else
dmg_ch[i][s]=dmg_ch[i][s]+hpdmg
dmg_cs[i][s]=dmg_cs[i][s]+1
end
else
if w==50 and rawdmg<60 then
dmg_ch[i][s]=dmg_ch[i][s]+hpdmg
dmg_cs[i][s]=dmg_cs[i][s]+1
end
end
end
end

---------------------------------------------------------------------
--F2&F3--------------------------------------------------------------
---------------------------------------------------------------------

addhook('menu','mk_change_music_menu')
addhook('serveraction','f23_serveraction')
addhook('menu','f23_menu')

hspa=l(32)
acpa=l(32)
searchid=l(32)
plist={}

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function f23_serveraction(i,a)
if a==1 then
local n,lvpa=player(i,'name'),(math.floor((save[i][2]/save[i][3])*10000))/100
if save[i][12]==0 and save[i][10]>=0 then
hspa[i]=0.00
elseif save[i][12]>=1 and save[i][10]==0 then
hspa[i]=100.00
else
hspa[i]=(math.floor((save[i][12]/save[i][10])*10000))/100
end
if save[i][16]==0 and save[i][15]>=0 then
acpa[i]=0.00
else
acpa[i]=(math.floor((save[i][16]/save[i][15])*10000))/100
if acpa[i]>100 then acpa[i]=100.00 end
end
menu(i,'Status,Name : '..n..',Level : '..save[i][1]..' ('..lvpa..'%),Win / Lose : '..save[i][5]..' / '..save[i][6]..',Kill / Death : '..save[i][10]..' / '..save[i][11]..',Headshot : '..save[i][12]..' ('..hspa[i]..'%),Accuary : '..acpa[i]..'%,MVP : '..save[i][13]..',Refresh')
elseif a==2 then
menu(i,'Settings,Change Musickit,Player List,About')
end
end

function f23_menu(i,t,b)
if t=='Status' then
if b==1 then
local tit
if save[i][76]~=0 then
tit=achievement[save[i][76]][4]
else
tit='None'
end
menu(i,'Player Info,Title : '..tit..',USGN : '..player(i,'usgn')..'')
elseif b==2 then
menu(i,'Level Info,Exp / Next : '..save[i][2]..' / '..save[i][3]..',Total Exp : '..save[i][4]..'')
elseif b==3 then
menu(i,'Win Info,Elimination : '..save[i][7]..',Detonate : '..save[i][8]..',Defuse/Protect : '..save[i][9]..',Others : '..save[i][87]..'')
elseif b==4 then
menu(i,'Kill Info,Pistol : '..save[i][17]..',Shotgun : '..save[i][18]..',SMG : '..save[i][19]..',Rifle : '..save[i][20]..',Sniper : '..save[i][21]..',Machinegun : '..save[i][22]..',Knife : '..save[i][23]..',Grenade : '..save[i][24]..',Others : '..save[i][46]..'')
elseif b==5 then
menu(i,'Headshot Info,Pistol : '..save[i][25]..',Shotgun : '..save[i][26]..',SMG : '..save[i][27]..',Rifle : '..save[i][28]..',Sniper : '..save[i][29]..',Machinegun : '..save[i][30]..',Others : '..save[i][47]..'')
elseif b==6 then
menu(i,'Accuary Info,Shots Fired : '..save[i][15]..',Shots Hit : '..save[i][16]..'')
elseif b==7 then
menu(i,'MVP Info,Musickit : '..musickit[save[i][14]][1]..',Author : '..musickit[save[i][14]][2]..'')
elseif b==8 then
local n,lvpa=player(i,'name'),(math.floor((save[i][2]/save[i][3])*10000))/100
if save[i][12]==0 and save[i][10]>=0 then
hspa[i]=0.00
elseif save[i][12]>=1 and save[i][10]==0 then
hspa[i]=100.00
else
hspa[i]=(math.floor((save[i][12]/save[i][10])*10000))/100
end
if save[i][16]==0 and save[i][15]>=0 then
acpa[i]=0.00
else
acpa[i]=(math.floor((save[i][16]/save[i][15])*10000))/100
if acpa[i]>100 then acpa[i]=100.00 end
end
menu(i,'Status,Name : '..n..',Level : '..save[i][1]..' ('..lvpa..'%),Win / Lose : '..save[i][5]..' / '..save[i][6]..',Kill / Death : '..save[i][10]..' / '..save[i][11]..',Headshot : '..save[i][12]..' ('..hspa[i]..'%),Accuary : '..acpa[i]..'%,MVP : '..save[i][13]..',Refresh')
end
elseif t=='Status (ID#'..searchid[i]..')' then
if b==1 then
local tits
if save[searchid[i]][76]~=0 then
tits=achievement[save[searchid[i]][76]][4]
else
tits='None'
end
menu(i,'Player Info (ID#'..searchid[i]..'),Title : '..tits..',USGN : '..player(searchid[i],'usgn')..'')
elseif b==2 then
menu(i,'Level Info (ID#'..searchid[i]..'),Exp / Next : '..save[searchid[i]][2]..' / '..save[searchid[i]][3]..',Total Exp : '..save[searchid[i]][4]..'')
elseif b==3 then
menu(i,'Win Info (ID#'..searchid[i]..'),Elimination : '..save[searchid[i]][7]..',Detonate : '..save[searchid[i]][8]..',Defuse/Protect : '..save[searchid[i]][9]..',Others : '..save[searchid[i]][87]..'')
elseif b==4 then
menu(i,'Kill Info (ID#'..searchid[i]..'),Pistol : '..save[searchid[i]][17]..',Shotgun : '..save[searchid[i]][18]..',SMG : '..save[searchid[i]][19]..',Rifle : '..save[searchid[i]][20]..',Sniper : '..save[searchid[i]][21]..',Machinegun : '..save[searchid[i]][22]..',Knife : '..save[searchid[i]][23]..',Grenade : '..save[searchid[i]][24]..',Others : '..save[searchid[i]][46]..'')
elseif b==5 then
menu(i,'Headshot Info (ID#'..searchid[i]..'),Pistol : '..save[searchid[i]][25]..',Shotgun : '..save[searchid[i]][26]..',SMG : '..save[searchid[i]][27]..',Rifle : '..save[searchid[i]][28]..',Sniper : '..save[searchid[i]][29]..',Machinegun : '..save[searchid[i]][30]..',Others : '..save[searchid[i]][47]..'')
elseif b==6 then
menu(i,'Accuary Info (ID#'..searchid[i]..'),Shots Fired : '..save[searchid[i]][15]..',Shots Hit : '..save[searchid[i]][16]..'')
elseif b==7 then
menu(i,'MVP Info (ID#'..searchid[i]..'),Musickit : '..musickit[save[searchid[i]][14]][1]..',Author : '..musickit[save[searchid[i]][14]][2]..'')
elseif b==8 then
if player(searchid[i],'exists') then
local n,lvpa=player(searchid[i],'name'),(math.floor((save[searchid[i]][2]/save[searchid[i]][3])*10000))/100
if save[searchid[i]][12]==0 and save[searchid[i]][10]>=0 then
hspa[searchid[i]]=0.00
elseif save[searchid[i]][12]>=1 and save[searchid[i]][10]==0 then
hspa[searchid[i]]=100.00
else
hspa[searchid[i]]=(math.floor((save[searchid[i]][12]/save[searchid[i]][10])*10000))/100
end
if save[searchid[i]][16]==0 and save[searchid[i]][15]>=0 then
acpa[searchid[i]]=0.00
else
acpa[searchid[i]]=(math.floor((save[searchid[i]][16]/save[searchid[i]][15])*10000))/100
if acpa[searchid[i]]>100 then acpa[searchid[i]]=100.00 end
end
menu(i,'Status (ID#'..searchid[i]..'),Name : '..n..',Level : '..save[searchid[i]][1]..' ('..lvpa..'%),Win / Lose : '..save[searchid[i]][5]..' / '..save[searchid[i]][6]..',Kill / Death : '..save[searchid[i]][10]..' / '..save[searchid[i]][11]..',Headshot : '..save[searchid[i]][12]..' ('..hspa[searchid[i]]..'%),Accuary : '..acpa[searchid[i]]..'%,MVP : '..save[searchid[i]][13]..',Refresh')
end
end
elseif t=='Player Info (ID#'..searchid[i]..')' or t=='Level Info (ID#'..searchid[i]..')' or t=='Win Info (ID#'..searchid[i]..')' or t=='Kill Info (ID#'..searchid[i]..')' or t=='Headshot Info (ID#'..searchid[i]..')' or t=='Accuary Info (ID#'..searchid[i]..')' or t=='MVP Info (ID#'..searchid[i]..')' then
if b==0 then
if player(searchid[i],'exists') then
local n,lvpa=player(searchid[i],'name'),(math.floor((save[searchid[i]][2]/save[searchid[i]][3])*10000))/100
if save[searchid[i]][12]==0 and save[searchid[i]][10]>=0 then
hspa[searchid[i]]=0.00
elseif save[searchid[i]][12]>=1 and save[searchid[i]][10]==0 then
hspa[searchid[i]]=100.00
else
hspa[searchid[i]]=(math.floor((save[searchid[i]][12]/save[searchid[i]][10])*10000))/100
end
if save[searchid[i]][16]==0 and save[searchid[i]][15]>=0 then
acpa[searchid[i]]=0.00
else
acpa[searchid[i]]=(math.floor((save[searchid[i]][16]/save[searchid[i]][15])*10000))/100
if acpa[searchid[i]]>100 then acpa[searchid[i]]=100.00 end
end
menu(i,'Status (ID#'..searchid[i]..'),Name : '..n..',Level : '..save[searchid[i]][1]..' ('..lvpa..'%),Win / Lose : '..save[searchid[i]][5]..' / '..save[searchid[i]][6]..',Kill / Death : '..save[searchid[i]][10]..' / '..save[searchid[i]][11]..',Headshot : '..save[searchid[i]][12]..' ('..hspa[searchid[i]]..'%),Accuary : '..acpa[searchid[i]]..'%,MVP : '..save[searchid[i]][13]..',Refresh')
end
end
elseif t=='Settings' then
if b==1 then
menu(i,'Music Kit 1/5@b,AD8,All I Want For Chrismas,Crimson Assault,Desert Fire,Disgusting,High Noon,Hotline Miami,Metal,Next Page')
elseif b==2 then
for pl=1,32 do
if player(pl,'exists') then
local pi='Lv'..save[pl][1]..'.'..player(pl,'name')..''
plist[pl]=pi
else
plist[pl]='(No Player)'
end
end
menu(i,'Player List (Page 1/4),'..plist[1]..','..plist[2]..','..plist[3]..','..plist[4]..','..plist[5]..','..plist[6]..','..plist[7]..','..plist[8]..',Next Page')
elseif b==3 then
msg2(i,'\169255128000[Server] System created by USGN#124616')
msg2(i,'\169255128000[Server] To perform headshots, fire closer to your enemies.')
msg2(i,'\169255128000[Server] Stab enemy in the back, it usually results in an instant kill.')
end
elseif t=='Player List (Page 1/4)' or t=='Player List (Page 2/4)' or t=='Player List (Page 3/4)' or t=='Player List (Page 4/4)' then
if b==9 then
if t=='Player List (Page 1/4)' then
menu(i,'Player List (Page 2/4),'..plist[9]..','..plist[10]..','..plist[11]..','..plist[12]..','..plist[13]..','..plist[14]..','..plist[15]..','..plist[16]..',Next Page')
elseif t=='Player List (Page 2/4)' then
menu(i,'Player List (Page 3/4),'..plist[17]..','..plist[18]..','..plist[19]..','..plist[20]..','..plist[21]..','..plist[22]..','..plist[23]..','..plist[24]..',Next Page')
elseif t=='Player List (Page 3/4)' then
menu(i,'Player List (Page 4/4),'..plist[25]..','..plist[26]..','..plist[27]..','..plist[28]..','..plist[29]..','..plist[30]..','..plist[31]..','..plist[32]..'')
end
elseif b==1 or b==2 or b==3 or b==4 or b==5 or b==6 or b==7 or b==8 then 
if t=='Player List (Page 1/4)' then
searchid[i]=b
elseif t=='Player List (Page 2/4)' then
searchid[i]=b+8
elseif t=='Player List (Page 3/4)' then
searchid[i]=b+16
elseif t=='Player List (Page 4/4)' then
searchid[i]=b+24
end
if player(searchid[i],'exists') then
local n,lvpa=player(searchid[i],'name'),(math.floor((save[searchid[i]][2]/save[searchid[i]][3])*10000))/100
if save[searchid[i]][12]==0 and save[searchid[i]][10]>=0 then
hspa[searchid[i]]=0.00
elseif save[searchid[i]][12]>=1 and save[searchid[i]][10]==0 then
hspa[searchid[i]]=100.00
else
hspa[searchid[i]]=(math.floor((save[searchid[i]][12]/save[searchid[i]][10])*10000))/100
end
if save[searchid[i]][16]==0 and save[searchid[i]][15]>=0 then
acpa[searchid[i]]=0.00
else
acpa[searchid[i]]=(math.floor((save[searchid[i]][16]/save[searchid[i]][15])*10000))/100
if acpa[searchid[i]]>100 then acpa[searchid[i]]=100.00 end
end
menu(i,'Status (ID#'..searchid[i]..'),Name : '..n..',Level : '..save[searchid[i]][1]..' ('..lvpa..'%),Win / Lose : '..save[searchid[i]][5]..' / '..save[searchid[i]][6]..',Kill / Death : '..save[searchid[i]][10]..' / '..save[searchid[i]][11]..',Headshot : '..save[searchid[i]][12]..' ('..hspa[searchid[i]]..'%),Accuary : '..acpa[searchid[i]]..'%,MVP : '..save[searchid[i]][13]..',Refresh')
end
end
end
end

function mk_change_music_menu(i,t,a)
if t=='Music Kit 1/5' then
if a>=1 and a<=8 then
save[i][14]=a
msg2(i,'\169000255255[Server] Musickit set : '..musickit[save[i][14]][1])
elseif a==9 then
menu(i,'Music Kit 2/5@b,Total Domination,Diamonds,Deaths Head Demolition,Battlepack,For No Mankind,I Am,Invasion!,Previous Page,Next Page')
end
end
if t=='Music Kit 2/5' then
if a>=1 and a<=7 then
save[i][14]=a+8
msg2(i,'\169000255255[Server] Musickit set : '..musickit[save[i][14]][1])
elseif a==8 then
menu(i,'Music Kit 1/5@b,AD8,All I Want For Chrismas,Crimson Assault,Desert Fire,Disgusting,High Noon,Hotline Miami,Metal,Next Page')
elseif a==9 then
menu(i,'Music Kit 3/5@b,IsoRhythm,Lions Mouth,Moments,Sharpened,The 8-bit Kit,The Talos Principle,Uber Blasto Phone,Previous Page,Next Page')
end
end
if t=='Music Kit 3/5' then
if a>=1 and a<=7 then
save[i][14]=a+15
msg2(i,'\169000255255[Server] Musickit set : '..musickit[save[i][14]][1])
elseif a==8 then
menu(i,'Music Kit 2/5@b,Total Domination,Diamonds,Deaths Head Demolition,Battlepack,For No Mankind,I Am,Invasion!,Previous Page,Next Page')
elseif a==9 then
menu(i,'Music Kit 4/5@b,II-Headshot,Insurgency,LNOE,MOLOTOV,Sponge Fingerz,Java Havana Funkaloo,Aggressive,Previous Page,Next Page')
end
end
if t=='Music Kit 4/5' then
if a>=1 and a<=7 then
save[i][14]=a+22
msg2(i,'\169000255255[Server] Musickit set : '..musickit[save[i][14]][1])
elseif a==8 then
menu(i,'Music Kit 3/5@b,IsoRhythm,Lions Mouth,Moments,Sharpened,The 8-bit Kit,The Talos Principle,Uber Blasto Phone,Previous Page,Next Page')
elseif a==9 then
menu(i,"Music Kit 5/5@b,Backbone,Free,GLA,III-Arena,Life's Not Out To Get You,The Good Youth,Hazardous Environments,Previous Page")
end
end
if t=='Music Kit 5/5' then
if a>=1 and a<=7 then
save[i][14]=a+29
msg2(i,'\169000255255[Server] Musickit set : '..musickit[save[i][14]][1])
elseif a==8 then
menu(i,'Music Kit 4/5@b,II-Headshot,Insurgency,LNOE,MOLOTOV,Sponge Fingerz,Java Havana Funkaloo,Aggressive,Previous Page,Next Page')
end
end
end

---------------------------------------------------------------------
--Achievement--------------------------------------------------------
---------------------------------------------------------------------

addhook('join','achievement_join')
addhook('menu','achievement_menu')
addhook('serveraction','achievement_serveraction')

achievement={
[1]={'Kill 100 enemies with pistol',17,100},
[2]={'Kill 500 enemies with pistol',17,500},
[3]={'Kill 100 enemies with shotgun',18,100},
[4]={'Kill 500 enemies with shotgun',18,500},
[5]={'Kill 100 enemies with smg',19,100},
[6]={'Kill 500 enemies with smg',19,500},
[7]={'Kill 100 enemies with rifle',20,100},
[8]={'Kill 500 enemies with rifle',20,500},
[9]={'Kill 100 enemies with sniper',21,100},
[10]={'Kill 500 enemies with sniper',21,500},
[11]={'Kill 100 enemies with machinegun',22,100},
[12]={'Kill 500 enemies with machinegun',22,500},
[13]={'Kill 100 enemies with knife',23,100},
[14]={'[TITLE] Kill 500 enemies with knife',23,500,'Slaughter'},
[15]={'Kill 100 enemies with grenade',24,100},
[16]={'[TITLE] Kill 500 enemies with grenade',24,500,'Kobe'},
[17]={'Kill 100 enemies',10,100},
[18]={'Kill 500 enemies',10,500},
[19]={'Kill 1000 enemies',10,1000},
[20]={'Kill 5000 enemies',10,5000},
[21]={'[TITLE] Kill 10000 enemies',10,10000,'Terminator'},
[22]={'Kill 10 enemy with headshot',12,10},
[23]={'Kill 50 enemies with headshot',12,50},
[24]={'Kill 100 enemies with headshot',12,100},
[25]={'Kill 500 enemies with headshot',12,500},
[26]={'[TITLE] Kill 1000 enemies with headshot',12,1000,'Headshot Master'},
[27]={'Be MVP for 1 time',13,1},
[28]={'Be MVP for 50 times',13,50},
[29]={'Be MVP for 100 times',13,100},
[30]={'[TITLE] Be MVP for 500 times',13,500,'MVP'},
[31]={'[TITLE] Gain level 5',1,5,'Newbie'},
[32]={'Gain level 50',1,50},
[33]={'[TITLE] Gain level 100',1,100,'Old Butt'},
[34]={'Ace 1 time',31,1},
[35]={'Ace 10 times',31,10},
[36]={'[TITLE] Ace 50 times',31,50,'PRO Player'},
[37]={'Kill 50 enemies with backstab',32,50},
[38]={'[TITLE] Kill 100 enemies with backstab',32,100,'Assassin'},
[39]={'Plant 50 bombs',33,50},
[40]={'[TITLE] Plant 100 bombs',33,100,'Bomber'},
[41]={'Defuse 50 bombs',34,50},
[42]={'[TITLE] Defuse 100 bombs',34,100,'Defuser'},
[43]={'Kill 100 enemies with m4 as TR',35,100},
[44]={'Kill 100 enemies with ak as CT',36,100},
[45]={'[TITLE] Win a round in 25 seconds',37,1,'Mr.Rush'},
[46]={'Win 100 rounds',5,100},
[47]={'Win 500 rounds',5,500},
[48]={'[TITLE] Win 1000 rounds',5,1000,'EZPZ'},
[49]={'[TITLE] Score firstblood 100 times',38,100,'The First'},
[50]={'Score doublekill 100 times',39,100},
[51]={'Score triplekill 100 times',40,100},
[52]={'Score ultrakill 100 times',41,100},
[53]={'Score unstopable 100 times',42,100},
[54]={'Fire 10000 shots',15,10000},
[55]={'Fire 100000 shots',15,100000},
[56]={'[TITLE] Survive round with 1HP left',43,1,'Lucky Guy'},
[57]={'Kill an enemy who is defusing using grenade',44,1},
[58]={'Plant the bomb in 25 seconds',45,1},
[59]={'[TITLE] Ace with headshot only',49,1,'Aimbot'},
[60]={'Kill 50 enemies who is defusing the bomb',48,50},
[61]={'Kill 100 enemies who is defusing the bomb',48,100},
[62]={'Kill an enemy with a grenade when dead',50,1},
[63]={'Win a round by detonating the bomb',8,1},
[64]={'Win a round by defusing the bomb',77,1},
[65]={'Inflict 5000 total points of damage to enemies',78,5000},
[66]={'Inflict 50000 total points of damage to enemies',78,50000},
[67]={'Inflict 100000 total points of damage to enemies',78,100000},
[68]={'Win a round by rescuing hostages',79,1},
[69]={'Kill five enemies in a single round',80,1},
[70]={'Kill five enemy players with headshots in a single round',86,1},
[71]={'Be the last player alive in a round with five players on your team',81,1},
[72]={'Get a kill with every weapon',0--[[Special]],1,nil--[[Title]],{51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75}},
[73]={'Win a knife fight',82,1},
[74]={'Win 100 knife fights',82,100},
[75]={'Kill an enemy while at one health',83,1},
[76]={'Survive damage from five different enemies within a round',84,1},
[77]={'Won without taking any casualties',85,1},
[78]={'[TITLE] Kill 500 enemies with Usp',51,500,'Usp Expert'},
[79]={'[TITLE] Kill 500 enemies with Glock',52,500,'Glock Expert'},
[80]={'[TITLE] Kill 500 enemies with Deagle',53,500,'Deagle Expert'},
[81]={'[TITLE] Kill 500 enemies with P228',54,500,'P228 Expert'},
[82]={'[TITLE] Kill 500 enemies with Elite',55,500,'Elite Expert'},
[83]={'[TITLE] Kill 500 enemies with Fiveseven',56,500,'Fiveseven Expert'},
[84]={'[TITLE] Unlock all Pistol kill awards',0,500,'Pistol Master',{51,52,53,54,55,56}},
[85]={'[TITLE] Kill 500 enemies with M3',57,500,'M3 Expert'},
[86]={'[TITLE] Kill 500 enemies with XM1014',58,500,'XM1014 Expert'},
[87]={'[TITLE] Unlock all Shotgun kill awards',0,500,'Shotgun Master',{85,86}},
[88]={'[TITLE] Kill 500 enemies with MP5',59,500,'MP5 Expert'},
[89]={'[TITLE] Kill 500 enemies with TMP',60,500,'TMP Expert'},
[90]={'[TITLE] Kill 500 enemies with P90',61,500,'P90 Expert'},
[91]={'[TITLE] Kill 500 enemies with MAC10',62,500,'MAC10 Expert'},
[92]={'[TITLE] Kill 500 enemies with UMP45',63,500,'UMP45 Expert'},
[93]={'[TITLE] Unlock all SMG kill awards',0,500,'SMG Master',{59,60,61,62,63}},
[94]={'[TITLE] Kill 1000 enemies with AK47',64,1000,'AK47 Expert'},
[95]={'[TITLE] Kill 1000 enemies with M4A1',66,1000,'M4A1 Expert'},
[96]={'[TITLE] Kill 1000 enemies with GALIL',72,1000,'GALIL Expert'},
[97]={'[TITLE] Kill 1000 enemies with FAMAS',73,1000,'FAMAS Expert'},
[98]={'[TITLE] Kill 1000 enemies with SG552',65,1000,'SG552 Expert'},
[99]={'[TITLE] Kill 1000 enemies with AUG',67,1000,'AUG Expert'},
[100]={'[TITLE] Kill 1000 enemies with Scout',68,1000,'SCOUT Expert'},
[101]={'[TITLE] Kill 1000 enemies with AWP',69,1000,'AWP Expert'},
[102]={'[TITLE] Kill 1000 enemies with G3SG1',70,1000,'G3SG1 Expert'},
[103]={'[TITLE] Kill 1000 enemies with SG550',71,1000,'SG550 Expert'},
[104]={'[TITLE] Unlock all rifle kill awards',0,1000,'Rifle Master',{64,65,66,67,68,69,70,71,72,73}},
[105]={'[TITLE] Kill 10000 enemies with M249',74,10000,'M249 Expert'},
[106]={'[TITLE] Unlock all LMG kill awards',74,10000,'LMG Expert'},
--[107]={'Kill the entire opposing team without any members of your team dying',88,1},
}
pl_achieve=l2(32,#achievement)

---------------------------------------------------------------------
--Function-----------------------------------------------------------
---------------------------------------------------------------------

function achievement_join(i)
for n=1,#achievement do
pl_achieve[i][n]=false
end
end

function achievement_serveraction(i,a)
if a==3 then
local c=0
for x=1,#achievement do
if achievement[x][2]==0 then
local sp_com=0
for o=1,#achievement[x][5] do
if save[i][achievement[x][5][o]]>=achievement[x][3] then
sp_com=sp_com+1
end
if sp_com==#achievement[x][5] then
pl_achieve[i][x]=true
c=c+1
end
end
elseif achievement[x][2]~=0 then
if save[i][achievement[x][2]]>=achievement[x][3] then
pl_achieve[i][x]=true
c=c+1
end
end
end
if save[i][76]~=0 then
menu(i,'Achievements menu,['..c..'/'..#achievement..'] Achievements,Clear Title : '..achievement[save[i][76]][4]..'')
else
menu(i,'Achievements menu,['..c..'/'..#achievement..'] Achievements,No Title')
end
end
end

function achievement_menu(i,t,b)
local page,k=tonumber(string.match(t,'(%d+)%S',19)) or 0,{}
for n=1,#achievement do
if pl_achieve[i][n] then
k[n]=achievement[n][1]
else
k[n]='('..achievement[n][1]..')'
end
end
if t=='Achievements menu' then
if b==1 then
menu(i,'Achievements (Page 1)@b,'..k[1]..','..k[2]..','..k[3]..','..k[4]..','..k[5]..','..k[6]..','..k[7]..','..k[8]..',Next Page')
elseif b==2 and save[i][76]~=0 then
save[i][76]=0
msg2(i,'\169000255255[Server] Title Cleared')
end
end
if t=='Achievements (Page '..page..')' then
if b==9 and b~=0 then
local kn,pagenext={1,2,3,4,5,6,7,8},page+1
for h=1,8 do
kn[h]=kn[h]+(8*page)
if not achievement[kn[h]] then
k[kn[h]]='(Empty)'
end
end
menu(i,'Achievements (Page '..pagenext..')@b,'..k[kn[1]]..','..k[kn[2]]..','..k[kn[3]]..','..k[kn[4]]..','..k[kn[5]]..','..k[kn[6]]..','..k[kn[7]]..','..k[kn[8]]..',Next Page')
end
if b~=9 and b~=0 then
local pp=(page-1)*8
local a=b+pp
for x=1,#achievement do
if achievement[a] and k[a]==achievement[x][1] and achievement[x][4]~=nil then
save[i][76]=x
msg2(i,'\169000255255[Server] Title set : '..achievement[x][4]..'')
end
end
end
end
end
