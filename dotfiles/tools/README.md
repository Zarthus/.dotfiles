# Sync

Synchronizes your dotfiles with

(1) your computer
(2) this repository

## Usage

Run `sync.rb` with either `machine` or `repo(sitory)`

With `machine` we synchronize all files specified in `.syncmap` from this
repository to your $HOME, overwriting any changes.

With `repo` we synchronize all files specified in `.syncmap` relative from your $HOME
to this repository, overwriting any changes.

## Known bugs

Currently directory copies are not working 100% yet
