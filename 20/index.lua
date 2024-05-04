package.path = package.path .. ';../?.lua'

local read = require 'read'
local utils = require 'utils'

local file = 'input.txt'
-- local file = 'example.txt'
-- local file = 'example_simple.txt'
local input_lines = read.lines_from(file)

local function part1(lines)
  local modules = {}

  for _, line in ipairs(lines) do
    line = line:gsub(' %-> ', '_')
    local name_str, destination_str = table.unpack(utils.split(line, '_'))

    local type = string.sub(name_str, 1, 1)
    local name = name_str:gsub('%%', ''):gsub('%&', '')
    local destinations = {}

    for _, destination in ipairs(utils.split(destination_str, ', ')) do
      table.insert(destinations, destination)
    end
    modules[name] = { type = type, destinations = destinations }
    if type == '%' then
      modules[name].status = false
    elseif type == '&' then
      modules[name].from = {}
    end
  end
  for name, module in pairs(modules) do
    if module.type == '&' then
      for _name, _module in pairs(modules) do
        if utils.includes(_module.destinations, name) then
          module.from[_name] = 'low'
        end
      end
    end
  end

  local pulses = { high = 0, low = 0 }
  local to_do = {}
  local reset = true
  local cycle_length = 0

  local function press_button()
    table.insert(to_do, { from = 'button', to = 'broadcaster', pulse = 'low' })

    cycle_length = cycle_length + 1
    while #to_do > 0 do
      local current = table.remove(to_do, 1)

      local name = current.to
      local from = current.from
      local pulse = current.pulse
      local module = modules[name]
      pulses[pulse] = pulses[pulse] + 1

      if not module then
        goto continue
      end

      local type = module.type

      local destinations = module.destinations
      if type == '%' then
        if pulse == 'low' then
          module.status = not module.status
          pulse = module.status and 'high' or 'low'
        else
          goto continue
        end
      elseif type == '&' then
        module.from[from] = pulse
        local all_high = true
        for _, value in pairs(module.from) do
          all_high = all_high and value == 'high'
        end
        if all_high then
          pulse = 'low'
        else
          pulse = 'high'
        end
      end

      for _, destination in ipairs(destinations) do
        table.insert(to_do, {
          from = name,
          to = destination,
          pulse = pulse,
        })
      end
      ::continue::
    end

    local _reset = true
    for _, module in pairs(modules) do
      if module.type == '%' then
        _reset = _reset and module.status == false
      elseif module.type == '&' then
        local all_low = true

        for _, saved in pairs(module.from) do
          all_low = all_low and saved == 'low'
        end

        _reset = _reset and all_low
        reset = _reset
      end
    end

    if reset then
      print 'RESET'
    end
  end

  for _ = 1, 1000, 1 do
    press_button()
  end

  return pulses.high * pulses.low
end
print('part 1', part1(input_lines))

local function part2(lines)
  local modules = {}

  local cycles = {}

  for _, line in ipairs(lines) do
    line = line:gsub(' %-> ', '_')
    local name_str, destination_str = table.unpack(utils.split(line, '_'))

    local type = string.sub(name_str, 1, 1)
    local name = name_str:gsub('%%', ''):gsub('%&', '')
    local destinations = {}

    for _, destination in ipairs(utils.split(destination_str, ', ')) do
      table.insert(destinations, destination)
    end
    modules[name] = { type = type, destinations = destinations, cycle_start = nil, cycle = nil }
    if type == '%' then
      modules[name].status = false
    elseif type == '&' then
      modules[name].from = {}
    end
  end
  local nb_conj = 0
  for name, module in pairs(modules) do
    if module.type == '&' then
      nb_conj = nb_conj + 1
      for _name, _module in pairs(modules) do
        if utils.includes(_module.destinations, name) then
          module.from[_name] = 'low'
          if name == 'rs' then
            cycles[_name] = 0
          end
        end
      end
    end
  end

  local pulses = { high = 0, low = 0 }
  local to_do = {}
  local nb_presses = 0
  local complete = false
  local ppcm = 1

  local function press_button()
    table.insert(to_do, { from = 'button', to = 'broadcaster', pulse = 'low' })

    nb_presses = nb_presses + 1
    while #to_do > 0 do
      local current = table.remove(to_do, 1)

      local name = current.to
      local from = current.from
      local pulse = current.pulse
      local module = modules[name]
      pulses[pulse] = pulses[pulse] + 1

      if name == 'rx' and pulse == 'low' then
        complete = true
      end
      if not module then
        goto continue
      end

      local type = module.type

      local destinations = module.destinations
      if type == '%' then
        if pulse == 'low' then
          module.status = not module.status
          pulse = module.status and 'high' or 'low'
        else
          goto continue
        end
      elseif type == '&' then
        module.from[from] = pulse
        if name == 'rs' and pulse == 'high' then
          cycles[from] = nb_presses - cycles[from]
          ppcm = utils.ppcm(ppcm, cycles[from])
        end
        local all_high = true
        for _, value in pairs(module.from) do
          all_high = all_high and value == 'high'
        end
        if all_high then
          pulse = 'low'
        else
          pulse = 'high'
        end
      end

      for _, destination in ipairs(destinations) do
        table.insert(to_do, {
          from = name,
          to = destination,
          pulse = pulse,
        })
      end
      ::continue::
    end

    local done = true
    for _, nb in pairs(cycles) do
      done = done and nb > 0
    end

    if done then
      complete = done
    end
  end

  repeat
    press_button()
  until complete

  return ppcm
end
print('part 2', part2(input_lines))
