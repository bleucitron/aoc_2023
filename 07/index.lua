package.path = package.path .. ";../?.lua"

local read = require"read"
local utils = require"utils"

local file = 'input.txt'
--local file = 'example.txt'
local input_lines = read.lines_from(file)

local function part1(lines)
	local order = { '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' }
	local entries = {}

	for _,line in pairs(lines) do
		local s = utils.split(line)

		local hand = s[1]
		local bid = tonumber(s[2])
		local nb_by_card = {}
		local cards = {}

		for card in hand:gmatch('.') do
			table.insert(cards, card)
			nb_by_card[card] = (nb_by_card[card] or 0) + 1
		end

		local nb_by_similar = {}
		for _, nb in pairs(nb_by_card) do
			nb_by_similar[nb] = (nb_by_similar[nb] or 0) + 1
		end

		local strength = 0
		if nb_by_similar[5] == 1 then
			strength = 6
		elseif nb_by_similar[4] == 1 then
			strength = 5
		elseif nb_by_similar[3] == 1 and nb_by_similar[2] == 1 then
			strength = 4
		elseif nb_by_similar[3] == 1 then
			strength = 3
		elseif nb_by_similar[2] == 2 then
			strength = 2
		elseif nb_by_similar[2] == 1 then
			strength = 1
		end

		table.insert(entries, { hand = hand, bid = bid, cards = cards, strength = strength })
	end

	table.sort(entries, function (e1, e2)
		if (e1.strength == e2.strength) then
			for i, card in pairs(e1.cards) do
				if card ~= e2.cards[i] then
					return utils.indexOf(order, card) < utils.indexOf(order, e2.cards[i])
				end
			end
		else
			return e1.strength < e2.strength
		end
		return false
	end)

	local winnings = 0
	for index, entry in pairs(entries) do
		winnings = winnings + index * entry.bid
	end

	return winnings
end
print("part 1", part1(input_lines))

local function part2(lines)
	local order = { 'J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A' }
	local entries = {}

	for _,line in pairs(lines) do
		local s = utils.split(line)

		local hand = s[1]
		local bid = tonumber(s[2])
		local nb_by_card = {}
		local cards = {}

		for card in hand:gmatch('.') do
			table.insert(cards, card)
			nb_by_card[card] = (nb_by_card[card] or 0) + 1
		end

		local nb_J = 0
		if nb_by_card['J'] and nb_by_card['J'] > 0 then
			nb_J = nb_by_card['J']
			nb_by_card['J'] = nil
		end

		local max = 0
		local max_card
		for card, nb in pairs(nb_by_card) do
			if nb > max then
				max_card = card
			end
			max = math.max(max, nb)
		end

		if not max_card then
			max_card = 'J'
			nb_by_card['J'] = 5
		else
			nb_by_card[max_card] = nb_by_card[max_card] + nb_J
		end

		local nb_by_similar = {}
		for _, nb in pairs(nb_by_card) do
			nb_by_similar[nb] = (nb_by_similar[nb] or 0) + 1
		end

		local strength = 0
		if nb_by_similar[5] == 1 then
			strength = 6
		elseif nb_by_similar[4] == 1 then
			strength = 5
		elseif nb_by_similar[3] == 1 and nb_by_similar[2] == 1 then
			strength = 4
		elseif nb_by_similar[3] == 1 then
			strength = 3
		elseif nb_by_similar[2] == 2 then
			strength = 2
		elseif nb_by_similar[2] == 1 then
			strength = 1
		end

		table.insert(entries, { hand = hand, bid = bid, cards = cards, strength = strength })
	end

	table.sort(entries, function (e1, e2)
		if (e1.strength == e2.strength) then
			for i, card in pairs(e1.cards) do
				if card ~= e2.cards[i] then
					return utils.indexOf(order, card) < utils.indexOf(order, e2.cards[i])
				end
			end
		else
			return e1.strength < e2.strength
		end
		return false
	end)

	local winnings = 0
	for index, entry in pairs(entries) do
		winnings = winnings + index * entry.bid
	end

	return winnings
end
print("part 2", part2(input_lines))

