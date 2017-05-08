return function ()
  ngx.say("Headers:")

  local h = ngx.req.get_headers()
  for k, v in pairs(h) do
      ngx.say(string.format("\t%s=%s", k ,v))
  end
end

