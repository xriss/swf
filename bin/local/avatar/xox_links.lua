--+-----------------------------------------------------------------------------------------------------------------+--
--
-- (C) Kriss Daniels 2005 http://www.XIXs.com
--
-- this file is now obsolete and its data is now included in the lua avatar handler /lua/fenestra/avatar.lua
--
--+-----------------------------------------------------------------------------------------------------------------+--

version="XOXLinks v2.0";

--
-- Catagorisation and availablity of xox files for use in avatar creation.
-- 
-- Currently has limited error detection so...
-- Fuck with this and things may crash.
--

--NoteToFutureSelf
--
-- In theory I can add morphs to reduce the number of base objects and increase the variety
-- so these names would then map to an object + morph target , without breaking anything, probably.
--

inmouth =
{ 
	joint					= { xox=	"inmouth_joint"			; boi=1; grl=1; };
	fag						= { xox=	"inmouth_fag"			; boi=1; grl=1; };
	pipe					= { xox=	"inmouth_pipe"			; boi=1; grl=1; };
	cigar					= { xox=	"inmouth_cigar"			; boi=1; grl=1; };
	sushi_nigiri			= { xox=	"inmouth_sushi_nigiri"	; boi=1; grl=1; };
};

inhand =
{ 
	dagger					= { xox=	"item_dagger_fist"			; boi=1; grl=1; };
	hammer					= { xox=	"item_hammer_fist"			; boi=1; grl=1; };
	pistol					= { xox=	"item_pistol_fist"			; boi=1; grl=1; };
	joint					= { xox=	"item_joint_fist"			; boi=1; grl=1; };
	fag						= { xox=	"item_fag_fist"				; boi=1; grl=1; };
	joint					= { xox=	"item_joint_fist"			; boi=1; grl=1; };
	pipe					= { xox=	"item_pipe_fist"			; boi=1; grl=1; };
	cigar					= { xox=	"item_cigar_fist"			; boi=1; grl=1; };
	bottle					= { xox=	"item_bottle_fist"			; boi=1; grl=1; };
	bottle_smashed			= { xox=	"item_bottle_smashed_fist"	; boi=1; grl=1; };
};

beard =
{ 
	default					= { xox=	"beard_circle"			; boi=1; grl=0; };
	circle					= { xox=	"beard_circle"			; boi=1; grl=0; };
	circle_point			= { xox=	"beard_circle_point"	; boi=1; grl=0; };
	tash					= { xox=	"beard_tash"			; boi=1; grl=0; };
	whiskers				= { xox=	"beard_whiskers"		; boi=0; grl=0; };
};

body =
{ 
	
	bare					= { xox=	"body_bare"				; boi=1; grl=0; };
	bare_boobs				= { xox=	"body_bare_boobs"		; boi=0; grl=1; };
	
	robox					= { xox=	"body_robox"			; boi=0; grl=0; };
	
	bodess					= { xox=	"body_bodess"			; boi=0; grl=1; };
	
	tshirt					= { xox=	"body_tshirt"			; boi=1; grl=0; };
	tshirt_boobs			= { xox=	"body_tshirt_boobs"		; boi=0; grl=1; };
	tshirt_boobs_low		= { xox=	"body_tshirt_boobs_low"	; boi=0; grl=1; };
	
	coat					= { xox=	"body_coat"				; boi=1; grl=0; };
	overalls				= { xox=	"body_overalls"			; boi=1; grl=0; };
	vest					= { xox=	"body_vest"				; boi=1; grl=0; };
	vest_boobs				= { xox=	"body_vest_boobs"		; boi=0; grl=1; };
	
	tie						= { xox=	"body_tie"				; boi=1; grl=0; };
	tie_boobs				= { xox=	"body_tie_boobs"		; boi=0; grl=1; };

	default					= { xox=	"body"					; boi=1; grl=0; };
	bare_boobs_small		= { xox=	"body_bare_boobsa"		; boi=0; grl=1; };
	bare_boobs_medium		= { xox=	"body_bare_boobsc"		; boi=0; grl=1; };
	bare_boobs_large		= { xox=	"body_bare_boobse"		; boi=0; grl=1; };
	bare_chest				= { xox=	"body_bare_chest"		; boi=1; grl=0; };
	bare_gut				= { xox=	"body_bare_gut"			; boi=1; grl=0; };
	bodess_medium			= { xox=	"body_bodessc"			; boi=0; grl=1; };
	bodess_large			= { xox=	"body_bodesse"			; boi=0; grl=1; };
	tshirt_boobs_small		= { xox=	"body_tshirt_boobsa"	; boi=0; grl=1; };
	tshirt_boobs_medium		= { xox=	"body_tshirt_boobsc"	; boi=0; grl=1; };
	tshirt_boobs_large		= { xox=	"body_tshirt_boobse"	; boi=0; grl=1; };
	tshirt_chest			= { xox=	"body_tshirt_chest"		; boi=1; grl=0; };
	tshirt_gut				= { xox=	"body_tshirt_gut"		; boi=1; grl=0; };
	tshirt_lowcut_large		= { xox=	"body_tshirt_lowcute"	; boi=0; grl=3; };
	tshirt_skinny			= { xox=	"body_tshirt_skinny"	; boi=1; grl=0; };
	
};

tail =
{ 
	default					= { xox=	"tail"					; boi=1; grl=1; };
	bunny					= { xox=	"tail_bunny"			; boi=0; grl=1; };
	devil					= { xox=	"tail_devil"			; boi=0; grl=1; };
};


ear =
{ 
	default					= { xox=	"ear"					; boi=1; grl=1; };
	big						= { xox=	"ear_big"				; boi=1; grl=1; };
	big_sticky				= { xox=	"ear_big_sticky"		; boi=1; grl=1; };
	robox					= { xox=	"ear_robox"				; boi=0; grl=0; };
};


eye =
{ 
	default					= { xox=	"eye"					; boi=1; grl=1; };
	bigbrow					= { xox=	"eye_bigbrow"			; boi=1; grl=1; };
	brow					= { xox=	"eye_brow"				; boi=0; grl=0; };
	tribrow					= { xox=	"eye_tribrow"			; boi=1; grl=1; };
	robox					= { xox=	"eye_robox"				; boi=0; grl=0; };
};


eyeball =
{ 
	default					= { xox=	"eyeball"				; boi=5; grl=5; };
	diamond					= { xox=	"eyeball_cat"			; boi=1; grl=1; };
};


foot =
{ 
	default					= { xox=	"foot"					; boi=1; grl=1; };
	bare					= { xox=	"foot_bare"				; boi=1; grl=1; };
	boot					= { xox=	"foot_boot"				; boi=1; grl=1; };
	flipflop				= { xox=	"foot_flipflop"			; boi=1; grl=1; };
	slipper					= { xox=	"foot_slipper"			; boi=1; grl=1; };
	heel					= { xox=	"foot_heel"				; boi=0; grl=1; };
	shoe					= { xox=	"foot_shoe"				; boi=1; grl=1; };
	hoof					= { xox=	"foot_hoof"				; boi=0; grl=0; };
	robox					= { xox=	"foot_robox"			; boi=0; grl=0; };
};


hair =
{ 
	topspiked_short			= { xox=	"hair_topspiked_short"		; boi=1; grl=1; };
	peak					= { xox=	"hair_peak"					; boi=1; grl=1; };
	
	bob						= { xox=	"hair_bob"					; boi=1; grl=1; };
	goth_long				= { xox=	"hair_goth_long"			; boi=1; grl=1; };
	spikey_short			= { xox=	"hair_spikey_short"			; boi=1; grl=1; };
	trihawk_short			= { xox=	"hair_trihawk_short"		; boi=1; grl=1; };
	trihawk_hi				= { xox=	"hair_trihawk_hi"			; boi=1; grl=1; };
	hedgehog				= { xox=	"hair_hedgehog"				; boi=1; grl=1; };
	afro					= { xox=	"hair_afro"					; boi=1; grl=1; };
	afro_tall				= { xox=	"hair_afro_tall"			; boi=1; grl=1; };
		
	quiff					= { xox=	"hair_quiff"				; boi=1; grl=1; };
	curl_left				= { xox=	"hair_curl_left"			; boi=1; grl=1; };
	curl_right				= { xox=	"hair_curl_right"			; boi=1; grl=1; };
};

hair_base =
{ 
	default					= { xox=	"hair"						; boi=1; grl=1; };
	bowl					= { xox=	"hair_bowl"					; boi=1; grl=1; };
};

hair_xtra =
{ 
	ponytail				= { xox=	"hair_ponytail"				; boi=1; grl=1; };
	pigtails				= { xox=	"hair_pigtails"				; boi=1; grl=1; };
	long					= { xox=	"hair_long"					; boi=1; grl=1; };
	bunches					= { xox=	"hair_bunches"				; boi=1; grl=1; };
	bang					= { xox=	"hair_bang_base"			; boi=1; grl=1; };
	bang_zigs				= { xox=	"hair_bang_zigs"			; boi=1; grl=1; };
	bang_goff				= { xox=	"hair_bang_goff"			; boi=1; grl=1; };
	bang_sidel				= { xox=	"hair_bang_sidel"			; boi=1; grl=1; };
	bang_sider				= { xox=	"hair_bang_sider"			; boi=1; grl=1; };
	bang_emol				= { xox=	"hair_bang_emol"			; boi=1; grl=1; };
	bang_emor				= { xox=	"hair_bang_emor"			; boi=1; grl=1; };
	bang_nerd				= { xox=	"hair_bang_nerd"			; boi=1; grl=1; };
	bang_hugh				= { xox=	"hair_bang_hugh"			; boi=1; grl=1; };
};

hat =
{ 
	baseball				= { xox=	"hat_baseball"				; boi=1; grl=1; };
	pirate					= { xox=	"hat_pirate"				; boi=1; grl=1; };
	kerchief				= { xox=	"hat_kerchief"				; boi=1; grl=1; };
	bunny_ears				= { xox=	"hat_bunny_ears"			; boi=1; grl=1; };
};


hand =
{ 
	default					= { xox=	"hand"					; boi=1; grl=1; };
	foot					= { xox=	"hand_foot"				; boi=0; grl=0; };
	hoof					= { xox=	"hand_hoof"				; boi=0; grl=0; };
	robox					= { xox=	"hand_robox"			; boi=0; grl=0; };
};


head =
{ 
	default					= { xox=	"head"					; boi=1; grl=1; };
	cheekbones				= { xox=	"head_cheakbones"		; boi=1; grl=1; };
	chub					= { xox=	"head_chub"				; boi=1; grl=1; };
	thin					= { xox=	"head_thin"				; boi=1; grl=1; };
	skull					= { xox=	"head_skull"			; boi=0; grl=0; };
	robox					= { xox=	"head_robox"			; boi=0; grl=0; };
	chinless				= { xox=	"head_chinless"			; boi=0; grl=1; };
};


mouth =
{ 
	default					= { xox=	"mouth"					; boi=1; grl=1; };
	bow						= { xox=	"mouth_bow"				; boi=1; grl=1; };
	bow_fat					= { xox=	"mouth_bow_fat"			; boi=1; grl=1; };
	bow_thin				= { xox=	"mouth_bow_thin"		; boi=1; grl=1; };
	fat						= { xox=	"mouth_fat"				; boi=1; grl=1; };
	thin					= { xox=	"mouth_thin"			; boi=1; grl=1; };
	beak					= { xox=	"mouth_beak"			; boi=0; grl=0; };
	squid					= { xox=	"mouth_squid"			; boi=0; grl=0; };
	jaw						= { xox=	"mouth_jaw"				; boi=0; grl=0; };
	robox					= { xox=	"mouth_robox"			; boi=0; grl=0; };
};


nose =
{ 
	default					= { xox=	"nose"					; boi=1; grl=1; };
	small					= { xox=	"nose_small"			; boi=1; grl=1; };
	small_up				= { xox=	"nose_small_up"			; boi=1; grl=1; };
	snub					= { xox=	"nose_snub"				; boi=1; grl=1; };
	wide					= { xox=	"nose_wide"				; boi=1; grl=1; };
	wide_up					= { xox=	"nose_wide_up"			; boi=1; grl=1; };
	clown					= { xox=	"nose_clown"			; boi=0; grl=0; };
	snout					= { xox=	"nose_snout"			; boi=0; grl=0; };
	robox					= { xox=	"nose_robox"			; boi=0; grl=0; };
};


specs =
{ 
	default					= { xox=	"specs"					; boi=1; grl=1; };
	round					= { xox=	"specs_round"			; boi=1; grl=1; };
	eyepatch_left			= { xox=	"specs_eyepatch_left"	; boi=1; grl=1; };
	eyepatch_right			= { xox=	"specs_eyepatch_right"	; boi=1; grl=1; };
};


