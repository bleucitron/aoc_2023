package.path = package.path .. ";../?.lua"

local read = require"read"

local file = 'input.txt'
--local file = 'example.txt'
local lines = read.lines_from(file)

local function compute(input_lines)
	local total = 0

	for _,line in pairs(input_lines) do
		local digits = {}
		for letter in line:gmatch"." do
			local n = tonumber(letter)
			if type(n) == "number" then
				digits[#digits+1] = n
			end
		end
		local first = digits[1]
		local last = digits[#digits]

		local number = first * 10 + last
		total = total + number
	end
	return total
end

print("part 1", compute(lines))

local function compute2(input_lines)
	local total = 0

	for _,line in pairs(input_lines) do
		local digits = {}
		local word = ""
		for letter in line:gmatch"." do
			local n = tonumber(letter)
			if type(n) == "number" then
				digits[#digits+1] = n
			else
				word = word .. letter
				if string.find(word, "one") then
					digits[#digits+1] = 1
					word = string.sub(word, -1)
				end
				if string.find(word, "two") then
					digits[#digits+1] = 2
					word = string.sub(word, -1)
				end
				if string.find(word, "three") then
					digits[#digits+1] = 3
					word = string.sub(word, -1)
				end
				if string.find(word, "four") then
					digits[#digits+1] = 4
					word = string.sub(word, -1)
				end
				if string.find(word, "five") then
					digits[#digits+1] = 5
					word = string.sub(word, -1)
				end
				if string.find(word, "six") then
					digits[#digits+1] = 6
					word = string.sub(word, -1)
				end
				if string.find(word, "seven") then
					digits[#digits+1] = 7
					word = string.sub(word, -1)
				end
				if string.find(word, "eight") then
					digits[#digits+1] = 8
					word = string.sub(word, -1)
				end
				if string.find(word, "nine") then
					digits[#digits+1] = 9
					word = string.sub(word, -1)
				end
			end
		end
		local first = digits[1]
		local last = digits[#digits]
		--print('nb', first, last, line)

		local number = first * 10 + last
		total = total + number
	end
	return total
end

print("part 2", compute2(lines))

