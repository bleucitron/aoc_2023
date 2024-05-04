package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
-- local file = 'example-2.txt'
local input_lines = read.lines_from(file)

local function get_closest_unseen(dists, seen)
  local min_dist = math.huge
  local current = nil

  for i, s in ipairs(seen) do
    if s == true then
      goto continue
    end

    local dist = dists[i]
    if dist < min_dist then
      min_dist = dist
      current = i
    end
    ::continue::
  end

  return current
end

local function get_edges(node, nodes, nb_cols)
  local coord = ((node - 1) % #nodes) + 1
  local axis = math.floor(node / #nodes)
  local DIR = axis == 0 and { EAST = 1, WEST = -1 } or { NORTH = -nb_cols, SOUTH = nb_cols }
  local edges = {}

  for _, dir in pairs(DIR) do
    local locations = {}
    for step = 1, 3, 1 do
      local location = coord + step * dir

      local same_line = math.ceil(coord / nb_cols) == math.ceil(location / nb_cols)
      local same_col = coord % nb_cols == location % nb_cols

      if location > #nodes then
        goto continue
      end
      if location < 1 then
        goto continue
      end
      if not same_line and not same_col then
        goto continue
      end

      table.insert(locations, location)
      ::continue::
    end

    local temp_loss = 0
    for _, location in ipairs(locations) do
      temp_loss = temp_loss + nodes[location]
      table.insert(edges, { to = location + (axis == 0 and 1 or 0) * #nodes, loss = temp_loss })
    end
  end

  return edges
end
local function get_edges_ultra(node, nodes, nb_cols)
  local coord = ((node - 1) % #nodes) + 1
  local axis = math.floor(node / #nodes)
  local DIR = axis == 0 and { EAST = 1, WEST = -1 } or { NORTH = -nb_cols, SOUTH = nb_cols }
  local edges = {}

  for _, dir in pairs(DIR) do
    local locations = {}
    for step = 1, 10, 1 do
      local location = coord + step * dir

      local same_line = math.ceil(coord / nb_cols) == math.ceil(location / nb_cols)
      local same_col = coord % nb_cols == location % nb_cols

      if location > #nodes then
        goto continue
      end
      if location < 1 then
        goto continue
      end
      if not same_line and not same_col then
        goto continue
      end

      table.insert(locations, location)
      ::continue::
    end

    local temp_loss = 0
    for i, location in ipairs(locations) do
      temp_loss = temp_loss + nodes[location]
      if i >= 4 then
        table.insert(edges, { to = location + (axis == 0 and 1 or 0) * #nodes, loss = temp_loss })
      end
    end
  end

  return edges
end

local function part1(lines)
  local nodes = {}

  for _, line in pairs(lines) do
    local j = 0
    for c in line:gmatch '.' do
      j = j + 1
      table.insert(nodes, tonumber(c))
    end
  end

  local nb_cols = math.floor(#nodes / #lines)

  local source = 1 -- first run going EAST
  local target = #nodes

  local losses = {}
  local seen = {}
  for i = 1, 2 * #nodes, 1 do
    losses[i] = math.huge
    seen[i] = false
  end

  losses[source] = 0
  local current = source

  while current ~= nil do
    seen[current] = true

    local loss = losses[current]
    local edges = get_edges(current, nodes, nb_cols)

    for _, edge in pairs(edges) do
      if seen[edge.to] then
        goto continue
      end

      local potential_loss = loss + edge.loss
      if potential_loss < losses[edge.to] then
        losses[edge.to] = potential_loss
      end
      ::continue::
    end

    current = get_closest_unseen(losses, seen)
  end
  local result = math.min(losses[target], losses[target + #nodes])

  source = 1 + #nodes -- second run going SOUTH

  for i = 1, 2 * #nodes, 1 do
    losses[i] = math.huge
    seen[i] = false
  end

  current = source
  losses[source] = 0

  while current ~= nil do
    seen[current] = true

    local loss = losses[current]
    local edges = get_edges(current, nodes, nb_cols)

    for _, edge in pairs(edges) do
      if seen[edge.to] then
        goto continue
      end

      local potential_loss = loss + edge.loss
      if potential_loss < losses[edge.to] then
        losses[edge.to] = potential_loss
      end
      ::continue::
    end

    current = get_closest_unseen(losses, seen)
  end

  result = math.min(result, math.min(losses[target], losses[target + #nodes]))

  return result
end
print('part 1', part1(input_lines))

local function part2(lines)
  local nodes = {}

  for _, line in pairs(lines) do
    local j = 0
    for c in line:gmatch '.' do
      j = j + 1
      table.insert(nodes, tonumber(c))
    end
  end

  local nb_cols = math.floor(#nodes / #lines)

  local source = 1 -- first run going EAST
  local target = #nodes

  local losses = {}
  local seen = {}
  for i = 1, 2 * #nodes, 1 do
    losses[i] = math.huge
    seen[i] = false
  end

  losses[source] = 0
  local current = source

  while current ~= nil do
    seen[current] = true

    local loss = losses[current]
    local edges = get_edges_ultra(current, nodes, nb_cols)

    for _, edge in pairs(edges) do
      if seen[edge.to] then
        goto continue
      end

      local potential_loss = loss + edge.loss
      if potential_loss < losses[edge.to] then
        losses[edge.to] = potential_loss
      end
      ::continue::
    end

    current = get_closest_unseen(losses, seen)
  end
  local result = math.min(losses[target], losses[target + #nodes])

  source = 1 + #nodes -- second run going SOUTH

  for i = 1, 2 * #nodes, 1 do
    losses[i] = math.huge
    seen[i] = false
  end

  current = source
  losses[source] = 0

  while current ~= nil do
    seen[current] = true

    local loss = losses[current]
    local edges = get_edges_ultra(current, nodes, nb_cols)

    for _, edge in pairs(edges) do
      if seen[edge.to] then
        goto continue
      end

      local potential_loss = loss + edge.loss
      if potential_loss < losses[edge.to] then
        losses[edge.to] = potential_loss
      end
      ::continue::
    end

    current = get_closest_unseen(losses, seen)
  end

  result = math.min(result, math.min(losses[target], losses[target + #nodes]))

  return result
end
print('part 2', part2(input_lines))
