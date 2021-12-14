### core / nvim-gomove

- [ ] selections

  - [ ] lines (handles lines & fold selections)
    - [ ] vertical.lua (move, duplicate)
      - [x] move
      - [ ] duplicate
    - [x] horizontal.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    
  - [x] blocks (handles block selections)
    - [x] vertical.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    - [x] horizontal.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    
  - [ ] motions (handles anything as long we can del-paste to new position)
  <!-- this might have to support/take into account a few plugins such as hop,
  lightspeed etc.-->
    - [ ] handle-motions.lua (get new position of motion and report)
    - [ ] init.lua (move, duplicate)
      - [ ] move
      - [ ] duplicate

- [x] mappings
  - [x] init.lua
  - [x] base.lua
  - [x] smart.lua

- [x] utils.lua (ContainsFold, GoTo, Range and such things)
- [x] fold.lua (give a vertical "distance, starting, end" to report a position past folds)
  *TODO*: add behavior to actually "move along" instead of "move past all" folds
  when the selection contains an actual fold

- [x] undo.lua (undo/undo parse handling)

- [x] config.lua (handle configuration/settings)
- [x] init.lua (interface to config/setup function)
