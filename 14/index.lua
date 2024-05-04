package.path = package.path .. ";../?.lua"

local read = require "read"
local utils = require "utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function tilt(lines)
	local tilted = {}
	for _, line in pairs(lines) do
		local current = 0

		while current do
			current = current + 1
			local next = line:find('O', current)
			if next then
				local rock = line:find('#', current)
				if rock then
					while rock < next do
						current = rock + 1
						local next_rock = line:find('#', current)

						if next_rock then
							rock = next_rock
						else
							break
						end
					end
				end
				line = line:sub(1, next - 1) .. '.' .. line:sub(next + 1, #line)
				line = line:sub(1, current - 1) .. 'O' .. line:sub(current + 1, #line)
			else
				break
			end
		end
		table.insert(tilted, line)
	end
	return tilted
end

local function measureLoad(lines)
	local load = 0

	for i, line in ipairs(lines) do
		local count = 0
		for _ in line:gmatch('O') do
			count = count + 1
		end

		load = load + count * (#lines - i + 1)
	end

	return load
end

local function part1(lines)
	local rotated = utils.rotateCounterClockWise(lines)

	local tilted = tilt(rotated)
	local load = measureLoad(utils.rotateClockWise(tilted))

	return load
end

print("part 1", part1(input_lines))

local function part2(lines)
	-- initialization
	local platform = utils.rotateCounterClockWise(lines)

	local function cycle(board)
		local tilted = board

		tilted = tilt(tilted)
		tilted = utils.rotateClockWise(tilted)
		tilted = tilt(tilted)
		tilted = utils.rotateClockWise(tilted)
		tilted = tilt(tilted)
		tilted = utils.rotateClockWise(tilted)
		tilted = tilt(tilted)
		tilted = utils.rotateClockWise(tilted)

		return tilted
	end

	local loads = {}
	local min_loop = 3
	local number_steps = math.floor(10 ^ 9)
	local left
	for step = 1, number_steps, 1 do
		platform = cycle(platform)
		-- we need to rotate once to compute loads
		local rotated = utils.rotateClockWise(platform)
		local load = measureLoad(rotated)
		table.insert(loads, load)

		local length = min_loop
		while 2 * length <= #loads do
			local extracted = utils.extract(loads, -2 * length)
			local extracted_2 = utils.extract(extracted, length + 1)
			local is_same = true

			for i = 1, length, 1 do
				is_same = extracted[i] == extracted_2[i]
				if not is_same then
					break
				end
			end
			if (is_same) then
				left = (number_steps - step) % length
				break
			else
				length = length + 1
			end
		end

		if left then
			break
		end
	end


	for _ = 1, left, 1 do
		platform = cycle(platform)

		-- we need to rotate once to compute loads
		local rotated = utils.rotateClockWise(platform)
		local load = measureLoad(rotated)
		table.insert(loads, load)
	end

	return loads[#loads]
end
print("part 2", part2(input_lines))
