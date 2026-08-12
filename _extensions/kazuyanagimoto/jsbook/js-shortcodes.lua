-- js-shortcodes.lua
-- Shortcodes for the `js` macros that take no body: the TeX and LaTeX logos.
-- Macros that wrap text (ruby, kintou, noindent) are spans and divs instead,
-- see js-macros.lua.

local function logo(typst_macro, latex_macro, plain)
  return function()
    if quarto.doc.is_format("typst") then
      return pandoc.RawInline("typst", "#" .. typst_macro)
    elseif quarto.doc.is_format("latex") then
      return pandoc.RawInline("tex", latex_macro .. "{}")
    end
    return pandoc.Str(plain)
  end
end

local tex = logo("TeX", "\\TeX", "TeX")
local latex = logo("LaTeX", "\\LaTeX", "LaTeX")

return {
  ["tex"] = tex,
  ["TeX"] = tex,
  ["latex"] = latex,
  ["LaTeX"] = latex,
}
