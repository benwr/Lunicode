local function lunicode_convert(s)
  local t = vim.g.lunicode_table or {}

  local result_builder = {}

  local initial_match = string.match(s, "^[^A-Z]*")
  table.insert(result_builder, initial_match)
  for m in string.gmatch(s, "[A-Z][a-z]*[^A-Z]*") do
    local word = string.match(m, "[A-Z][a-z]*")
    local rest = string.sub(m, string.len(word) + 1)
    if t[word] then
      table.insert(result_builder, t[word])
    else
      table.insert(result_builder, word)
    end
    table.insert(result_builder, rest)
  end

  return table.concat(result_builder)
end

return {
  lunicode_convert = lunicode_convert
}
