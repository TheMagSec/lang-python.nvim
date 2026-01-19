vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rst' },
  callback = function() vim.treesitter.start() end,
})