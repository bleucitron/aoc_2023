package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
--local file = 'example-4.txt'
local input_lines = read.lines_from(file)

local function makeChain(lines)
	local map = {}
	local chain = {}

	for i,line in pairs(lines) do
		local chars = {}

		for c in line:gmatch('.') do
			table.insert(chars, c)
		end

		for j,char in pairs(chars) do
			if not map[i] then
				map[i] = {}
			end
			map[i][j] = char
			if char == 'S' then
				table.insert(chain, { i = i, j = j, char = char })
			end
		end
	end

	local function checkRight(i, j)
		local neighbor = map[i][j+1]
		if neighbor == nil then return nil end

		if neighbor == '-' or neighbor == 'J' or neighbor == '7' then
			return neighbor
		end

		return nil
	end
	local function checkTop(i, j)
		local row = map[i-1]
		if row == nil then return nil end

		local neighbor = row[j]

		if neighbor == '|' or neighbor == 'F' or neighbor == '7' then
			return neighbor
		end

		return nil
	end
	local function checkLeft(i, j)
		local neighbor = map[i][j+1]
		if neighbor == nil then return nil end

		if neighbor == '-' or neighbor == 'F' or neighbor == 'L' then
			return neighbor
		end

		return nil
	end
	local function checkDown(i, j)
		local row = map[i+1]
		if row == nil then return nil end

		local neighbor = row[j]
		if neighbor == '|' or neighbor == 'J' or neighbor == 'L' then
			return neighbor
		end

		return nil
	end

	local current = chain[1]
	local s

	while current ~= nil and current.char ~= nil do
		local i = current.i
		local j = current.j
		local char = current.char
		local step

		if char == 'S' then
			if #chain > 1 then
				current = nil
				return chain, s
			end

			local newChar = checkRight(i, j)
			if newChar ~= nil then
				step = { i = i, j = j + 1, char = newChar }
				if checkDown(i,j) then
					s = 'F'
				elseif checkTop(i,j) then
					s = 'L'
				elseif checkLeft(i,j) then
					s = '-'
				end
				goto continue
			end

			newChar = checkLeft(i, j)
			if newChar ~= nil then
				step = { i = i, j = j - 1, char = newChar }
				if checkDown(i,j) then
					s = '7'
				elseif checkTop(i,j) then
					s = 'J'
				elseif checkRight(i,j) then
					s = '-'
				end
				goto continue
			end

			newChar = checkTop(i, j)
			if newChar ~= nil then
				step = { i = i - 1, j = j, char = newChar }
				if checkDown(i,j) then
					s = '|'
				elseif checkLeft(i,j) then
					s = 'J'
				elseif checkRight(i,j) then
					s = 'L'
				end
				goto continue
			end

			newChar = checkDown(i, j)
			if newChar ~= nil then
				step = { i = i + 1, j = j, char = newChar }
				goto continue
				if checkTop(i,j) then
					s = '|'
				elseif checkLeft(i,j) then
					s = '7'
				elseif checkRight(i,j) then
					s = 'F'
				end
			end
		end
		if char == '|' then
			local prev = chain[#chain - 1]
			local delta = i - prev.i
			local newI = i + delta

			step = { i = newI, j = j, char = map[newI][j] }
			goto continue
		end
		if char == '-' then
			local prev = chain[#chain - 1]
			local delta = j - prev.j
			local newJ = j + delta

			step = { i = i, j = newJ, char = map[i][newJ] }
			goto continue
		end
		if char == 'L' then
			local prev = chain[#chain - 1]
			local newI = j == prev.j and i or i - 1
			local newJ = j == prev.j and j + 1 or j

			step = { i = newI, j = newJ, char = map[newI][newJ] }
			goto continue
		end
		if char == '7' then
			local prev = chain[#chain - 1]
			local newI = j == prev.j and i or i + 1
			local newJ = j == prev.j and j - 1 or j

			step = { i = newI, j = newJ, char = map[newI][newJ] }
			goto continue
		end
		if char == 'J' then
			local prev = chain[#chain - 1]
			local newI = j == prev.j and i or i - 1
			local newJ = j == prev.j and j - 1 or j

			step = { i = newI, j = newJ, char = map[newI][newJ] }
			goto continue
		end
		if char == 'F' then
			local prev = chain[#chain - 1]
			local newI = j == prev.j and i or i + 1
			local newJ = j == prev.j and j + 1 or j

			step = { i = newI, j = newJ, char = map[newI][newJ] }
			goto continue
		end
		::continue::

		table.insert(chain, step)
		current = step
	end

end

local function part1(lines)
	local chain = makeChain(lines)

	return math.tointeger((#chain - 1) / 2)
end
print("part 1", part1(input_lines))

local function part2(lines)
	local total = 0

	local chain,s = makeChain(lines)
	local positions = {}
	for _,step in pairs(chain) do
		positions[step.i .. ';' .. step.j] = step.char
	end

	for i,line in pairs(lines) do
		line = line:gsub('S', s)

		local chars = {}

		for c in line:gmatch('.') do
			table.insert(chars, c)
		end
		for j,_ in pairs(chars) do
			if not positions[i .. ';' .. j] then
				line = line:sub(1, j-1) .. '.' .. line:sub(j+1)
			end
		end

		for j in pairs(chars) do
			if j == 1 or j == #chars or positions[i .. ';' .. j] ~= nil then
				goto continue
			end

			local before = line:sub(1, j - 1)
			before = before:gsub('%.', ''):gsub('-', '')

			local b_matches = {}
			for m in before:gmatch('|') do
				table.insert(b_matches, m)
			end
			for m in before:gmatch('FJ') do
				table.insert(b_matches, m)
			end
			for m in before:gmatch('L7') do
				table.insert(b_matches, m)
			end

			if #b_matches % 2 == 1 then
				total = total + 1
			end
		    ::continue::
		end
		--print(line)
	end

	return total
end
print("part 2", part2(input_lines))

