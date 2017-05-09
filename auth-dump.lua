-- Outputs the contents of the headers
-- in a plain text format.
--    Headers:
--        key=value
return function ()
  -- 'ngx.say' emits content to the HTTP client of that
  -- request.
  ngx.say("Headers:")

  -- 'req.get_headers' gives us a lua table that
  -- has all the current request headers for
  -- the current request
  local h = ngx.req.get_headers()
  for k, v in pairs(h) do
      ngx.say(string.format("\t%s=%s", k ,v))
  end
end

