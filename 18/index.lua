package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
local input_lines = read.lines_from(file)

local DIR = {
  L = { x = -1, y = 0 },
  D = { x = 0, y = 1 },
  U = { x = 0, y = -1 },
  R = { x = 1, y = 0 },
  LD = { x = -1, y = 1 },
  LU = { x = -1, y = -1 },
  RD = { x = 1, y = 1 },
  RU = { x = 1, y = -1 },
}

local function part1(lines)
  local trench = {}
  local current = { x = 1, y = 1 }
  local max_x = 1
  local max_y = 1
  local min_x = 1
  local min_y = 1

  for _, line in ipairs(lines) do
    local direction, nb_steps, color = table.unpack(utils.split(line, ' '))
    color = color:gsub('%(', ''):gsub('%)', '')

    for _ = 1, nb_steps, 1 do
      local node = {}
      node.x = current.x + DIR[direction].x
      node.y = current.y + DIR[direction].y
      if node.x < min_x then
        min_x = node.x
      end
      if node.y < min_y then
        min_y = node.y
      end
      if node.x > max_x then
        max_x = node.x
      end
      if node.y > max_y then
        max_y = node.y
      end
      table.insert(trench, node)
      current = node
    end
  end

  local nb_cols = max_x - min_x + 1
  local nb_lines = max_y - min_y + 1
  local total = nb_cols * nb_lines

  local ground = {}
  local edges = {}

  for _, node in ipairs(trench) do
    local x = node.x - min_x + 1
    local y = node.y - min_y + 1

    if not ground[y] then
      ground[y] = {}
    end
    ground[y][x] = '#'
  end
  for x = 1, nb_cols, 1 do
    if ground[1][x] ~= '#' then
      table.insert(edges, { x = x, y = 1 })
    end
    if ground[nb_lines][x] ~= '#' then
      table.insert(edges, { x = x, y = nb_lines })
    end
  end
  for y = 2, nb_lines - 1, 1 do
    if ground[y][1] ~= '#' then
      table.insert(edges, { x = 1, y = y })
    end
    if ground[y][nb_cols] ~= '#' then
      table.insert(edges, { x = nb_cols, y = y })
    end
  end

  local nb_outside = 0

  local function explore(node)
    local x = node.x
    local y = node.y
    if x < 1 or x > nb_cols then
      return
    end
    if y < 1 or y > nb_lines then
      return
    end
    if ground[y][x] then
      return
    end
    ground[y][x] = '.'
    nb_outside = nb_outside + 1

    for _, dir in pairs(DIR) do
      local next = { x = x + dir.x, y = y + dir.y }
      explore(next)
    end
  end

  for _, edge in ipairs(edges) do
    explore(edge)
  end

  return total - nb_outside
end
print('part 1', part1(input_lines))

local function part2(lines)
  local trench = {}
  local current = { x = 1, y = 1 }
  local max_x = 1
  local max_y = 1
  local min_x = 1
  local min_y = 1

  local number_to_dir = { 'R', 'D', 'L', 'U' }
  local first, last
  local trench_length = 0

  for i, line in ipairs(lines) do
    local _, _, color = table.unpack(utils.split(line, ' '))
    -- local direction, nb_steps, color = table.unpack(utils.split(line, ' '))
    color = color:gsub('%(', ''):gsub('%)', ''):gsub('%#', '')

    local nb_steps = tonumber(string.sub(color, 1, 5), 16)
    local direction = number_to_dir[tonumber(string.sub(color, -1)) + 1]

    trench_length = trench_length + nb_steps

    if i == 1 then
      first = DIR[direction]
    end
    if i == #lines then
      last = DIR[direction]
    end

    local node = {}
    node.x = current.x + nb_steps * DIR[direction].x
    node.y = current.y + nb_steps * DIR[direction].y
    if node.x < min_x then
      min_x = node.x
    end
    if node.y < min_y then
      min_y = node.y
    end
    if node.x > max_x then
      max_x = node.x
    end
    if node.y > max_y then
      max_y = node.y
    end
    table.insert(trench, node)
    current = node
  end

  local first_inside = { x = current.x + first.x - last.x, y = current.y + first.y - last.y }

  print('inside', first_inside.x, first_inside.y)
  print('trench_length', trench_length)

  local nb_cols = max_x - min_x + 1
  local nb_lines = max_y - min_y + 1
  local total = nb_cols * nb_lines

  local ground = {}
  local edges = {}

  local nb_inside = 0
  local seen = {}
  local to_check = {}

  local function get_position(x, y)
    return x + (y - 1) * nb_cols
  end

  table.insert(to_check, first_inside)

  local function is_trench(x, y)
    for i, vertex in ipairs(trench) do
      local start = i > 1 and trench[i - 1] or trench[#trench]

      if x == vertex.x then
        local min = math.min(start.y, vertex.y)
        local max = math.max(start.y, vertex.y)
        if y >= min and y <= max then
          return true
        end
      end
      if y == vertex.y then
        local min = math.min(start.x, vertex.x)
        local max = math.max(start.x, vertex.x)
        if x >= min and x <= max then
          return true
        end
      end
    end

    return false
  end

  while #to_check > 0 do
    local checking = table.remove(to_check, 1)
    local x = checking.x
    local y = checking.y
    local position = get_position(x, y)

    if seen[position] then
      goto continue
    end
    if is_trench(x, y) then
      goto continue
    end
    seen[position] = true

    nb_inside = nb_inside + 1
    for _, dir in pairs(DIR) do
      table.insert(to_check, { x = x + dir.x, y = y + dir.y })
    end

    ::continue::
  end

  return trench_length + nb_inside
end
print('part 2', part2(input_lines))
