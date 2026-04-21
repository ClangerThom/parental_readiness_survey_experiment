function Meta(meta)
  local tags = {}

  local function add(name, val)
    if val then
      local text = pandoc.utils.stringify(val)
      if text ~= '' then
        tags[#tags + 1] = '<meta name="' .. name .. '" content="' ..
                          text:gsub('"', '&quot;') .. '">'
      end
    end
  end

  add('muni-footer-author', meta['footer-author'])
  add('muni-footer-title',  meta['footer-title'])
  add('muni-email',         meta['email'])

  if #tags > 0 then
    meta['header-includes'] = meta['header-includes'] or pandoc.MetaList({})
    for _, tag in ipairs(tags) do
      table.insert(meta['header-includes'], pandoc.MetaBlocks({pandoc.RawBlock('html', tag)}))
    end
  end

  return meta
end
