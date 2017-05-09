local log = ngx.log
local ERR = ngx.ERR

-- Requiring the basic string manipulationn utilities
-- from a file that lives at '/etc/nginx/*.lua' as 
-- indicated in the 'nginx.conf' file.
require("utils")


-- Rewrites an `Authorization: Basic b64(<token>:"")` header
-- to `Authorization: Bearer <token>`. 
return function ()
  local authorization = ngx.var.http_authorization
  if isEmpty(authorization) then
    -- Logging to ERR will end up logging its arguments]
    -- to the configured logging destinations defined at
    -- 'nginx.conf'. Without modifying a thing and using
    -- openresty image you should see them with 'docker logs'
    -- as the 'error.log' file is soft-linked to stdout.
    -- ps.: when we return early no error is thrown.
    log(ERR, "Empty authorization header")
    return
  end

  if not isBasic(authorization) then
    log(ERR, "Not basic auth - authorization=", authorization)
    return
  end

  -- Stripping out the 'Basic ' prefix from the Authroization
  -- header.
  local basicb64 = string.sub(authorization, 7)
  if isEmpty(basicb64) then
    log(ERR, "Empty basic auth - authorization=", authorization)
    return
  end 

  -- Decoding the base64-encoded string so that we get
  -- 'user:pass'.
  local basic = ngx.decode_base64(basicb64)  
  if isEmpty(basic) then
    log(ERR, "Couldn't decode base64 - basicb64=", basicb64)
    return
  end 

  -- Extract 'user' from 'user:pass' (i.e, performs a string
  -- splitting and then gets the first).
  local user = getUserFromBasic(basic)
  if isEmpty(user) then
    log(ERR, "Couldn't extract user from basic auth - basic=", basic)
    return
  end 

  -- Creates the new Authorization header
  local bearerHeader = string.format("Bearer %s", user)
  -- Sets the request's header. If there's a proxy_pass that forwardss
  -- the request, the header will go with the changes we make.
  ngx.req.set_header("Authorization", bearerHeader)
end


