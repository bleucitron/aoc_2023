package.path = package.path .. ";../?.lua"

local read = require"read"

local file = 'input.txt'
--local file = 'example.txt'
local lines = read.lines_from(file)

local function part1(lines)
	local max_red = 12
	local max_green = 13
	local max_blue = 14

	local total = 0
	for _,line in pairs(lines) do

		local id = line:match("Game (%d+):")
		print("Game", id)
		local is_valid = true

		for nb in line:gmatch('(%d+) red') do
			if tonumber(nb) > max_red then
				is_valid = false
			end
			if not is_valid then
				break
			end
		end
		if not is_valid then
			goto continue
		end

		for nb in line:gmatch('(%d+) green') do
			if tonumber(nb) > max_green then
				is_valid = false
			end
			if not is_valid then
				break
			end
		end
		if not is_valid then
			goto continue
		end

		for nb in line:gmatch('(%d+) blue') do
			if tonumber(nb) > max_blue then
				is_valid = false
			end
			if not is_valid then
				break
			end
		end
		if not is_valid then
			goto continue
		end

		print('is valid')
		total = total + id
		::continue::
	end

	return total
end
print("part 1", part1(lines))


local function part2(lines)
	local total_power = 0
	for _,line in pairs(lines) do

		local id = line:match("Game (%d+):")
		print("Game", id)

		local min_red = 0
		for nb in line:gmatch('(%d+) red') do
			min_red = math.max(tonumber(nb) or 0, min_red)
		end

		local min_green = 0
		for nb in line:gmatch('(%d+) green') do
			min_green = math.max(tonumber(nb) or 0, min_green)
		end

		local min_blue = 0
		for nb in line:gmatch('(%d+) blue') do
			min_blue = math.max(tonumber(nb) or 0, min_blue)
		end

		local power = min_red * min_blue * min_green
		total_power = total_power + power
	end

	return total_power
end
print("part 2", part2(lines))

