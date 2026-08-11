-- Typst cannot include animated GIFs, and the Zotero walkthrough in
-- lesson/literature.qmd is illustrated with them. For PDF output, point each
-- GIF at the still frame exported next to it (same basename, .png), which is
-- the final state of the animation. HTML keeps the animation.
--
-- Keeping this here rather than in the prose means the .qmd stays free of
-- per-format branching, and any GIF added later is handled automatically --
-- as long as a .png sibling exists.

function Image(img)
  if FORMAT ~= "typst" then
    return nil
  end
  if img.src:match("%.gif$") then
    img.src = img.src:gsub("%.gif$", ".png")
    return img
  end
end
