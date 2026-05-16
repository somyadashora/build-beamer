-- Fills date front-matter fields with the current date when left empty.
-- Fields handled: date, date-title, month-title, year-title
-- If a field is present and non-empty its value is kept as-is.

local function is_empty(val)
  if val == nil then return true end
  return pandoc.utils.stringify(val) == ""
end

local function str(s)
  return pandoc.MetaInlines({ pandoc.Str(s) })
end

function Meta(meta)
  -- os.date uses the locale of the pandoc/extra container (C/POSIX → English month names)
  if is_empty(meta.date) then
    meta.date = str(os.date("%d %B %Y"))
  end
  if is_empty(meta["date-title"]) then
    meta["date-title"] = str(os.date("%d"))
  end
  if is_empty(meta["month-title"]) then
    meta["month-title"] = str(os.date("%B"))
  end
  if is_empty(meta["year-title"]) then
    meta["year-title"] = str(os.date("%Y"))
  end
  return meta
end
