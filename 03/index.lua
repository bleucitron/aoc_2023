package.path = package.path .. ";../?.lua"

local read = require"read"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function is_part_char(char)
	local output = not(char == '.' or char == nil or char == '')
	return output
end

local function at(s, position)
	return string.sub(s, position, position)
end

local function part1(lines)
	local total = 0

	for i_line,line in pairs(lines) do

		local prev_line = lines[i_line - 1]
		local next_line = lines[i_line + 1]

		local parts = string.gmatch(line, "(%d+)")
		local from = 1
		for part in parts do
			local first, last = line:find(part, from)
			from = last

			if is_part_char(at(line, first - 1)) then
				total = total + part
				goto continue
			end
			if is_part_char(at(line, last + 1)) then
				total = total + part
				goto continue
			end


			for step = first - 1, last + 1, 1 do
				if prev_line then
					local char = at(prev_line, step)
					if is_part_char(char) then
						total = total + part
						break
					end
				end
				if next_line then
					local char = at(next_line, step)
					if is_part_char(char) then
						total = total + part
						break
					end
				end
			end

		    ::continue::
		end
	end
	return total
end
print("part 1", part1(input_lines))

local function is_gear(char)
	return char == '*'
end

local function part2(lines)
	local total = 0
	local gears = {}

	for i_line,line in pairs(lines) do

		local prev_line = lines[i_line - 1]
		local next_line = lines[i_line + 1]

		local parts = string.gmatch(line, "(%d+)")
		local from = 1
		for part in parts do
			local first, last = line:find(part, from)
			from = last

			if is_gear(at(line, first - 1)) then
				local position = i_line .. ';' .. first - 1
				local pieces = gears[position] or {}
				table.insert(pieces, part)
				gears[position] = pieces
			end
			if is_gear(at(line, last + 1)) then
				local position = i_line .. ';' .. last + 1
				local pieces = gears[position] or {}
				table.insert(pieces, part)
				gears[position] = pieces
			end


			for step = first - 1, last + 1, 1 do
				if prev_line then
					local char = at(prev_line, step)
					if is_gear(char) then
						local position = i_line - 1 .. ';' .. step
						local pieces = gears[position] or {}
						table.insert(pieces, part)
						gears[position] = pieces
					end
				end
				if next_line then
					local char = at(next_line, step)
					if is_gear(char) then
						local position = i_line + 1 .. ';' .. step
						local pieces = gears[position] or {}
						table.insert(pieces, part)
						gears[position] = pieces
					end
				end
			end

		end
	end

	for _,v in pairs(gears) do
		if #v == 2 then
			total = total + v[1] * v[2]
		end
	end
	return total
end
print("part 2", part2(input_lines))

