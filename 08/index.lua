package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example-bis.txt'
local input_lines = read.lines_from(file)

local first_line = table.remove(input_lines, 1)

local function part1(lines)
	local directions_by_node = {}

	for _,line in pairs(lines) do
		if #line > 0 then
			local node, left, right = string.match(line, "(%u+) = .(%u+), (%u+).")
			directions_by_node[node] = { R = right, L = left }
		end
	end

	local current = 'AAA'
	local i = 0

	while current ~= 'ZZZ' do
		i = i + 1
		local index = (i - 1) % #first_line + 1
		local direction = string.sub(first_line, index, index)
		current = directions_by_node[current][direction]
	end

	return i
end
print("part 1", part1(input_lines))

local function part2(lines)
	local directions_by_node = {}

	local current_nodes = {}
	for _,line in pairs(lines) do
		if #line > 0 then
			local node, left, right = string.match(line, "(%u+) = .(%u+), (%u+).")
			directions_by_node[node] = { R = right, L = left }

			if utils.endsWith(node, 'A') then
				table.insert(current_nodes, node)
			end
		end
	end

	local output = 1

	for _,start in pairs(current_nodes) do
		local i = 0
		local current = start
		while not utils.endsWith(current, 'Z') do
			i = i + 1
			local index = (i - 1) % #first_line + 1
			local direction = string.sub(first_line, index, index)
			current = directions_by_node[current][direction]
		end
		output = utils.ppcm(output, i)
	end

	return output
end
print("part 2", part2(input_lines))

