--Lua by Dragon Lore--

function T(m)
local array={}
for i=1,m do
array[i]=0
end
return array
end

--[[
製作地圖須知 :
1.難度HARD的事件名需是：hard_zb, hard_event
2. 一波殭屍來襲配樂啟動要 trigger : misc_s ; 結束則 trigger : misc_e
3.類似l4d所有人進門計算實體是 : trigger_move 名稱叫 +pi 之後觸發名叫 : +pi_ok.1,+pi_ok.2,+pi_ok.3...... 的東西
4.拿醫療包的實體名稱要叫 : get_medkits.1~50 另外還有 get_pills.1~50, get_drug1.1~50 自己看看[全免自己trigger自己]
5.special_bonus...trigger
6.開始類似l4d倒油事件開關實體是 : trigger_move 名稱叫 tsg_start.需要油桶數(1~12).x(第x次, 1~n)[trigger自己]
6-1.需要倒油的載具的事件實體是 : trigger_use 名稱叫 gc_done 完成後事件名稱叫 : tsg_finish.x(第x次, 1~n)
6-2.取得油桶的事件實體是 : trigger_use 名稱叫 gct.1~20(第幾個油桶).x(第x次, 1~6) [免自己trigger自己]
6-3.油桶事件盡量在 6 次以內
6-4.避免油桶到處噴就trigger : p_pi_reset
7.說 p玩家編號 來得知他們的血量
8.
9.cash,unlock wpn,achivement,shop
10.unlock weapon : chainsaw+chainsaw upgrades
]]

-------------------------------------------------
--數值
-------------------------------------------------
difficulty='Normal'
menu_op=1

special_bonus=0

player_on_server=0
player_alive=0

player_count=0
tsp_number=1

playing_sound=0
sound_file=''

gascan_start=0
gascan_needed=0
gascan_done=0
gas_using=1
tsg_number=1
tsg_repeat=1
respawn_delay=0

g1=0
g2=0
g3=0
g4=0
g5=0
g6=0
g7=0
g8=0
g9=0
g10=0
g11=0
g12=0
g13=0
g14=0
g15=0
g16=0
g17=0
g18=0
g19=0
g20=0
-------------------------------------------------
--數值(ARRAY)
-------------------------------------------------
as=T(4)

total_kills=T(4)

player_lv=T(4)
player_exp=T(4)
player_exp_to_next=T(4)
player_pts=T(4)

max_health=T(4)
exp_per_kill=T(4)

max_health_times=T(4)
exp_per_kill_times=T(4)

chainsaw_out=T(4)
chainsaw_pow_id=T(4)

player_in=T(4)
player_get_gas=T(4)

i_lock=T(4)
medkits=T(4)
pills=T(4)
adrenalineshot=T(4)
lmedkits=T(4)
syringe=T(4)
morphia=T(4)

lmedkit_unlock=T(4)
syringe_unlock=T(4)
morphia_unlock=T(4)

sa1=T(4)
sa2=T(4)

using=T(4)
gimg=T(4)
p_xy=T(4)
chainsaw_pow=T(4)
items_unlock=T(4)
-------------------------------------------------
--附件
-------------------------------------------------
--字體顏色
color={
'©000255255',--淺藍[1]
'©000000255',--深藍[2]
'©255000000',--紅[3]
'©255128255',--粉紅[4]
'©128000000',--深紅[5]
'©255128000',--橘[6]
'©000255000',--綠[7]
'©255255255',--白[8]
'©000000000',--黑[9]
''--黃色[10]
}

--遊戲結束
function gameover()
if player_on_server>=3 then
if player_alive==0 then
parse('sv_sound T-Storm/lua/gameover/death.wav')
msg(''..color[10]..'GAME OVER')
parse('restart 5')
end
end
end

--調整難度附件
function hard_trigger()
parse('trigger hard_zb')
parse('trigger hard_event')
end

--屍潮音效附件
function play()
if playing_sound==1 then
parse("sv_sound "..sound_file.."")
end
if playing_sound==0 then
freetimer('play')
end
end

--屍潮音效
misc={
'T-Storm/lua/drums/drums1.wav',
'T-Storm/lua/drums/drums2.wav',
'T-Storm/lua/drums/drums3.wav',
'T-Storm/lua/drums/drums4.wav',
'T-Storm/lua/drums/drums5.wav',
'T-Storm/lua/drums/drums6.wav'
}

--醫療包
medkits_number={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15',
'16','17','18','19','20','21','22','23','24','25','26','27','28','29','30',
'31','32','33','34','35','36','37','38','39','40','41','42','43','44','45',
'46','47','48','49','50'}
--藥丸
pills_number={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15',
'16','17','18','19','20','21','22','23','24','25','26','27','28','29','30',
'31','32','33','34','35','36','37','38','39','40','41','42','43','44','45',
'46','47','48','49','50'}
--腎上腺素
adrenalineshot_number={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15',
'16','17','18','19','20','21','22','23','24','25','26','27','28','29','30',
'31','32','33','34','35','36','37','38','39','40','41','42','43','44','45',
'46','47','48','49','50'}

--換彈音效
reloading={
"T-Storm/lua/voice/reload/reloading01.wav",
"T-Storm/lua/voice/reload/reloading02.wav",
"T-Storm/lua/voice/reload/reloading03.wav",
"T-Storm/lua/voice/reload/reloading04.wav",
"T-Storm/lua/voice/reload/reloading05.wav",
"T-Storm/lua/voice/reload/reloading06.wav"
 }

--拿到油桶音效
Get_Gascan={
"T-Storm/lua/voice/worldc1m4b40.wav",
"T-Storm/lua/voice/worldc1m4b41.wav",
"T-Storm/lua/voice/worldc1m4b43.wav",
"T-Storm/lua/voice/quiet.wav"
 }

--油桶需要數事件名稱
gascan_take_number={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'}

--油桶避免重複
gct_number={'1','2','3','4','5','6'}

--油桶開始說的
gcs_say={''..color[10]..'Find gascan or die here !!!',
''..color[10]..'Move on, bring gascan here !',
''..color[10]..'I think we need some gascan...'
}

--油桶結束說的
gce_say={''..color[10]..'Good job',
''..color[10]..'Yeah, that us move on',
''..color[10]..'We did it !!'
}

--油桶開始附件
function tsgs()
parse('trigger tsg_start.'..gascan_needed..'.'..tsg_repeat..'')
tsg_repeat=tsg_repeat+1
gascan_done=0
gascan_start=1
for id=1,4 do
player_get_gas[id]=0
end
msg(''..gcs_say[math.random(#gcs_say)]..'')
end

--未知
p={'1','2','3','4'}
-------------------------------------------------
--設定
-------------------------------------------------
parse('sv_gamemode 2')
parse('mp_dropgrenades 0')
parse('mp_deathdrop 3')
parse('mp_timelimit 0')
parse('sv_fow 3')
parse('sv_maxplayers 4')
parse('mp_respawndelay 0')
parse('sv_specmode 0')
parse('sv_friendlyfire 1')
parse('mp_infammo 1')
-------------------------------------------------
--設定完
-------------------------------------------------

--HOOK STARTROUND
addhook('startround','Tstorm_startround')
function Tstorm_startround(mode)
-------------------------------------------------
--新局重置
-------------------------------------------------
special_bonus=0
player_count=0
tsp_number=1
gascan_start=0
gascan_needed=0
gascan_carry=0
gascan_done=0
gas_using=1
tsg_number=1
tsg_repeat=1
menu_op=1
difficulty='Normal'
playing_sound=0
-------------------------------------------------
end

oh=T(4)
addhook('objectdamage','Tstorm_obdmg')
function Tstorm_obdmg(o,d,p)
local h=object(o,'typename')
local n=object(o,'health')-d
if n<0 then
n=0
end
oh[p]=('('..h..''..o..'): '..n..'')
end

--HOOK ALWAYS
addhook('always','Tstorm_always')
function Tstorm_always()
-------------------------------------------------
parse('hudtxt 11 "'..color[1]..'== ITEMS ==" 10 73 -1')
parse('hudtxt 12 "Difficulty : '..difficulty..'" 260 460 -1')
parse('hudtxt 13 "Player Alive : '..player_alive..' / '..player_on_server..'" 370 460 -1')
--油桶類
if gascan_start==1 then
parse('hudtxt 14 "'..color[1]..'== GASCAN ==" 10 208 -1')
parse('hudtxt 15 "'..color[1]..'Needed / Done : '..gascan_needed..' / '..gascan_done..'" 10 223 -1')
else
parse('hudtxt 14 "" 10 208 -1')
parse('hudtxt 15 "" 10 223 -1')
end
-------------------------------------------------
--[[名子顯示
for id=1,4 do
if player(id,'exists') and player(id,'health')>0 then
for i=1,4 do
if player(i,'exists') and player(i,'health')>0 and i~=id then
local x=player(i,'x')-player(id,'x')+320-16
local y=player(i,'y')-player(id,'y')+240+16
if player(i,'health')>=60 then
parse('hudtxt2 '..id..' '..i..' "'..color[7]..''..player(i,"name")..'" '..x..' '..y)
elseif player(i,'health')>=30 and player(i,'health')<60 then
parse('hudtxt2 '..id..' '..i..' "'..color[6]..''..player(i,"name")..'" '..x..' '..y)
elseif player(i,'health')<30 then
parse('hudtxt2 '..id..' '..i..' "'..color[3]..''..player(i,"name")..'" '..x..' '..y)
end
else
parse('hudtxt2 '..id..' '..i..' "" 0 0')		
end
end
else
for i=1,4 do
parse('hudtxt2 '..id..' '..i..' "" 0 0')
end
end
end]]
-------------------------------------------------
parse('hudtxt 20 "'..color[7]..'Health" 290 15 -1')
for id=1,4 do
parse('hudtxt2 '..id..' 21 "'..color[7]..''..oh[id]..'" 330 15')
end
end

--HOOK MS100
addhook('ms100','Tstorm_ms100')
function Tstorm_ms100()
-------------------------------------------------
--銀幕顯示
for id=1,4 do
if player(id,'exists') then
parse('hudtxt2 '..id..' 5 "'..color[1]..'Level : '..player_lv[id]..'" 10 13 -1')
parse('hudtxt2 '..id..' 6 "'..color[1]..'EXP / NEXT : '..player_exp[id]..' / '..player_exp_to_next[id]..'" 10 28 -1')
parse('hudtxt2 '..id..' 7 "'..color[1]..'Upgrade Points : '..player_pts[id]..'" 10 43 -1')
--醫療包
if sa1[id]==1 and sa2[id]==1 then
parse('hudtxt2 '..id..' 8 "'..color[1]..'Medkits : '..medkits[id]..' (F2/F3)" 10 88 -1')
elseif sa1[id]==1 then
parse('hudtxt2 '..id..' 8 "'..color[1]..'Medkits : '..medkits[id]..' (F2)" 10 88 -1')
elseif sa2[id]==1 then
parse('hudtxt2 '..id..' 8 "'..color[1]..'Medkits : '..medkits[id]..' (F3)" 10 88 -1')
else
parse('hudtxt2 '..id..' 8 "'..color[1]..'Medkits : '..medkits[id]..'" 10 88 -1')
end
--藥丸
if sa1[id]==2 and sa2[id]==2 then
parse('hudtxt2 '..id..' 9 "'..color[1]..'Pills : '..pills[id]..' (F2/F3)" 10 103 -1')
elseif sa1[id]==2 then
parse('hudtxt2 '..id..' 9 "'..color[1]..'Pills : '..pills[id]..' (F2)" 10 103 -1')
elseif sa2[id]==2 then
parse('hudtxt2 '..id..' 9 "'..color[1]..'Pills : '..pills[id]..' (F3)" 10 103 -1')
else
parse('hudtxt2 '..id..' 9 "'..color[1]..'Pills : '..pills[id]..'" 10 103 -1')
end
--腎上腺素
if sa1[id]==3 and sa2[id]==3 then
parse('hudtxt2 '..id..' 10 "'..color[1]..'Adrenaline Shots : '..adrenalineshot[id]..' (F2/F3)" 10 118 -1')
elseif sa1[id]==3 then
parse('hudtxt2 '..id..' 10 "'..color[1]..'Adrenaline Shots : '..adrenalineshot[id]..' (F2)" 10 118 -1')
elseif sa2[id]==3 then
parse('hudtxt2 '..id..' 10 "'..color[1]..'Adrenaline Shots : '..adrenalineshot[id]..' (F3)" 10 118 -1')
else
parse('hudtxt2 '..id..' 10 "'..color[1]..'Adrenaline Shots : '..adrenalineshot[id]..'" 10 118 -1')
end
--大醫療包
if lmedkit_unlock[id]==1 then
if sa1[id]==4 and sa2[id]==4 then
parse('hudtxt2 '..id..' 17 "'..color[1]..'Large Medkits : '..lmedkits[id]..' (F2/F3)" 10 133 -1')
elseif sa1[id]==4 then
parse('hudtxt2 '..id..' 17 "'..color[1]..'Large Medkits : '..lmedkits[id]..' (F2)" 10 133 -1')
elseif sa2[id]==4 then
parse('hudtxt2 '..id..' 17 "'..color[1]..'Large Medkits : '..lmedkits[id]..' (F3)" 10 133 -1')
else
parse('hudtxt2 '..id..' 17 "'..color[1]..'Large Medkits : '..lmedkits[id]..'" 10 133 -1')
end
else
parse('hudtxt2 '..id..' 17 "" 10 133 -1')
end
--注射器
if syringe_unlock[id]==1 then
if sa1[id]==5 and sa2[id]==5 then
parse('hudtxt2 '..id..' 18 "'..color[1]..'Syringe : '..syringe[id]..' (F2/F3)" 10 148 -1')
elseif sa1[id]==5 then
parse('hudtxt2 '..id..' 18 "'..color[1]..'Syringe : '..syringe[id]..' (F2)" 10 148 -1')
elseif sa2[id]==5 then
parse('hudtxt2 '..id..' 18 "'..color[1]..'Syringe : '..syringe[id]..' (F3)" 10 148 -1')
else
parse('hudtxt2 '..id..' 18 "'..color[1]..'Syringe : '..syringe[id]..'" 10 148 -1')
end
else
parse('hudtxt2 '..id..' 18 "" 10 148 -1')
end
--嗎啡
if morphia_unlock[id]==1 then
if sa1[id]==6 and sa2[id]==6 then
parse('hudtxt2 '..id..' 19 "'..color[1]..'Morphia : '..morphia[id]..' (F2/F3)" 10 163 -1')
elseif sa1[id]==6 then
parse('hudtxt2 '..id..' 19 "'..color[1]..'Morphia : '..morphia[id]..' (F2)" 10 163 -1')
elseif sa2[id]==6 then
parse('hudtxt2 '..id..' 19 "'..color[1]..'Morphia : '..morphia[id]..' (F3)" 10 163 -1')
else
parse('hudtxt2 '..id..' 19 "'..color[1]..'Morphia : '..morphia[id]..'" 10 163 -1')
end
else
parse('hudtxt2 '..id..' 19 "" 10 163 -1')
end
end
end
-------------------------------------------------
--圖
for id=1,4 do
if player(id,'exists') and player_get_gas[id]==1 then
imagealpha(gimg[id],1)
else
imagealpha(gimg[id],0)
end
end
-------------------------------------------------
--電鋸電量
for id=1,4 do
if player(id,'exists') then
if player(id,'weapontype')==85 then
if chainsaw_pow[id]>=50 then
parse('hudtxt2 '..id..' 16 "'..color[7]..'POW : '..chainsaw_pow[id]..' %" 320 400 1')
elseif chainsaw_pow[id]<50 and chainsaw_pow[id]>0 then
parse('hudtxt2 '..id..' 16 "'..color[3]..'POW : '..chainsaw_pow[id]..' %" 320 400 1')
end
else
parse('hudtxt2 '..id..' 16 "" 320 400 1')
end
end
end
-------------------------------------------------
end

--HOOK SECOND
addhook('second','Tstorm_second')
function Tstorm_second()
-------------------------------------------------
--地圖設定
if sv_maxplayers~=4 then
parse('sv_maxplayers 4')
end
if sv_friendlyfire~=1 then
parse('sv_friendlyfire 1')
end
if sv_specmode~=0 then
parse('sv_specmode 0')
end
if sv_fow~=1 then
parse('sv_fow 3')
end
-------------------------------------------------
--bug
for id=1,4 do
if player(id,'exists') then
if lmedkit_unlock[id]==1 then
items_unlock[id][1]='Large Medkits'
end
if syringe_unlock[id]==1 then
items_unlock[id][2]='Syringe'
end
if morphia_unlock[id]==1 then
items_unlock[id][3]='Morphia'
end
end
end
-------------------------------------------------
end

--HOOK MINUTE
addhook('minute','Tstorm_minute')
function Tstorm_minute()
-------------------------------------------------
msg('Press [F4] to open main menu')
-------------------------------------------------
end

--HOOK SAY
addhook('say','Tstorm_say')
function Tstorm_say(id,txt)
-------------------------------------------------
if txt=='kills' then
msg2(id,''..color[10]..'================')
msg2(id,''..color[10]..'TOTAL KILLS : '..total_kills[id]..'')
msg2(id,''..color[10]..'================')
return 1
end
-------------------------------------------------
for i=1,#p do
if txt=='p'..p[i]..'' then
if player(p[i],'exists') then
msg2(id,''..player(p[i],'name')..' : '..player(p[i],'health')..' %')
else
msg2(id,'No Players')
end
return 1
end
end
-------------------------------------------------
end

--HOOK SAYTEAM
addhook('sayteam','Tstorm_sayteam')
function Tstorm_sayteam(id,txt)
-------------------------------------------------
if txt=='kills' then
msg2(id,''..color[10]..'================')
msg2(id,''..color[10]..'TOTAL KILLS : '..total_kills[id]..'')
msg2(id,''..color[10]..'================')
return 1
end
-------------------------------------------------
for i=1,#p do
if txt=='p'..p[i]..'' then
if player(p[i],'exists') then
msg2(id,''..player(p[i],'name')..' : '..player(p[i],'health')..' %')
else
msg2(id,'No Players')
end
return 1
end
end
-------------------------------------------------
end

--HOOK SERVERACTION
addhook('serveraction','Tstorm_serveraction')
function Tstorm_serveraction(id,action)
-------------------------------------------------
--醫療包
function use_medkit()
local h = player(id,'health')
if medkits[id]>0 then
if h<max_health[id] and h>0 then
if i_lock[id]~=1 then
i_lock[id]=1
medkits[id]=medkits[id]-1
parse('speedmod '..id..' -100')
parse('sv_sound2 '..id..' T-Storm/lua/item/bandaging_1.wav')
timer(5000,'medkit_end')
function medkit_end()
local heal=math.random(40,60)
parse("sethealth "..id.." "..player(id,"health")+heal)
parse('speedmod '..id..' 0')
msg(''..color[10]..''..player(id,'name')..' use medkit')
i_lock[id]=0
end
else
msg2(id,''..color[10]..'Cant use now')	
end
else
msg2(id,''..color[10]..'Your HP is full')
end
else
msg2(id,''..color[10]..'No medkit')	
end
end
-------------------------------------------------
--藥丸
function use_pills()
local h = player(id,'health')
if pills[id]>0 then
if h<max_health[id] and h>0 then
if i_lock[id]~=1 then
i_lock[id]=1
pills[id]=pills[id]-1
parse('speedmod '..id..' -10')
parse('sv_sound2 '..id..' T-Storm/lua/item/pills_use_1.wav')
timer(2000,'pills_end')
function pills_end()
parse("sethealth "..id.." "..player(id,"health")+20)
parse('speedmod '..id..' 0')
msg(''..color[10]..''..player(id,'name')..' use pills')
i_lock[id]=0
end
else
msg2(id,''..color[10]..'Cant use now')
end
else
msg2(id,''..color[10]..'Your HP is full')
end
else
msg2(id,''..color[10]..'No pills')
end
end
-------------------------------------------------
--腎上腺素
function use_adrenalineshot()
local h = player(id,'health')
if adrenalineshot[id]>0 then
if i_lock[id]~=1 then
adrenalineshot[id]=adrenalineshot[id]-1
parse('speedmod '..id..' +10')
msg(''..color[10]..''..player(id,'name')..' use adrenaline shots')
msg2(id,''..color[10]..'Speedboost for 10 seconds')
timer(10000,'parse',('speedmod '..id..' 0'))
timer(10000,'parse','sv_msg2 '..id..' '..color[10]..'Speedboost cancel')
else
msg2(id,''..color[10]..'Cant use now')
end
else
msg2(id,''..color[10]..'No adrenaline shots')
end
end
-------------------------------------------------
--大醫療包
function use_lmedkit()
local h = player(id,'health')
if lmedkits[id]>0 then
if h<max_health[id] and h>0 then
if i_lock[id]~=1 then
i_lock[id]=1
lmedkits[id]=lmedkits[id]-1
parse('speedmod '..id..' -100')
parse('sv_sound2 '..id..' T-Storm/lua/item/bandaging_1.wav')
timer(5000,'lmedkit_end')
function lmedkit_end()
local heal=math.random(60,100)
parse("sethealth "..id.." "..player(id,"health")+heal)
parse('speedmod '..id..' 0')
msg(''..color[10]..''..player(id,'name')..' use large medkit')
i_lock[id]=0
end
else
msg2(id,''..color[10]..'Cant use now')	
end
else
msg2(id,''..color[10]..'Your HP is full')
end
else
msg2(id,''..color[10]..'No large medkit')	
end
end
-------------------------------------------------
--注射器
function use_syringe()
local h = player(id,'health')
if syringe[id]>0 then
if h<max_health[id] and h>0 then
if i_lock[id]~=1 then
syringe[id]=syringe[id]-1
local heal=math.random(5,15)
parse("sethealth "..id.." "..player(id,"health")+heal)
msg(''..color[10]..''..player(id,'name')..' use syringe')
else
msg2(id,''..color[10]..'Cant use now')
end
else
msg2(id,''..color[10]..'Your HP is full')
end
else
msg2(id,''..color[10]..'No syringe')
end
end
-------------------------------------------------
--嗎啡
function use_morphia()
local h = player(id,'health')
if morphia[id]>0 then
if h<=max_health[id]-30 and h>0 then
if i_lock[id]~=1 then
morphia[id]=morphia[id]-1
parse("sethealth "..id.." "..player(id,"health")+30)
msg(''..color[10]..''..player(id,'name')..' use morphia')
msg2(id,''..color[10]..'Hp+30 for 60 seconds')
timer(60000,'parse',("sethealth "..id.." "..player(id,"health")-30))
timer(60000,'parse','sv_msg2 '..id..' '..color[10]..'Hp-30')
else
msg2(id,''..color[10]..'Cant use now')
end
else
msg2(id,''..color[10]..'Cant use now')
end
else
msg2(id,''..color[10]..'No morphia')
end
end
-------------------------------------------------
--按鍵1
if action==1 then
if sa1[id]==1 then
use_medkit()
elseif sa1[id]==2 then
use_pills()
elseif sa1[id]==3 then
use_adrenalineshot()
elseif sa1[id]==4 then
use_lmedkit()
elseif sa1[id]==5 then
use_syringe()
elseif sa1[id]==6 then
use_morphia()
end
end
--按鍵2
if action==2 then
if sa2[id]==1 then
use_medkit()
elseif sa2[id]==2 then
use_pills()
elseif sa2[id]==3 then
use_adrenalineshot()
elseif sa2[id]==4 then
use_lmedkit()
elseif sa2[id]==5 then
use_syringe()
elseif sa2[id]==6 then
use_morphia()
end
end
--按鍵3
if action==3 then
menu(id,'Main Menu,Upgrade Menu,Item Menu,Info,Save & Load')
end
-------------------------------------------------
end

--HOOK MENU
addhook('menu','Tstorm_menu')
function Tstorm_menu(id,title,button)
-------------------------------------------------
--主選單
if title=='Main Menu' then
--升級選單
if button==1 then
menu(id,'Upgrade Menu,Max Health(1pts),More EXP(1pts),Unlock')
--道具選單
elseif button==2 then
menu(id,'Item Menu,Use Items,Quick Settings,Items Info')
--情報選單
elseif button==3 then
menu(id,'Info Menu,Game Rules,Staff,Upgrade Menu,Item Menu,About Upgrades')
--存檔/讀檔
elseif button==4 then
menu(id,'Save / Load,Save,Load,Others')
end
end
-------------------------------------------------
--升級選單2
if title=='Upgrade Menu' then
--總血量
if button==1 then
if player_pts[id]>=1 then
if max_health_times[id]~=50 then
player_pts[id]=player_pts[id]-1
max_health[id]=max_health[id]+2
max_health_times[id]=max_health_times[id]+1
msg2(id,''..color[10]..'Max health upgrade')
else
msg2(id,''..color[10]..'Cant upgrade anymore')
end
else
msg2(id,''..color[10]..'Not enough upgrade points')
end
--更多經驗值
elseif button==2 then
if player_pts[id]>=1 then
if exp_per_kill_times[id]~=50 then
player_pts[id] = player_pts[id]-1
exp_per_kill[id] = exp_per_kill[id]+0.5
exp_per_kill_times[id] = exp_per_kill_times[id]+1
msg2(id,''..color[10]..'More EXP Upgrade')
else
msg2(id,''..color[10]..'Cant upgrade anymore')
end
else
msg2(id,''..color[10]..'Not enough upgrade points')
end
--解鎖
elseif button==3 then
menu(id,'Unlock,Weapons,Items')
end
end
-------------------------------------------------
--解鎖2
if title=='Unlock' then
--解鎖武器
if button==1 then
msg2(id,'Not Yet')
--解鎖道具
elseif button==2 then
menu(id,'Unlock Items,Large Medkit(10pts),Syringe(5pts),Morphia(5pts)')
end
end
-------------------------------------------------
--解鎖道具2
if title=='Unlock Items' then
--大醫療包
if button==1 then
if player_pts[id]>=10 then
if lmedkit_unlock[id]~=1 then
player_pts[id]=player_pts[id]-10
lmedkit_unlock[id]=1
else
msg2(id,''..color[10]..'Unlock Already')
end
else
msg2(id,''..color[10]..'Not enough upgrade points')
end
--注射器
elseif button==2 then
if player_pts[id]>=5 then
if syringe_unlock[id]~=1 then
player_pts[id]=player_pts[id]-5
syringe_unlock[id]=1
else
msg2(id,''..color[10]..'Unlock Already')
end
else
msg2(id,''..color[10]..'Not enough upgrade points')
end
--嗎啡
elseif button==3 then
if player_pts[id]>=5 then
if morphia_unlock[id]~=1 then
player_pts[id]=player_pts[id]-5
morphia_unlock[id]=1
else
msg2(id,''..color[10]..'Unlock Already')
end
else
msg2(id,''..color[10]..'Not enough upgrade points')
end
end
end
-------------------------------------------------
--道具選單2
if title=='Item Menu' then
--使用道具
if button==1 then
menu(id,'Use Items,Medkits,Pills,Adrenaline Shots,'..items_unlock[id][1]..','..items_unlock[id][2]..','..items_unlock[id][3]..'')
--快捷設置
elseif button==2 then
menu(id,'Quick Settings,Serveraction 1,Serveraction 2')
--道具說明
elseif button==3 then
menu(id,'Items Info,Medkits,Pills,Adrenaline Shots,'..items_unlock[id][1]..','..items_unlock[id][2]..','..items_unlock[id][3]..'')
end
end
-------------------------------------------------
--道具選單2-Use Items
if title=='Use Items' then
--使用醫療包
if button==1 then
use_medkit()
--使用藥丸
elseif button==2 then
use_pills()
--使用腎上腺素
elseif button==3 then
use_adrenalineshot()
--使用大醫療包
elseif button==4 then
use_lmedkit()
--使用注射器
elseif button==5 then
use_syringe()
--使用嗎啡
elseif button==6 then
use_morphia()
end
end
-------------------------------------------------
--道具Quick Settings
if title=='Quick Settings' then
--Serveraction 1
if button==1 then
menu(id,'Items for [F2],Medkits,Pills,Adrenaline Shots,'..items_unlock[id][1]..','..items_unlock[id][2]..','..items_unlock[id][3]..'')
--Serveraction 2
elseif button==2 then
menu(id,'Items for [F3],Medkits,Pills,Adrenaline Shots,'..items_unlock[id][1]..','..items_unlock[id][2]..','..items_unlock[id][3]..'')
end
end
-------------------------------------------------
--Quick Settings[F2]
if title=='Items for [F2]' then
--醫療包
if button==1 then
sa1[id]=1
--藥丸
elseif button==2 then
sa1[id]=2
--腎上腺素
elseif button==3 then
sa1[id]=3
--大醫療包
elseif button==4 then
sa1[id]=4
--注射器
elseif button==5 then
sa1[id]=5
--嗎啡
elseif button==6 then
sa1[id]=6
end
end
-------------------------------------------------
--Quick Settings[F3]
if title=='Items for [F3]' then
--醫療包
if button==1 then
sa2[id]=1
--藥丸
elseif button==2 then
sa2[id]=2
--腎上腺素
elseif button==3 then
sa2[id]=3
--大醫療包
elseif button==4 then
sa2[id]=4
--注射器
elseif button==5 then
sa2[id]=5
--嗎啡
elseif button==6 then
sa2[id]=6
end
end
-------------------------------------------------
--道具情報
if title=='Items Info' then
if button==1 then
msg2(id,'Medkits')
msg2(id,'Use times : 5s')
msg2(id,'Heal : 40~60hp')
elseif button==2 then
msg2(id,'Pills')
msg2(id,'Use times : 2s')
msg2(id,'Heal : 20hp')
elseif button==3 then
msg2(id,'adrenaline shots')
msg2(id,'Use times : 0s')
msg2(id,'Speedboost times : 10s')
elseif button==4 then
msg2(id,'Large Medkits')
msg2(id,'Use times : 5s')
msg2(id,'Heal : 60~100hp')
elseif button==5 then
msg2(id,'Syringe')
msg2(id,'Use times : 0s')
msg2(id,'Heal : 5~15hp')
elseif button==6 then
msg2(id,'Morphia')
msg2(id,'Use times : 0s')
msg2(id,'Heal 30hp for 1min')
end
end
-------------------------------------------------
--情報選單2
if title=='Info Menu' then
--規則
if button==1 then
msg2(id,'================')
msg2(id,'Game Rules')
msg2(id,'================')
msg2(id,'Survival till the goal !!')
msg2(id,'If there is 3 or more players playing, if everyone dies = gameover !!')	
--介紹
elseif button==2 then
msg2(id,'Lua created by Dragon Lore')
--關於升級選單
elseif button==3 then
msg2(id,'================')
msg2(id,'Upgrade Menu')
msg2(id,'================')
msg2(id,'You need [Upgrade Points] to upgrade skills')
msg2(id,'To get [Upgrade Points], just gain level !!')				
--關於道具選單
elseif button==4 then
msg2(id,'================')
msg2(id,'Item Menu')
msg2(id,'================')
msg2(id,'You can use this menu to use and set buttons for items !!')
--關於升級
elseif button==5 then
menu(id,'About Upgrades,Max Health,More EXP,Unlock Weapons')
end
end
-------------------------------------------------
--關於升級2
if title=='About Upgrades' then
--總血量說明
if button==1 then
msg2(id,'================')
msg2(id,'Max Health')
msg2(id,'================')
msg2(id,'Every upgrades get 2 more HP, max : 100 more HP')
msg2(id,'Your HP will not change until you respawn !!')
msg2(id,''..color[10]..''..max_health_times[id]..' / 50')			
--經驗值說明
elseif button==2 then
msg2(id,'================')
msg2(id,'More EXP')
msg2(id,'================')
msg2(id,'Every upgrades get 0.5 more EXP when killing a NPC, max : 25 more EXP')
msg2(id,''..color[10]..''..exp_per_kill_times[id]..' / 50')
--解鎖武器說明
elseif button==3 then
msg2(id,'================')
msg2(id,'Unlock Weapons')
msg2(id,'================')
msg2(id,'Unlock weapons you can take on the map')
end
end
-------------------------------------------------
--存檔/讀檔選單
if title=='Save / Load' then
--存
if button==1 then
Tstorm_save(id)
--讀
elseif button==2 then
local n=player(id,"name")
local file=io.open("sys/lua/Tstorm/Save/"..n..".sav", "r")
if not file then
msg2(id,''..color[10]..'Failed to load save data !')
else
as[id]=file:read("\*n")
player_lv[id]=file:read("\*n")
player_exp[id]=file:read("\*n")
player_exp_to_next[id]=file:read("\*n")
player_pts[id]=file:read("\*n")
max_health[id]=file:read("\*n")
max_health_times[id]=file:read("\*n")
exp_per_kill[id]=file:read("\*n")
exp_per_kill_times[id]=file:read("\*n")
total_kills[id]=file:read("\*n")
lmedkits[id]=file:read("\*n")
syringe[id]=file:read("\*n")
morphia[id]=file:read("\*n")
sa1[id]=file:read("\*n")
sa2[id]=file:read("\*n")
chainsaw_pow_id[id]=file:read("\*n")
chainsaw_out[id]=file:read("\*n")
lmedkit_unlock[id]=file:read("\*n")
syringe_unlock[id]=file:read("\*n")
morphia_unlock[id]=file:read("\*n")
msg2(id,''..color[10]..'Game data loaded')
file:close()
end
--升級(其他)
elseif button==3 then
menu(id,'Others,About,Settings')
end
end
-------------------------------------------------
--升級(其他)2
if title=='Others' then
--關於
if button==1 then
msg2(id,'================')
msg2(id,'About')
msg2(id,'================')
msg2(id,'Save and load your stats (level,exp,points,upgrades......)')
--自動存檔
elseif button==2 then
menu(id,'Auto Save,On,Off')
end
end
-------------------------------------------------
--自動存檔開關2
if title=='Auto Save' then
--開
if button==1 then
if as[id]==0 then
msg2(id,''..color[10]..'Auto save on')
as[id]=1
else
msg2(id,''..color[10]..'Auto save is on')
end
--關
elseif button==2 then
if as[id]==1 then
msg2(id,''..color[10]..'Auto save off')
as[id]=0
else
msg2(id,''..color[10]..'Auto save is off')
end
end
end
-------------------------------------------------
--調難度選單
if title=='Difficulty Menu' then
--普通
if button==1 then
difficulty='Normal'
msg(''..color[10]..'Game difficulty set to normal')
--困難	
elseif button==2 then
difficulty='Hard'
hard_trigger()
msg(''..color[10]..'Game difficulty set to hard')
end	
end
-------------------------------------------------
end

--HOOK JOIN
addhook('join','Tstorm_join')
function Tstorm_join(id)
-------------------------------------------------
--系統
player_lv[id]=1
player_exp[id]=0
player_exp_to_next[id]=50
player_pts[id]=0
max_health[id] = 100
max_health_times[id]=0
exp_per_kill[id]=5
exp_per_kill_times[id]=0
--道具
medkits[id]=0
pills[id]=0
adrenalineshot[id]=0
sa1[id]=1
sa2[id]=2
items_unlock[id]={'','','',''}
lmedkit_unlock[id]=0
syringe_unlock[id]=0
morphia_unlock[id]=0
--紀錄
total_kills[id]=0
--其他
player_in[id]=0
as[id]=0
chainsaw_pow[id]=0
chainsaw_pow_id[id]=100
chainsaw_out[id]=2
i_lock[id]=0
using[id]=0
--開圖
p_xy[id]=1
gimg[id]=image('gfx/T-Storm/lua/gas_hat.png',1,1,id+200)
-------------------------------------------------
--人數更新
player_on_server=player_on_server+1
if player_on_server<3 then
respawn_delay=0
else
respawn_delay=5
end
-------------------------------------------------
--自動讀檔
local n=player(id,"name")
local file=io.open("sys/lua/Tstorm/Save/"..n..".sav", "r")
if not file then
msg2(id,''..color[10]..'Failed to load save data !')
else
as[id]=file:read("\*n")
player_lv[id]=file:read("\*n")
player_exp[id]=file:read("\*n")
player_exp_to_next[id]=file:read("\*n")
player_pts[id]=file:read("\*n")
max_health[id]=file:read("\*n")
max_health_times[id]=file:read("\*n")
exp_per_kill[id]=file:read("\*n")
exp_per_kill_times[id]=file:read("\*n")
total_kills[id]=file:read("\*n")
lmedkits[id]=file:read("\*n")
syringe[id]=file:read("\*n")
morphia[id]=file:read("\*n")
sa1[id]=file:read("\*n")
sa2[id]=file:read("\*n")
chainsaw_pow_id[id]=file:read("\*n")
chainsaw_out[id]=file:read("\*n")
lmedkit_unlock[id]=file:read("\*n")
syringe_unlock[id]=file:read("\*n")
morphia_unlock[id]=file:read("\*n")
msg2(id,''..color[10]..'Game data auto loaded')
file:close()
end
-------------------------------------------------
end

--HOOK LEAVE
addhook('leave','Tstorm_leave')
function Tstorm_leave(id,reason)
-------------------------------------------------
--人數更新
player_on_server=player_on_server-1
if player_on_server<3 then
respawn_delay=0
else
respawn_delay=5
end
-------------------------------------------------
--存活玩家數更新
if player(id,"health")~=0 then
player_alive=player_alive-1
end
-------------------------------------------------
--遊戲結束
gameover()
-------------------------------------------------
--關圖
freeimage(gimg[id])
--噴桶
if player_get_gas[id]==1 and using[id]~=1 then
player_get_gas[id]=0
local xy=(''..player(id,'tilex')..''..player(id,'tiley')..'')
local img=image('gfx/T-Storm/item/gascan.png',player(id,'x'),player(id,'y'),0)
if g1==0 then
g1=xy
gi1=img
else
if g2==0 then
g2=xy
gi2=img
else
if g3==0 then
g3=xy
gi3=img
else
if g4==0 then
g4=xy
gi4=img
else
if g5==0 then
g5=xy
gi5=img
else
if g6==0 then
g6=xy
gi6=img
else
if g7==0 then
g7=xy
gi7=img
else
if g8==0 then
g8=xy
gi8=img
else
if g9==0 then
g9=xy
gi9=img
else
if g10==0 then
g10=xy
gi10=img
else
if g11==0 then
g11=xy
gi11=img
else
if g12==0 then
g12=xy
gi12=img
else
if g13==0 then
g13=xy
gi13=img
else
if g14==0 then
g14=xy
gi14=img
else
if g15==0 then
g15=xy
gi15=img
else
if g16==0 then
g16=xy
gi16=img
else
if g17==0 then
g17=xy
gi17=img
else
if g18==0 then
g18=xy
gi18=img
else
if g19==0 then
g19=xy
gi19=img
else
if g20==0 then
g20=xy
gi20=img
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
-------------------------------------------------
end

--HOOK SPAWN
addhook('spawn','Tstorm_spawn')
function Tstorm_spawn(id)
-------------------------------------------------
--數值重置
parse('setmaxhealth '..id..' '..max_health[id]..'')
parse('speedmod '..id..' 0')
-------------------------------------------------
--存活玩家數更新
player_alive=player_alive+1
-------------------------------------------------
--難度選單
if menu_op==1 then
menu(id,'Difficulty Menu,Normal,Hard')
menu_op=0
end
-------------------------------------------------
--電鋸滿電
chainsaw_pow[id]=chainsaw_pow_id[id]
-------------------------------------------------
end

--HOOK DIE
addhook('die','Tstorm_die')
function Tstorm_die(id)
-------------------------------------------------
--存活玩家數更新
player_alive=player_alive-1
-------------------------------------------------
--效果&指令
parse('mp_respawndelay '..respawn_delay..'')
parse('sv_sound2 '..id..' T-Storm/lua/die/theend.wav')
-------------------------------------------------
--遊戲結束
gameover()
-------------------------------------------------
--自動存檔
if as[id]==1 then
Tstorm_save(id)
end
-------------------------------------------------
end

--HOOK OBJECTKILL
addhook('objectkill','Tstorm_objectkill')
function Tstorm_objectkill(obj,id)
-------------------------------------------------
--經驗值&分數
if (object(obj,'typename')=='NPC') then
parse('setscore '..id..' '..player(id,'score')+1)
total_kills[id]=total_kills[id] + 1
player_exp[id]=player_exp[id]+exp_per_kill[id]+special_bonus
--升級
if player_exp[id]>=player_exp_to_next[id] then
local lvexp=(player_lv[id]+1)*100
local lvrm=math.random(200,400)
player_exp_to_next[id]=player_exp_to_next[id]+lvrm+lvexp
player_lv[id]=player_lv[id]+1
msg2(id,''..color[10]..'================')
msg2(id,''..color[10]..'Level Up !!')
msg2(id,''..color[10]..'================')
player_pts[id]=player_pts[id]+1
end
end
-------------------------------------------------
end

--HOOK USEBUTTON
addhook('usebutton','Tstorm_usebutton')
function Tstorm_usebutton(id,x,y)
local etn=entity(x,y,"typename")
local en=entity(x,y,"name")
-------------------------------------------------
--道具取得
if etn=="Trigger_Use" then
--醫療包
for i=1,#medkits_number do
if en=="get_medkits."..medkits_number[i].."" then
parse('sv_sound2 '..id..' T-Storm/lua/item/itempickup.wav')
medkits[id]=medkits[id]+1
parse('trigger get_medkits.'..medkits_number[i]..'')
end
end
--藥丸
for i=1,#pills_number do
if en=="get_pills."..pills_number[i].."" then
parse('sv_sound2 '..id..' T-Storm/lua/item/pills_deploy_1.wav')
pills[id]=pills[id]+1
parse('trigger get_pills.'..pills_number[i]..'')
end
end
--腎上腺素
for i=1,#adrenalineshot_number do
if en=="get_drug1."..adrenalineshot_number[i].."" then
parse('sv_sound2 '..id..' T-Storm/lua/item/itempickup.wav')
adrenalineshot[id]=adrenalineshot[id]+1
parse('trigger get_drug1.'..adrenalineshot_number[i]..'')
end
end
end
-------------------------------------------------
--倒油
if etn=="Trigger_Use" and en=="gc_done" then
if gascan_start==1 and gas_using==1 and player_get_gas[id]==1 and i_lock[id]~=1 then
using[id]=1
i_lock[id]=1
gas_using=0
parse('speedmod '..id..' -100')
parse('sv_sound2 '..id..' T-Storm/lua/item/gas_can_fill_pour_01.wav')
timer(4000,'Tstorm_gcd')
else
msg2(id,'Cant use now')
end
end
function Tstorm_gcd()
gas_using=1
player_get_gas[id]=0
gascan_done=gascan_done+1
parse('speedmod '..id..' 0')
i_lock[id]=0
using[id]=0
if gascan_done==gascan_needed then
parse('trigger tsg_finish.'..tsg_number..'')
gascan_start=0
tsg_number=tsg_number+1
parse('trigger g_gi_reset')
msg(''..gce_say[math.random(#gce_say)]..'')
end
end
-------------------------------------------------
--油桶取得
for i=1,#gascan_take_number do
for q=1,#gct_number do
if etn=="Trigger_Use" and en==('gct.'..gascan_take_number[i]..'.'..gct_number[q]..'') then
if gascan_start==1 and player_get_gas[id]~=1 then
player_get_gas[id]=1
parse('trigger gct.'..gascan_take_number[i]..'.'..gct_number[q]..'')
parse("sv_sound2 "..id.." "..Get_Gascan[math.random(#Get_Gascan)].."")
end
end
end
end
-------------------------------------------------
end

--HOOK MOVETILE
addhook('movetile','Tstorm_movetile')
function Tstorm_movetile(id,x,y)
local en=entity(x,y,"name")
local etn=entity(x,y,"typename")
-------------------------------------------------
--統計進入玩家數(事件)
if etn=='Trigger_Move' and en=='+pi' then
if player_in[id]==0 then
player_in[id]=1
player_count=player_count+1
if player_count==player_alive then
parse('trigger +pi_ok.'..tsp_number..'') 
tsp_number=tsp_number+1
player_count=0
for id=1,4 do
player_in[id]=0
end
end
elseif player_in[id]==1 then
player_in[id]=0
player_count=player_count-1
end
end
-------------------------------------------------
--油桶開始
if etn=="Trigger_Move" then
--1
if en==('tsg_start.1.'..tsg_repeat..'') then
gascan_needed=1
tsgs()
--2
elseif en==('tsg_start.2.'..tsg_repeat..'') then
parse('trigger tsg_start.2.'..tsg_repeat..'')
gascan_needed=2
tsgs()
--3
elseif en==('tsg_start.3.'..tsg_repeat..'') then
gascan_needed=3
tsgs()
--4
elseif en==('tsg_start.4.'..tsg_repeat..'') then
gascan_needed=4
tsgs()
--5
elseif en==('tsg_start.5.'..tsg_repeat..'') then
gascan_needed=5
tsgs()
--6
elseif en==('tsg_start.6.'..tsg_repeat..'') then
gascan_needed=6
tsgs()
--7
elseif en==('tsg_start.7.'..tsg_repeat..'') then
gascan_needed=7
tsgs()
--8
elseif en==('tsg_start.8.'..tsg_repeat..'') then
gascan_needed=8
tsgs()
--9
elseif en==('tsg_start.9.'..tsg_repeat..'') then
gascan_needed=9
tsgs()
--10
elseif en==('tsg_start.10.'..tsg_repeat..'') then
gascan_needed=10
tsgs()
--11
elseif en==('tsg_start.11.'..tsg_repeat..'') then
gascan_needed=11
tsgs()
--12
elseif en==('tsg_start.12.'..tsg_repeat..'') then
gascan_needed=12
tsgs()
end
end
-------------------------------------------------
end

--HOOK TRIGGER
addhook('trigger','Tstorm_trigger')
function Tstorm_trigger(trigger,source)
-------------------------------------------------
--屍潮音效
--開
if trigger=='misc_s' then
sound_file=''..misc[math.random(#misc)]..''
playing_sound=1
parse("sv_sound "..sound_file.."")
timer(5500,'play','',0)
elseif trigger=='misc_e' then
--關
playing_sound=0
end
-------------------------------------------------
end

--HOOK RELOAD
addhook('reload','Tstorm_reload')
function Tstorm_reload(id,mode)
-------------------------------------------------
--換彈音效
if mode==1 then
parse('sv_sound2 '..id..' '..reloading[math.random(#reloading)]..'')
msg(''..player(id,'name')..': Reloding')
end
-------------------------------------------------
end

--HOOK ATTACK
addhook('attack','Tstorm_attack')
function Tstorm_attack(id)
-------------------------------------------------
if player(id,'weapontype')==85 then
local out=chainsaw_out[id]
chainsaw_pow[id]=chainsaw_pow[id]-out
if chainsaw_pow[id]<=0 then
parse('strip '..id..' 85')
msg2(id,'Your chainsaw had no more power')
chainsaw_pow[id]=chainsaw_pow_id[id]
end
end
-------------------------------------------------
end

addhook('leave','Tstorm_save')
function Tstorm_save(id)
-------------------------------------------------
local n=player(id,"name")
local file=io.open ("sys/lua/Tstorm/Save/"..n..".sav", "w")
file:write(as[id].."\n")
file:write(player_lv[id].."\n")
file:write(player_exp[id].."\n")
file:write(player_exp_to_next[id].."\n")
file:write(player_pts[id].."\n")
file:write(max_health[id].."\n")
file:write(max_health_times[id].."\n")
file:write(exp_per_kill[id].."\n")
file:write(exp_per_kill_times[id].."\n")
file:write(total_kills[id].."\n")
file:write(lmedkits[id].."\n")
file:write(syringe[id].."\n")
file:write(morphia[id].."\n")
file:write(sa1[id].."\n")
file:write(sa2[id].."\n")
file:write(chainsaw_pow_id[id].."\n")
file:write(chainsaw_out[id].."\n")
file:write(lmedkit_unlock[id].."\n")
file:write(syringe_unlock[id].."\n")
file:write(morphia_unlock[id].."\n")
msg2(id,''..color[10]..'Game data saved')
file:close()
-------------------------------------------------
end

-------------------------------------------------
--油桶禁區
-------------------------------------------------

--HOOK ATTACK
addhook('attack','Tstorm_attack_2')
function Tstorm_attack_2(id)
-------------------------------------------------
--丟油桶確認
if player_get_gas[id]==1 and using[id]~=1 then
player_get_gas[id]=0
local xy=(''..player(id,'tilex')..''..player(id,'tiley')..'')
local img=image('gfx/T-Storm/item/gascan.png',player(id,'x'),player(id,'y'),0)
if g1==0 then
g1=xy
gi1=img
else
if g2==0 then
g2=xy
gi2=img
else
if g3==0 then
g3=xy
gi3=img
else
if g4==0 then
g4=xy
gi4=img
else
if g5==0 then
g5=xy
gi5=img
else
if g6==0 then
g6=xy
gi6=img
else
if g7==0 then
g7=xy
gi7=img
else
if g8==0 then
g8=xy
gi8=img
else
if g9==0 then
g9=xy
gi9=img
else
if g10==0 then
g10=xy
gi10=img
else
if g11==0 then
g11=xy
gi11=img
else
if g12==0 then
g12=xy
gi12=img
else
if g13==0 then
g13=xy
gi13=img
else
if g14==0 then
g14=xy
gi14=img
else
if g15==0 then
g15=xy
gi15=img
else
if g16==0 then
g16=xy
gi16=img
else
if g17==0 then
g17=xy
gi17=img
else
if g18==0 then
g18=xy
gi18=img
else
if g19==0 then
g19=xy
gi19=img
else
if g20==0 then
g20=xy
gi20=img
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
-------------------------------------------------
end

--HOOK ATTACK2
addhook('attack2','Tstorm_attack2_2')
function Tstorm_attack2_2(id)
-------------------------------------------------
Tstorm_attack_2(id)
-------------------------------------------------
end

addhook('movetile','Tstorm_movetile2')
function Tstorm_movetile2(id,x,y)
-------------------------------------------------
--撿油桶確認
local xy=(''..player(id,'tilex')..''..player(id,'tiley')..'')
p_xy[id]=xy
if player_get_gas[id]~=1 then
if p_xy[id]==g1 then
player_get_gas[id]=1
freeimage(gi1)
g1=0
elseif p_xy[id]==g2 then
player_get_gas[id]=1
freeimage(gi2)
g2=0
elseif p_xy[id]==g3 then
player_get_gas[id]=1
freeimage(gi3)
g3=0
elseif p_xy[id]==g4 then
player_get_gas[id]=1
freeimage(gi4)
g4=0
elseif p_xy[id]==g5 then
player_get_gas[id]=1
freeimage(gi5)
g5=0
elseif p_xy[id]==g6 then
player_get_gas[id]=1
freeimage(gi6)
g6=0
elseif p_xy[id]==g7 then
player_get_gas[id]=1
freeimage(gi7)
g7=0
elseif p_xy[id]==g8 then
player_get_gas[id]=1
freeimage(gi8)
g8=0
elseif p_xy[id]==g9 then
player_get_gas[id]=1
freeimage(gi9)
g9=0
elseif p_xy[id]==g10 then
player_get_gas[id]=1
freeimage(gi10)
g10=0
elseif p_xy[id]==g11 then
player_get_gas[id]=1
freeimage(gi11)
g11=0
elseif p_xy[id]==g12 then
player_get_gas[id]=1
freeimage(gi12)
g12=0
elseif p_xy[id]==g13 then
player_get_gas[id]=1
freeimage(gi13)
g13=0
elseif p_xy[id]==g14 then
player_get_gas[id]=1
freeimage(gi14)
g14=0
elseif p_xy[id]==g15 then
player_get_gas[id]=1
freeimage(gi15)
g15=0
elseif p_xy[id]==g16 then
player_get_gas[id]=1
freeimage(gi16)
g16=0
elseif p_xy[id]==g17 then
player_get_gas[id]=1
freeimage(gi17)
g17=0
elseif p_xy[id]==g18 then
player_get_gas[id]=1
freeimage(gi18)
g18=0
elseif p_xy[id]==g19 then
player_get_gas[id]=1
freeimage(gi19)
g19=0
elseif p_xy[id]==g20 then
player_get_gas[id]=1
freeimage(gi20)
g20=0
end
end
-------------------------------------------------
end

addhook('trigger','Tstorm_trigger2')
function Tstorm_trigger2(trigger,source)
-------------------------------------------------
--避免油桶到處噴
if trigger=='g_gi_reset' then
g1=0
freeimage(gi1)
g2=0
freeimage(gi2)
g3=0
freeimage(gi3)
g4=0
freeimage(gi4)
g5=0
freeimage(gi5)
g6=0
freeimage(gi6)
g7=0
freeimage(gi7)
g8=0
freeimage(gi8)
g9=0
freeimage(gi9)
g10=0
freeimage(gi10)
g11=0
freeimage(gi11)
g12=0
freeimage(gi12)
g13=0
freeimage(gi13)
g14=0
freeimage(gi14)
g15=0
freeimage(gi15)
g16=0
freeimage(gi16)
g17=0
freeimage(gi17)
g18=0
freeimage(gi18)
g19=0
freeimage(gi19)
g20=0
freeimage(gi20)
end
-------------------------------------------------
end
