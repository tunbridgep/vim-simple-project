" simple-project.vim
" Simple Project Management
" 
" Simply create a project.vim file at the root
" of your project, and it will be loaded automatically
"""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ProjectWikiPath = 'wiki'
let g:ProjectWikiIndex = 'index.md'
let g:ProjectAutoCMD = 1
let g:ProjectAutoSession = 1

" Dirty Hack!
function! s:GetSlash()
    if has('win32')
        return '\'
    else
        return '/'
    endif
endfunction

" Ask for confirmation when making a project or wiki dir
function! s:AskForConfirmation(question,dir) abort
    echom a:question.' '.a:dir.'?'
    while 1
        let choice = inputlist(['1. yes', '2. no'])
        if choice != 'q' && choice != '' && choice != 0 && choice != 1
            redraw!
            echohl WarningMsg
            echo 'Please enter a number between 1 and 2'
            echohl None
            continue
        elseif choice == 1
            return 1
        else
            return 0
        endif
        break
    endwhile
endfunction

" Gets our project dir by recursing upwards through the folder tree
function! s:GetProjectDir()
    let lookFor='project.vim'
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            let projectFile=expand(fileToCheck)
            let g:currentProject=projectFile
            let g:currentProjectDir=expand(pathMaker)
            return expand(pathMaker)
        endif
    endwhile
    return ""
endfunction

" Load the project file when we switch to a new buffer
function! s:LoadProject()
    let dir=s:GetProjectDir()
    if dir!=""
        execute 'source '.dir.'/project.vim'
        if g:ProjectAutoCMD > 0
            execute 'cd '.dir
        endif
        if g:ProjectAutoSession > 0
            execute 'mksession! '.dir.'/projectsession.vim'
        endif
        " echo 'Found project '.dir
    else
        " echo 'No project found'
    endif
endfunction

function! s:RefreshProjectDir()
    if g:ProjectAutoCMD <= 0
        return
    endif
    let dir=s:GetProjectDir()
    if dir!=""
        execute 'cd '.dir
    endif
endfunction

function! s:OpenProjectSession()
    let dir=s:GetProjectDir()
    if dir!="" && g:ProjectAutoSession > 0
        execute 'source '.dir.'/projectsession.vim'
    endif
endfunction

" Open the actual project file
function! s:OpenProjectFile(type)
    let dir=s:GetProjectDir()
    if (dir=='')
        let dir = getcwd()
    endif
    let file=dir.s:GetSlash().'project.vim'
    if filereadable(file) || s:AskForConfirmation('Create new project.vim file at',dir) == 1
        if a:type == 'v'
            execute 'vsp '.file
        elseif a:type == 's'
            execute 'split '.file
        elseif a:type == 't'
            execute 'tabe '.file
        else
            execute 'e '.file
        endif
    endif
endfunction

" Open the project wiki
function! s:AccessProjectWiki(type)
    let dir=s:GetProjectDir().s:GetSlash().g:ProjectWikiPath
    if !isdirectory(dir) && s:AskForConfirmation('Create new wiki at',dir) == 0
        return
    elseif !isdirectory(dir)
        call mkdir(dir)
    endif
    if a:type == 'v'
        execute 'vsp '.dir.'/'.g:ProjectWikiIndex
    elseif a:type == 's'
        execute 'split '.dir.'/'.g:ProjectWikiIndex
    elseif a:type == 't'
        execute 'tabe '.dir.'/'.g:ProjectWikiIndex
    else
        execute 'e '.dir.'/'.g:ProjectWikiIndex
    endif
endfunction

" Commands
command! ProjectEdit call s:OpenProjectFile('')
command! ProjectEditV call s:OpenProjectFile('v')
command! ProjectEditH call s:OpenProjectFile('s')
command! ProjectEditT call s:OpenProjectFile('t')
command! ProjectWikiV call s:AccessProjectWiki('v')
command! ProjectWikiH call s:AccessProjectWiki('s')
command! ProjectWikiT call s:AccessProjectWiki('t')
command! ProjectWiki call s:AccessProjectWiki('')
command! ProjectSession call s:OpenProjectSession()

augroup ProjectPluginFunctions
    autocmd!
    " Reload project whenever we change buffers so we can set cwd correctly.
    autocmd BufEnter,BufNew,BufRead * call s:LoadProject()
    " and fix autochdir
    autocmd DirChanged auto call s:RefreshProjectDir()
augroup END
