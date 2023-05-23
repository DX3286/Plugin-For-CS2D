-----------------------------------------------------------------------
hudtxtid=33--hudtxt id (If not showing proper, change this)
-----------------------------------------------------------------------
function c(a)
local array={}
	for x=1,a do
	array[x]=0
	end
return array
end
location=c(32)
autoscale=c(32)
spec=c(32)
-----------------------------------------------------------------------
callouts={}
havecallout=false
local sav=io.open('sys/lua/Callouts/'..map('name')..'_callouts.sav','r')
if not sav then
print('\169255255255[Script] Callouts file undetected')
else
local x=1
	while true do
	local no,value=1,sav:read('*line')
		if value~=nil then
			if callouts[x]==nil then
			callouts[x]={}
			callouts[x][1]=0
			callouts[x][2]=0
			callouts[x][3]=0
			end
			for v in string.gmatch(value,'(%d+)') do
			callouts[x][no]=tonumber(v)
			no=no+1
			end
		callouts[x][3]=string.match(value,'%p([%a%s]+)%p')
		x=x+1
		else
		break	
		end
	end
sav:close()
havecallout=true
print('\169255255255[Script] Callouts loaded : '..#callouts)
end
print('\169255255255[Script] Callout script by USGN:124616')

list={
[0]={'Affirmative!','affirm'},
[1]={'Need backup!','backup'},
[2]={'Get out of there she\'s gonna blow!','blow'},
[5]={'Sector clear!','clear'},
[6]={'Cover me!','coverme'},
[8]={'Enemy down!','enemydown'},
[9]={'Enemy spotted!','enemys'},
[10]={'Team, fall back!','fallback'},
[11]={'Taking fire, need assistance!','fireassis'},
[12]={'Fire in the hole!','fireinhole'},
[13]={'Follow me!','followme'},
[14]={'Get in position and wait for my go!','getinpos'},
[15]={'Go, go, go!','go'},
[16]={'Hostage down!','hosdown'},
[17]={'I\'m in position!','inpos'},
[20]={'Teammate down!','matedown'},
[22]={'Negative!','negative'},
[23]={'Hold this position!','position'},
[24]={'Regroup team!','regroup'},
[25]={'Report in, team!','reportin'},
[26]={'Reporting in!','reportingin'},
[27]={'Hostage has been rescued!','rescued'},
[28]={'Roger that!','roger'},
[30]={'Stick together, team!','sticktog'},
[31]={'Storm the front!','stormfront'},
[32]={'You take the point!','takepoint'},
}
-----------------------------------------------------------------------
addhook('movetile','callout_movetile')
addhook('ms100','callout_ms100')
addhook('radio','callout_radio')
addhook('spawn','callout_spawn')
addhook('specswitch','callout_specswitch')

function getpos(v1,v2)
	for k,v in pairs(callouts) do
		if v1==callouts[k][1] and v2==callouts[k][2] then
		return k
		end
	end
end

function callout_ms100()
	if havecallout then
		for i=1,32 do
			if player(i,'exists') and not player(i,'bot') then
				if spec[i]>=1 and spec[i]<=32 then
				local w=getpos(player(spec[i],'tilex'),player(spec[i],'tiley'))
					if w then location[i]=callouts[w][3] else location[i]='' end
				else
					if player(i,'health')<=0 then location[i]='' end
				end
			parse('hudtxt2 '..i..' '..hudtxtid..' "\169000000000'..location[i]..'" 3 '..repos(i,73)..' 0')
			end
		end
	end
end

function callout_movetile(i,x,y)
	if havecallout then
		if player(i,'exists') and not player(i,'bot') then
		local w=getpos(x,y)
			if w then location[i]=callouts[w][3] else location[i]='' end
		end
	end	
end

function callout_spawn(i)
	if havecallout and not player(i,'bot') then
	local f=io.open ('sys/config.cfg','r')
	local v=f:read('*all')
	autoscale[i]=tonumber(string.match(v,'autohudscale (%d)')) or 0
	f:close()
	spec[i]=0
	local pic=image('gfx/hud_shade_c.bmp<a>',75,repos(i,80),2,i)
	imagescale(pic,0.75,1.2)
	callout_movetile(i,player(i,'tilex'),player(i,'tiley'))
	end
end

function callout_specswitch(i,t)
	if not player(i,'bot') then spec[i]=t end
end

function callout_radio(i,mi)
	if havecallout then
	local w=getpos(player(i,'tilex'),player(i,'tiley'))
		if w then
		message(i,player(i,'team'),mi,w)
		return 1
		end
	end
end

function message(s,team,radio,loc)
	if team==1 then 
		for k,v in pairs(player(0,'team1')) do
		msg2(v,'\169000150000\169255000000'..player(s,'name')..' \169135135135('..callouts[loc][3]..')\169255220000: '..list[radio][1]..'')
		parse('sv_sound2 '..v..' radio/'..list[radio][2]..'.ogg')
		end
	elseif team==2 then
		for k,v in pairs(player(0,'team2')) do
		msg2(v,'\169000150000\169000150255'..player(s,'name')..' \169135135135('..callouts[loc][3]..')\169255220000: '..list[radio][1]..'')
		parse('sv_sound2 '..v..' radio/'..list[radio][2]..'.ogg')
		end
	end
end

function repos(i,v)
local new
	if autoscale[i]==1 then
	local res={[361]=75,[451]=70,[480]=35,[578]=58,[598]=35,[720]=32,[722]=50,[768]=25,[900]=25,[1080]=20}
	new=v+res[player(i,'screenh')]
	else
		if player(i,'screenh')<720 then new=v+345
		elseif player(i,'screenh')==722 then new=v+355
		elseif player(i,'screenh')==1080 then new=v+370
		else
		new=v+360
		end
	end
return new
end