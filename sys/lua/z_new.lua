--------Free to change--------
counttime=20		--Countdown(Seconds)
minhp=500			--Min zombie health(Zombie health cant be lower than)
diepa=5				--Health decrease every time zombie dies(-X%)
zbpa=150			--Normal zombie health(CT Player * X)
bosszbpa=400		--Boss zombie health(CT Player * X)
supplytime=30		--How long to supply drop(Seconds)
machetedamage=500	--Machete(ID69) Damage
machetestr=15		--Machete Strength
burntime=5			--Burning time(Seconds)
burndmg=2			--Burning damage(Per ms100 #1.second=10.ms100)

supply_items={
--[EX]={{item ids},percent,name}
--Note: sum of percent must be 100
[1]={{51,52,53},26,'Grenade Pack'},
[2]={{69},7,'Machete'},
[3]={{90},12,'M134'},
[4]={{91},8,'FNF2000'},
[5]={{30},8,'AK47(Zombie Edition)'},
[6]={{23},18,'MAC10(Zombie Edition)'},
[7]={{46},9,'Flamethrower'},
[8]={{73,52,53},12,'Molotov Pack'},
}

--------Dont change anything below--------
print('\169000255000Check user setting')
if counttime<10 then 
counttime=10 
print('\169255000000counttime change to 10')
end
if minhp<300 then 
minhp=300
print('\169255000000minhp change to 300')
end
if diepa<0 then 
diepa=0
print('\169255000000diepa change to 0')
end
if zbpa<100 then 
zbpa=100
print('\169255000000zbpa change to 100')
end
if bosszbpa<zbpa then 
bosszbpa=zbpa*2
print('\169255000000bosszbpa change to'..zbpa*2)
end
if supplytime<5 then
supplytime=5
print('\169255000000supplytime change to 5')
end
if machetedamage<100 then
machetedamage=100
print('\169255000000machetedamage change to 100')
end
if machetestr<1 then
machetestr=1
print('\169255000000machetestr change to 1')
end
if burntime<0 then
burntime=0
print('\169255000000burntime change to 0')
end
if burndmg<1 then
burndmg=1
print('\169255000000burndmg change to 1')
end
print('\169000255000Done')

print('\169000255000Analyze supply items')
supply_data={}
supply_sum=0
for i=1,#supply_items do
supply_sum=supply_sum+supply_items[i][2]
end
if supply_sum~=100 then
for i=1,#supply_items do
supply_items[i][2]=0
end
supply_items[1][2]=100
print('\169255000000Sum of supply items arent 100, only first item can be collect')
end
for i=1,#supply_items do
for i2=1,supply_items[i][2] do
table.insert(supply_data,i)
end
end

supply_x,supply_y={},{}
for mx=1,map('xsize') do
for my=1,map('ysize') do
if tile(mx,my,'property')>=10 and tile(mx,my,'property')<=16 then
table.insert(supply_x,mx)
table.insert(supply_y,my)
end
end
end
print('\169000255000Done')

function z2(a,b)
local array={}
for i=1,a do
array[i]={}
for x=1,b do
array[i][x]=0
end
end
return array
end

firstzombie=false
isplaying=false

humanatk=0
countdown=0
supplydrop=600

trap_x={}
trap_y={}
trap_img={}
state=z2(32,11)
--[[	#For ZB [1]:zbhp [2]:zbmaxhp [3]:zbdie [4]:recovery [5]:speedboost [8]:isburning? [9]:burn.u.id [10]is molotov? [11]zombie type
		#For Human [6]:machetestr [7]:showdmg(hud id 1~10)]]
zbboss={0,0,0,0}

hs={
--[EX]={Min,Max,X,Note}
[1]={3,45,2,'Usp'},
[2]={3,43,2,'Glock(Cant Get)'},
[3]={5,35,3,'Deagle'},
[4]={3,40,2,'P228'},
[5]={4,40,2,'Elite'},
[6]={3,42,2,'Fiveseven'},
[10]={4,30,2.5,'M3'},
[11]={4,30,2,'Xm1014'},
[20]={3,45,2,'Mp5'},
[21]={3,42,2,'Tmp'},
[22]={3,40,2,'P90'},
[23]={3,85,2,'Mac10(Supply)'},
[24]={3,40,2,'Ump45'},
[30]={3,40,4,'Ak47(Supply)'},
[31]={3,40,2,'Sg552(Cant Get)'},
[32]={3,42,2,'M4a1'},
[33]={3,40,2,'Aug'},
[34]={25,70,2,'Scout'},
[35]={30,80,2,'Awp'},
[36]={30,60,2,'G3sg1(Cant Get)'},
[37]={30,60,2,'Sg550'},
[38]={3,40,2,'Galil(Cant Get)'},
[39]={3,40,2,'Famas'},
[40]={4,35,1.5,'M249'},
[90]={4,30,1.5,'M134(Supply)'},
[91]={3,70,2.5,'FNF2000(Supply)'},
}

icon=z2(32,2)
supply_img={}
supply={[1]={0,0,false},[2]={0,0,false}}

addhook('startround','zb1')
function zb1(m)
isplaying=false
firstzombie=true
countdown=counttime
humanatk=0
supplydrop=600
supply[1][3],supply[2][3]=false,false
parse('mp_zombiekillscore 1')
parse('mp_autoteambalance 0')
parse('mp_freezetime 0')
parse('mp_infammo 1')
for _,id in pairs(player(0,'table')) do
parse('makect '..id)
parse('setdeaths '..id..' '..(player(id,'deaths')-1))
parse('setmoney '..id..' 16000')
end
zbboss={0,0,0,0}
zbnumber=math.ceil(#player(0,'team2')/10)
for i=1,32 do
state[i][3]=0
state[i][4]=10
state[i][5]=1
state[i][6]=machetestr
state[i][7]=0
state[i][8]=0
state[i][11]=math.random(1,3)
for r=1,2 do
icon[i][r]=image('gfx/ez_zb/supply.png',0,0,2,i)
imagealpha(icon[i][r],0.0)
supply_img[r]=nil
end
trap_x[i]=nil
trap_y[i]=nil
trap_img[i]=nil
end
end

addhook('second','zb2')
function zb2()
if not isplaying then
if #player(0,'team1')>0 then
parse('endround 3')
end
end
if countdown>0 and firstzombie then
countdown=countdown-1
parse('hudtxt 11 "\169000255000Zombie incoming in '..countdown..' seconds" 320 260 1')
elseif countdown==0 and firstzombie then
isplaying=true
firstzombie=false
supplydrop=supplytime
parse('hudtxt 11 "" 320 260 1')
for x=1,zbnumber do
local a,zb=player(0,'team2'),math.random(1,#player(0,'team2'))
parse('maket '..a[zb])
parse('spawnplayer '..a[zb]..' '..player(a[zb],'x')..' '..player(a[zb],'y'))
parse('setdeaths '..a[zb]..' '..(player(a[zb],'deaths')-1))
msg('\169255000000'..player(a[zb],'name')..' is now a zombie @C')
zbboss[x]=a[zb]
sethealthzbbossfirst(a[zb])
end
end
if supplydrop>0 then
supplydrop=supplydrop-1
elseif supplydrop==0 then
supplydrop=supplytime
for k=1,2 do
if not supply[k][3] then
local sp=math.random(1,#supply_x)
supply[k][1],supply[k][2],supply[k][3]=supply_x[sp],supply_y[sp],true
supply_img[k]=image('gfx/ez_zb/box.png',supply_x[sp]*32+16,supply_y[sp]*32+16,0)
parse('hudtxt 11 "\169000255000Supply Dropped !!!" 320 260 1')
parse('hudtxtalphafade 0 11 3000 0.0')
end
end
end
if isplaying then
for _,i in pairs(player(0,'team1living')) do
if state[i][4]~=0 then state[i][4]=state[i][4]-1 end
if state[i][4]==0 and state[i][1]+5<=state[i][2] then
state[i][1]=state[i][1]+5 
showdmg(i,i,5,'000255000+')
end
if state[i][8]~=0 then state[i][8]=state[i][8]-1 end
end
end
end

function sethealthzbbossfirst(i)
local h=(#player(0,'table')-zbnumber)*bosszbpa
if h<=minhp then h=minhp end
state[i][1],state[i][2]=h,h
end

function sethealthzbboss(i)
local a=100-diepa*state[i][3]
if a<50 then a=50 end
local h0=(#player(0,'team2'))*bosszbpa
local h=math.ceil(a/100*h0)
if h<=minhp then h=minhp end
state[i][1],state[i][2]=h,h
end

function sethealthzb(i)
local a=100-diepa*state[i][3]
if a<50 then a=50 end
local h0=(#player(0,'team2'))*zbpa
local h=math.ceil(a/100*h0)
if h<=minhp then h=minhp end
state[i][1],state[i][2]=h,h
end

addhook('ms100','zb4')
function zb4()
for i=1,32 do
if player(i,'exists') then
if player(i,'team')==1 then
parse('equip '..i..' 78')
parse('setweapon '..i..' 78')
parse('sethealth '..i..' '..state[i][1])
parse('hudtxt2 '..i..' 12 "\169000255000Health : '..state[i][1]..'" 10 420 -1')
if state[i][11]==1 then
parse('hudtxt2 '..i..' 13 "\169000255000(Spray) SpeedBoost" 10 400 -1')
elseif state[i][11]==2 then
parse('hudtxt2 '..i..' 13 "\169000255000(Spray) RangeHeal" 10 400 -1')
elseif state[i][11]==3 then
parse('hudtxt2 '..i..' 13 "\169000255000(Spray) Set Trap" 10 400 -1')
end
if state[i][8]~=0 then 
parse('effect "fire" "'..player(i,'x')..'" "'..player(i,'y')..'" "1" "16"')
local ha,s=math.floor((humanatk/10+1)*burndmg),state[i][9]
showdmg(i,s,ha,'255000000-')
if state[i][1]-ha<=0 then 
state[i][1],state[i][8]=0,0
if state[i][10] then
parse('customkill '..s..' "'..itemtype(73,'name')..',gfx/weapons/'..itemtype(73,'name')..'_k.bmp" '..i)
else
parse('customkill '..s..' "'..itemtype(46,'name')..',gfx/weapons/'..itemtype(46,'name')..'_k.bmp" '..i)
end
parse('setdeaths '..i..' '..(player(i,'deaths')+1))
atkup()
else
state[i][1]=state[i][1]-ha
end
end
else
parse('hudtxt2 '..i..' 12 "" 10 400 -1')
parse('hudtxt2 '..i..' 13 "" 10 400 -1')
end
if player(i,'team')==2 and not player(i,'bot') then
if player(i,'weapontype')==69 then
parse('hudtxt2 '..i..' 13 "\169000255000Strength : '..state[i][6]..'" 10 400 -1')
else
parse('hudtxt2 '..i..' 13 "" 10 400 -1')
end
local pa=humanatk*10
parse('hudtxt2 '..i..' 14 "\169000255000Extra ATK : '..pa..' %" 10 420 -1')
if isplaying then
for k=1,2 do
if supply[k][3] and player(i,'health')>0 then
imagealpha(icon[i][k],1.0)
local aa,bb=supply[k][1]*32-player(i,'x')+320+16,supply[k][2]*32-player(i,'y')+240
if aa>=630 then aa=630
elseif aa<=10 then aa=10
end
if bb>=470 then bb=470
elseif bb<=10 then bb=10
end
imagepos(icon[i][k],aa,bb,0)
else
imagealpha(icon[i][k],0.0)
end
end
end
else
parse('hudtxt2 '..i..' 14 "" 10 400 -1')
end
end
end
end

function showdmg(v,s,d,c)
if not player(s,'bot') then
state[s][7]=state[s][7]+1
if state[s][7]>10 then state[s][7]=1 end
local x,y=player(v,'x')-player(s,'x')+320-8,player(v,'y')-player(s,'y')+240-24
parse('hudtxt2 '..s..' '..state[s][7]..' "\169'..c..''..d..'" '..x..' '..y)
parse('hudtxtmove '..s..' '..state[s][7]..' 500 '..x..' '..(y-32)..'')
parse('hudtxtalphafade '..s..' '..state[s][7]..' 500 0')
end
end

addhook('hit','zb5')
function zb5(v,s,w,h,a,r)
if player(s,'team')~=player(v,'team') then
if player(v,'team')==1 then
state[v][4]=10
if w==51 then
msg2(v,'\169255000000Stunned !!! @C')
parse('speedmod '..v..' -20')
timer(1000,'parse',('speedmod '..v..' 0'))
end
local ha=math.floor((humanatk/10+1)*r)
--Special
if w>40 and w<90 and w~=69 then
showdmg(v,s,ha,'255000000-')
if ha>=state[v][1] then
state[v][1]=0
parse('customkill '..s..' "'..itemtype(w,'name')..',gfx/weapons/'..itemtype(w,'name')..'_k.bmp" '..v)
atkup()
else
state[v][1]=state[v][1]-ha
if w==46 then
state[v][8]=burntime
state[v][9]=s
state[v][10]=false
elseif w==73 then
state[v][8]=burntime
state[v][9]=s
state[v][10]=true
end
end
end
if w==69 then
local hma=math.floor((humanatk/10+1)*machetedamage)
showdmg(v,s,hma,'255000000-')
if hma>=state[v][1] then
state[v][1]=0
parse('customkill '..s..' "'..itemtype(w,'name')..',gfx/weapons/'..itemtype(w,'name')..'_k.bmp" '..v)
atkup()
else
state[v][1]=state[v][1]-hma
end
end
if w==239 or w==251 then
if r>=state[v][1] then
state[v][1]=0
parse('killplayer' ..v)
else
state[v][1]=state[v][1]-r
end
end
--Special
if hs[w] then 
local hmin,hmax=hs[w][1],hs[w][2]
local dx,dy=math.abs(player(s,'x')-player(v,'x')),math.abs(player(s,'y')-player(v,'y'))
local ishs=math.random(math.sqrt(dx*dx+dy*dy))
--msg(math.sqrt(dx*dx+dy*dy))
haveknockback(s,v,w)
if ishs>=hmin and ishs<=hmax then
parse('sv_sound2 '..s..' Headshot/headshot'..math.random(1,3)..'.wav')
parse('sv_sound2 '..v..' Headshot/headshot'..math.random(1,3)..'.wav')
showdmg(v,s,math.floor(ha*hs[w][3]),'255255000-')
if state[v][1]-math.floor(ha*hs[w][3])>0 then
state[v][1]=state[v][1]-math.floor(ha*hs[w][3])
else
state[v][1]=0
parse('customkill '..s..' "'..itemtype(w,'name')..'(HeadShot),gfx/Headshot/'..itemtype(w,'name')..'_hs.bmp" '..v)
parse('setdeaths '..v..' '..(player(v,'deaths')+1))
parse('makespec '..v)
atkup()
checkifwin()
end
else
showdmg(v,s,ha,'255000000-')
if ha>=state[v][1] then
state[v][1]=0
parse('customkill '..s..' "'..itemtype(w,'name')..',gfx/weapons/'..itemtype(w,'name')..'_k.bmp" '..v)
atkup()
else
state[v][1]=state[v][1]-ha
end
end
end
elseif player(v,'team')==2 and w==78 then
parse('customkill '..s..' "Infected,gfx/weapons/claw_k.bmp" '..v)
imagealpha(icon[v][1],0.0)
imagealpha(icon[v][2],0.0)
return 1
end
end
end

function checkifwin()
if #player(0,'team1')==0 then
parse('endround 2')
else
atkup()
end
end

function atkup()
if humanatk<10 then
humanatk=humanatk+0.5
end
end

function haveknockback(s,v,w)
local px,py=player(v,'tilex'),player(v,'tiley')
if not tile(px,py+1,'walkable') and not tile(px+1,py,'walkable') and not tile(px+1,py+1,'walkable') or not tile(px,py-1,'walkable') and not tile(px-1,py,'walkable') and not tile(px-1,py-1,'walkable') or not tile(px+1,py,'walkable') and not tile(px,py-1,'walkable') and not tile(px+1,py-1,'walkable') or not tile(px-1,py,'walkable') and not tile(px,py+1,'walkable') and not tile(px-1,py+1,'walkable') then
--No Knockback
else
knockback(s,v,w)
end
end

addhook('kill','zb6')
function zb6(s,v,w,x,y)
if player(s,'team')~=player(v,'team') then
if player(v,'team')==2 then
parse('maket '..v)
parse('spawnplayer '..v..' '..player(v,'x')..' '..player(v,'y'))
parse('setdeaths '..v..' '..(player(v,'deaths')-1))
state[v][3]=state[v][3]-1
end
end
end

addhook('spawn','zb7')
function zb7(i)
parse('speedmod '..i..' 0')
if i==zbboss[1] or i==zbboss[2] or i==zbboss[3] or i==zbboss[4] then
sethealthzbboss(i)
else
sethealthzb(i)
end
end

addhook('team','zb8')
function zb8(i,t)
if isplaying then
if player(i,'team')==0 then
return 1
else
return 0
end
end
end

function knockcheck(x,y,rot,knock)
local col,dist,dx,dy
for dist=5,math.ceil(knock),2 do
dx=x+math.cos(rot)*dist
dy=y+math.sin(rot)*dist
if (not tile(math.ceil(dx/32)-1,math.ceil(dy/32)-1,'walkable')) then
col=true
break
end
end
return col
end

function knockback(s,v,w)
local knock=itemtype(w,'dmg')/2
local rot=player(s,'rot')
if (rot<-90) then
rot=rot+360
end
local angle=math.rad(math.abs(rot+90))-math.pi
x=player(v,'x')+math.cos(angle)*knock
y=player(v,'y')+math.sin(angle)*knock
if (not knockcheck(player(v,'x'),player(v,'y'),angle,knock)) then
parse('setpos '..v..' '..x..' '..y)
end
end

addhook('movetile','zb9')
function zb9(i,x,y)
if player(i,'team')==2 and player(i,'health')>0 then
if supply[1][3] and player(i,'tilex')==supply[1][1] and player(i,'tiley')==supply[1][2] then
supply[1][3]=false
freeimage(supply_img[1])
getitem(i)
end
if supply[2][3] and player(i,'tilex')==supply[2][1] and player(i,'tiley')==supply[2][2] then
supply[2][3]=false
freeimage(supply_img[2])
getitem(i)
end
for k,tx in pairs(trap_x) do
for _,ty in pairs(trap_y) do
if player(i,'tilex')==tx and player(i,'tiley')==ty then
trap_x[k],trap_y[k]=nil,nil
msg2(k,'\169255000000You caught '..player(i,'name')..' @C')
msg2(i,'\169255000000Caught by '..player(k,'name')..'\'s trap @C')
imagealpha(trap_img[k],1.0)
parse('speedmod '..i..' -100')
timer(5000,'freeimage',trap_img[k])
timer(5000,'parse',('speedmod '..i..' 0'))
end
end
end
end
end

function getitem(i)
local pick=supply_data[math.random(#supply_data)]
msg('\169000255000'..player(i,'name')..' got '..supply_items[pick][3]..' @C')
for _,v in pairs(supply_items[pick][1]) do
parse('equip '..i..' '..v)
end
end

addhook('attack','zb10')
function zb10(i)
if player(i,'weapontype')==69 then
state[i][6]=state[i][6]-1
if state[i][6]<=0 then
state[i][6]=machetestr
parse('strip '..i..' 69')
end
end
end

addhook('move','zb11')
function zb11(i,x,y,w)
state[i][4]=10
if state[i][8]~=0 and w~=1 then
state[i][8]=burntime
end
end

addhook('spray','zb12')
function zb12(i)
if player(i,'team')==1 and state[i][5]==1 then
if state[i][11]==1 then--! Speed Zombie
state[i][5]=0
msg2(i,'\169255000000SpeedBoost for 5 seconds! @C')
parse('speedmod '..i..' 5')
timer(5000,'parse',('speedmod '..i..' 0'))
elseif state[i][11]==2 then--! Heal Zombie
state[i][5]=0
msg2(i,'\169255000000Heal all zombies around you @C')
local range_x={player(i,'tilex'),player(i,'tilex')-1,player(i,'tilex')-2,player(i,'tilex')-3,player(i,'tilex')+1,player(i,'tilex')+2,player(i,'tilex')+3}
local range_y={player(i,'tiley'),player(i,'tiley')-1,player(i,'tiley')-2,player(i,'tiley')-3,player(i,'tiley')+1,player(i,'tiley')+2,player(i,'tiley')+3}
for _,v in pairs(player(0,'team1living')) do
for _,tx in pairs(range_x) do
for _,ty in pairs(range_y) do
if player(v,'tilex')==tx and player(v,'tiley')==ty and v~=i then
msg2(v,'\169255000000Heal by '..player(i,'name')..' @C')
if state[v][1]+500<=state[v][2] then
showdmg(v,i,500,'000255000+')
state[v][1]=state[v][1]+500
else
local healamount=state[v][2]-state[v][1]
showdmg(v,i,healamount,'000255000+')
state[v][1]=state[v][1]+healamount
end
end
end
end
end
elseif state[i][11]==3 then--! Trap Zombie
state[i][5]=0
msg2(i,'\169255000000Set a trap on your postition! @C')
table.insert(trap_x,i,player(i,'tilex'))
table.insert(trap_y,i,player(i,'tiley'))
table.insert(trap_img,i,image('gfx/ez_zb/trap.png',player(i,'tilex')*32+16,player(i,'tiley')*32+16,0))
imagealpha(trap_img[i],0.5)
end
elseif player(i,'team')==1 and state[i][5]==0 then
if state[i][11]==1 then--! Speed Zombie
msg2(i,'\169255000000Once a round! @C')
elseif state[i][11]==2 then--! Heal Zombie
msg2(i,'\169255000000Once a round! @C')
elseif state[i][11]==3 then--! Trap Zombie
msg2(i,'\169255000000Once a round! @C')
end
end
end

addhook('die','zb13')
function zb13(i,s,w)
if player(i,'team')==1 then
state[i][3]=state[i][3]+1
elseif player(i,'team')==2 and w>=240 and w<=243 and isplaying then
parse('maket '..i)
end
end