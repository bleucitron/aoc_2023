package.path = package.path .. ";../?.lua"

local read = require"read"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function part1()
	local times = {}
	local distances = {}

	for value in input_lines[1]:gmatch('%d+') do
		times[#times + 1] = tonumber(value)
	end
	for value in input_lines[2]:gmatch('%d+') do
		distances[#distances + 1] = tonumber(value)
	end

	local score = 1
	for i, time in pairs(times) do
		local options = 0
		for t=0,time,1 do
			local s = t * (time - t)
			if s > distances[i] then
				options = options + 1
			end
		end
		score = score * options
	end

	return score
end

print("part 1", part1())

local function part2()
	local times = {}
	local distances = {}

	for value in input_lines[1]:gmatch('%d+') do
		times[#times + 1] = value
	end
	for value in input_lines[2]:gmatch('%d+') do
		distances[#distances + 1] = value
	end

	local time_string = ''
	local distance_string = ''

	for _,t in pairs(times) do
		time_string = time_string .. t
	end
	for _,d in pairs(distances) do
		distance_string = distance_string .. d
	end

	local time = tonumber(time_string)
	local distance = tonumber(distance_string)

	local options = 0
	for t=0,time,1 do
		local score = t * (time - t)
		if score > distance then
			options = options + 1
		end
	end

	return options
end
print("part 2", part2())

