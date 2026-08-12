-- js-macros.lua
-- Spans and divs that map onto the macros of the `js` Typst package, in the
-- spirit of christopherkenny/typst-function: the class names the macro and
-- `argument` carries what does not fit in the body.
--
--   [科]{.ruby argument="か"}          -> #ruby[科][か]
--   [超電磁砲]{.kintou argument="5em"} -> #kintou(5em)[超電磁砲]
--   ::: {.noindent} ... :::            -> #noindent[...]
--
-- Outside of Typst they fall back to the HTML equivalent where there is one,
-- and to the plain body otherwise, so the same source renders everywhere.

local function argument_of(el)
  local value = el.attributes["argument"] or el.attributes["arguments"]
  if value == nil or value == "" then
    return nil
  end
  return value
end

-- `ruby` and `kintou` read the `.text` field of what they are given, so the
-- body has to reach them as a single text element. Markup with escapes
-- (`C\#`) is a sequence and would fail, hence the detour through a Typst
-- string literal: `[#"C#"]` is one text element whatever the characters are.
local function typst_text(s)
  return '[#"' .. s:gsub("[\\\"]", "\\%0") .. '"]'
end

local function html_escape(s)
  return (s:gsub("[&<>\"]", {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
  }))
end

local function warn_missing(class, hint)
  quarto.log.warning("A ." .. class .. " span needs an argument, e.g. " .. hint)
end

-- [科]{.ruby argument="か"} -> #ruby[科][か]
-- Group ruby: the reading is spread over the whole body, as in `js`.
local function ruby(el)
  local base = pandoc.utils.stringify(el.content)
  local reading = argument_of(el)
  if reading == nil then
    warn_missing("ruby", '[科]{.ruby argument="か"}')
    return el.content
  end

  if quarto.doc.is_format("typst") then
    return pandoc.RawInline("typst", "#ruby" .. typst_text(base) .. typst_text(reading))
  elseif quarto.doc.is_format("html") then
    return pandoc.RawInline(
      "html",
      "<ruby>"
        .. html_escape(base)
        .. "<rp>(</rp><rt>"
        .. html_escape(reading)
        .. "</rt><rp>)</rp></ruby>"
    )
  end
  -- No ruby in the target format: the reading is a pronunciation aid, so
  -- dropping it leaves the sentence intact.
  return el.content
end

-- [超電磁砲]{.kintou argument="5em"} -> #kintou(5em)[超電磁砲]
local function kintou(el)
  local body = pandoc.utils.stringify(el.content)
  local width = argument_of(el)
  if width == nil then
    warn_missing("kintou", '[超電磁砲]{.kintou argument="5em"}')
    return el.content
  end

  if quarto.doc.is_format("typst") then
    -- The width is a Typst length, so it goes in as code rather than text.
    return pandoc.RawInline("typst", "#kintou(" .. width .. ")" .. typst_text(body))
  elseif quarto.doc.is_format("html") then
    return pandoc.RawInline(
      "html",
      '<span style="display: inline-block; width: '
        .. html_escape(width)
        .. '; text-align: justify; text-align-last: justify;">'
        .. html_escape(body)
        .. "</span>"
    )
  end
  return el.content
end

return {
  Span = function(el)
    if el.classes:includes("ruby") then
      return ruby(el)
    elseif el.classes:includes("kintou") then
      return kintou(el)
    end
    return nil
  end,

  -- `#noindent[...]` turns off the one-em first-line indent for the
  -- paragraphs it wraps. Other formats keep the div, so it can be styled by
  -- class.
  Div = function(el)
    if not el.classes:includes("noindent") or not quarto.doc.is_format("typst") then
      return nil
    end

    local blocks = pandoc.List({ pandoc.RawBlock("typst", "#noindent[") })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock("typst", "]"))
    return blocks
  end,
}
