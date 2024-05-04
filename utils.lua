local utils = {}

function utils.shallow_copy(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function utils.extract(array, from, to)
  local extracted = {}
  to = to or #array

  if from < 0 then
    from = #array + from + 1
    to = #array
  end
  for i = from, to, 1 do
    table.insert(extracted, array[i])
  end
  return extracted
end

function utils.split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

function utils.startsWith(str, s)
  return string.sub(str, 1, #s) == s
end

function utils.endsWith(str, s)
  return string.sub(str, #str - #s + 1, #str) == s
end

function utils.indexOf(array, value)
  for index, v in ipairs(array) do
    if v == value then
      return index
    end
  end

  return nil
end

function utils.find(array, fn)
  for i, element in ipairs(array) do
    if fn(element) then
      return element, i
    end
  end
  return nil
end

function utils.includes(array, value)
  for _, element in pairs(array) do
    if element == value then
      return true
    end
  end
  return false
end

function utils.pgcd(a, b)
  a = math.abs(a)
  b = math.abs(b)

  if a == 0 and b == 0 then
    return 0
  end

  local max = math.max(a, b)
  local min = math.min(a, b)

  if min == 0 then
    return max
  end

  return utils.pgcd(max % min, min)
end

function utils.ppcm(a, b)
  local pgcd = utils.pgcd(a, b)

  if pgcd == nil then
    return 0
  end

  return math.floor(math.abs(a) * math.abs(b) / pgcd)
end

function utils.all(array, f)
  local valid = true

  for _, value in pairs(array) do
    if not f(value) then
      valid = false
      break
    end
  end

  return valid
end

function utils.factorial(n)
  if n == 0 then
    return 1
  end

  return utils.factorial(n - 1) * n
end

function utils.transpose(lines)
  local transposed = {}
  for _ = 1, #lines[1], 1 do
    transposed[#transposed + 1] = ''
  end

  for _, line in pairs(lines) do
    local j = 0
    for char in line:gmatch '.' do
      j = j + 1
      transposed[j] = transposed[j] .. char
    end
  end

  return transposed
end

function utils.reverse(array)
  local reversed = {}

  for i = #array, 1, -1 do
    table.insert(reversed, array[i])
  end

  return reversed
end

function utils.rotateClockWise(lines)
  local rotated = {}

  for _ = 1, #lines[1], 1 do
    rotated[#rotated + 1] = ''
  end

  for _, line in pairs(lines) do
    local j = 0
    for char in line:gmatch '.' do
      j = j + 1
      rotated[j] = char .. rotated[j]
    end
  end

  return rotated
end

function utils.rotateCounterClockWise(lines)
  local rotated = {}

  for _ = 1, #lines[1], 1 do
    rotated[#rotated + 1] = ''
  end

  for _, line in pairs(lines) do
    local j = 0
    for char in line:gmatch '.' do
      j = j + 1
      local position = #line - j + 1
      rotated[position] = rotated[position] .. char
    end
  end

  return rotated
end

return utils
