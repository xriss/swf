--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
--+-----------------------------------------------------------------------------------------------------------------+--





------------------------------------------------------------------------
--
-- Create a tween animation table
--
------------------------------------------------------------------------
function soul.create_tweens()

local tweens

local tween_mask="*CULHABTFFWWHHMNHEEIIBB"

-- lua mask array string
-- a . or 0 means not used, 0.0 weight
-- numbers 1-9 mean 0.1 to 0.9 weight
-- any other letters mean 1.0 weight, so can be used to make the string easier to read by a human
--
-- 100% default string == "*CULHABTFFWWHHMNHEEIIBB"
--
--  0 * Handle
--  1 C Center
--  2 U Upper
--  3 L Lower
--  4 H Head
--  5 A Arms
--  6 B Body
--  7 T Tail
--  8 F Foot left
--  9 F Foot right
-- 10 W Wrist left
-- 11 W Wrist right
-- 12 H Hand left
-- 13 H Hand right
-- 14 M Mouth 
-- 15 N Nose
-- 16 H Hair
-- 17 E Ear left
-- 18 E Ear right
-- 19 I Eye left
-- 20 I Eye right
-- 21 B eyeBall left
-- 22 B eyeBall right


	tweens={}

	tweens[1]={blend=0,mask=tween_mask}
	tweens[2]={blend=0,mask=tween_mask}
	tweens[3]={blend=0,mask=tween_mask}
	tweens[4]={blend=0,mask=tween_mask}
	tweens[5]={blend=0,mask=tween_mask}
	tweens[6]={blend=0,mask=tween_mask}
	tweens[7]={blend=0,mask=tween_mask}
	tweens[8]={blend=0,mask=tween_mask}

	tweens.frame=0

	return tweens

end


------------------------------------------------------------------------
--
-- Initalise a tween with a given anims ID/name and length,
-- doesnt change any other values
--
------------------------------------------------------------------------
function soul.set_tween(tween,name)

	tween.name=name
	tween.ID=soul.info.anims[name]
	tween.length=soul.info.animframes[tween.ID]

end



------------------------------------------------------------------------
--
-- Pick a random part of a given group and sex
--
--
-- group is the name of the group
-- type is grl or boi
--
------------------------------------------------------------------------
function soul.random_part(group,sex)

local weight
local part


-- count how many parts we have available

	weight=0

	for i,p in ipairs(soul.info.groups[group]) do

		if sex=="boi" then weight=weight+p.boi end
		if sex=="grl" then weight=weight+p.grl end

	end


-- if we found some possible parts, pick one

	if weight>0 then

		do
		local find,found

			find=math.random(weight)
			found=0

			for i,p in ipairs(soul.info.groups[group]) do

				if sex=="boi" then found=found+p.boi end
				if sex=="grl" then found=found+p.grl end

				if found>=find then part=p break end

			end
		end

		return part 

	end


-- we found nothing

	return nil 

end






------------------------------------------------------------------------
--
-- Pick a fully random soul of the given sex
--
------------------------------------------------------------------------
function soul.random(sex)

	if sex==nil then
		if math.random(100)<=50 then sex="grl" else sex="boi" end
	end

	local ret={}

-- some colors to pick from

	local colors={}

-- normal(ish) flesh tones
	colors.flesh=	{
						{ argb="0xffffaaaa"; spec="0xff4f2c00"; gloss="0.000000"; };
						{ argb="0xffeebb99"; spec="0xff353333"; gloss="0.000000"; };
						{ argb="0xffeebb99"; spec="0xff362c50"; gloss="0.000000"; };
						{ argb="0xffdd9977"; spec="0xff660000"; gloss="0.000000"; };
						{ argb="0xffff9977"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xff000000"; spec="0xffcc6600"; gloss="0.000000"; };
						{ argb="0xffaa6644"; spec="0xffcc6600"; gloss="0.000000"; };
						{ argb="0xffaa6644"; spec="0xff666600"; gloss="0.000000"; };
						{ argb="0xff660000"; spec="0xff296600"; gloss="0.000000"; };
					}

-- normal(ish) hair tones
	colors.hair=	{
						{ argb="0xffffaaaa"; spec="0xff4f2c00"; gloss="0.000000"; }
					}

-- earthy tones
	colors.earth=	{
						{ argb="0xffffaaaa"; spec="0xff4f2c00"; gloss="0.000000"; }
					}

-- bright colors
	colors.primary=	{
						{ argb="0xff000000"; spec="0xff444444"; gloss="0.000000"; };
						{ argb="0xffffffff"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xffff0000"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xffff8800"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xffffff00"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xff00ff00"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xff008888"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xff0000ff"; spec="0xff000000"; gloss="0.000000"; };
						{ argb="0xff8800ff"; spec="0xff000000"; gloss="0.000000"; };
					}

-- shiny colors
	colors.shiny=	{
						{ argb="0xffffaaaa"; spec="0xff4f2c00"; gloss="0.000000"; }
					}


	local function random( t )	return t[ math.random( table.getn(t) ) ] end

	local function random_color( t , min , max )

		local base,argb,spec

		if min==nil then min=-16 end
		if max==nil then max= 16 end

		base = t[ math.random( table.getn(t) ) ]

		argb=xtra.str2argb(base.argb)
		spec=xtra.str2argb(base.spec)

		argb.r=argb.r+math.random(min,max)
		argb.g=argb.g+math.random(min,max)
		argb.b=argb.b+math.random(min,max)

		spec.r=spec.r+math.random(min,max)
		spec.g=spec.g+math.random(min,max)
		spec.b=spec.b+math.random(min,max)

		return { argb=xtra.argb2str(argb); spec=xtra.argb2str(spec); gloss=base.gloss; }

	end

	local function tint_argb( base , r,g,b )

		local argb

		argb=xtra.str2argb(base.argb)

		argb.r=argb.r+r
		argb.g=argb.g+g
		argb.b=argb.b+b

		return { argb=xtra.argb2str(argb); spec=base.spec; gloss=base.gloss; }

	end

	local function tint_spec( base , r,g,b )

		local argb

		spec=xtra.str2argb(base.spec)

		spec.r=spec.r+r
		spec.g=spec.g+g
		spec.b=spec.b+b

		return { argb=base.argb; spec=xtra.argb2str(spec); gloss=base.gloss; }

	end

-- set up blank tables

	ret.parts={}
	ret.surfaces={}

	for i,v in ipairs(soul.info.parts) do

		ret.parts[v]={}

	end

	for i,v in ipairs(soul.info.surfaces) do

		ret.surfaces[v]={ argb="0xffffffff"; spec="0x00000000"; gloss="0.000000"; }

	end

-- roll all the default parts we can null them out later if we wish

	ret.parts.body[1]			=soul.random_part("body",sex)

	ret.parts.head[1]			=soul.random_part("head",sex)

	ret.parts.mouth[1]			=soul.random_part("mouth",sex)

	ret.parts.nose[1]			=soul.random_part("nose",sex)

	ret.parts.left_hand[1]		=soul.random_part("hand",sex)
	ret.parts.right_hand[1]		=ret.parts.left_hand[1]

	ret.parts.left_foot[1]		=soul.random_part("foot",sex)
	ret.parts.right_foot[1]		=ret.parts.left_foot[1]

	ret.parts.left_eye[1]		=soul.random_part("eye",sex)
	ret.parts.right_eye[1]		=ret.parts.left_eye[1]

	ret.parts.left_eyeball[1]	=soul.random_part("eyeball",sex)
	ret.parts.right_eyeball[1]	=ret.parts.left_eyeball[1]

	ret.parts.left_ear[1]		=soul.random_part("ear",sex)
	ret.parts.right_ear[1]		=ret.parts.left_ear[1]


-- do the bits that may or may not be there

	if math.random(100)<=10 then -- chance of beard

		ret.parts.mouth[2]			=soul.random_part("beard",sex)

	end

	if math.random(100)<=10 then -- chance of fag/etc

		ret.parts.mouth[3]			=soul.random_part("inmouth",sex)

	end

	if math.random(100)<=15 then -- chance of fag/etc

		ret.parts.mouth[3]			=soul.random_part("inmouth",sex)

	end


	if math.random(100)<=80 then -- chance of hair

		if math.random(100)<=20 then -- chance of base

			ret.parts.head[2]			=soul.random_part("hair_base",sex)

			if math.random(100)<=50 then -- chance of xtra

				ret.parts.head[3]		=soul.random_part("hair_xtra",sex)
			end

			if math.random(100)<=20 then -- chance of hat

				ret.parts.head[4]		=soul.random_part("hat",sex)
			end

		else

			ret.parts.head[2]			=soul.random_part("hair",sex)

			if math.random(100)<=20 then -- chance of xtra

				ret.parts.head[3]		=soul.random_part("hair_xtra",sex)
			end

		end

	else

		if math.random(100)<=20 then -- chance of hat

			ret.parts.head[4]			=soul.random_part("hat",sex)
		end

	end

	if math.random(100)<=20 then -- chance of specs

		ret.parts.nose[2]			=soul.random_part("specs",sex)

	end

	if math.random(100)<=10 then -- chance of tail

		ret.parts.tail[1]			=soul.random_part("tail",sex)

	end

-- apply some coloring

	ret.surfaces.skin=random_color(colors.flesh,-32,32)
	ret.surfaces.lips=tint_argb(ret.surfaces.skin,-32,-32,-32)
	ret.surfaces.nipples=tint_argb(ret.surfaces.skin,-32,-32,-32)

	ret.surfaces.body=random_color(colors.primary,-64,64)
	ret.surfaces.bodyhi=tint_argb( ret.surfaces.body , math.random(16,128)   , math.random(16,128)   , math.random(16,128)   )
	ret.surfaces.bodylo=tint_argb( ret.surfaces.body , math.random(-128,-16) , math.random(-128,-16) , math.random(-128,-16) )

	ret.surfaces.foot=random_color(colors.primary,-64,64)
	ret.surfaces.socks=  tint_argb( ret.surfaces.foot , math.random(16,128)   , math.random(16,128)   , math.random(16,128)   )
	ret.surfaces.sole=   tint_argb( ret.surfaces.foot , math.random(-128,-16) , math.random(-128,-16) , math.random(-128,-16) )
	ret.surfaces.toecaps=tint_argb( ret.surfaces.foot , math.random(-128,128) , math.random(-128,128) , math.random(-128,128) )

	ret.surfaces.specs=random_color(colors.primary,-64,64)

	ret.surfaces.iris=random_color(colors.primary,-255,-128)
	ret.surfaces.eye={ argb="0xffaaaaaa"; spec="0xffffffff"; gloss="0.125"; };
	ret.surfaces.iris.spec="0xffffffff";
	ret.surfaces.iris.gloss="0.125";

	ret.surfaces.hair=random_color(colors.primary,-64,64)
	ret.surfaces.hairhi=tint_argb( ret.surfaces.hair , math.random(16,128)   , math.random(16,128)   , math.random(16,128)   )
	ret.surfaces.hairlo=tint_argb( ret.surfaces.hair , math.random(-128,-16) , math.random(-128,-16) , math.random(-128,-16) )
	ret.surfaces.eyebrows=ret.surfaces.hairlo
	ret.surfaces.beard=ret.surfaces.hairlo

	return ret
end


