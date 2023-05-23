if tonumber(game('mp_roundtime'))<60 then
parse('mp_roundtime 60')
end
if tonumber(game('mp_timelimit'))<60 then
parse('mp_timelimit 60')
end
if tonumber(game('sv_maxplayers'))>1 then
parse('sv_maxplayers 1')
end
if tonumber(game('sv_gamemode'))~=0 then
parse('sv_gamemode 0')
end
print('\169255255255[Script] Callout script by USGN:124616')
function createtable(a,b)--Just for table
local array={}
	for i=1,a do
	array[i]={}
		for k=1,b do
		array[i][k]=0
		end
	end
return array
end

function tilewithcallout(b)--Just for table
local c=0
	for x=1,map('xsize') do
		for y=1,map('ysize') do
			if tile(x,y,'walkable') and tile(x,y,'frame')~=0 then
			c=c+1
				if b then
				callouts[c][1]=x
				callouts[c][2]=y
				end
			end
		end
	end
return c
end
callouts=createtable(tilewithcallout(false),3)--Main table in use
tilewithcallout(true)--Gen XY
print('\169255000000[Debug] Auto generate '..#callouts..' table values')

location='CT Start'
ispaint=false
iserase=false
showingunnamed=false
showingspecific=false
detailicon=true
quickreplace=false
cursormode=false

addhook('always','call_always')
function call_always()
	if not player(1,'bot') and player(1,'exists') then
	parse('hudtxt2 1 2 "\169150150150Location : '..location..'" 5 420 0')
		if ispaint then parse('hudtxt2 1 3 "\169000255000Paint mode activate" 425 100 1') else parse('hudtxt2 1 3 "" 425 100 1') end
		if iserase then	parse('hudtxt2 1 4 "\169255000000Delete mode activate" 425 100 1') else parse('hudtxt2 1 4 "" 425 100 1') end
		if cursormode then
		local mx,my=player(1,'tilex')+math.floor((player(1,'mousex')-409)/32),player(1,'tiley')+math.floor((player(1,'mousey')-224)/32)
		local w=getspot(mx,my)
			for k,v in pairs(image9x9) do freeimage(image9x9[k]) end
		image9x9={}
			for k,v in pairs(image9x9wn) do	freeimage(image9x9wn[k]) end
		image9x9wn={}
			if squareimg[1] then freeimage(squareimg[1]) end
		squareimg[1]=image('gfx/c_square.png',(mx)*32+16,(my)*32+16,0)
			if w then
				if ispaint then
					if quickreplace then
					callouts[w][3]=location
					else
						if callouts[w][3]==0 then
						callouts[w][3]=location
						end
					end
				elseif iserase then
					if callouts[w][3]~=0 then callouts[w][3]=0 end
				end	
			end
			for a=-1,1,1 do
				for b=-1,1,1 do
				local w2=getspot(mx+a,my+b)
					if w2 then
						if callouts[w2][3]==0 then
						table.insert(image9x9,image('gfx/c_erase.png',(mx+a)*32+16,(my+b)*32+16,0))
						else
						lettersimg(mx,my,a,b,w2)	
						table.insert(image9x9,image('gfx/c_paint.png',(mx+a)*32+16,(my+b)*32+16,0))
						end
					end
				end
			end
			if w then parse('hudtxt2 1 1 "Callout:'..callouts[w][3]..' X:'..callouts[w][1]..' Y:'..callouts[w][2]..'" 5 435 0') else parse('hudtxt2 1 1 "Callout: X: Y:" 5 435 0') end
		else
		local w=getspot(player(1,'tilex'),player(1,'tiley'))
			if w then parse('hudtxt2 1 1 "Callout:'..callouts[w][3]..' X:'..callouts[w][1]..' Y:'..callouts[w][2]..'" 5 435 0') else parse('hudtxt2 1 1 "Callout: X: Y:" 5 435 0') end
		end
	end
end
squareimg={}

function getspot(v1,v2)
	for k,v in pairs(callouts) do
		if v1==callouts[k][1] and v2==callouts[k][2] then
		return k
		end
	end
end

addhook('serveraction','call_serveraction')
function call_serveraction(i,a)
	if a==1 then
	local menu4
		if cursormode then iserase,ispaint=false,false end
		if not showingunnamed and not showingspecific then menu4='Mark Unnamed|Disable' end
		if not showingunnamed and showingspecific then menu4='Mark Specific|Enable' end
		if showingunnamed and not showingspecific then menu4='Mark Unnamed|Enable' end
		if showingunnamed and showingspecific then menu4='Mark Unnamed/Specific|Enable' end
	menu(i,'Callouts Menu,Save Map Callouts,Load Map Callouts,Final Compile,'..menu4..',Quick Location,Custom Location,Help,Settings')
	elseif a==2 then--Start/Stop painting
	iserase=false
		if ispaint then	ispaint=false else ispaint=true	end
	elseif a==3 then--Start/Stop erasing
	ispaint=false	
		if iserase then	iserase=false else iserase=true	end
	end
end

addhook('menu','call_menu')
function call_menu(i,t,a)
	if t=='Callouts Menu' then
		if a==1 then--Save
		msg2(i,'\169255000255Warning !!! You are gonna "SAVE"')
		menu(i,'Save Map Callout File ?,Yes')
		elseif a==2 then--Load
		msg2(i,'\169255000255Warning !!! You are gonna "LOAD"')
		menu(i,'Load Map Callout File ?,Yes')
		elseif a==3 then--Compile
		msg2(i,'\169255000255Warning !!! All unnamed tiles will be remove')
		menu(i,'Are You Sure ?,Yes')
		elseif a==4 then--Mark unnamed
		show_unnamed(i)
		elseif a==5 then--Fast location
		menu(i,'Pick Location,CT Start,T Start,Bombsite A,Bombsite B,Apartment,Middle,Connector,Vent')
		elseif a==6 then--Custom location
			for x=1,9 do
				if customloc[x]==nil then
				customloc[x]='(Empty)'
				end
			end
		menu(i,'Custom Location,'..customloc[1]..','..customloc[2]..','..customloc[3]..','..customloc[4]..','..customloc[5]..','..customloc[6]..','..customloc[7]..','..customloc[8]..','..customloc[9]..'')
		elseif a==7 then--Help
		msg2(i,'\169000255000[HELP] Move your chracter to paint/erase')
		msg2(i,'\169000255000[HELP] Press "Serveraction2" to toggle paint mode')
		msg2(i,'\169000255000[HELP] Press "Serveraction3" to toggle erase mode')
		msg2(i,'\169000255000[HELP] Say "#Location Name#" to set location')
		msg2(i,'\169000255000[HELP] Say "mark#Location Name#" to mark all specific location')
		msg2(i,'\169000255000[HELP] Say "clear#Location Name#" to clear all specific location')
		msg2(i,'\169000255000[HELP] Say "re#Location Name#New Location Name" to replace all match location')
		msg2(i,'\169000255000[HELP] Say "!gloc" to get your current location')
		msg2(i,'\169000255000[HELP] Say "!sloc" to save location in custom menu, you can save up to 9 custom location')
		msg2(i,'\169000255000[HELP] Remember to save your hard work frequently')
		msg2(i,'\169000255000[HELP] Say "!add" to add an area at cursor position while cursor mode enabled')
		msg2(i,'\169000255000[HELP] Say "!del" to remove an area at cursor position while cursor mode enabled')
		elseif a==8 then--Settings
		local menu1,menu2,menu3
			if detailicon then menu1='Detailed Icon|Enable'	else menu1='Detailed Icon|Disable' end
			if quickreplace then menu2='Quick Replace|Enable' else menu2='Quick Replace|Disable' end
			if cursormode then	menu3='Cursor Mode|Enable' else	menu3='Cursor Mode|Disable'	end
		menu(i,'Settings,'..menu1..','..menu2..','..menu3..'')
		end
	elseif t=='Pick Location' then--Fast location
		if a==1 then
		location='CT Start'
		elseif a==2 then
		location='T Start'
		elseif a==3 then
		location='Bombsite A'
		elseif a==4 then
		location='Bombsite B'
		elseif a==5 then
		location='Apartment'
		elseif a==6 then
		location='Middle'
		elseif a==7 then
		location='Connector'
		elseif a==8 then
		location='Vent'
		end
	elseif t=='Custom Location' then--Custom location
		if a~=0 then location=customloc[a] end
	elseif t=='Are You Sure ?' then--Compile
		if a==1 then final_compile(i) end
	elseif t=='Save Map Callout File ?' then--Save
		if a==1 then
		local f=io.open('sys/lua/Callouts/'..map('name')..'_editor.sav','w')
			for k,v in ipairs(callouts) do
				for x=1,3 do
				f:write(callouts[k][x]..',')
				end
			f:write('\n')
			end
		f:close()
		msg2(i,'Map callout file saved')
		print('\169255000000[Debug] '..#callouts..' table values saved')
		end
	elseif t=='Load Map Callout File ?' then--Load
		if a==1 then
		local f=io.open('sys/lua/Callouts/'..map('name')..'_editor.sav','r')
			if not f then
			msg2(i,'Map callouts save file undetected')
			else
			local x=1
				while true do
				local no=1
				local value=f:read('*line')
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
					callouts[x][3]=string.match(value,'%p([%a%s]+)%p') or 0
					x=x+1
					else
					break	
					end
				end
			msg2(i,'Map callout file loaded')
			print('\169255000000[Debug] '..(x-1)..' table values loaded')
			f:close()
			clear_repeat()
			end	
		end
	elseif t=='Settings' then--Settings
		if a==1 then
			if detailicon then detailicon=false	else detailicon=true end
		call_menu(i,'Callouts Menu',8)	
		elseif a==2 then
			if quickreplace then quickreplace=false else quickreplace=true end
		call_menu(i,'Callouts Menu',8)	
		elseif a==3 then
			if cursormode then
			cursormode=false
				if squareimg[1] then freeimage(squareimg[1]) end
			else
			iserase=false
			ispaint=false
			cursormode=true
			end
		end
	end
end

function clear_repeat()
	for r1=1,#callouts do
		for r2=1,#callouts do
			if callouts[r1][1]==callouts[r2][1] and callouts[r1][2]==callouts[r2][2] and r1~=r2 then
			callouts[r2][1]='del'
			end
		end
	end
local no=0
	for k=1,#callouts do
		if callouts[k-no][1]=='del' then
		table.remove(callouts,k-no)
		no=no+1
		end
	end
print('\169255000000[Debug] '..no..' repeat values cleared')
end

function final_compile(i)
local compile_table={}
	for x=1,#callouts do
	compile_table[x]={}
		for x2=1,3 do
		compile_table[x][x2]=callouts[x][x2]
		end
	end
local no=0
	for k=1,#compile_table do
		if compile_table[k-no][3]==0 then
		table.remove(compile_table,k-no)
		no=no+1
		end
	end
print('\169255000000[Debug] '..no..' unnamed area deleted')	
local f=io.open('sys/lua/Callouts/'..map('name')..'_callouts.sav','w')
	for k,v in ipairs(compile_table) do
		for x=1,3 do
		f:write(compile_table[k][x]..',')
		end
	f:write('\n')
	end
f:close()
msg2(i,'Map final callouts saved')
print('\169255000000[Debug] '..#compile_table..' table values saved')
end

imageunnamed={}
specificimage={}
function show_unnamed(i)
	if not showingunnamed and not showingspecific then
	showingunnamed=true
	local c=0
		for k,v in pairs(callouts) do
			if callouts[k][3]==0 then
			table.insert(imageunnamed,image('gfx/c_erase.png',callouts[k][1]*32+16,callouts[k][2]*32+16,0))
			c=c+1
			end
		end
	msg2(i,''..c..' tiles mark')
		if c==0 then
		showingunnamed=false
		end
	elseif showingunnamed and not showingspecific then
	showingunnamed=false
	freeunnamedimg()
	elseif not showingunnamed and showingspecific then
	showingspecific=false
	freespecificimg()
	elseif showingunnamed and showingspecific then
	showingspecific=false
	showingunnamed=false
	freeunnamedimg()
	freespecificimg()
	end
end

function markspecific(i,loc)
showingspecific=true
freespecificimg()
local c=0
	for k,v in pairs(callouts) do
		if callouts[k][3]==loc then
		table.insert(specificimage,image('gfx/c_mark.png',callouts[k][1]*32+16,callouts[k][2]*32+16,0))
		c=c+1
		end
	end
msg2(i,''..c..' tiles mark')
	if c==0 then
	showingspecific=false
	end
end

function freespecificimg()
	for k,v in pairs(specificimage) do freeimage(specificimage[k]) end
specificimage={}
end

function freeunnamedimg()
	for k,v in pairs(imageunnamed) do freeimage(imageunnamed[k]) end
imageunnamed={}
end

image9x9={}
image9x9wn={}
addhook('movetile','call_move')
function call_move(i,px,py)
	if player(1,'exists') and not player(1,'bot') and i==1 and not cursormode then
	local w=getspot(px,py)
		for k,v in pairs(image9x9) do freeimage(image9x9[k]) end
	image9x9={}
		for k,v in pairs(image9x9wn) do	freeimage(image9x9wn[k]) end
	image9x9wn={}
		if w then
			if ispaint then
				if quickreplace then
				callouts[w][3]=location
				else
					if callouts[w][3]==0 then
					callouts[w][3]=location
					end
				end
			elseif iserase then
				if callouts[w][3]~=0 then callouts[w][3]=0 end
			end	
		end
		for a=-1,1,1 do
			for b=-1,1,1 do
			local w2=getspot(px+a,py+b)
				if w2 then
					if callouts[w2][3]==0 then
					table.insert(image9x9,image('gfx/c_erase.png',(px+a)*32+16,(py+b)*32+16,0))
					else
					lettersimg(px,py,a,b,w2)	
					table.insert(image9x9,image('gfx/c_paint.png',(px+a)*32+16,(py+b)*32+16,0))
					end
				end
			end
		end
	end
end

function lettersimg(x,y,a,b,w)
	if detailicon then
	local pic=string.lower(string.match(callouts[w][3],'(%a)'))
	local pos=27
		if pic=='a' then pos=1
		elseif pic=='b' then pos=2
		elseif pic=='c' then pos=3
		elseif pic=='d' then pos=4
		elseif pic=='e' then pos=5
		elseif pic=='f' then pos=6
		elseif pic=='g' then pos=7
		elseif pic=='h' then pos=8
		elseif pic=='i' then pos=9
		elseif pic=='j' then pos=10
		elseif pic=='k' then pos=11
		elseif pic=='l' then pos=12
		elseif pic=='m' then pos=13
		elseif pic=='n' then pos=14
		elseif pic=='o' then pos=15
		elseif pic=='p' then pos=16
		elseif pic=='q' then pos=17
		elseif pic=='r' then pos=18
		elseif pic=='s' then pos=19
		elseif pic=='t' then pos=20
		elseif pic=='u' then pos=21
		elseif pic=='v' then pos=22
		elseif pic=='w' then pos=23
		elseif pic=='x' then pos=24
		elseif pic=='y' then pos=25
		elseif pic=='z' then pos=26
		end
	local tt=image('<spritesheet:gfx/c_word.png:48:48>',(x+a)*32+16,(y+b)*32+16,0)
	table.insert(image9x9wn,tt)
	imageframe(tt,pos)
	imagescale(tt,0.6,0.6)
	end
end

customloc={}
addhook('say','call_say')
function call_say(i,t)
	if (string.sub(t,1,1)=='#') then
	local xx=string.match(t,'#(%a+[%a%s]*)#')
		if xx then
		msg2(i,'Location set : '..xx)
		location=xx
		return 1
		end
	elseif (string.sub(t,1,5)=='mark#') then
	local xx=string.match(t,'#(%a+[%a%s]*)#')
		if xx then
		markspecific(i,xx)
		return 1
		end
	elseif (string.sub(t,1,6)=='clear#') then
	local xx=string.match(t,'#(%a+[%a%s]*)#')
	local c=0
		if xx then
			for k,v in pairs(callouts) do
				if callouts[k][3]==xx then
				callouts[k][3]=0
				c=c+1
				end
			end
		msg2(i,''..c..' tiles cleared')	
		return 1
		end	
	elseif t=='!sloc' then
		if #customloc<9 then
		table.insert(customloc,1,location)
		else
		table.remove(customloc)
		table.insert(customloc,1,location)
		end
	msg2(i,'Custom location saved')
	return 1
	elseif t=='!gloc' then
	local w=getspot(player(i,'tilex'),player(i,'tiley'))
		if w and callouts[w][3]~=0 then
		location=callouts[w][3]
		msg2(i,'Location set : '..callouts[w][3]..'')
		return 1
		end
	elseif (string.sub(t,1,3)=='re#') then
	local c=0
	local x=string.exp(t)
	local replacename=string.match(x[3],'(%a+[%a%s]*)')
		if x[1]=='re' and x[2] and replacename and x[4]==nil then
			for k,v in pairs(callouts) do
				if callouts[k][3]==x[2] then
				callouts[k][3]=replacename
				c=c+1
				end
			end
		msg2(i,''..c..' tiles replaced')
			if c~=0 then
			msg2(i,'Original callout : '..x[2]..' \169000255000New callout : '..replacename..'')
			end
		return 1
		end	
	elseif t=='!add' then
		if cursormode then
		local mx,my=player(1,'tilex')+math.floor((player(1,'mousex')-409)/32),player(1,'tiley')+math.floor((player(1,'mousey')-224)/32)
		local w=getspot(mx,my)	
			if not w then
				if mx>=0 and my>=0 and mx<=map('xsize') and my<=map('ysize') and tile(mx,my,'walkable') then
				table.insert(callouts,{})
				callouts[#callouts][1]=mx
				callouts[#callouts][2]=my
				callouts[#callouts][3]=0
				msg2(i,'Area added')
				print('\169255000000[Debug] Current table value count : '..#callouts)
				else
				msg2(i,'Cant add area')
				end
			else
			msg2(i,'Cant add area')		
			end				
		return 1	
		end
	elseif t=='!del' then
		if cursormode then
		local mx,my=player(1,'tilex')+math.floor((player(1,'mousex')-409)/32),player(1,'tiley')+math.floor((player(1,'mousey')-224)/32)
		local w=getspot(mx,my)
			if w then
			table.remove(callouts,w)
			msg2(i,'Area deleted')
			print('\169255000000[Debug] Current table value count : '..#callouts)
			end
		return 1	
		end	
	end
end

function string.exp(t)
local v={}
local con="[^#]+"
for x in string.gmatch(t,con) do table.insert(v,x) end
return v
end

addhook('startround','call_startround')
function call_startround(m)
ispaint=false
iserase=false
cursormode=false
showingunnamed=false
showingspecific=false
image9x9={}
image9x9wn={}
specificimage={}
imageunnamed={}
end