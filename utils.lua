function hasColon(s)
  return s:find("Bearer ") == 1
end

function isBearer(s)
  return s:find("Bearer ") == 1
end

function isBasic(s)
  return s:find("Basic ") == 1
end

function isEmpty(s)
  return s == nil or s == ''
end

function getUserFromBasic(str)
  local splitted = string.gmatch(str, '([^:]+)')
  return splitted()
end
