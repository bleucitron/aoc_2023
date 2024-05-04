package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
local input_lines = read.lines_from(file)

local function intersect(a, b)
  return not (a.to < b.from or b.to < a.from)
end
local function intersect_2d(a, b)
  local intersect_x = intersect({ from = a.x_min, to = a.x_max }, { from = b.x_min, to = b.x_max })
  local intersect_y = intersect({ from = a.y_min, to = a.y_max }, { from = b.y_min, to = b.y_max })

  return intersect_x and intersect_y
end

local function get_bricks(lines)
  local bricks = {}

  for i, line in ipairs(lines) do
    local first, last = table.unpack(utils.split(line, '~'))
    local x_f, y_f, z_f = table.unpack(utils.split(first, ','))
    local x_l, y_l, z_l = table.unpack(utils.split(last, ','))

    local x_min = math.min(tonumber(x_f) or 0, tonumber(x_l))
    local x_max = math.max(tonumber(x_f) or 0, tonumber(x_l))
    local y_min = math.min(tonumber(y_f) or 0, tonumber(y_l))
    local y_max = math.max(tonumber(y_f) or 0, tonumber(y_l))
    local z_min = math.min(tonumber(z_f) or 0, tonumber(z_l))
    local z_max = math.max(tonumber(z_f) or 0, tonumber(z_l))

    table.insert(bricks, {
      id = i,
      x_min = x_min,
      y_min = y_min,
      z_min = z_min,
      x_max = x_max,
      y_max = y_max,
      z_max = z_max,
      handled = false,
      supports = {},
      supported_by = {},
      can_be_removed = true,
    })
  end
  return bricks
end

local function apply_gravity(brick, bricks)
  if brick.handled then
    return
  end
  local supported_by = {}
  local height = 0

  for _, other in ipairs(bricks) do
    if other == brick then
      goto skip_brick
    end
    if other.z_min > brick.z_max then
      goto skip_brick
    end

    local intersection = intersect_2d(brick, other)
    if intersection then
      if not other.handled then
        apply_gravity(other, bricks)
      end

      if other.z_max > height then
        height = other.z_max
        supported_by = { other }
      elseif other.z_max == height then
        table.insert(supported_by, other)
      end
    end

    ::skip_brick::
  end

  local diff = brick.z_max - brick.z_min

  brick.z_min = height + 1
  brick.z_max = brick.z_min + diff
  brick.supported_by = supported_by

  for _, support in ipairs(supported_by) do
    table.insert(support.supports, brick)
  end
  brick.handled = true
end

local function bfs_destroy(brick)
  local to_do = { brick }
  local destroyed = {}
  local nb = 0

  while #to_do > 0 do
    local current = table.remove(to_do, 1)

    if destroyed[current.id] then
      goto skip
    end

    if current ~= brick then
      local still_supported = false

      for _, supported in ipairs(current.supported_by) do
        if not destroyed[supported.id] then
          still_supported = true
          goto continue
        end
        ::continue::
      end
      if still_supported then
        goto skip
      end
      nb = nb + 1
    end

    -- print(v)
    destroyed[current.id] = true

    for _, other in ipairs(current.supports) do
      table.insert(to_do, other)
    end
    ::skip::
  end
  return nb
end

local function part1(lines)
  local bricks = get_bricks(lines)

  for _, brick in ipairs(bricks) do
    apply_gravity(brick, bricks)
  end

  local total = 0
  for _, brick in ipairs(bricks) do
    local nb = bfs_destroy(brick)

    if nb == 0 then
      total = total + 1
    end
  end
  return total
end
print('part 1', part1(input_lines))

local function part2(lines)
  local bricks = get_bricks(lines)

  for _, brick in ipairs(bricks) do
    apply_gravity(brick, bricks)
  end

  local total = 0
  for _, brick in ipairs(bricks) do
    local nb = bfs_destroy(brick)

    total = total + nb
  end

  return total
end
print('part 2', part2(input_lines))
