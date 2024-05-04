package.path = package.path .. ";../?.lua"

local read = require "read"
local utils = require "utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_line = read.text_from(file)
input_line = input_line:gsub('%s+', '')

local function hash(s)
	local result = 0

	for c in s:gmatch('.') do
		if string.char(10) ~= c then
			local code = string.byte(c)
			result = ((result + code) * 17) % 256
		end
	end

	return result
end

local function part1(line)
	local steps = utils.split(line, ',')
	local result = 0
	for _, step in ipairs(steps) do
		local hashed = hash(step)
		result = result + hashed
	end

	return result
end

print("part 1", part1(input_line))

local function part2(line)
	local steps = utils.split(line, ',')
	local result = 0
	local box_by_hash = {}

	for _, step in ipairs(steps) do
		local removal = step:find('-')
		local split = (removal and utils.split(step, '-')) or utils.split(step, '=')
		local label = split[1]
		local focal = split[2]

		local box_number = hash(label)

		local box = box_by_hash[box_number] or {}
		box_by_hash[box_number] = box
		local _, position = utils.find(box, function(e)
			return e.label == label
		end)

		if removal then
			if position then
				table.remove(box, position)
			end
		else
			local lens = { label = label, focal = focal }
			if position then
				box[position] = lens
			else
				table.insert(box, lens)
			end
		end
	end

	for hash_id, b in pairs(box_by_hash) do
		for position, lens in ipairs(b) do
			result = result + (hash_id + 1) * position * lens.focal
		end
	end
	return result
end
print("part 2", part2(input_line))
