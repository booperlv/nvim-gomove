### booperlv / nvim-gomove

- [x] selections

  - [x] init.lua (moving/reporting vertical destinations)

  - [x] lines (handles lines & fold selections)
    - [x] vertical.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    - [x] horizontal.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    
  - [x] blocks (handles block selections)
    - [x] vertical.lua (move, duplicate)
      - [ ] move
      - [x] duplicate
    - [x] horizontal.lua (move, duplicate)
      - [x] move
      - [x] duplicate
    
- [x] mappings
  - [x] init.lua
  - [x] base.lua
  - [x] smart.lua

- [x] utils.lua

- [x] undo.lua (undo/undo parse handling)

- [x] config.lua (handle configuration/settings)
- [x] init.lua (interface to config/setup function)

## Planned

<!-- this might have to support specifically a few plugins such as hop,
lightspeed etc.-->
- [ ] motions (handles anything as long we can del-paste to new position)
  - [ ] handle-motions.lua (get new position of motion and report)
  - [ ] init.lua (move, duplicate)
    - [ ] move
    - [ ] duplicate

## TODO

- comment more of the code
