package.path = package.path .. ";../?.lua"

local read = require "read"
local utils = require "utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function compute(lines, start_x, start_y, direction)
	start_x = start_x or 1
	start_y = start_y or 1
	direction = direction or '>'

	local max_x = #(lines[1])
	local max_y = #lines

	local toHandle = {}
	local energized = {}

	table.insert(toHandle, { position = start_x .. '-' .. start_y })

	while #toHandle > 0 do
		local spot = table.remove(toHandle, 1)
		local position = spot.position
		local previous = spot.previous or direction

		local coords = utils.split(position, '-')
		local x = tonumber(coords[1])
		local y = tonumber(coords[2])

		local line = lines[y]
		local beam = line:sub(x, x)
		if beam == '.' then
			beam = previous
		end

		local beams = energized[position]
		if beams then
			table.insert(beams, beam)
		else
			energized[position] = { beam }
		end

		local potential = {}
		if beam == '>' then
			x = x + 1
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == '<' then
			x = x - 1
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == '^' then
			y = y - 1
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == 'v' then
			y = y + 1
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == '/' then
			if previous == '>' then
				y = y - 1
				beam = '^'
			elseif previous == '<' then
				y = y + 1
				beam = 'v'
			elseif previous == '^' then
				x = x + 1
				beam = '>'
			elseif previous == 'v' then
				x = x - 1
				beam = '<'
			end
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == '\\' then
			if previous == '>' then
				y = y + 1
				beam = 'v'
			elseif previous == '<' then
				y = y - 1
				beam = '^'
			elseif previous == '^' then
				x = x - 1
				beam = '<'
			elseif previous == 'v' then
				x = x + 1
				beam = '>'
			end
			table.insert(potential, { x = x, y = y, previous = beam })
		elseif beam == '|' then
			if previous == '>' or previous == '<' then
				y = y + 1
				beam = 'v'
				table.insert(potential, { x = x, y = y, previous = beam })
				y = y - 2
				beam = '^'
				table.insert(potential, { x = x, y = y, previous = beam })
			elseif previous == 'v' then
				y = y + 1
				table.insert(potential, { x = x, y = y, previous = previous })
			elseif previous == '^' then
				y = y - 1
				table.insert(potential, { x = x, y = y, previous = previous })
			end
		elseif beam == '-' then
			if previous == '^' or previous == 'v' then
				x = x + 1
				beam = '>'
				table.insert(potential, { x = x, y = y, previous = beam })
				x = x - 2
				beam = '<'
				table.insert(potential, { x = x, y = y, previous = beam })
			elseif previous == '>' then
				x = x + 1
				table.insert(potential, { x = x, y = y, previous = previous })
			elseif previous == '<' then
				x = x - 1
				table.insert(potential, { x = x, y = y, previous = previous })
			end
		end

		for _, p in pairs(potential) do
			if p.x > 0 and p.x <= max_x and p.y > 0 and p.y <= max_y then
				local e_position = p.x .. '-' .. p.y
				local found = energized[e_position]

				if not found or not utils.includes(found, beam) then
					table.insert(toHandle, { position = e_position, previous = p.previous })
				end
			end
		end
	end

	local total = 0
	for _ in pairs(energized) do
		total = total + 1
	end
	return total
end

local function part1(lines)
	return compute(lines)
end
print("part 1", part1(input_lines))

local function part2(lines)
	local max_x = #(lines[1])
	local max_y = #lines

	local max = 0
	for i = 1, max_x, 1 do
		max = math.max(max, compute(lines, i, 1, 'v'))
		max = math.max(max, compute(lines, i, max_y, '^'))
	end
	for j = 1, max_y, 1 do
		max = math.max(max, compute(lines, 1, j, '>'))
		max = math.max(max, compute(lines, max_x, j, '<'))
	end

	return max
end
print("part 2", part2(input_lines))
