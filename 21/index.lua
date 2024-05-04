package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
local input_lines = read.lines_from(file)

local DIR = {
  { i = -1, j = 0 },
  { i = 0, j = -1 },
  { i = 1, j = 0 },
  { i = 0, j = 1 },
}

local function part1(lines)
  local NB_STEPS = 6
  local positions = {}
  local map = ''
  local nb_cols = #lines[1]
  local nb_lines = #lines
  print(nb_cols, nb_lines)

  local function to_position(i, j)
    if i > 0 and i <= nb_cols and j > 0 and j <= nb_lines then
      return (j - 1) * nb_cols + i
    else
      return nil
    end
  end

  local function to_coords(position)
    local i = position % nb_cols
    local j = math.floor(position / nb_cols) + 1
    return i, j
  end
  local nb_blocks = 0
  for j, line in ipairs(lines) do
    local i = 0
    map = map .. line

    for char in string.gmatch(line, '.') do
      i = i + 1
      if char == 'S' then
        positions[to_position(i, j)] = true
      end
      if char == '#' then
        nb_blocks = nb_blocks + 1
      end
    end
  end

  print(nb_blocks)
  local function step(current_positions)
    local _positions = {}

    for position in pairs(current_positions) do
      current_positions[position] = nil
      local i, j = to_coords(position)

      for _, dir in ipairs(DIR) do
        local _i = i + dir.i
        local _j = j + dir.j
        local pos = to_position(_i, _j)
        local char = map:sub(pos, pos)

        if pos and char ~= '#' then
          _positions[pos] = true
        end
      end
    end

    return _positions
  end

  for _ = 1, NB_STEPS, 1 do
    positions = step(positions)
  end

  local total = 0
  for _ in pairs(positions) do
    total = total + 1
  end

  return total
end
print('part 1', part1(input_lines))

local function part2(lines)
  local NB_STEPS = 5000
  local map = ''
  local nb_cols = #lines[1]
  local nb_lines = #lines
  local to_do = {}
  local positions_even = {}
  local positions_odd = {}

  local function to_position(i, j)
    i = (i - 1) % nb_cols + 1
    j = (j - 1) % nb_lines + 1

    return (j - 1) * nb_cols + i
  end

  local function to_coords(s)
    local i, j = table.unpack(utils.split(s, ','))
    return i, j
  end

  local nb_block = 0
  for j, line in ipairs(lines) do
    local i = 0
    map = map .. line

    for char in string.gmatch(line, '.') do
      i = i + 1
      if char == 'S' then
        local s = tostring(i) .. ',' .. tostring(j)
        table.insert(to_do, s)
        positions_even[s] = true
      end
      if char == '#' then
        nb_block = nb_block + 1
      end
    end
  end

  local function step(n)
    local current_positions = n % 2 == 0 and positions_even or positions_odd

    local _to_do = {}
    for _, position in ipairs(to_do) do
      local i, j = to_coords(position)

      for _, dir in ipairs(DIR) do
        local _i = i + dir.i
        local _j = j + dir.j
        local pos = to_position(_i, _j)
        local char = map:sub(pos, pos)
        local key = tostring(_i) .. ',' .. tostring(_j)

        if char ~= '#' and positions_odd[key] == nil and positions_even[key] == nil then
          current_positions[key] = true
          table.insert(_to_do, key)
        end
      end
    end
    to_do = _to_do
  end

  for i = 1, NB_STEPS, 1 do
    step(i)
  end

  local total = 0
  local final_positions = NB_STEPS % 2 == 0 and positions_even or positions_odd
  for _ in pairs(final_positions) do
    total = total + 1
  end

  -- local s = ''
  -- for j = -1 * nb_lines + 1, 2 * nb_lines, 1 do
  --   for i = -1 * nb_cols + 1, 2 * nb_cols, 1 do
  --     local p = to_position(i, j)
  --
  --     local c = map:sub(p, p)
  --     if c == 'S' then
  --       c = '.'
  --     end
  --     if positions[i .. ',' .. j] then
  --       c = 'O'
  --     end
  --     s = s .. c
  --   end
  --   print(s)
  --   s = ''
  -- end

  return total
end
-- print('part 2', part2(input_lines))
