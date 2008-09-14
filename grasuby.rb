#!/usr/bin/env ruby1.9 --encoding=UTF-8
# -*- encoding: utf-8 -*-

Machine = Struct.new(:code, :env, :dump)
class Machine
  def to_a
    [code, env, dump]
  end
end

Env0 =  [:out, :succ, :w, :in].map{|i| [[[:abs, 1, i]], []]}
Dump0 = [ [[[:app, 1, 1]], []], [[],[]] ]

def to_church(v)
  if Numeric === v
    return (v.to_i%256).chr.intern
  elsif v
    return [:abs, 2]
  else
  end
end

def trans(m)
  c, e, d = [*m].map(&:dup)
  if c.empty?
    f = e.first
    (c, e), *d = d.map(&:dup)
    return Machine.new( c, e.dup.unshift(f.dup), d)
  end
  
  (c, a, b), *rest = c.map(&:dup)
  case c
  when :app
    raise "index must be larger than 0" unless a >= 1 && b >= 1
    (cm, em), (cn, en) = e[a-1].map(&:dup), e[b-1].map(&:dup)
    return Machine.new(cm, em.unshift([cn, en]), d.unshift([rest,e]))
  when :abs
    b = b.dup unless b.is_a?(Symbol)
    if a < 1
      raise "index must be larger than 0"
    elsif a == 1
      arg = e[0][0][0][-1]
      case b
      when :succ
        b = ((arg.to_s.bytes.to_a[0]+1)%256).chr
      when :out
        print arg.to_s
        b = arg
      when :in
        b = $<.getc || arg
      when Symbol
        b = to_church(b == arg)
      end
      return Machine.new(rest, e.unshift([b, e.map(&:dup)]), d)
    else
      return Machine.new(rest, e.unshift([ [[:abs, a-1, b]], e.map(&:dup)]), d)
    end
  else
    raise "illegal instruction: #{c.inspect}"
  end
end

def evaluate(insts)
  m = Machine.new( insts, Env0, Dump0 )
  loop do
    break m if m.code.empty? && m.dump.empty?
    m = trans(m)
  end
end

def decompile(src)
  src.tr!("ｗＷｖ", "wWv")
  src.gsub!(/[^wWv]/m,"")
  src.gsub!(/^[^w]+/, "")
  return src.split("v").map{|s|
    case s
    when /^(w+)((?:W+w+)*)$/
      count = $1.size
      body = $2.split(/(?<=w)(?=W)/).map{|t|
        t=~/^(W+)(w+)$/; [:app, $1.size, $2.size]
      }
      [:abs, count, body]
    when /^((?:W+w+)*)$/
      $1.split(/(?<=w)(?=W)/).map{|t|
        t=~/^(W+)(w+)$/; [:app, $1.size, $2.size]
      }
    else
      raise "syntax error"
    end
  }
end

def run(src)
  evaluate decompile(src)
end

def Abs(n, args)
  [:abs, n, args]
end

def App(n, m)
  [:app, n, m]
end

def compile(insts)
  insts.map{|i| compile_sub(*i)}.join("v")
end

def compile_sub(inst, a, b)
  case inst
  when :abs
    "w"*a+b.map{|i|compile_sub(*i)}.join("")
  when :app
    "W"*a + "w"*b
  end
end

if $0 == __FILE__
  mode = :run
  if ARGV.size <= 1
    run(ARGF.read)
  else
    mode = ARGV.shift
    src = ARGF.read
    case mode
    when /^decompile$/i
      p decompile(src)
    when /^compile$/i
      puts compile(eval(src))
    when /^run$/i
      run src
    when /^evaluate$/i
      evaluate eval(src)
    end
  end
end