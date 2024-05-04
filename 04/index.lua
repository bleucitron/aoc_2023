package.path = package.path .. ";../?.lua"

local read = require"read"
local utils= require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function part1(lines)
	local total = 0

	for _,line in pairs(lines) do
		local first = utils.split(line, ':')
		local all = utils.split(first[2], '|')
		local winnings = utils.split(all[1], ' ')
		local numbers = utils.split(all[2], ' ')

		local exp = -1
		for _,winning in pairs(winnings) do
			for _,number in pairs(numbers) do
				if winning == number then
					exp = exp + 1
					print("win", number)
					break
				end
			end
		end
		if (exp >= 0) then
			total = total + math.floor(2^(exp))
		end
	end

	return total
end
print("part 1", part1(input_lines))

local function part2(lines)
	local total = {}

	for id,line in pairs(lines) do
		local first = utils.split(line, ':')
		local all = utils.split(first[2], '|')
		local winnings = utils.split(all[1], ' ')
		local numbers = utils.split(all[2], ' ')

		total[id] = (total[id] or 0) + 1

		local wins = 0
		for _,winning in pairs(winnings) do
			for _,number in pairs(numbers) do
				if winning == number then
					wins = wins + 1
					print("win", number)
					break
				end
			end
		end
		if (wins > 0) then
			for step=1,wins,1 do
				total[id + step] = (total[id + step] or 0) + total[id]
			end
		end
		print("Card", id)
		for _,nb in pairs(total) do
			print("in", _, ":", nb)
		end
	end

	local nb_cards = 0
	for _,nb in pairs(total) do
		print("in", _, ":", nb)
		nb_cards = nb_cards + nb
	end
	return nb_cards
end
print("part 2", part2(input_lines))

