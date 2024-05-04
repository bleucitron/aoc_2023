package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function part1(lines)
	local output = 0

	for _,line in pairs(lines) do
		local n = utils.split(line)

		local numbers = {}
		for _, nb in pairs(n) do
			table.insert(numbers, tonumber(nb))
		end

		local last_numbers = {}
		while not utils.all(numbers, function (v) return v == 0 end) do
			table.insert(last_numbers, numbers[#numbers])

			local temp = {}
			for i = 2, #numbers, 1 do
				table.insert(temp, numbers[i] - numbers[i-1])
			end
			numbers = temp
		end

		for _,last in pairs(last_numbers) do
			output = output + last
		end
	end

	return output
end
print("part 1", part1(input_lines))

local function part2(lines)
	local output = 0

	for _,line in pairs(lines) do
		local n = utils.split(line)

		local numbers = {}
		for _, nb in pairs(n) do
			table.insert(numbers, tonumber(nb))
		end

		local first_numbers = {}
		while not utils.all(numbers, function (v) return v == 0 end) do
			table.insert(first_numbers, numbers[1])

			local temp = {}
			for i = 2, #numbers, 1 do
				table.insert(temp, numbers[i] - numbers[i-1])
			end
			numbers = temp
		end

		local sum = 0
		for i = #first_numbers,1,-1 do
			sum = first_numbers[i] - sum
		end

		output = output + sum
	end

	return output
end
print("part 2", part2(input_lines))

