-- Taken from https://pandoc.org/lua-filters.html#building-images-with-tikz
local system = require 'pandoc.system'

local tikz_doc_template = [[
\documentclass{standalone}
\usepackage{xcolor}
\usepackage{tikz}
\begin{document}
\nopagecolor
\begin{tikzpicture}
%s
\end{tikzpicture}
\end{document}
]]

local tikzcd_doc_template = [[
\documentclass[12pt]{standalone}
\usepackage{xcolor}
\usepackage{tikz-cd}
\begin{document}
\nopagecolor
\begin{tikzcd}
%s
\end{tikzcd}
\end{document}
]]

local function tikz2image(src, filetype, outfile)
  system.with_temporary_directory('tikz2image', function (tmpdir)
    system.with_working_directory(tmpdir, function()
      local f = io.open('tikz.tex', 'w')
      f:write(tikz_doc_template:format(src))
      f:close()
      os.execute('pdflatex tikz.tex')
      if filetype == 'pdf' then
        os.rename('tikz.pdf', outfile)
      else
        os.execute('pdf2svg tikz.pdf ' .. outfile)
      end
    end)
  end)
end

local function tikzcd2image(src, filetype, outfile)
  system.with_temporary_directory('tikzcd2image', function (tmpdir)
    system.with_working_directory(tmpdir, function()
      local f = io.open('tikzcd.tex', 'w')
      f:write(tikzcd_doc_template:format(src))
      f:close()
      os.execute('pdflatex tikzcd.tex')
      if filetype == 'pdf' then
        os.rename('tikzcd.pdf', outfile)
      else
        os.execute('pdf2svg tikzcd.pdf ' .. outfile)
      end
    end)
  end)
end

extension_for = {
  html = 'svg',
  html4 = 'svg',
  html5 = 'svg',
  latex = 'pdf',
  beamer = 'pdf' }

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function starts_with(start, str)
  return str:sub(1, #start) == start
end


function CodeBlock(block)
   if block.classes[1] == "tikzpicture" or block.classes[1] == "tikzcd" then
    local filetype = extension_for[FORMAT] or 'svg'
    local fbasename = pandoc.sha1(block.text) .. '.' .. filetype
    local fname = system.get_working_directory() .. '/' .. fbasename
    if not file_exists(fname) then
       if block.classes[1] == "tikzpicture"
       then tikz2image(block.text, filetype, fname)
       elseif block.classes[1] == "tikzcd"
       then tikzcd2image(block.text, filetype, fname)
       end
    end
    return pandoc.Para({pandoc.Image({}, fbasename)})
  else
   return block
  end
end

-- function RawBlock(el)
--   if starts_with('\\begin{tikzpicture}', el.text) then
--     local filetype = extension_for[FORMAT] or 'svg'
--     local fbasename = pandoc.sha1(el.text) .. '.' .. filetype
--     local fname = system.get_working_directory() .. '/' .. fbasename
--     if not file_exists(fname) then
--       tikz2image(el.text, filetype, fname)
--     end
--     return pandoc.Para({pandoc.Image({}, fbasename)})
--   else
--    return el
--   end
-- end
