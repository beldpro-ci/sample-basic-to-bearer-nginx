local log = ngx.log
local ERR = ngx.ERR

require("utils")

-- Rewrites an `Authorization: Bearer <token>` header
-- to `Authorization: Basic b64(token:"")`. 
return function ()
  local authorization = ngx.var.http_authorization
  if isEmpty(authorization) then
    log(ERR, "Empty authorization header")
    return
  end

  if not isBearer(authorization) then
    log(ERR, "Not bearer auth ", authorization)
    return
  end

  local token = string.sub(authorization, 7)

  if isEmpty(token) then
    log(ERR, "Empty token")
    return
  end 

  local basic = string.format("%s:%s", token, "")
  local basicb64 = ngx.encode_base64(basic)
  local basicHeader = string.format("Basic %s", basicb64)

  ngx.req.set_header("Authorization", basicHeader)
end


