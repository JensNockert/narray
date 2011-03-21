# :stopdoc:

require 'mkmf'
require 'rbconfig'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
INCLUDEDIR = Config::CONFIG['includedir']

if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'macruby'
  $LIBRUBYARG_STATIC.gsub!(/-static/, '')
end

$CFLAGS << " #{ENV["CFLAGS"]}"
$LIBS << " #{ENV["LIBS"]}"

if RbConfig::MAKEFILE_CONFIG['CC'] =~ /gcc/
  $CFLAGS << " -O3 -Wall -Wcast-qual -Wwrite-strings -Wconversion -Wmissing-noreturn -Winline"
end

def have_type(type, header=nil)
  print "checking for #{type}... "; STDOUT.flush
  
  src =  "#include <ruby.h>\n"
  src << "#include <#{header}>\n" if header
  
  if try_link(src + "int main() { return 0; }\nint t() { #{type} a; return 0; }");
    puts "yes"
    
    $defs.push("-DHAVE_#{type.upcase}")
    
    return true
  else
    puts "no"
    
    return false
  end
end

if find_header(integer_header = 'stdint.h')
elsif find_header(integer_header = 'sys/types.h')
else
  integer_header = nil
end

have_type("u_int8_t",   integer_header)
have_type("uint8_t",    integer_header)
have_type("int16_t",    integer_header)
have_type("int32_t",    integer_header)
have_type("u_int32_t",  integer_header)
have_type("uint32_t",   integer_header)

def create_conf_h(file)
  puts "creating #{file}"
  
  File.open(file, 'w') do |f|
    for line in $defs
      line =~ /^-D(.*)/
      f.puts "#define #{$1} 1"
    end
  end
end


$objs = Dir.glob('*.c').map { |x| x.gsub(/\.c$/, '.o') } + ['na_op.o', 'na_math.o']

create_conf_h("narray_config.h")
create_makefile("narray")

# :startdoc: