# vim-simple-project
A very, very simple project plugin for vim.

I made this because I was annoyed at having to cd to my project root every time
I wanted to be able to search within a project for various files, and I wanted
to be able to set some vim settings per-project (such as the theme), since I
have a few projects with very similar files and wanted to make sure I never got
confused about which project files belonged to.

I tried other project plugins in the past, but all of them required managing
project lists in a centralised location and added a lot of extra
boilerplate, which I didn't want.

This is a very simple plugin and I don't expect anyone else to want to use it,
it's here in case anyone finds it useful.

# How to install and use
To install it, simply add it using your favourite package manager

Once installed, create a `project.vim` file at the root of your project.

Once this file has been created:
- Any file opened within the project directory will set it's working dir to
  match the location of the `project.vim` file (for easy searching through the
  entire project with `:find` etc).
- The `project.vim` file will be sourced every time a buffer from any file
  related to the project is opened. Add any arbitrary per-project commands you
  wish to use in this file and they will be automatically run when editing any
  file of the project.
- use `:ProjectEdit` to edit the `project.vim` file for the current project.
  You can also use `:ProjectEditV` and `ProjectEditH` to open in splits, and
  `:ProjectEditT` to open in a tab.
- use `:ProjectWiki` to create a `wiki` folder at the root of your project
  directory, and edit `wiki/index.md`. This is a very simple documentation
  solution and there's nothing smart about it, so don't expect it to work like
  vimwiki or any other documentation plugin. You can change the wiki location
  using the `g:ProjectWikiPath` for the folder path, and `g:ProjectWikiIndex`
  for the name of the index file. `:ProjectWikiV`, `:ProjectWikiH` and
  `:ProjectWikiT` also work.
