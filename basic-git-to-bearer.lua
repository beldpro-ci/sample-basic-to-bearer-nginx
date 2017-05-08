local log = ngx.log
local ERR = ngx.ERR

require("utils")


-- Rewrites an `Authorization: Basic b64(<token>:"")` header
-- to `Authorization: Bearer <token>`. 
return function ()
  local authorization = ngx.var.http_authorization
  if isEmpty(authorization) then
    log(ERR, "Empty authorization header")
    return
  end

  if not isBasic(authorization) then
    log(ERR, "Not basic auth - authorization=", authorization)
    return
  end

  local basicb64 = string.sub(authorization, 7)
  if isEmpty(basicb64) then
    log(ERR, "Empty basic auth - authorization=", authorization)
    return
  end 

  local basic = ngx.decode_base64(basicb64)  
  if isEmpty(basic) then
    log(ERR, "Couldn't decode base64 - basicb64=", basicb64)
    return
  end 

  local user = getUserFromBasic(basic)
  if isEmpty(user) then
    log(ERR, "Couldn't extract user from basic auth - basic=", basic)
    return
  end 

  local bearerHeader = string.format("Bearer %s", user)
  ngx.req.set_header("Authorization", bearerHeader)
end


