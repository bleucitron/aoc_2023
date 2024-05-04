package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_blocks = read.blocks_from(file)

local function compare(l1, l2, approx)
	if not approx then
		return l1 == l2, false
	end

	if l1 == l2 then
		return true, false
	end

	for i = 1, #l1, 1 do
		local ci1 = l1:sub(i,i)
		local ci2 = l2:sub(i,i)

		if ci1 ~= ci2 then
			if ci2 == '#' then
				ci2 = '.'
			else
				ci2 = '#'
			end

			local l2bis = l2:sub(1,i-1)..ci2..l2:sub(i+1,#l2)

			if l1 == l2bis then
				return true, true
			end
		end
	end

	return false, false
end

local function find_mirror(lines, approx)
	approx = approx or false

	local modified = false
	for i, line in pairs(lines) do
		if i < #lines then
			local eq, _modified = compare(line, lines[i + 1], approx)
			modified = _modified

			if eq then
				local valid = true
				local k = 1

				while i - k > 0 and i + k + 1 <= #lines do
					local _eq, _mod = compare(lines[i - k],lines[i + k + 1], approx)
					modified = modified or _mod

					if not _eq then
						valid = false
						goto continue
					end
					k = k + 1
				end
				if approx and not modified then
					valid = false
				end
				::continue::
				if valid then
					return i
				end
			end
		end
	end

	return nil
end

local function part1(blocks)
	local total = 0

	for _,lines in pairs(blocks) do
		local multiplier = 100
		local value = find_mirror(lines)

		if not value then
			multiplier = 1
			value = find_mirror(utils.transpose(lines))
		end
		if not value then
			break
		end
		total = total + value * multiplier
	end
	return total
end
print("part 1", part1(input_blocks))

local function part2(blocks)
	local total = 0

	for _,lines in pairs(blocks) do
		local multiplier = 100
		local value = find_mirror(lines, true)

		if not value then
			multiplier = 1
			value = find_mirror(utils.transpose(lines), true)
		end
		if not value then
			break
		end
		total = total + value * multiplier
	end
	return total
end
print("part 2", part2(input_blocks))

