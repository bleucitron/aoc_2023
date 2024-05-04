-- see if the file exists
local function file_exists(file)
  local f = io.open(file, 'rb')
  if f then
    f:close()
  end
  return f ~= nil
end

local read = {}
-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function read.lines_from(file)
  if not file_exists(file) then
    return {}
  end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

function read.text_from(file_name)
  local file = io.open(file_name, 'r')
  if file then
    local text = file:read '*a'
    file:close()
    return text
  end
  return file ~= nil
end

function read.blocks_from(file_name)
  local lines = read.lines_from(file_name)

  local groups = { {} }

  for _, line in pairs(lines) do
    if #line == 0 then
      groups[#groups + 1] = {}
    else
      table.insert(groups[#groups], line)
    end
  end

  return groups
end

return read
