local dashboard = require('dashboard')
dashboard.custom_header = {
  '',
  " _   _         __     ___           ",
  "| \\ | | ___  __\\ \\   / (_)_ __ ___  ",
  "|  \\| |/ _ \\/ _ \\ \\ / /| | '_ ` _ \\ ",
  "| |\\  |  __/ (_) \\ V / | | | | | | |",
  "|_| \\_|\\___|\\___/ \\_/  |_|_| |_| |_|",
  '                                    ',
  '',
  '',
}
dashboard.custom_center = {
  {
    icon = '  ',
    desc = 'Find File                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = '<C-p>'
  },
  {
    icon = '  ',
    desc = 'Browse Files                ',
    action = 'NvimTreeToggle',
    shortcut = '<leader><leader>'
  },
  {
    icon = '  ',
    desc = 'Live Grep                              ',
    action = 'Telescope live_grep',
    shortcut = '<C-f>'
  },
  {
    icon = '  ',
    desc = 'Change Colorscheme                ',
    action = 'Telescope colorscheme',
    shortcut = '<leader>cs'
  },
  {
    icon = '  ',
    desc = 'Check Health                    ',
    action = 'CheckHealth',
    shortcut = ':CheckHealth'
  },
  {
    icon = '  ',
    desc = 'Open Dotfiles                  ',
    action = 'e ~/dotfiles',
    shortcut = ':e ~/dotfiles'
  },
}
local version = require('util').trim(require('util').system('nvim --version | grep -o "v\\d\\+\\.\\d\\+\\.\\d\\+"'))
dashboard.custom_footer = {
  version
}
