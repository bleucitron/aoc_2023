package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

-- local file = 'input.txt'
local file = 'example.txt'
local input_lines = read.lines_from(file)

local DIR = {
  { i = -1, j = 0 },
  { i = 0, j = -1 },
  { i = 1, j = 0 },
  { i = 0, j = 1 },
}

local function part1(lines)
  local map = {}

  for _, line in ipairs(lines) do
    local chars = {}
    for char in string.gmatch(line, '.') do
      table.insert(chars, char)
    end
    table.insert(map, chars)
  end
  print(#map, #map[1])
end
print('part 1', part1(input_lines))

local function part2(lines) end
print('part 2', part2(input_lines))
