---------------------------------------------------------------------
--##Do not say that this is yours------------------------------------
--##2015/11/2, Dragon Lore, TW---------------------------------------
---------------------------------------------------------------------

addhook('spawn','zb_spawn')
addhook('ms100','zb_ms100')
addhook('second','zb_second')
addhook('join','zb_join')
addhook('startround','zb_start')
addhook('kill','zb_kill_ct')
addhook('kill','zb_kill_t')
addhook('serveraction','zb_action')
addhook('movetile','zb_mt')
addhook('movetile','zb_mt1')
addhook('movetile','zb_mt2')
addhook('movetile','zb_mt3')
addhook('menu','zb_menu')
addhook('hit','zb_hit')
addhook('say','zb_say')
addhook('sayteam','zb_say_team')
addhook('ms100','hero_ms100')
addhook('die','zb_die')

dropammo=1--drop ammo on zombie kill?
tohuman=0--turn zombie to human?
bot_random_zb=1--bot random zombie type?
--HP
normal_zombie_hp=300
shooter_zombie_hp=200
trap_zombie_hp=250
smoke_zombie_hp=250
ninja_zombie_hp=250
boom_zombie_hp=300
guard_zombie_hp=300

--SP
normal_zombie_sp=1
shooter_zombie_sp=0
trap_zombie_sp=0
smoke_zombie_sp=1
ninja_zombie_sp=2
boom_zombie_sp=0
guard_zombie_sp=0

hme={
'factory/hme1.OGG',
'factory/hme2.OGG',
'factory/hme3.OGG'
}

function z(m)
local array={}
for i=1,m do
array[i]=0
end
return array
end

--Zombie Info
zstyle=z(32)
zstyle2=z(32)
zhp=z(32)
zhp2=z(32)
zsp=z(32)
zsp2=z(32)

--Got Effect
px=z(32)
py=z(32)

--Skill Info(Human)
speed_boost=z(32)
hero_atk=z(32)
hero_atk_up=10--hero extra atk
human_atk=0
human_atk_max=10--max human atk raise range
h_h_num=10--max heal hp on zombie kill
head_shot=z(32)
hs_mode=z(32)
hs_atk=10--headshot mode extra atk
knife_combat=z(32)
kc_mode=z(32)
kc_x=2--knife combat mode atk*?

--Skill Info(Zombie Heal)
zb_heal=z(32)
zmaxhp=z(32)
heal_time=5--wait time till heal
heal_value=5--heal value

--Skill Info(Trap Zombie)
trap_1=0
trap_2=0
trap_3=0
p_spot=z(32)
set_trap_delay=z(32)
trap_delay=10--cooling time

--Skill Info(Normal Zombie)
speed_boost_zb=z(32)
speed_boost_zb_cooling_time=45--cooling time

--Skill Info(Guard Zombie)
knockavoid=z(32)
guard_zb=z(32)
guard_zb_cooling_time=50--cooling time

--Skill Info(Smoke Zombie)
smoke_cool=z(32)
smoke_cooling_time=30--cooling time

--Skill Info(Shooter Zombie)
shooter_reload=z(32)
shooter_reload_time=2--reload time

--Skill Info(Ninja Zombie)
hide_cool=z(32)
hide_cooling_time=50--cooling time
hide_img=z(32)
hide_obj={
'zb_hide1.bmp',
'zb_hide2.bmp',
'zb_hide3.bmp',
'zb_hide4.bmp',
'zb_hide5.bmp',
'zb_hide6.bmp',
'zb_hide7.bmp'
}

function zb_join(i)
if not player(i,'bot') then
zstyle[i]=1
zstyle2[i]=1
zhp[i]=normal_zombie_hp
zhp2[i]=normal_zombie_hp
zsp[i]=normal_zombie_sp
zsp2[i]=normal_zombie_sp
elseif player(i,'bot') then
if bot_random_zb==1 then
local brz=math.random(1,5)
if brz>=1 and brz<=4 then
zstyle[i]=2
zstyle2[i]=2
zhp[i]=shooter_zombie_hp
zhp2[i]=shooter_zombie_hp
zsp[i]=shooter_zombie_sp
zsp2[i]=shooter_zombie_sp
elseif brz==5 then
zstyle[i]=6
zstyle2[i]=6
zhp[i]=boom_zombie_hp
zhp2[i]=boom_zombie_hp
zsp[i]=boom_zombie_sp
zsp2[i]=boom_zombie_sp
end
else
zstyle[i]=2
zstyle2[i]=2
zhp[i]=shooter_zombie_hp
zhp2[i]=shooter_zombie_hp
zsp[i]=shooter_zombie_sp
zsp2[i]=shooter_zombie_sp
end
end
end

function zb_spawn(i)
if player(i,'team')==1 then
zstyle[i]=zstyle2[i]
zhp[i]=zhp2[i]
zsp[i]=zsp2[i]
parse('sethealth '..i..' '..zhp[i]..'')
zmaxhp[i]=zhp[i]
parse('speedmod '..i..' '..zsp[i]..'')
shooter_reload[i]=shooter_reload_time
freeimage(hide_img[i])
hide_cool[i]=0
smoke_cool[i]=0
set_trap_delay[i]=0
speed_boost_zb[i]=0
guard_zb[i]=0
knockavoid[i]=0
zb_heal[i]=0
msg2(i,'\169255128000[Zombie]Say  !zb  to change zombie')
msg2(i,'\169255128000[Zombie]Auto Heal when you dont move')
msg2(i,'\169255128000[Zombie]If stuck,type kill in console')
else
parse('setmaxhealth '..i..' 100')
speed_boost[i]=0
head_shot[i]=0
hs_mode[i]=0
knife_combat[i]=0
kc_mode[i]=0
end
end

function zb_say(i,t)
if t=='!zb' then
menu(i,'Choose Zombie@b,Normal Zombie(Gain Speed---HP'..normal_zombie_hp..'---SP'..normal_zombie_sp..'),Shooter Zombie(Infinite GutBomb---HP'..shooter_zombie_hp..'---SP'..shooter_zombie_sp..'),Trap Zombie(Set Trap---HP'..trap_zombie_hp..'---SP'..trap_zombie_sp..'),Smoke Zombie(Smoke---HP'..smoke_zombie_hp..'---SP'..smoke_zombie_sp..'),Ninja Zombie(Hide---HP'..ninja_zombie_hp..'---SP'..ninja_zombie_sp..'),Explode Zombie(Boom!!!---HP'..boom_zombie_hp..'---SP'..boom_zombie_sp..'),Guard Zombie(No Knockback---HP'..guard_zombie_hp..'---SP'..guard_zombie_sp..')')
end
end

function zb_say_team(i,t)
if t=='!zb' then
menu(i,'Choose Zombie@b,Normal Zombie(Gain Speed---HP'..normal_zombie_hp..'---SP'..normal_zombie_sp..'),Shooter Zombie(Infinite GutBomb---HP'..shooter_zombie_hp..'---SP'..shooter_zombie_sp..'),Trap Zombie(Set Trap---HP'..trap_zombie_hp..'---SP'..trap_zombie_sp..'),Smoke Zombie(Smoke---HP'..smoke_zombie_hp..'---SP'..smoke_zombie_sp..'),Ninja Zombie(Hide---HP'..ninja_zombie_hp..'---SP'..ninja_zombie_sp..'),Explode Zombie(Boom!!!---HP'..boom_zombie_hp..'---SP'..boom_zombie_sp..'),Guard Zombie(No Knockback---HP'..guard_zombie_hp..'---SP'..guard_zombie_sp..')')
end
end

function zb_menu(i,t,a)
if t=='Choose Zombie' then
if a==1 then--Normal
zstyle2[i]=1
zhp2[i]=normal_zombie_hp
zsp2[i]=normal_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Normal Zombie in next spawn')
elseif a==2 then--Shooter
zstyle2[i]=2
zhp2[i]=shooter_zombie_hp
zsp2[i]=shooter_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Shooter Zombie in next spawn')
elseif a==3 then--Trap
zstyle2[i]=3
zhp2[i]=trap_zombie_hp
zsp2[i]=trap_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Trap Zombie in next spawn')
elseif a==4 then--Smoke
zstyle2[i]=4
zhp2[i]=smoke_zombie_hp
zsp2[i]=smoke_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Smoke Zombie in next spawn')
elseif a==5 then--Ninja
zstyle2[i]=5
zhp2[i]=ninja_zombie_hp
zsp2[i]=ninja_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Ninja Zombie in next spawn')
elseif a==6 then--Boom
zstyle2[i]=6
zhp2[i]=boom_zombie_hp
zsp2[i]=boom_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Explode Zombie in next spawn')
elseif a==7 then--Guard
zstyle2[i]=7
zhp2[i]=guard_zombie_hp
zsp2[i]=guard_zombie_sp
msg2(i,'\169255128000[Zombie]You will be Guard Zombie in next spawn')
end
end
end

function zb_ms100()
for i=1,32 do
if player(i,'team')==1 then
if zstyle[i]==1 or zstyle[i]==3 or zstyle[i]==4 or zstyle[i]==5 or zstyle[i]==6 or zstyle[i]==7 then
if player(i,'weapontype')~=78 then
parse('equip '..i..' 78')
parse('setweapon '..i..' 78')
end
end
parse('sethealth '..i..' 100')
end
if player(i,'exists') and not player(i,'bot') then
if player(i,'team')==1 then
parse('hudtxt2 '..i..' 43 "©000255000Health : '..zhp[i]..'" 45 400 1')
else
parse('hudtxt2 '..i..' 43 "©000255000ATK+ : '..human_atk..'" 35 400 1')
end
if player(i,'team')==2 then
if speed_boost[i]~=1 then
parse('hudtxt2 '..i..' 44 "©000255000(F2)Speed Boost" 520 360 -1')
else
parse('hudtxt2 '..i..' 44 "©000000000(F2)Speed Boost" 520 360 -1')
end
if head_shot[i]~=1 then
parse('hudtxt2 '..i..' 45 "©000255000(F3)Headshot Mode" 520 375 -1')
else
parse('hudtxt2 '..i..' 45 "©000000000(F3)Headshot Mode" 520 375 -1')
end
if knife_combat[i]~=1 then
parse('hudtxt2 '..i..' 46 "©000255000(F4)Knife Combat" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F4)Knife Combat" 520 390 -1')
end
elseif player(i,'team')==1 then
if zstyle[i]==1 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "©000255000(F3)Zombie Menu" 520 375 -1')
if speed_boost_zb[i]==0 then
parse('hudtxt2 '..i..' 46 "©000255000(F2)Speed Boost" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F2)Speed Boost" 520 390 -1')
end
elseif zstyle[i]==2 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "" 520 375 -1')
parse('hudtxt2 '..i..' 46 "©000255000(F3)Zombie Menu" 520 390 -1')
elseif zstyle[i]==3 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "©000255000(F3)Zombie Menu" 520 375 -1')
if set_trap_delay[i]==0 then
parse('hudtxt2 '..i..' 46 "©000255000(F2)Set Trap" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F2)Set Trap" 520 390 -1')
end
elseif zstyle[i]==4 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "©000255000(F3)Zombie Menu" 520 375 -1')
if smoke_cool[i]==0 then
parse('hudtxt2 '..i..' 46 "©000255000(F2)Smoke" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F2)Smoke" 520 390 -1')
end
elseif zstyle[i]==5 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "©000255000(F3)Zombie Menu" 520 375 -1')
if hide_cool[i]==0 then
parse('hudtxt2 '..i..' 46 "©000255000(F2)Hide" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F2)Hide" 520 390 -1')
end
elseif zstyle[i]==6 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "" 520 375 -1')
parse('hudtxt2 '..i..' 46 "©000255000(F3)Zombie Menu" 520 390 -1')
elseif zstyle[i]==7 then
parse('hudtxt2 '..i..' 44 "" 520 360 -1')
parse('hudtxt2 '..i..' 45 "©000255000(F3)Zombie Menu" 520 375 -1')
if guard_zb[i]==0 then
parse('hudtxt2 '..i..' 46 "©000255000(F2)Guard" 520 390 -1')
else
parse('hudtxt2 '..i..' 46 "©000000000(F2)Guard" 520 390 -1')
end
end
end
end
end
end

function zb_kill_ct(k,v,w,x,y)
if player(v,'team')==1 and player(k,'team')==2 then
local human_heal=math.random(0,h_h_num)
parse('sethealth '..k..' '..(player(k,'health')+human_heal))
local l=math.random(1,20)
if l>=1 and l<=4 and dropammo==1 then
parse('spawnitem 61 '..player(k,'tilex')..' '..player(k,'tiley'))
end
if l==20 and tohuman==1 then
parse('makect '..v)
msg('\169255128000[Server]One zombie became survivor')
end
end
end

function zb_kill_t(k,v,w,x,y)
if player(v,'team')==2 and player(k,'team')~=2 then
px[v]=player(v,'x')
py[v]=player(v,'y')
parse('maket '..v)
parse('spawnplayer '..v..' '..px[v]..' '..py[v])
parse('sv_sound '..hme[math.random(#hme)]..'')
hs_mode[v]=0
kc_mode[v]=0
hero_atk[v]=0
end
end

function zb_die(i)
if player(i,'team')==2 then
parse('maket '..i)
hs_mode[i]=0
kc_mode[i]=0
hero_atk[i]=0
end
end

function zb_start(m)
for i=1,32 do
parse('setmaxhealth '..i..' 100')
parse('sethealth '..i..' 100')
hero_atk[i]=0
end
trap_1=0
trap_2=0
trap_3=0
human_atk=0
msg('\169255128000[Server]Zombie mod by Dragon Lore')
local hero=math.random(1,5)
if hero==1 then
hero_human()
end
end

function hero_human()
local hero=math.random(1,32)
if player(hero,'team')==2 and player(hero,'exists') then
parse('setmaxhealth '..hero..' 200')
parse('sethealth '..hero..' 200')
parse('equip '..hero..' 30')
parse('equip '..hero..' 49')
hero_atk[hero]=hero_atk_up
msg('\169255128000[Server]'..player(hero,'name')..' is hero')
else
hero_human()
end
end

function hero_ms100()
for id=1,32 do
if player(id,'exists') and player(id,'health')>0 then
for i=1,32 do
if player(i,'exists') and player(i,'health')>0 then
if hero_atk[i]>0 then
local x=player(i,'x')-player(id,'x')+320-12
local y=player(i,'y')-player(id,'y')+240+16
parse('hudtxt2 '..id..' '..i..' "Hero" '..x..' '..y)
else
parse('hudtxt2 '..id..' '..i..' "" 0 0')
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

function zb_second()
for i=1,32 do
if player(i,'team')==1 then
if zstyle[i]==2 and shooter_reload[i]>=shooter_reload_time and player(i,'weapontype')~=86 then
shooter_reload[i]=0
parse('equip '..i..' 86')
parse('setweapon '..i..' 86')
elseif zstyle[i]==2 and player(i,'weapontype')~=86 then
shooter_reload[i]=shooter_reload[i]+1
end
if zb_heal[i]>=heal_time and zhp[i]~=zmaxhp[i] then
zhp[i]=zhp[i]+heal_value
if zhp[i]>zmaxhp[i] then
zhp[i]=zmaxhp[i]
end
else
zb_heal[i]=zb_heal[i]+1
end
end
if speed_boost_zb[i]>0 then
speed_boost_zb[i]=speed_boost_zb[i]-1
end
if smoke_cool[i]>0 then
smoke_cool[i]=smoke_cool[i]-1
end
if hide_cool[i]>0 then
hide_cool[i]=hide_cool[i]-1
end
if set_trap_delay[i]>0 then
set_trap_delay[i]=set_trap_delay[i]-1
end
if guard_zb[i]>0 then
guard_zb[i]=guard_zb[i]-1
end
end
end

function zb_action(i,a)
if a==1 then
if player(i,'team')==2 and speed_boost[i]~=1 then
speed_boost[i]=1
parse('speedmod '..i..' '..(player(i,'speedmod')+10))
msg2(i,'Speedboost for 5 seconds @C')
timer(5000,'parse',('speedmod '..i..' 0'))
timer(5000,'parse','sv_msg2 '..i..' Speedboost cancel @C')
elseif player(i,'team')==2 and speed_boost[i]==1 then
msg2(i,'\169255128000[Human]Once a round')
end
if player(i,'team')==1 then
if speed_boost_zb[i]==0 and zstyle[i]==1 then
speed_boost_zb[i]=speed_boost_zb_cooling_time
parse('speedmod '..i..' '..(player(i,'speedmod')+10))
msg2(i,'Speedboost for 5 seconds @C')
timer(5000,'parse',('speedmod '..i..' '..zsp[i]..''))
timer(5000,'parse','sv_msg2 '..i..' Speedboost cancel @C')
elseif speed_boost_zb[i]~=0 and zstyle[i]==1 then
msg2(i,'\169255128000[Zombie]Cooling('..speed_boost_zb[i]..'s left)')
end
if zstyle[i]==3 and set_trap_delay[i]==0 then
set_trap_delay[i]=trap_delay
local xy=(''..player(i,'tilex')..''..player(i,'tiley')..'')
if trap_1==0 and xy~=trap_2 and xy~=trap_3 then
trap_1=xy
msg2(i,'You set a trap @C')
elseif trap_2==0 and xy~=trap_1 and xy~=trap_3 then
trap_2=xy
msg2(i,'You set a trap @C')
elseif trap_3==0 and xy~=trap_1 and xy~=trap_2 then
trap_3=xy
msg2(i,'You set a trap @C')
elseif trap_1~=0 and trap_2~=0 and trap_3~=0 then
msg2(i,'\169255128000[Zombie]Cant set trap : Max 3 on field')
set_trap_delay[i]=0
end
elseif zstyle[i]==3 and set_trap_delay[i]~=0 then
msg2(i,'\169255128000[Zombie]Cooling('..set_trap_delay[i]..'s left)')
end
if zstyle[i]==4 and smoke_cool[i]==0 then
smoke_cool[i]=smoke_cooling_time
for ii=0,315,45 do
parse('spawnprojectile '..i..' 53 '..player(i,'x')..' '..player(i,'y')..' 200 '..ii)
end
elseif zstyle[i]==4 and smoke_cool[i]~=0 then
msg2(i,'\169255128000[Zombie]Cooling('..smoke_cool[i]..'s left)')
end
if zstyle[i]==5 and hide_cool[i]==0 then
hide_cool[i]=hide_cooling_time
local h_obj=hide_obj[math.random(#hide_obj)]
hide_img[i]=image('gfx/ez_zb/'..h_obj..'',0,1,i+200)
timer(20000,'freeimage',hide_img[i])
elseif zstyle[i]==5 and hide_cool[i]~=0 then
msg2(i,'\169255128000[Zombie]Cooling('..hide_cool[i]..'s left)')
end
if zstyle[i]==7 and guard_zb[i]==0 then
guard_zb[i]=guard_zb_cooling_time
knockavoid[i]=1
msg2(i,'Avoid knockback for 10 seconds @C')
timer(10000,'parse','sv_msg2 '..i..' Avoid knockback cancel @C')
timer(10000,'avoidkb_cancel')
function avoidkb_cancel()
knockavoid[i]=0
end
elseif zstyle[i]==7 and guard_zb[i]~=0 then
msg2(i,'\169255128000[Zombie]Cooling('..guard_zb[i]..'s left)')
end
end
end
if a==2 then
if player(i,'team')==1 then
menu(i,'Choose Zombie@b,Normal Zombie(Gain Speed---HP'..normal_zombie_hp..'---SP'..normal_zombie_sp..'),Shooter Zombie(Infinite GutBomb---HP'..shooter_zombie_hp..'---SP'..shooter_zombie_sp..'),Trap Zombie(Set Trap---HP'..trap_zombie_hp..'---SP'..trap_zombie_sp..'),Smoke Zombie(Smoke---HP'..smoke_zombie_hp..'---SP'..smoke_zombie_sp..'),Ninja Zombie(Hide---HP'..ninja_zombie_hp..'---SP'..ninja_zombie_sp..'),Explode Zombie(Boom!!!---HP'..boom_zombie_hp..'---SP'..boom_zombie_sp..'),Guard Zombie(No Knockback---HP'..guard_zombie_hp..'---SP'..guard_zombie_sp..')')
end
if player(i,'team')==2 and head_shot[i]==0 then
head_shot[i]=1
hs_mode[i]=1
msg2(i,'\169255128000[Human]Headshot mode for 15 seconds')
timer(15000,'hs_cancel')
function hs_cancel()
hs_mode[i]=0
msg2(i,'\169255128000[Human]Headshot mode cancel')
end
elseif head_shot[i]~=0 then
msg2(i,'\169255128000[Human]Once a round')
end
end
if a==3 then
if player(i,'team')==2 and knife_combat[i]==0 then
knife_combat[i]=1
kc_mode[i]=1
msg2(i,'\169255128000[Human]Knife Combat for 15 seconds')
timer(15000,'kc_cancel')
function kc_cancel()
kc_mode[i]=0
msg2(i,'\169255128000[Human]Knife Combat cancel')
end
elseif knife_combat[i]~=0 then
msg2(i,'\169255128000[Human]Once a round')
end
end
end

function zb_mt1(i,x,y)
if player(i,'team')==2 then
p_spot[i]=(''..player(i,'tilex')..''..player(i,'tiley')..'')
if p_spot[i]==trap_1 then
trap_1=0
speed_boost[i]=1
local img1=image('gfx/ez_zb/zb_trap.png',player(i,'x'),player(i,'y'),0)
parse('sv_sound2 '..i..' ez_zb/hit2.wav')
parse('speedmod '..i..' -100')
msg('\169255128000'..player(i,'name')..' get stuck!! @C')
timer(5000,'parse',('speedmod '..i..' 0'))
timer(5000,'freeimage',img1)
end
end
end

function zb_mt2(i,x,y)
if player(i,'team')==2 then
p_spot[i]=(''..player(i,'tilex')..''..player(i,'tiley')..'')
if p_spot[i]==trap_2 then
trap_2=0
speed_boost[i]=1
local img2=image('gfx/ez_zb/zb_trap.png',player(i,'x'),player(i,'y'),0)
parse('sv_sound2 '..i..' ez_zb/hit2.wav')
parse('speedmod '..i..' -100')
msg('\169255128000'..player(i,'name')..' get stuck!! @C')
timer(5000,'parse',('speedmod '..i..' 0'))
timer(5000,'freeimage',img2)
end
end
end

function zb_mt3(i,x,y)
if player(i,'team')==2 then
p_spot[i]=(''..player(i,'tilex')..''..player(i,'tiley')..'')
if p_spot[i]==trap_3 then
trap_3=0
speed_boost[i]=1
local img3=image('gfx/ez_zb/zb_trap.png',player(i,'x'),player(i,'y'),0)
parse('sv_sound2 '..i..' ez_zb/hit2.wav')
parse('speedmod '..i..' -100')
msg('\169255128000'..player(i,'name')..' get stuck!! @C')
timer(5000,'parse',('speedmod '..i..' 0'))
timer(5000,'freeimage',img3)
end
end
end

function zb_mt(i,x,y)
if player(i,'team')==1 then
zb_heal[i]=0
end
end

function zb_hit(i,source,w,hpdmg,apdmg,odmg)
if player(i,'team')==1 and player(source,'team')~=player(i,'team') then
zb_heal[i]=0
if w==51 or w==49 then
msg2(i,'\169255128000Stunned !!! @C')
parse('speedmod '..i..' -20')
timer(1000,'parse',('speedmod '..i..' '..zsp[i]..''))
end
if hs_mode[source]==1 and kc_mode[source]~=1 then
zhp[i]=zhp[i]-hpdmg-human_atk-hs_atk-hero_atk[source]
end
if kc_mode[source]==1 and hs_mode[source]~=1 then
if w==50 then
local kc_dmg=hpdmg*kc_x
zhp[i]=zhp[i]-kc_dmg-human_atk-hero_atk[source]
else
zhp[i]=zhp[i]-hpdmg-human_atk-hero_atk[source]
end
end
if kc_mode[source]==1 and hs_mode[source]==1 then
if w==50 then
local kc_dmg=hpdmg*kc_x
zhp[i]=zhp[i]-kc_dmg-human_atk-hs_atk-hero_atk[source]
else
zhp[i]=zhp[i]-hpdmg-human_atk-hs_atk-hero_atk[source]
end
end
if kc_mode[source]==0 and hs_mode[source]==0 then
zhp[i]=zhp[i]-hpdmg-human_atk-hero_atk[source]
end
if zhp[i]<=0 then
local img=image("gfx/ez_zb//body"..math.random(0,6)..".bmp",0,0,0)
imagepos(img,player(i,"x"),player(i,"y"),math.random(0,359))
imagescale(img,1,1)
if hs_mode[source]==1 then
if w<=40 or w==50 or w==51 then
parse('customkill '..source..' [HeadShot]'..itemtype(player(source,'weapontype'),'name')..' '..i) 
else
parse('customkill '..source..' [HeadShot]Kill '..i) 
end
else
if w<=40 or w==50 or w==51 then
parse('customkill '..source..' '..itemtype(player(source,'weapontype'),'name')..' '..i) 
else
parse('customkill '..source..' Kill '..i) 
end
end
if zstyle[i]==1 then
zhp[i]=normal_zombie_hp
elseif zstyle[i]==2 then
zhp[i]=shooter_zombie_hp
elseif zstyle[i]==3 then
zhp[i]=trap_zombie_hp
elseif zstyle[i]==4 then
zhp[i]=smoke_zombie_hp
elseif zstyle[i]==5 then
zhp[i]=ninja_zombie_hp
elseif zstyle[i]==6 then
zhp[i]=boom_zombie_hp
elseif zstyle[i]==7 then
zhp[i]=guard_zombie_hp
end
if zstyle[i]==6 then
for ii=0,315,45 do
parse('spawnprojectile '..i..' 86 '..player(i,'x')..' '..player(i,'y')..' 200 '..ii)
end
end
if human_atk~=human_atk_max then
human_atk=human_atk+1
end
end
end
end

--Lua from Cure Pikachu#6585
addhook("hit","zb_knockback")
function zb_knockback(id,source,weapon)
if (itemtype(weapon,"slot") == 1 or itemtype(weapon,"slot") == 2) then
if player(id,"team") == 1 and knockavoid[id]~=1 then
knockback(source,id,weapon)
end
end
end

function knockcheck(x,y,rotation,knock)
local breaks, op1, op2
for distance = 5, math.ceil(knock), 2 do
op1 = x + math.cos(rotation) * distance
op2 = y + math.sin(rotation) * distance
if (not tile(math.ceil(op1 / 32) - 1,math.ceil(op2 / 32) - 1,"walkable")) then
breaks = true
break
end
end
return breaks
end

function knockback(source,id,weapon)
if (itemtype(weapon,"slot") == 1 or itemtype(weapon,"slot") == 2) then
local knock = itemtype(weapon,"dmg") / 2
local rotation = player(source,"rot")
if (rotation < -90) then
rotation = rotation + 360
end
local angle = math.rad(math.abs(rotation + 90)) - math.pi
x = player(id,"x") + math.cos(angle) * knock
y = player(id,"y") + math.sin(angle) * knock
if (not knockcheck(player(id,"x"),player(id,"y"),angle,knock)) then
parse("setpos "..id.." "..x.." "..y)
end
end
end

addhook('second','stucksec')
addhook('move','stuckmove')
stt=z(32)

function stucksec()
for i=1,32 do
if player(i,'exists') and player(i,'team')==1 and player(i,'bot') then
stt[i]=stt[i]+1
if stt[i]>=10 then
stt[i]=0
parse('killplayer '..i..'')
end
end
end
end

function stuckmove(i)
if player(i,'exists') and player(i,'team')==1 and player(i,'bot') then
stt[i]=0
end
end
