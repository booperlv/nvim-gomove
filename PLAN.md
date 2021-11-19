### core / nvim-gomove

- [ ] selections

  - [ ] lines (handles lines & fold selections)
    - [ ] vertical.lua (move, duplicate)
      - [+] move
      *TODO*: undojoining of fold-selections
      - [ ] duplicate
    - [+] horizontal.lua (move, duplicate)
      - [+] move
      - [+] duplicate
    
  - [+] blocks (handles block selections)
    - [+] vertical.lua (move, duplicate)
      - [+] move
      - [+] duplicate
    - [+] horizontal.lua (move, duplicate)
      - [+] move
      - [+] duplicate
    
  - [ ] motions (handles anything as long we can del-paste to new position)
  <!-- this might have to support/take into account a few plugins such as hop,
  lightspeed etc.-->
    - [ ] handle-motions.lua (get new position of motion and report)
    - [ ] init.lua (move, duplicate)
      - [ ] move
      - [ ] duplicate

- [+] mappings
  - [+] init.lua
  - [+] base.lua
  - [+] smart.lua

- [x] utils.lua (ContainsFold, GoTo, Range and such things)
- [ ] fold.lua (give a vertical "distance, starting, end" to report a position past folds)
  *TODO*: add behavior to actually "move along" instead of "move past all" folds
  when the selection is an actual fold
  *TODO*: split into the files: main fold - has an argument for block/line
  instead of seperate files like now, and init - which interfaces main fold
  file.

- [x] undo.lua (undo/undo parse handling)
  *TODO*: do refactor to undo fold-selections

- [x] config.lua (handle configuration/settings)
- [x] init.lua (interface to config/setup function)
