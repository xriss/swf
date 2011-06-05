



local print=print
local string=string
local os=os

local ipairs=ipairs
local tonumber=tonumber

local tdata=tdata

local dump=require 'dump'


module 'wetlim'


local rnd_num=1
function rnd_seed(n)	rnd_num=n%65536	end
function rnd()	rnd_num=(((rnd_num+1)*75)-1)%65537	return rnd_num	end
function rnd_tab(tab) return tab[1+(rnd()%#tab)] end
function rnd_idx(tab) return 1+(rnd()%#tab) end


function load(nam)

	local tab,dat,dest,destlab,destlabany,list,listlab,listlabany

	tab=tdata.load_csv(nam)

	dat={}
	
	dat[1]={}	-- lines table
	dat[2]={}	-- list table

	dest=null
	destlab=null
	
	list=dat[2]
	listlab=null

	for i,v in ipairs(tab) do

		if i>1 then

			if		v[2]=='LINES'	then
			
				dest=dat[1]
				dat[1][#(dat[1])+1]={}
				dest=dat[1][#(dat[1])]
			
			elseif	v[2]=='RHYME'	then
			
				dat[#dat+1]={}
				dest=dat[#dat]
			
			elseif	v[2]=='LIST'	then
			
				dest=dat[2]
			
			end
			
			if v[3] and v[3]~='' then
			
				local idx=tonumber(v[3]) or v[3]		

				dest[idx]=dest[idx] or {}
				dest['ANY']=dest['ANY'] or {}
				
				destlab=dest[idx]
				destlabany=dest['ANY']
				
				if dest == dat[1] or dest == dat[2] then
				
					listlab=nil
					listlabany=nil
				else
				
					list[idx]=list[idx] or {}
					list['ANY']=list['ANY'] or {}
					
					listlab=list[idx]
					listlabany=list['ANY']
				
				end

			end
			

			for d=4,#v do
			
				if v[d] and v[d]~='' then
				
					destlab[#destlab+1]=v[d]
					destlabany[#destlabany+1]=v[d]
					
					if listlab then
					
						listlab[#listlab+1]=v[d]
						listlabany[#listlabany+1]=v[d]

					end
					
				end
			
			end
		
		end
	end

	
--	dump.tree(dat)

	return dat
end



function gene(tab)

local ret=''

rnd_seed(os.time())

local rhyme={}

for i,st in ipairs(rnd_tab(tab[1])) do
	local s=rnd_tab(st)
	local space=''
	
--	print(s)

	for w in string.gfind(s, "%S+") do 
	
		if string.sub(w,1,1)=='[' then
	
			local usetab=nil
			local usetabidx
			
			for ww in string.gfind(w, "%w+") do 
			
--print(ww,tonumber(ww))

				if tonumber(ww) then
				
					local r=tonumber(ww)
					
					if not rhyme[r] then -- pick a rhyme
					
						rhyme[r]={ (rnd()%(#tab-2))+3 , rnd() }
						
					end
					
					rhyme[r][2]=rhyme[r][2]+1
					usetab=tab[rhyme[r][1]]
					usetabidx=rhyme[r][2]
					
				else
				
					if usetab then
					
						www=usetab[ww][1+(usetabidx%#(usetab[ww]))]
						
					else
						www=rnd_tab(tab[2][ww])
					end
					
					ret=ret..space..www
					
				end
			end
		else
			ret=ret..space..w
		end
		space=' '
	end
	
	ret=ret..'\n'
	
end

return ret




end