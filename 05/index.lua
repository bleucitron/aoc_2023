package.path = package.path .. ";../?.lua"

local read = require"read"
local utils= require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local first_line = table.remove(input_lines, 1)
local seeds = utils.split(utils.split(first_line, ':')[2])
local real_seeds = {}

for position,seed in pairs(seeds) do
	local index = math.floor((position-1) / 2) + 1

	if real_seeds[index] then
		real_seeds[index].range = tonumber(seed)
	else
		real_seeds[index] = {from = tonumber(seed)}
	end
end

local blocks = {}

for _, line in pairs(input_lines) do
	if (string.find(line, ':')) then
		blocks[#blocks + 1] = {}
	elseif #line > 1 then
		local numbers = utils.split(line)
		local from = numbers[2]
		local to = numbers[1]
		local range = numbers[3]
		local o = {}
		o.from = tonumber(from)
		o.to = tonumber(to)
		o.range = tonumber(range)
		table.insert(blocks[#blocks], o)
	end
end

local function part1()
	local locations = {}
	for i, seed in pairs(seeds) do
		local next = tonumber(seed)
		for _, block in pairs(blocks) do
			for _, entry in pairs(block) do
				if next >= entry.from and next < entry.from + entry.range then
					next = next - entry.from + entry.to
					break
				end
			end
		end
		locations[i] = next
	end
	return math.min(table.unpack(locations))
end
print("part 1", part1())

local function part2()
	local last_block = blocks[#blocks]
	table.sort(last_block, function (o1, o2) return o1.to < o2.to end)

	local max_location = last_block[#last_block].to + last_block[#last_block].range

	for location=0,max_location,1 do
		local output = location
		for j=#blocks,1,-1 do
			local block = blocks[j]

			for _, entry in pairs(block) do
				if output >= entry.to and output < entry.to + entry.range then
					output = output - entry.to + entry.from
					break
				end
			end
		end
		for _,seed in pairs(real_seeds) do
			if output >= seed.from and output < seed.from + seed.range then
				return location
			end
		end
	end
end
print("part 2", part2())

