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
- [x] init.lua (handle configuration/settings)

## Planned

<!-- this might have to support specifically a few plugins such as hop,
lightspeed etc. alternatively, this could be an entirely separate plugin as this
mostly revolves around the concept of deleting and pasting to positions, rather
than "moving" them by hand. However, there is much discussion and planning to be
done for this -->
- [ ] motions (handles anything as long we can del-paste to new position)
  - [ ] handle-motions.lua (get new position of motion and report)
  - [ ] init.lua (move, duplicate)
    - [ ] move
    - [ ] duplicate

## TODO

- comment more of the code 
- explore treesitter capability

- codebase cleanup/refactoring + bug fixing
  - [ ] mappings
    (could be made more intuitive and less repetitive)
    - [ ] base
    - [ ] init
    - [ ] smart
  - [ ] selections
    - [x] handle_vertical
    - [ ] block
      - [ ] vertical
        (fix behavior with multi-width characters)
      - [x] horizontal
    - [ ] line
      - [ ] vertical
        (functionality is perfect, but commenting and cleanup)
      - [ ] horizontal
        (commenting and cleanup)
  - [x] init.lua
  - [x] undo.lua
  - [x] utils.lua

- add plenary tests
