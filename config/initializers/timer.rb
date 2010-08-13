
def print_time name, &block
  print "#{name}..."
  a = Time.now
  foo = yield block
  b = Time.now
  print " Used #{b-a} seconds.\n"
  return foo
end


