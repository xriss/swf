

require "dump"

require "FeatData"


for i,v in ipairs(FeatData_idxs) do
	print(i,v)
	dump.tree_all(FeatData[v],-1)
	print("")
end






