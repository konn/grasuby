=begin
= Grasuby -- Grass rUBY interpreter and his friends

  ver 0.1b1 2008-09-15T02:20:51+09:00
  
  Copyright (c) 2008 Hiromi Ishii
  
  You can redistribute it and/or modify it under the same term as Ruby.


== What is this?
Yet anoter grass interpreter that perhaps work.

== Usage
Result is written to the standard output.
=== Interpreter
Interprete
 $ echo 'wWWwwww' | ruby grasuby.rb

Or, 

 $ ruby grasuby.rb prog.www

=== Compile
Compile from formal notation to grass program.

  $ cat prog1.asm
  [[:abs, 1, [[:app, 5, 1], [:app, 3, 1], [:app, 3, 3]]]]
  $ ruby1.9 grasuby.rb compile prog1.asm
  wWWWWWwWWWwWWWwww
  $ cat prog2.asm
  [Abs(1, [App(5,1),App(3,1),App(3,3)])]
  $ ruby1.9 grasuby.rb compile prog2.asm
  wWWWWWwWWWwWWWwww

=== Decompile
Decompile from Grass program to formal notation.

  $ cat prog.www
  wWWWWWwWWWwWWWwww
  $ ruby1.9 grasuby.rb decompile prog.www
  [[:abs, 1, [[:app, 5, 1], [:app, 3, 1], [:app, 3, 3]]]]

=== Evaluate
Evaluate formal notation.

  $ cat prog3.asm
  [[:abs, 1, [[:app, 2, 4]]]]
  $ grasuby.rb evaluate prog3.asm
  w
  $ cat prog4.asm
  [Abs(1, [App(2, 4)])]
  $ grasuby.rb evaluate prog4.asm
  w

== Todo
(1) Test.