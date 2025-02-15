" Attempt to fix fucked up terminal - seems to work: https://github.com/neovim/neovim/issues/7002
set guicursor=
let g:airline_powerline_fonts = 1
syntax on
set hlsearch
"set autoindent
"set smartindent
set is
set tabstop=2
set shiftwidth=2
set number
set mouse=nvi
set t_Co=256
" Try a new colorscheme for light background...
" set background=dark
" colorscheme dante
" " This is the bit that actually highlights trailing whitespace
" match RedundantSpaces /\s\+$/
" autocmd BufWinEnter * match RedundantSpaces /\s\+$/

" The csv plugin is gash for the most part; makes files unreadable and hard to
" edit IMO
let g:polyglot_disabled = ['csv']

" Becoz stupid python, format sql to 4 spaces
autocmd FileType sql setlocal shiftwidth=4 tabstop=4

" " To make it show up in new tabs - use Ctrl-E
" map  :match RedundantSpaces /\s\+$/ <CR>

set expandtab

" Shows all the files when trying to open a new file and tabbing out
set wildmode=list:longest
" Ignores these files in ctrlp and tabbing out files
set wildignore+=*.swp,*.map,public/assets/*,*.beam
let g:ctrlp_custom_ignore = {
  \ 'dir': '\vpublic\/assets',
  \ }
let g:ctrlp_max_files=0

set nocp
filetype indent on
filetype plugin on

" Always strip whitespace for it be evil
" autocmd BufWritePre * :%s/\s\+$//e

set complete=.,w,b,u,t

" Read .rabl and .god files as ruby files for syntax
au BufNewFile,BufRead *.god set filetype=ruby
au BufNewFile,BufRead *.rabl set filetype=ruby

" Checks the files for changes on filesystem when we get focus
au WinEnter * checktime

" Taken from /etc/vim/vimrc
" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Format elixir on save
au BufWritePost *.ex :MixFormat
au BufWritePost *.exs :MixFormat

" Format js with prettier innit
au BufWritePre *.js,*.ts,*tsx :Prettier

" Start up pathogen
call pathogen#infect()
call pathogen#helptags()

" Set up colours correctly - change this to work in sunlight
set background=dark
" set background=light

" Setting a variable so only need to change the one line above to switch
" context
let s:is_dark=(&background == 'dark')

if s:is_dark
  let g:PaperColor_Theme_Options = {
        \   'theme': {
        \     'default': {
        \       'transparent_background': 1
        \     }
        \   }
        \ }
else
  " PaperColor does not do a light transparent background well!
endif

colorscheme PaperColor

" vim-indent-guides overrides because ewwwww for defaults. This should
" probably be done with the PaperColor config but lazy
if s:is_dark
  hi IndentGuidesOdd  ctermbg=236
  hi IndentGuidesEven ctermbg=235
else
  hi IndentGuidesOdd  ctermbg=252
  hi IndentGuidesEven ctermbg=253
endif

syn sync minlines=1000

" Put a line on 80 characters
" let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80"

" :set list! to toggle
set list
" set listchars=tab:>\.
set listchars=tab:\ \ 

" Toggle list and numbers on/off
map  :set nolist! nonumber! <CR>

" Include a space when commenting
let NERDSpaceDelims=1

" Remove all trailing whitespace in a file
map  :%s/[ ^I]\+$// <CR>

" Clear all comment markers (one rule for all languages)
" map _ :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:noh<CR>
" map _ :s/^\([ ^I]*\)#/\1/<CR>:noh<CR>
map _ <leader>ci

"function! s:MyRubySettings()
" Insert comments markers
" map - :s/^/#/<CR>:noh<CR>
map - <leader>cl

" Maps :T to restarting the app
cnoreabbrev T ! echo "Restarting app"; touch /home/esaunder/sites/noths/www/tmp/restart.txt; curl --silent www.dev.noths.com > /dev/null &

" Maps :Z to restarting zeus
cnoreabbrev Z ! echo "Restarting zeus" && restart_zeus

map <space>t :T<cr>
map <space>x :Z<cr>

" Set sensible background for autocomplete
highlight Pmenu ctermfg=18 ctermbg=243 guibg=grey30

" syntastic (plugin) setup
" see :help syntastic for more info
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_mode_map = { 'mode': 'active',
   \ 'active_filetypes': ['ruby', 'eruby', 'php', 'css', 'less', 'cucumber', 'javascript'],
   \ 'passive_filetypes': ['puppet', 'python'] }

" 4-space tabs was a NOTHS frontend thing, fuck that shit!
" autocmd Filetype less setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
" autocmd Filetype javascript setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Start up indent-guides on startup
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors           = 0
let g:indent_guides_start_level           = 1
let g:indent_guides_guide_size            = 1
" Trying out this on all filetypes...
" autocmd Filetype coffee IndentGuidesEnable

let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_jump=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_quiet_warnings=1

" Unite settings
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('line,outline','matchers','matcher_fuzzy')

" Try out the silver searcher...
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:unite_prompt='» '
" let g:unite_source_grep_command='ack'
let g:unite_source_grep_command='ag'
let g:unite_source_grep_default_opts='--no-heading --no-color'
let g:unite_source_grep_recursive_opt=''
nnoremap <silent> <space>/ :Unite -no-quit -auto-preview -buffer-name=search grep:.<cr>

" Gitgutter configuration - set updatetime to something low, according to their
" README this is glitchy if < 1000ms
set updatetime=1000

" Always display powerline
" 0: never
" 1: only if there are at least two windows (this one is the default)
" 2: always
set laststatus=2
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 0
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_symbols.space = "\ua0"

" VimShell into a new irb window
map <space>r :VimShellInteractive --split="split \| resize 20" irb<cr>
map <space>z :VimShellInteractive --split="split \| resize 20" ssh dev.noths.com -t "cd current && zeus c"<cr>

" vim-test is awesome
let test#strategy = "neovim"
map <Leader>f :TestFile<CR>
map <Leader>s :TestNearest<CR>
map <Leader>l :TestLast<CR>
map <Leader>a :TestSuite<CR>
map <Leader>v :TestVisit<CR>

" vim-markdown options
let g:vim_markdown_folding_disabled = 1

" Spellcheck
autocmd BufRead,BufNewFile *.md,*.markdown,*.txt setlocal spell
autocmd FileType gitcommit setlocal spell
hi SpellBad ctermfg=15 ctermbg=1 gui=undercurl guisp=Red

set spelllang=en_gb
map <C-l> :setlocal spell!<CR>

let g:jsx_ext_required = 0

" Neovim configuration
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
endif

" NERDTree open
map <C-n> :NERDTreeFind<CR>
" Ignore compiled bullshit
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" Make camel case into snake case
map <Leader>k :s#\(\<\u\l\+\\|\l\+\)\(\u\)#\l\1_\l\2#g<CR>
map <Leader>K :s#_\(\l\)#\u\1#g<CR>

" Stupid alchemist definition; has to be a better way of doing this. What if I
" move to a different project with a different elixir/erlang version (for
" example). Essentially, you need a specific release of the elixir/erlang
" version we're using, so need to create this folder and do the following:
"
"   $ tar xvzf v1.5.2.tar.gz elixir-1.5.2/
"   $
"   $ wget https://github.com/elixir-lang/elixir/archive/v1.5.2.tar.gz
"   $ wget https://github.com/erlang/otp/archive/OTP-20.1.tar.gz
"   $
"   $ ln -s elixir-1.5.2 elixir
"   $ ln -s otp-OTP-20.1 otp
"
" This gives fucking awesome ability to view source code using :ExDef and
" documentation with K in normal mode, but sticks to a single version of
" elixir/erlang :(
"
let g:alchemist#elixir_erlang_src="/home/seddy/tmp/vim_alchemist_shit"

" vim-mix-format binding for quick happy formatting
map <C-f> :MixFormat<CR>

" Something's gone shit and set the formatprg to do .!mix format -
" Fuck that, I want gqq to align my comment blocks
map <C-g> :set formatprg=<CR>

" Make ctrlp fast - see https://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Shows current highlighting under the cursor. Yoinked from:
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
          \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
          \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Try to vim-flow a bit
let g:javascript_plugin_flow = 1

" Async linting stuff (nicked from @sadir)
" call neomake#configure#automake('wr')
call neomake#configure#automake('nrw')
let g:neomake_serialize = 1

" let g:neomake_javascript_enabled_makers = ['eslint', 'prettier']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_maker = {
        \ 'exe': 'eslint',
        \ 'args': ['--fix'],
        \ }
let g:neomake_javascript_prettier_maker = {
        \ 'exe': 'prettier',
        \ 'args': ['--write'],
        \ }

let g:neomake_elixir_enabled_makers = ['mixf', 'mix', 'credo']
let g:neomake_elixir_mix_maker = {
        \ 'exe': 'mix',
        \ 'args': ['compile'],
        \ 'errorformat':
          \ '** %s %f:%l: %m,'.
          \ '%Ewarning: %m,%C  %f:%l,%Z'
        \ }
let $MIX_QUIET=1
let g:neomake_elixir_mixf_maker = {
        \ 'exe': 'mix',
        \ 'args': ['format'],
        \ 'errorformat':
          \ '** %s %f:%l: %m,'.
          \ '%Ewarning: %m,%C  %f:%l,%Z'
        \ }
let g:neomake_elixir_credo_maker = {
        \ 'exe': 'mix',
        \ 'args': ['credo'],
        \ }

let g:neomake_python_enabled_makers = ['pylint']

" Disable autocompletions in jedi. This is just because beam is massive so
" every time I type `beam` everything pauses while the autocompletion is
" generated
let g:jedi#completions_enabled = 0
" show_call_signatures is a massive pain its default mode because it gets in
" the way of the buffer and makes it impossible to write dags or use beam (as
" there are generally millions of call options). Setting it to 2 does nothing unless showmode is diesabled, which it isn't because it's more useful. But it's more useful than nothing :shrug:
let g:jedi#show_call_signatures = 2
" Changing the buffer is mad when looking for quick documentation
let g:jedi#use_splits_not_buffers = "top"

" Not sure if this should be a neomake thing
autocmd BufWritePre *.py execute ':Black'
" Elasticsearch-fucking-curator means we can't be on a more recent version
let g:black_virtualenv = "~/tmp/black_19.01b"

" Enable syntax folding in typescript for collapsing blocks, but open all
" blocks (zR) when opening files
autocmd Syntax typescript,typescriptreact setlocal foldmethod=syntax
autocmd Syntax typescript,typescriptreact normal zR

" Try to see whether neovim will give me credo feedback. Pro-tip, it does
autocmd BufRead,BufWritePost * Neomake

set autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup my_neomake_hooks
  au!
  autocmd User NeomakeJobFinished :checktime
augroup END

" Misc colour mapping
hi x016_Grey0 ctermfg=16 guifg=#000000
hi x017_NavyBlue ctermfg=17 guifg=#00005f
hi x018_DarkBlue ctermfg=18 guifg=#000087
hi x019_Blue3 ctermfg=19 guifg=#0000af
hi x020_Blue3 ctermfg=20 guifg=#0000d7
hi x021_Blue1 ctermfg=21 guifg=#0000ff
hi x022_DarkGreen ctermfg=22 guifg=#005f00
hi x023_DeepSkyBlue4 ctermfg=23 guifg=#005f5f
hi x024_DeepSkyBlue4 ctermfg=24 guifg=#005f87
hi x025_DeepSkyBlue4 ctermfg=25 guifg=#005faf
hi x026_DodgerBlue3 ctermfg=26 guifg=#005fd7
hi x027_DodgerBlue2 ctermfg=27 guifg=#005fff
hi x028_Green4 ctermfg=28 guifg=#008700
hi x029_SpringGreen4 ctermfg=29 guifg=#00875f
hi x030_Turquoise4 ctermfg=30 guifg=#008787
hi x031_DeepSkyBlue3 ctermfg=31 guifg=#0087af
hi x032_DeepSkyBlue3 ctermfg=32 guifg=#0087d7
hi x033_DodgerBlue1 ctermfg=33 guifg=#0087ff
hi x034_Green3 ctermfg=34 guifg=#00af00
hi x035_SpringGreen3 ctermfg=35 guifg=#00af5f
hi x036_DarkCyan ctermfg=36 guifg=#00af87
hi x037_LightSeaGreen ctermfg=37 guifg=#00afaf
hi x038_DeepSkyBlue2 ctermfg=38 guifg=#00afd7
hi x039_DeepSkyBlue1 ctermfg=39 guifg=#00afff
hi x040_Green3 ctermfg=40 guifg=#00d700
hi x041_SpringGreen3 ctermfg=41 guifg=#00d75f
hi x042_SpringGreen2 ctermfg=42 guifg=#00d787
hi x043_Cyan3 ctermfg=43 guifg=#00d7af
hi x044_DarkTurquoise ctermfg=44 guifg=#00d7d7
hi x045_Turquoise2 ctermfg=45 guifg=#00d7ff
hi x046_Green1 ctermfg=46 guifg=#00ff00
hi x047_SpringGreen2 ctermfg=47 guifg=#00ff5f
hi x048_SpringGreen1 ctermfg=48 guifg=#00ff87
hi x049_MediumSpringGreen ctermfg=49 guifg=#00ffaf
hi x050_Cyan2 ctermfg=50 guifg=#00ffd7
hi x051_Cyan1 ctermfg=51 guifg=#00ffff
hi x052_DarkRed ctermfg=52 guifg=#5f0000
hi x053_DeepPink4 ctermfg=53 guifg=#5f005f
hi x054_Purple4 ctermfg=54 guifg=#5f0087
hi x055_Purple4 ctermfg=55 guifg=#5f00af
hi x056_Purple3 ctermfg=56 guifg=#5f00d7
hi x057_BlueViolet ctermfg=57 guifg=#5f00ff
hi x058_Orange4 ctermfg=58 guifg=#5f5f00
hi x059_Grey37 ctermfg=59 guifg=#5f5f5f
hi x060_MediumPurple4 ctermfg=60 guifg=#5f5f87
hi x061_SlateBlue3 ctermfg=61 guifg=#5f5faf
hi x062_SlateBlue3 ctermfg=62 guifg=#5f5fd7
hi x063_RoyalBlue1 ctermfg=63 guifg=#5f5fff
hi x064_Chartreuse4 ctermfg=64 guifg=#5f8700
hi x065_DarkSeaGreen4 ctermfg=65 guifg=#5f875f
hi x066_PaleTurquoise4 ctermfg=66 guifg=#5f8787
hi x067_SteelBlue ctermfg=67 guifg=#5f87af
hi x068_SteelBlue3 ctermfg=68 guifg=#5f87d7
hi x069_CornflowerBlue ctermfg=69 guifg=#5f87ff
hi x070_Chartreuse3 ctermfg=70 guifg=#5faf00
hi x071_DarkSeaGreen4 ctermfg=71 guifg=#5faf5f
hi x072_CadetBlue ctermfg=72 guifg=#5faf87
hi x073_CadetBlue ctermfg=73 guifg=#5fafaf
hi x074_SkyBlue3 ctermfg=74 guifg=#5fafd7
hi x075_SteelBlue1 ctermfg=75 guifg=#5fafff
hi x076_Chartreuse3 ctermfg=76 guifg=#5fd700
hi x077_PaleGreen3 ctermfg=77 guifg=#5fd75f
hi x078_SeaGreen3 ctermfg=78 guifg=#5fd787
hi x079_Aquamarine3 ctermfg=79 guifg=#5fd7af
hi x080_MediumTurquoise ctermfg=80 guifg=#5fd7d7
hi x081_SteelBlue1 ctermfg=81 guifg=#5fd7ff
hi x082_Chartreuse2 ctermfg=82 guifg=#5fff00
hi x083_SeaGreen2 ctermfg=83 guifg=#5fff5f
hi x084_SeaGreen1 ctermfg=84 guifg=#5fff87
hi x085_SeaGreen1 ctermfg=85 guifg=#5fffaf
hi x086_Aquamarine1 ctermfg=86 guifg=#5fffd7
hi x087_DarkSlateGray2 ctermfg=87 guifg=#5fffff
hi x088_DarkRed ctermfg=88 guifg=#870000
hi x089_DeepPink4 ctermfg=89 guifg=#87005f
hi x090_DarkMagenta ctermfg=90 guifg=#870087
hi x091_DarkMagenta ctermfg=91 guifg=#8700af
hi x092_DarkViolet ctermfg=92 guifg=#8700d7
hi x093_Purple ctermfg=93 guifg=#8700ff
hi x094_Orange4 ctermfg=94 guifg=#875f00
hi x095_LightPink4 ctermfg=95 guifg=#875f5f
hi x096_Plum4 ctermfg=96 guifg=#875f87
hi x097_MediumPurple3 ctermfg=97 guifg=#875faf
hi x098_MediumPurple3 ctermfg=98 guifg=#875fd7
hi x099_SlateBlue1 ctermfg=99 guifg=#875fff
hi x100_Yellow4 ctermfg=100 guifg=#878700
hi x101_Wheat4 ctermfg=101 guifg=#87875f
hi x102_Grey53 ctermfg=102 guifg=#878787
hi x103_LightSlateGrey ctermfg=103 guifg=#8787af
hi x104_MediumPurple ctermfg=104 guifg=#8787d7
hi x105_LightSlateBlue ctermfg=105 guifg=#8787ff
hi x106_Yellow4 ctermfg=106 guifg=#87af00
hi x107_DarkOliveGreen3 ctermfg=107 guifg=#87af5f
hi x108_DarkSeaGreen ctermfg=108 guifg=#87af87
hi x109_LightSkyBlue3 ctermfg=109 guifg=#87afaf
hi x110_LightSkyBlue3 ctermfg=110 guifg=#87afd7
hi x111_SkyBlue2 ctermfg=111 guifg=#87afff
hi x112_Chartreuse2 ctermfg=112 guifg=#87d700
hi x113_DarkOliveGreen3 ctermfg=113 guifg=#87d75f
hi x114_PaleGreen3 ctermfg=114 guifg=#87d787
hi x115_DarkSeaGreen3 ctermfg=115 guifg=#87d7af
hi x116_DarkSlateGray3 ctermfg=116 guifg=#87d7d7
hi x117_SkyBlue1 ctermfg=117 guifg=#87d7ff
hi x118_Chartreuse1 ctermfg=118 guifg=#87ff00
hi x119_LightGreen ctermfg=119 guifg=#87ff5f
hi x120_LightGreen ctermfg=120 guifg=#87ff87
hi x121_PaleGreen1 ctermfg=121 guifg=#87ffaf
hi x122_Aquamarine1 ctermfg=122 guifg=#87ffd7
hi x123_DarkSlateGray1 ctermfg=123 guifg=#87ffff
hi x124_Red3 ctermfg=124 guifg=#af0000
hi x125_DeepPink4 ctermfg=125 guifg=#af005f
hi x126_MediumVioletRed ctermfg=126 guifg=#af0087
hi x127_Magenta3 ctermfg=127 guifg=#af00af
hi x128_DarkViolet ctermfg=128 guifg=#af00d7
hi x129_Purple ctermfg=129 guifg=#af00ff
hi x130_DarkOrange3 ctermfg=130 guifg=#af5f00
hi x131_IndianRed ctermfg=131 guifg=#af5f5f
hi x132_HotPink3 ctermfg=132 guifg=#af5f87
hi x133_MediumOrchid3 ctermfg=133 guifg=#af5faf
hi x134_MediumOrchid ctermfg=134 guifg=#af5fd7
hi x135_MediumPurple2 ctermfg=135 guifg=#af5fff
hi x136_DarkGoldenrod ctermfg=136 guifg=#af8700
hi x137_LightSalmon3 ctermfg=137 guifg=#af875f
hi x138_RosyBrown ctermfg=138 guifg=#af8787
hi x139_Grey63 ctermfg=139 guifg=#af87af
hi x140_MediumPurple2 ctermfg=140 guifg=#af87d7
hi x141_MediumPurple1 ctermfg=141 guifg=#af87ff
hi x142_Gold3 ctermfg=142 guifg=#afaf00
hi x143_DarkKhaki ctermfg=143 guifg=#afaf5f
hi x144_NavajoWhite3 ctermfg=144 guifg=#afaf87
hi x145_Grey69 ctermfg=145 guifg=#afafaf
hi x146_LightSteelBlue3 ctermfg=146 guifg=#afafd7
hi x147_LightSteelBlue ctermfg=147 guifg=#afafff
hi x148_Yellow3 ctermfg=148 guifg=#afd700
hi x149_DarkOliveGreen3 ctermfg=149 guifg=#afd75f
hi x150_DarkSeaGreen3 ctermfg=150 guifg=#afd787
hi x151_DarkSeaGreen2 ctermfg=151 guifg=#afd7af
hi x152_LightCyan3 ctermfg=152 guifg=#afd7d7
hi x153_LightSkyBlue1 ctermfg=153 guifg=#afd7ff
hi x154_GreenYellow ctermfg=154 guifg=#afff00
hi x155_DarkOliveGreen2 ctermfg=155 guifg=#afff5f
hi x156_PaleGreen1 ctermfg=156 guifg=#afff87
hi x157_DarkSeaGreen2 ctermfg=157 guifg=#afffaf
hi x158_DarkSeaGreen1 ctermfg=158 guifg=#afffd7
hi x159_PaleTurquoise1 ctermfg=159 guifg=#afffff
hi x160_Red3 ctermfg=160 guifg=#d70000
hi x161_DeepPink3 ctermfg=161 guifg=#d7005f
hi x162_DeepPink3 ctermfg=162 guifg=#d70087
hi x163_Magenta3 ctermfg=163 guifg=#d700af
hi x164_Magenta3 ctermfg=164 guifg=#d700d7
hi x165_Magenta2 ctermfg=165 guifg=#d700ff
hi x166_DarkOrange3 ctermfg=166 guifg=#d75f00
hi x167_IndianRed ctermfg=167 guifg=#d75f5f
hi x168_HotPink3 ctermfg=168 guifg=#d75f87
hi x169_HotPink2 ctermfg=169 guifg=#d75faf
hi x170_Orchid ctermfg=170 guifg=#d75fd7
hi x171_MediumOrchid1 ctermfg=171 guifg=#d75fff
hi x172_Orange3 ctermfg=172 guifg=#d78700
hi x173_LightSalmon3 ctermfg=173 guifg=#d7875f
hi x174_LightPink3 ctermfg=174 guifg=#d78787
hi x175_Pink3 ctermfg=175 guifg=#d787af
hi x176_Plum3 ctermfg=176 guifg=#d787d7
hi x177_Violet ctermfg=177 guifg=#d787ff
hi x178_Gold3 ctermfg=178 guifg=#d7af00
hi x179_LightGoldenrod3 ctermfg=179 guifg=#d7af5f
hi x180_Tan ctermfg=180 guifg=#d7af87
hi x181_MistyRose3 ctermfg=181 guifg=#d7afaf
hi x182_Thistle3 ctermfg=182 guifg=#d7afd7
hi x183_Plum2 ctermfg=183 guifg=#d7afff
hi x184_Yellow3 ctermfg=184 guifg=#d7d700
hi x185_Khaki3 ctermfg=185 guifg=#d7d75f
hi x186_LightGoldenrod2 ctermfg=186 guifg=#d7d787
hi x187_LightYellow3 ctermfg=187 guifg=#d7d7af
hi x188_Grey84 ctermfg=188 guifg=#d7d7d7
hi x189_LightSteelBlue1 ctermfg=189 guifg=#d7d7ff
hi x190_Yellow2 ctermfg=190 guifg=#d7ff00
hi x191_DarkOliveGreen1 ctermfg=191 guifg=#d7ff5f
hi x192_DarkOliveGreen1 ctermfg=192 guifg=#d7ff87
hi x193_DarkSeaGreen1 ctermfg=193 guifg=#d7ffaf
hi x194_Honeydew2 ctermfg=194 guifg=#d7ffd7
hi x195_LightCyan1 ctermfg=195 guifg=#d7ffff
hi x196_Red1 ctermfg=196 guifg=#ff0000
hi x197_DeepPink2 ctermfg=197 guifg=#ff005f
hi x198_DeepPink1 ctermfg=198 guifg=#ff0087
hi x199_DeepPink1 ctermfg=199 guifg=#ff00af
hi x200_Magenta2 ctermfg=200 guifg=#ff00d7
hi x201_Magenta1 ctermfg=201 guifg=#ff00ff
hi x202_OrangeRed1 ctermfg=202 guifg=#ff5f00
hi x203_IndianRed1 ctermfg=203 guifg=#ff5f5f
hi x204_IndianRed1 ctermfg=204 guifg=#ff5f87
hi x205_HotPink ctermfg=205 guifg=#ff5faf
hi x206_HotPink ctermfg=206 guifg=#ff5fd7
hi x207_MediumOrchid1 ctermfg=207 guifg=#ff5fff
hi x208_DarkOrange ctermfg=208 guifg=#ff8700
hi x209_Salmon1 ctermfg=209 guifg=#ff875f
hi x210_LightCoral ctermfg=210 guifg=#ff8787
hi x211_PaleVioletRed1 ctermfg=211 guifg=#ff87af
hi x212_Orchid2 ctermfg=212 guifg=#ff87d7
hi x213_Orchid1 ctermfg=213 guifg=#ff87ff
hi x214_Orange1 ctermfg=214 guifg=#ffaf00
hi x215_SandyBrown ctermfg=215 guifg=#ffaf5f
hi x216_LightSalmon1 ctermfg=216 guifg=#ffaf87
hi x217_LightPink1 ctermfg=217 guifg=#ffafaf
hi x218_Pink1 ctermfg=218 guifg=#ffafd7
hi x219_Plum1 ctermfg=219 guifg=#ffafff
hi x220_Gold1 ctermfg=220 guifg=#ffd700
hi x221_LightGoldenrod2 ctermfg=221 guifg=#ffd75f
hi x222_LightGoldenrod2 ctermfg=222 guifg=#ffd787
hi x223_NavajoWhite1 ctermfg=223 guifg=#ffd7af
hi x224_MistyRose1 ctermfg=224 guifg=#ffd7d7
hi x225_Thistle1 ctermfg=225 guifg=#ffd7ff
hi x226_Yellow1 ctermfg=226 guifg=#ffff00
hi x227_LightGoldenrod1 ctermfg=227 guifg=#ffff5f
hi x228_Khaki1 ctermfg=228 guifg=#ffff87
hi x229_Wheat1 ctermfg=229 guifg=#ffffaf
hi x230_Cornsilk1 ctermfg=230 guifg=#ffffd7
hi x231_Grey100 ctermfg=231 guifg=#ffffff
hi x232_Grey3 ctermfg=232 guifg=#080808
hi x233_Grey7 ctermfg=233 guifg=#121212
hi x234_Grey11 ctermfg=234 guifg=#1c1c1c
hi x235_Grey15 ctermfg=235 guifg=#262626
hi x236_Grey19 ctermfg=236 guifg=#303030
hi x237_Grey23 ctermfg=237 guifg=#3a3a3a
hi x238_Grey27 ctermfg=238 guifg=#444444
hi x239_Grey30 ctermfg=239 guifg=#4e4e4e
hi x240_Grey35 ctermfg=240 guifg=#585858
hi x241_Grey39 ctermfg=241 guifg=#626262
hi x242_Grey42 ctermfg=242 guifg=#6c6c6c
hi x243_Grey46 ctermfg=243 guifg=#767676
hi x244_Grey50 ctermfg=244 guifg=#808080
hi x245_Grey54 ctermfg=245 guifg=#8a8a8a
hi x246_Grey58 ctermfg=246 guifg=#949494
hi x247_Grey62 ctermfg=247 guifg=#9e9e9e
hi x248_Grey66 ctermfg=248 guifg=#a8a8a8
hi x249_Grey70 ctermfg=249 guifg=#b2b2b2
hi x250_Grey74 ctermfg=250 guifg=#bcbcbc
hi x251_Grey78 ctermfg=251 guifg=#c6c6c6
hi x252_Grey82 ctermfg=252 guifg=#d0d0d0
hi x253_Grey85 ctermfg=253 guifg=#dadada
hi x254_Grey89 ctermfg=254 guifg=#e4e4e4
hi x255_Grey93 ctermfg=255 guifg=#eeeeee
