"
" ORIGINAL GIST: https://gist.github.com/thecompyoda/074cdb6c04c52198b2ab9165ed93e828
" DATE: 30/10/16

"---------------------
"   1. vim options
"---------------------
 
"{{{
    syntax enable           " enable syntax processing
    set background=dark     " set the background for the colorscheme below
    set number              " show line numbers
    set tabstop=4           " number of visual spaces per TAB
    set softtabstop=4       " number of spaces in tab when editing
    set expandtab           " tabs are spaces
    set showcmd             " show command in bottom bar
    set cursorline          " highlight current line
    set wildmenu            " visual autocomplete for command menu
    set lazyredraw          " redraw only when its needed
    set showmatch           " highlight matching [{()}]
    set incsearch           " search as characters are entered
    set hlsearch            " highlight search matches
    set modelines=1         " look at the very last line of a file for file specific vim settings
"   set list                " show trailing special characters e.g. whitespace, tabs, newline etc...
    set colorcolumn=110     " 
"}}}

"--------------------- 
"   2. Key Mapping - WIP 
"---------------------

"{{{
    nnoremap <Space> za      " space open/closes folds
"}}}

"---------------------
"   3. Color Options
"---------------------

"{{{
    let g:solarized_termcolors=256      " 16|256                - number of colors to use
    let g:solarized_termtrans=1         " 1|0                   - toggle transparne background
    let g:solarized_bold=1              " 1|0                   - show/hide bold typefaces
    let g:solarized_underline=1         " 1|0                   - show/hide underlined typefaces
    let g:solarized_italic=1            " 1|0                   - show/hide italic typefaces
    let g:solarized_contrast="normal"   " normal|high|low       - set contrast level
    let g:solarized_visibility="normal" " normal|high|low       - set intensity of 'set list' above

    colorscheme solarized               " load the solarized colorscheme
"}}}

"---------------------
"   4. Notes & To-Do's
"---------------------

"{{{
"   Add gundo from https://github.com/sjl/gundo.vim.git
"   Add ctrlp from https://github.com/kien/ctrlp.vim.git
"   Add Launch Config, ctrlp bindings, gundo bindings,
"       autogroups, & custom functions
"       from http://dougblack.io/words/a-good-vimrc.html
"}}}

"init pathogen
execute pathogen#infect()

" LOAD NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" vim:foldenable:foldlevel=0:foldmethod=marker:foldnestmax=10
