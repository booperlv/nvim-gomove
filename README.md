
## This is simply for storing progress, for the most part, and likely for a long time, this will be unusable. Please do not use this branch for actual use.

## Major Refactor

The current code base is very messy and hard to understand. And I think a big
part of it is because I've been trying to copy the approach of plugins before,
which is to "pretend" to be a human interacting and deciding how to deal with
the text. And it has worked well for the most part. However, for what
nvim-gomove wants to do, I don't think it's the best way, and it gets
repetitive very quick.

Therefore, In the following months I will be attempting a huge refactor that will
follow a more organized approach, wherein we will:
- cut ranges of text
- parse cut text into tables of rows and columns
- rearrange said tables
- paste

This will make multiple features easier, including trailing whitespace, undojoin,
supporting multiwidth unicode characters, etc.

The main goal of this new concept is to minimize complexity with reuseable
portions of code, minimizing edge case handling, and overall creating a more
user-like interaction with the "text tables", as we can process said tables
easily; instead of trying to interact like a user, as a computer.
