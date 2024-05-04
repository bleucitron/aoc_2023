package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local cache = {}

local function generate(n, k)
	if n<0 then return {} end
	if k<0 then return {} end
	if k>n then return {} end
	if n == 1 then
		if k == 0 then return {'.'} end
		if k == 1 then return {'#'} end
	end

	local key = n..'-'..k
	if cache[key] then
		return cache[key]
	end

	local results1 = generate(n-1,k)
	local options = {}
	for _,s in pairs(results1) do
		table.insert(options, '.'..s)
	end
	local results2 = generate(n-1,k-1)
	for _,s in pairs(results2) do
		table.insert(options, '#'..s)
	end

	cache[key] = options
	return options
end

local function part1(lines)
	local result = 0

	for _,line in pairs(lines) do
		local data = utils.split(line)
		local springs, order = data[1], data[2]
		local sizes = utils.split(order, ',')

		local total = 0
		for _,n in pairs(sizes) do
			total = total + tonumber(n)
		end

		local nb_holes = 0
		local nb_springs = 0
		for c in springs:gmatch('.') do
			if c == '?' then
				nb_holes = nb_holes + 1
			elseif c == '#' then
				nb_springs = nb_springs + 1
			end
		end
		local missing = total - nb_springs
		print('Line', line)
		print('Total', total, 'holes', nb_holes, 'springs', nb_springs, 'missing', missing)
		local options = generate(nb_holes, missing)

		print('nb options', #options)
		local position = 0
		local positions = {}
		while position do
			position = springs:find('?', position+1)
			if position then
				table.insert(positions, position)
			end
		end

		local nb_valid = 0
		for _,option in pairs(options) do
			local fixed = springs
			for i,p in pairs(positions) do

				local c = option:sub(i, i)
				fixed = fixed:sub(1, p-1)..c..fixed:sub(p+1, #fixed)
			end

			local t = {}
			for spring in fixed:gmatch('(#+)') do
				table.insert(t, #spring)
			end
			local s = table.concat(t, ',')
			if s == order then
				nb_valid = nb_valid + 1
				result = result + 1
			end
		end
		print('Valid', nb_valid)
		print()
	end
	return result
end
print("part 1", part1(input_lines))

local function part2(lines)
	local result = 0

	for _,line in pairs(lines) do
		local data = utils.split(line)
		local springs, order = data[1], data[2]

		local duplicate_springs = springs
		local duplicate_order = order
		for _ = 1, 5, 1 do
			duplicate_springs = duplicate_springs..'?'..springs
			duplicate_order = duplicate_order..','..order
		end
		springs = duplicate_springs
		order = duplicate_order

		local sizes = utils.split(order, ',')

		local total = 0
		for _,n in pairs(sizes) do
			total = total + tonumber(n)
		end

		local nb_holes = 0
		local nb_springs = 0
		for c in springs:gmatch('.') do
			if c == '?' then
				nb_holes = nb_holes + 1
			elseif c == '#' then
				nb_springs = nb_springs + 1
			end
		end
		local missing = total - nb_springs
		print(springs, order)
		print('Total', total, 'holes', nb_holes, 'springs', nb_springs, 'missing', missing)
		local options = generate(nb_holes, missing)

		print('nb options', #options)
		local position = 0
		local positions = {}
		while position do
			position = springs:find('?', position+1)
			if position then
				table.insert(positions, position)
			end
		end

		local nb_valid = 0
		for _,option in pairs(options) do
			local fixed = springs
			for i,p in pairs(positions) do

				local c = option:sub(i, i)
				fixed = fixed:sub(1, p-1)..c..fixed:sub(p+1, #fixed)
			end

			local t = {}
			for spring in fixed:gmatch('(#+)') do
				table.insert(t, #spring)
			end
			local s = table.concat(t, ',')
			if s == order then
				nb_valid = nb_valid + 1
				result = result + 1
			end
		end
		print('Valid', nb_valid)
		print()
	end
	return result

end
--print("part 2", part2(input_lines))

