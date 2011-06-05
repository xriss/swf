

gl=require('gl')

win=require('fenestra.wrap').win()

print("poop1")

win.setup(_G) -- create and associate with this global table, eg _G.print gets replaced

print("poop2")

for i=1,1000000000 do

	j=i

end

