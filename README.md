# Lunicode

A plugin that provides a way to insert special characters that I prefer to the available options for Neovim.

## Installation

Assuming you're using vim-plug or a similar tool, add the following to your plugin section:

```vim
Plug 'benwr/lunicode'
```

## Usage

In order to use this library, you need to (for example) add the following to your init.vim:

```vim
let g:lunicode_table = {
      \'To': '→',
      \'Times': '×',
      \}
```

Now you should be able to use the `<leader>k` operator on any motion. This will search
the text contained in the motion for the words "Times" and "To" (case-sensitive), and
replace them with the specified characters.

From insert mode, you can use `<C-k>` to quickly enter a motion from the current cursor position,
or `<C-k><C-k>` to format the current line.


This is basically how I think digraphs *should* work: You don't need to repeatedly press chords
to get your expression translated, and there's a lot more flexibility about naming (since the
words you use can be anything matching the regex `[A-Z][a-z]*`. The way I typically use this tool
is when I'm writing, say, a type declaration in Agda. I'll write out the whole line as a sequence
of CamelCaseSymbols, and when I'm done I'll press `<C-k><C-k>` to convert it all to unicode.

There are some obvious downsides here compared to digraphs. You need to fill in your own table
from scratch, and since the words must follow the above regex, there are significantly fewer two-character
codes available. But for me personally, this way of doing it is much more ergonomic than digraphs or
latex-based snippets.
