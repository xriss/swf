--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2007 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--

-- config
dofile( "lua/sblog/sblog.cfg.lua")


local socket = require("socket")
local md5    = require("md5")
local mime   = require("mime")
local ltn12  = require("ltn12")

-- need tweaked smtp to send via the google
local smtp = require("socket.ssl_smtp")
smtp.SERVER = "smtp.gmail.com"
smtp.PORT = 465
smtp.SSL_PARAMS = {
   mode = "client",
   protocol = "sslv3",
   key = "./ssl_certs/clientAkey.pem",
   certificate = "./ssl_certs/clientA.pem",
--   cafile = "./ssl_certs/rootA.pem",
   verify = {"none"},
   options = {"all", "no_sslv2"},
}

local http   = require("socket.http")
local ftp    = require("socket.ftp")


local grd   = grd

-----------------------------------------------------------------------------
--
-- function to squirt out dump information
--
-----------------------------------------------------------------------------
function dbg(...)
local fp=io.open("dbg.txt","a")
	fp:write(unpack(arg))
	io.close(fp)
end


-----------------------------------------------------------------------------
--
-- split a string into a table
--
-----------------------------------------------------------------------------
function str_split(div,str)

  if (div=='') then return false end
  
  local pos,arr = 0,{}
  
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  
  if pos~=0 then
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  else
	table.insert(arr,str) -- return entire string
  end
  
  
  return arr
end



-----------------------------------------------------------------------------
--
-- This function is called to perform a screenshot, upload and post
--
-- use
--
-- sblog_blogpost
-- sblog_screenshot
-- sblog_getwh
--
-- to get a text blogpost and a grd screenshot (also width and height)
--
-----------------------------------------------------------------------------
function sblogit()

--dbg("sblog it baby\n")

local w,h=sblog_getwh()

local nw,nh

local tim

local sb

local r,e

	nw=500
	nh=math.floor(h*nw/w)
			
	sb={}
	sb.time=os.time()
	sb.filename=os.date("%Y%m%d%H%M",sb.time)
	
	sb.rawpost=string.gsub(sblog_blogpost(), "\r", "") -- remove all \r that windows lovingly creates.
	
local x1,y1,x2,y2 = sblog_rect()
	sb.popup={ width=x2-x1 , height=y2-y1 , top=y1 , left=x1 }
	
	sb.image=grd.create("GRD_FMT_U8_BGRA",w,h,1)
	sblog_screenshot(sb.image)
	
	sb.thumb=grd.create(sb.image)
	sb.thumb:scale(nw,nh,1)

--	dbg(sb.rawpost)

	local_build(sb)
	
	if sblog_cfg.email then -- simple email post
		
		r,e = post_to_blogger(sb)

		if e then
			sblog_balloon(e)
		else
			sblog_balloon("Congratulations on a sucessful SbLOGing experience!")
		end
		
	else -- ftp + lj post
		
		ftp_upload(sb)
		post_to_lj(sb)

	end
end


-----------------------------------------------------------------------------
--
-- create everything we need in the local file system
--
-----------------------------------------------------------------------------
function local_build(sb)

local fp
local lines

	sb.html_name=sb.filename..".html"	
	sb.html_post_name=sb.filename..".post.html"	
	sb.image_name=sb.filename..".png"	
	sb.thumb_name=sb.filename.."."..(sb.thumb.width).."x.png"
	sb.rawpost_name=sb.filename..".raw.txt"
	
	
	lines=str_split("\n",sb.rawpost)
	
	
	local post=""
	
	for i,v in ipairs(lines) do
	
		if i==1 then

			sb.title=v
		
		else
		
			post=post..v.."\n"
		
		end
		

	end
	
	sb.post=post
	sb.title=sb.title or ""

	
--	dbg("\n")
--	dbg("TITLE=",sb.title,"\n")
--	dbg("POST=",post,"\n")
	
local 	url_image=sblog_cfg.url_image or ""
local 	url_html=sblog_cfg.url_html or ""

--local 	url_image=""
--local 	url_html=""

local text_width=150
local css_zero="border:none;outline:none;margin:0px;padding:0px;"
	
	sb.html_post=
	"<table style='"..css_zero.."width:"..(sb.thumb.width+text_width).."px;height:"..sb.thumb.height.."px;'><tr>\n"..
	"<td style='"..css_zero.."width:"..sb.thumb.width.."px;height:"..sb.thumb.height.."px;'>"..
	"<a href='"..url_image..sb.html_name.."'><img style='"..css_zero.."' src='"..url_image..sb.thumb_name.."'/></a>"..
	"</td>\n<td style='"..css_zero.."width:"..text_width.."px;height:"..sb.thumb.height.."px;'>"..post.."</td></tr></table>"
	
--	sb.html=
--	"<div style='"..css_zero.."width:"..sb.image.width.."px;height:"..sb.image.height.."px;'>"..
--	"<img style='"..css_zero.."' src='"..url_image..sb.image_name.."'/>"..
--	"</div>"

	sb.html=[[
<html>
<head>

<script language="JavaScript1.2">

// Script Source: CodeLifter.com
// Copyright 2003
// Do not remove this header

isIE=document.all;
isNN=!document.all&&document.getElementById;
isN4=document.layers;
isHot=false;

function ddInit(e){
  topDog=isIE ? "BODY" : "HTML";
  whichDog=isIE ? document.all.theLayer : document.getElementById("theLayer");  
  hotDog=isIE ? event.srcElement : e.target;  
  while (hotDog.id!="titleBar"&&hotDog.tagName!=topDog){
    hotDog=isIE ? hotDog.parentElement : hotDog.parentNode;
  }  
  if (hotDog.id=="titleBar"){
    offsetx=isIE ? event.clientX : e.clientX;
    offsety=isIE ? event.clientY : e.clientY;
    nowX=parseInt(whichDog.style.left);
    nowY=parseInt(whichDog.style.top);
    ddEnabled=true;
    document.onmousemove=dd;
  }
}

function dd(e){
  if (!ddEnabled) return;
  whichDog.style.left=isIE ? nowX+event.clientX-offsetx : nowX+e.clientX-offsetx; 
  whichDog.style.top=isIE ? nowY+event.clientY-offsety : nowY+e.clientY-offsety;
  return false;  
}

function ddN4(whatDog){
  if (!isN4) return;
  N4=eval(whatDog);
  N4.captureEvents(Event.MOUSEDOWN|Event.MOUSEUP);
  N4.onmousedown=function(e){
    N4.captureEvents(Event.MOUSEMOVE);
    N4x=e.x;
    N4y=e.y;
  }
  N4.onmousemove=function(e){
    if (isHot){
      N4.moveBy(e.x-N4x,e.y-N4y);
      return false;
    }
  }
  N4.onmouseup=function(){
    N4.releaseEvents(Event.MOUSEMOVE);
  }
}

function hideMe(){
  if (isIE||isNN) whichDog.style.visibility="hidden";
  else if (isN4) document.theLayer.visibility="hide";
}

function showMe(){
  if (isIE||isNN) whichDog.style.visibility="visible";
  else if (isN4) document.theLayer.visibility="show";
}

document.onmousedown=ddInit;
document.onmouseup=Function("ddEnabled=false");

</script>

</head>

<body style='border:none;outline:none;margin:0px;padding:0px;'>

<div id="theLayer" style="padding:4px;position:absolute;width:]]..sb.popup.width..[[px;height:]]..sb.popup.height..[[px;left:]]..sb.popup.left..[[px;top:]]..sb.popup.top..[[px;visibility:visible;background-color:#000000;color:#ffffff;font-family: Verdana, Tahoma, 'Myriad Web', Syntax, sans-serif;font-size: 12px;">
<div style="position:relative">
  
<div id="titleBar" style="overflow:hidden;cursor:move;position:absolute;width:]]..sb.popup.width..[[px;height:20px;left:0px;top:0px;background-color:#404040;">

	<div width="100%" onSelectStart="return false">
		<div width="100%" onMouseover="isHot=true;if (isN4) ddN4(theLayer)" onMouseout="isHot=false">
			<b style="position:absolute;left:2px;top:2px;" >]].. sb.title ..[[</b>
		</div>
	</div>
	
</div>
  
<div style="overflow:auto;position:absolute;width:]]..sb.popup.width..[[px;height:]]..(sb.popup.height-20)..[[px;left:0px;top:20px;color:#cccccc;">
]].. post ..[[</div>

</div>
</div>

<img style='border:none;outline:none;margin:0px;padding:0px;' src=']]..	sb.image_name ..[['/>

</body>
</html>]]

	sb.image:save(sblog_cfg.save_dir..sb.image_name)
	sb.thumb:save(sblog_cfg.save_dir..sb.thumb_name)
	
	fp=io.open(sblog_cfg.save_dir..sb.rawpost_name,"w")
	fp:write(sb.rawpost)
	io.close(fp)
	
	fp=io.open(sblog_cfg.save_dir..sb.html_post_name,"w")
	fp:write(sb.html_post)
	io.close(fp)
	
	fp=io.open(sblog_cfg.save_dir..sb.html_name,"w")
	fp:write(sb.html)
	io.close(fp)
	
end




function ftp_put_retry(tab,filename)

local r,e,c

	r=nil
	c=0
	while r==nil do
	
		if filename then -- need to open a new file for each call
			tab.source=ltn12.source.file( io.open(filename,"rb") )
		end

		r,e = ftp.put(tab)

		if r==nil then
			c=c+1	
			if c>20 then break end
			sblog_balloon("ftp error ! "..c.." : "..e)	
		end

	end

end

-----------------------------------------------------------------------------
--
-- ftp upload files that need to be visible from the internets
--
-----------------------------------------------------------------------------
function ftp_upload(sb)

ftp_put_retry({

host=sblog_cfg.ftp_image_host,
path=sblog_cfg.ftp_image_dir..sb.image_name,
user=sblog_cfg.ftp_image_name,
password=sblog_cfg.ftp_image_pass,
type="i",

},sblog_cfg.save_dir..sb.image_name)

ftp_put_retry({

host=sblog_cfg.ftp_image_host,
path=sblog_cfg.ftp_image_dir..sb.thumb_name,
user=sblog_cfg.ftp_image_name,
password=sblog_cfg.ftp_image_pass,
type="i",

},sblog_cfg.save_dir..sb.thumb_name)

ftp_put_retry{

host=sblog_cfg.ftp_html_host,
path=sblog_cfg.ftp_html_dir..sb.html_post_name,
user=sblog_cfg.ftp_html_name,
password=sblog_cfg.ftp_html_pass,
type="i",
source=ltn12.source.string(sb.html_post)

}

ftp_put_retry{

host=sblog_cfg.ftp_html_host,
path=sblog_cfg.ftp_html_dir..sb.html_name,
user=sblog_cfg.ftp_html_name,
password=sblog_cfg.ftp_html_pass,
type="i",
source=ltn12.source.string(sb.html)

}

end

-----------------------------------------------------------------------------
--
-- split a string into a table
--
-----------------------------------------------------------------------------
function str_split(div,str)

  if (div=='') then return false end
  
  local pos,arr = 0,{}
  
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  
  if pos~=0 then
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  else
	table.insert(arr,str) -- return entire string
  end
  
  
  return arr
end


-----------------------------------------------------------------------------
--
-- Make a blog post to lj
--
-----------------------------------------------------------------------------
function post_to_lj(sb)

local head=
[[<?xml version="1.0"?>
<methodCall>
	<methodName>LJ.XMLRPC.postevent</methodName>
	<params>
		<param>
			<value>
				<struct>
]]
local tail=
[[				</struct>
			</value>
		</param>
	</params>
</methodCall>
]]

do
   local escapes = {["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;"}
   local function escape(c) return escapes[c] end
   function html_escape(str) return (str:gsub("[&<>]", escape)) end
end


local tab=
{

{name="username",value=sblog_cfg.blog_lj_name,type="string"},
{name="password",value=sblog_cfg.blog_lj_pass,type="string"},
--{name="usejournal",value=sblog_cfg.blog_lj_journal,type="string"},

{name="event",value=html_escape(sb.html_post),type="string"},
{name="subject",value=html_escape(sb.title),type="string"},
{name="lineendings",value="pc",type="string"},

{name="year",value=os.date("%Y",sb.time),type="int"},
{name="mon",value=os.date("%m",sb.time),type="int"},
{name="day",value=os.date("%d",sb.time),type="int"},
{name="hour",value=os.date("%H",sb.time),type="int"},
{name="min",value=os.date("%M",sb.time),type="int"},

}

if sblog_cfg.blog_lj_private then
	table.insert(tab,{name="security",value="private",type="string"})
end

local xml
local val

	for ii,vv in ipairs( str_split(",",sblog_cfg.blog_lj_journal) ) do -- loop through each journal name seperated by a ,

		xml=head

		for i,v in ipairs(tab) do
		
		
			val='<member><name>'..v.name..'</name><value><'..v.type..'>'..v.value..'</'..v.type..'></value></member>\n'
			
			xml=xml..val
		
		end
		
		xml=xml..'<member><name>usejournal</name><value><string>'..vv..'</string></value></member>\n'
			
		xml=xml..tail


--	dbg(xml,"\n")

--dbg("sending\n")	

local b={}

http.request{ url="http://www.livejournal.com/interface/xmlrpc" , method="POST" , source=ltn12.source.string(xml) , 
		headers={["Content-type"]="text/xml",["content-length"]=string.len(xml)} , sink=ltn12.sink.table(b) }

--dbg("sent\n")	

--	dbg(table.concat(b),"\n")

	end

end

-----------------------------------------------------------------------------
--
-- Make a blog post to blogger by email
--
-----------------------------------------------------------------------------
function post_to_blogger(sb)

	if not sblog_cfg.email then return end

-- creates a source to send a message with two parts. The first part is 
-- plain text, the second part is a PNG image, encoded as base64.
local source = smtp.message{
  headers = {
     -- Remember that headers are *ignored* by smtp.send. 
     from = "assblaster <"..sblog_cfg.gmail_user..">",
     to = "<"..sblog_cfg.email..">",
     subject = sb.title
  },
  body = {
--    preamble = "",
    -- first part: no headers means plain text, us-ascii.
    -- The mime.eol low-level filter normalizes end-of-line markers.
    [1] = { 
      headers = {
        ["content-type"] = 'text/html',
      },
      body = mime.eol(0, sb.post )
    },
    -- second part: headers describe content to be a png image, 
    -- sent under the base64 transfer content encoding.
    -- notice that nothing happens until the message is actually sent. 
    -- small chunks are loaded into memory right before transmission and 
    -- translation happens on the fly.
    [2] = { 
      headers = {
        ["content-type"] = 'image/png; name="'..sb.image_name..'"',
        ["content-disposition"] = 'attachment; filename="'..sb.image_name..'"',
        ["content-description"] = ''..sb.image_name..'',
        ["content-transfer-encoding"] = "BASE64"
      },
      body = ltn12.source.chain(
        ltn12.source.file(io.open( sblog_cfg.save_dir..sb.image_name , "rb")),
        ltn12.filter.chain(
          mime.encode("base64"),
          mime.wrap()
        )
      )
    },
--    epilogue = ""
  }
}

r, e = smtp.send{
  user = sblog_cfg.gmail_user,
  password = sblog_cfg.gmail_password,
  from = "<"..sblog_cfg.gmail_user..">",
  rcpt = "<"..sblog_cfg.email..">",
  source = source
}

	return r,e
end
