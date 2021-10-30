### core / nvim-gomove

- [ ] gomove-selections

  - [ ] lines (handles lines & fold selections)
    - [ ] vertical.lua (move, duplicate)
    - [ ] horizontal.lua (move, duplicate)
    
  - [ ] blocks (handles block selections)
    - [ ] vertical.lua (move, duplicate)
    - [ ] horizontal.lua (move, duplicate)
    
  - [ ] motions (handles anything as long we can del-paste to new position)
  <!-- this might have to support/take into account a few plugins such as hop,
  lightspeed etc.-->
    - [ ] handle-motions.lua (get new position of motion and report)
    - [ ] init.lua (move, duplicate)

- mappings
  - [ ] init.lua
  - [ ] base.lua
  - [ ] smart.lua

- [+] utils.lua (ContainsFold, GoTo, Range and such things)
- [+] fold.lua (give a vertical "distance, starting, end" to report a position past folds)

- [+] undo.lua (undo/undo parse handling)

- [+] config.lua (handle configuration/settings)
- [+] init.lua (interface to config/setup function)
