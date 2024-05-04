package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function compute(lines, size)
	size = size or 2

	local galaxies = {}
	local empty_columns = {}
	local empty_lines = {}

	for i,line in pairs(lines) do
		local chars = {}
		table.insert(empty_lines, i)

		for c in line:gmatch('.') do
			table.insert(chars, c)
		end

		for j,char in pairs(chars) do
			if i == 1 then
				table.insert(empty_columns, j)
			end

			if (char == '#') then
				local pos_i = utils.indexOf(empty_lines, i)
				local pos_j = utils.indexOf(empty_columns, j)
				if pos_j then
					table.remove(empty_columns, pos_j)
				end
				if pos_i then
					table.remove(empty_lines, pos_i)
				end

				table.insert(galaxies, {i=i, j=j})
			end
		end
	end

	for _,galaxy in pairs(galaxies) do
		local dj = 0
		for _,column in pairs(empty_columns) do
			if column < galaxy.j then
				dj = dj + size - 1
			end
		end
		galaxy.j = galaxy.j + dj

		local di = 0
		for _,line in pairs(empty_lines) do
			if line < galaxy.i then
				di = di + size - 1
			end
		end
		galaxy.i = galaxy.i + di
	end

	local distance = 0
	for i,galaxy in pairs(galaxies) do
		for j = i+1,#galaxies do
			local other = galaxies[j]

			distance = distance + math.abs(other.j - galaxy.j) + math.abs(other.i - galaxy.i)
		end
	end

	return distance
end
local function part1(lines)
	return compute(lines)
end
print("part 1", part1(input_lines))

local function part2(lines)
	return compute(lines, 1000000)
end
print("part 2", part2(input_lines))

