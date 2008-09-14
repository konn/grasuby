=begin
= Grasuby -- Grass rUBY interpreter and his friends

  ver 0.5b2 2008-08-27T12:17:46+09:00
  
  Copyright (c) 2008 Hiromi Ishii
  
  You can redistribute it and/or modify it under the same term as Ruby.


== What is this?
Yet anoter grass interpreter that does not really work.
10% of features are not implemented.

== Usage
Result is written to the standard output.
=== Interpreter
Interprete
 $ echo 'wWWwwww' | ruby grasuby.rb

Or, 

 $ ruby grasuby.rb prog.www

=== Compile
Compile from formal notation to grass program.

 $ grasuby.rb compile prog.grass

=== Decompile
Decompile from Grass program to formal notation.

 $ grasuby.rb decompile prog.www

=== Evaluate
Evaluate formal notation.

 $ grasuby.rb evaluate prog.grass

== Todo
(1) Implement all the features.