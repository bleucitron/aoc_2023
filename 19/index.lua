package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
local input_lines = read.lines_from(file)

local MAX = 4000

local function parse_rule(line)
  local id, rules_str = table.unpack(utils.split(line, '{'))
  rules_str = rules_str:gsub('%}', '')

  return id, rules_str
end

local function part1(lines)
  local workflows = { A = { 'A' }, R = { 'R' } }
  local parts = {}

  local function handle_workflow(workflow, part)
    for _, step in ipairs(workflow) do
      if step == 'A' then
        return true
      end
      if step == 'R' then
        return false
      end

      local rule, to = step:match '(.+):(.+)'

      if rule then
        local check = load('return ' .. rule, nil, nil, part)
        if check and check() then
          return handle_workflow(workflows[to], part)
        end
        goto next_step
      else
        return handle_workflow(workflows[step], part)
      end

      ::next_step::
    end
  end

  for _, line in ipairs(lines) do
    if #line == 0 then
      goto continue
    end

    if utils.startsWith(line, '{') then
      local get_part = load('return ' .. line)
      if get_part then
        table.insert(parts, get_part())
      end
    else
      local id, rules_str = parse_rule(line)

      local rules = {}
      for _, rule in ipairs(utils.split(rules_str, ',')) do
        table.insert(rules, rule)
      end
      workflows[id] = rules
    end

    ::continue::
  end

  local total = 0
  for _, part in ipairs(parts) do
    local is_valid = handle_workflow(workflows['in'], part)
    local temp = part.x + part.m + part.a + part.s
    if is_valid then
      total = total + temp
    end
  end

  return total
end
print('part 1', part1(input_lines))

local function part2(lines)
  local workflows = { A = 'A', R = 'R' }

  local function handle(workflow, state)
    local first_coma = workflow:find ','

    if not first_coma then
      if workflow == 'A' then
        local nb = 1
        for _, value in pairs(state) do
          local to = value.to
          local from = value.from
          local _nb = math.max(to - from + 1, 0)
          nb = nb * _nb
        end
        return nb
      end
      if workflow == 'R' then
        return 0
      end

      local value = handle(workflows[workflow], state)
      return value
    end

    local step = string.sub(workflow, 1, first_coma - 1)
    local rest = string.sub(workflow, first_coma + 1)

    local rule, to_rule = step:match '(.+):(.+)'

    local type = rule:sub(1, 1)
    rule = rule:sub(2)
    local inferior = rule:sub(1, 1) == '<'
    local value = tonumber(rule:sub(2)) or 0

    local from = state[type].from
    local to = state[type].to
    local state_valid = utils.shallow_copy(state)
    local state_invalid = utils.shallow_copy(state)

    if inferior then
      state_valid[type] = { from = from, to = math.min(value - 1, to) }
      state_invalid[type] = { from = math.max(value, from), to = to }
    else
      state_valid[type] = { from = math.max(value + 1, from), to = to }
      state_invalid[type] = { from = from, to = math.min(value, to) }
    end

    local value_valid = handle(workflows[to_rule], state_valid)
    local value_invalid = handle(rest, state_invalid)

    return value_valid + value_invalid
  end

  for _, line in ipairs(lines) do
    if #line == 0 then
      goto continue
    end

    if not utils.startsWith(line, '{') then
      local id, rules_str = parse_rule(line)
      workflows[id] = rules_str
    end

    ::continue::
  end
  local total = handle(workflows['in'], { x = { from = 1, to = MAX }, m = { from = 1, to = MAX }, a = { from = 1, to = MAX }, s = { from = 1, to = MAX } })

  return total
end
print('part 2', part2(input_lines))
