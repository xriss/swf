--+-----------------------------------------------------------------------------------------------------------------+--
--
--	(C) Shi + Kriss Daniels 2007/2008 [ http://esyou.com/sblog.php + http://www.XIXs.com ]
-- 	SbLOG lets artists blog as easy as bloggers blog.
--	SbLOG is smart screenshot blogging for everyone.
--
--	How does SbLOG work?
--	SbLOG sends a message containing your screenshot using your GMAIL account.
--	SbLOG works with any blogging service that supports email hosting.
--	This includes Flickr, Blogger, Livejournal (paid account) and more.
--
--+-----------------------------------------------------------------------------------------------------------------+--

local cfg={}

-- where to email blog to (simplest option) and if set overrides the ftp + lj
-- CHANGE THIS TO YOUR SETTING

cfg.email = "sblog@blogger.com"

-- use gmail to send mail, this needs a google account email address and password
-- CHANGE THIS TO YOUR SETTING

cfg.gmail_user = "myname@gmail.com"
cfg.gmail_password = "secret"


-- where to store local copys of each screenshot and blog post (be careful with vistapoops)
-- DO NOT CHANGE THIS AS THIS IS WHERE YOUR IMAGES AND POSTS ARE BACKED UP LOCALLY. :}

cfg.save_dir	=	"./sblog/"


sblog_cfg=cfg

