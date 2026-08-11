-- jsbook.lua
-- Turns Quarto's book structure into the Typst calls that typst-template.typ
-- exposes: `#part[...]`, `#show: jsbook-mainmatter` (LaTeX's \mainmatter) and
-- `#show: jsbook-appendix` (LaTeX's \appendix).

local mainmatter_started = false
local appendix_started = false

local function typst_raw(text)
  return pandoc.RawBlock("typst", text)
end

local function begin_mainmatter(blocks)
  if not mainmatter_started then
    mainmatter_started = true
    blocks:insert(typst_raw("#show: jsbook-mainmatter"))
  end
end

local header_filter = {
  Header = function(el)
    if not quarto.doc.is_format("typst") or el.level ~= 1 then
      return nil
    end

    local state = quarto.doc.file_metadata()
    local file = state ~= nil and state.file or nil
    local book_item_type = file ~= nil and file.bookItemType or nil
    local blocks = pandoc.List({})

    -- Not a book: the main matter simply starts at the first level-1 heading.
    if book_item_type == nil then
      begin_mainmatter(blocks)
      if #blocks == 0 then
        return nil
      end
      blocks:insert(el)
      return blocks
    end

    if book_item_type == "appendix" then
      if appendix_started then
        return nil
      end
      appendix_started = true
      begin_mainmatter(blocks)
      blocks:insert(typst_raw("#show: jsbook-appendix"))
      -- Quarto inserts a synthetic unnumbered "Appendices" divider heading.
      -- jsbook has no such page: \appendix only switches the numbering, so
      -- drop the divider and let the first appendix chapter open normally.
      if not el.classes:includes("unnumbered") then
        blocks:insert(el)
      end
      return blocks
    end

    -- \mainmatter goes in front of whichever comes first, the opening part
    -- page or the first numbered chapter.
    local opens_mainmatter = book_item_type == "part"
      or (book_item_type == "chapter" and file.bookItemNumber ~= nil)
    if opens_mainmatter then
      begin_mainmatter(blocks)
    end

    if book_item_type == "part" then
      blocks:insert(typst_raw("#part[" .. pandoc.utils.stringify(el.content) .. "]"))
      return blocks
    end

    if #blocks == 0 then
      return nil
    end
    blocks:insert(el)
    return blocks
  end,
}

-- Combined with file_metadata_filter so that the book metadata markers are
-- parsed during this filter's own traversal (needed for bookItemType).
return quarto.utils.combineFilters({
  quarto.utils.file_metadata_filter(),
  header_filter,
})
