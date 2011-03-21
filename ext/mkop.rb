require 'erb'

require "#{File.dirname(__FILE__)}/generator/ntype"
require "#{File.dirname(__FILE__)}/generator/nfunction"

NOps = [
  {
    :name => :Set, :kind => :assignment, :visibility => :public,
    :documentation => "Elementwise assignment, _x_ = _y_.",
    :implementation => {
      [:object,   :u8]      => { :code => 'object_short.c' },
      [:object,   :i16]     => { :code => 'object_short.c' },
      [:object,   :i32]     => { :code => 'object_long.c' },
      [:object,   :float]   => { :code => 'object_float.c' },
      [:object,   :complex] => { :code => 'object_complex.c' },
      [:object,   :object]  => { :code => 'object_object.c' },
      [:real,     :real]    => { :code => 'real_real.c' },
      [:real,     :complex] => { :code => 'real_complex.c' },
      [:integer,  :object]  => { :code => 'integer_object.c' },
      [:float,    :object]  => { :code => 'float_object.c' },
      [:complex,  :real]    => { :code => 'complex_real.c' },
      [:complex,  :complex] => { :code => 'complex_complex.c' },
      [:complex,  :object]  => { :code => 'complex_object.c' },
    },
  },
  
  {
    :name => :Swp, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a byteswapped copy of _x_.",
    :implementation => {
      [:object]   => { :code => 'identity.c', :output => :identity },
      [:size8]    => { :code => 'identity.c', :output => :identity },
      [:size16]   => { :code => 'size16.c',   :output => :identity },
      [:size32]   => { :code => 'size32.c',   :output => :identity },
      [:f64]      => { :code => 'size64.c',   :output => :identity },
      [:c32]      => { :code => 'size64c.c',  :output => :identity },
      [:c64]      => { :code => 'size128c.c', :output => :identity }
    }
  },
  
  {
    :name => :Neg, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns _-x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :AddU, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise adds _y_ to _x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :SbtU, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise subtracts _y_ from _x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :MulU, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise multiplies _x_ by _y_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :DivU, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise divide _x_ by _y_.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :ModU, :kind => :elementwise, :visibility => :public,
    :documentation => "The elementwise remainder of _x_ divided by _y_.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :ImgSet, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise assignment of the imaginary part, Im(_x_) = _y_.",
    :implementation => {
      [:complex]  => { :code => 'complex.c', :output => :real }
    }
  },
  
  {
    :name => :Floor, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of _x_ rounded down.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity }
    }
  },
  
  {
    :name => :Ceil, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of _x_ rounded up.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity }
    }
  },
  
  {
    :name => :Round, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of _x_ rounded towards zero.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity }
    }
  },
  
  {
    :name => :Abs, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of the absolute value of _x_.",
    :implementation => {
      [:u8]       => { :code => 'u8.c',       :output => :real },
      [:i16]      => { :code => 'real.c',     :output => :real },
      [:float]    => { :code => 'real.c',     :output => :real },
      [:complex]  => { :code => 'complex.c',  :output => :real },
      [:object]   => { :code => 'object.c',   :output => :real }
    }
  },
  
  {
    :name => :Real, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of Re(_x_).",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :real },
      [:complex]  => { :code => 'complex.c',  :output => :real }
    }
  },
  
  {
    :name => :Imag, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns a copy of Im(_x_).",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :real },
      [:complex]  => { :code => 'complex.c',  :output => :real }
    }
  },
  
  {
    :name => :Angl, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the angle of _x_.",
    :implementation => {
      [:complex]  => { :code => 'complex.c',  :output => :real }
    }
  },
  
  {
    :name => :ImagMul, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns _x_ multiplied by the imaginary unit.",
    :implementation => {
      [:float]    => { :code => 'real.c',     :output => :complex },
      [:complex]  => { :code => 'complex.c',  :output => :complex }
    }
  },
  
  {
    :name => :Conj, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the complex conjugate of _x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity }
    }
  },
  
  {
    :name => :Not, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the logical not of _x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :u8 },
      [:complex]  => { :code => 'complex.c',  :output => :u8 },
      [:object]   => { :code => 'object.c',   :output => :u8 }
    }
  },
  
  {
    :name => :BRv, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the bitwise negation of _x_.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :Min, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the minimum value of each pair of elements in _x_ and _y_.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :Max, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns the maximum value of each pair of elements in _x_ and _y_.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :identity },
      [:float]    => { :code => 'float.c',    :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :Sort, :kind => :sort, :visibility => :public,
    :documentation => "Sorts _x_ by value.",
    :implementation => {
      [:real,   :previous]   => { :code => 'real.c' },
      [:object, :previous] => { :code => 'object.c' }
    }
  },
  
  # TODO: Fix SortIdx and find out what it does...
  # {
  #   :name => :SortIdx, :kind => :sort, :visibility => :public,
  #   :documentation => "Sorts _x_ by ..?",
  #   :implementation => {
  #     [:real,   :previous] => { :code => 'real.c' },
  #     [:object, :previous] => { :code => 'object.c' }
  #   }
  # },
  
  {
    :name => :IndGen, :kind => :generator, :visibility => :public,
    :documentation => "Generates indices.",
    :implementation => {
      [:real]     => { :code => 'real.c' },
      [:complex]  => { :code => 'complex.c' },
      [:object]   => { :code => 'object.c' }
    }
  },
  
  {
    :name => :ToStr, :kind => :elementwise, :visibility => :public,
    :documentation => "Converts every element to a string.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :object },
      [:f32]      => { :code => 'f32.c',      :output => :object },
      [:f64]      => { :code => 'f64.c',      :output => :object },
      [:c32]      => { :code => 'c32.c',      :output => :object },
      [:c64]      => { :code => 'c64.c',      :output => :object },
      [:object]   => { :code => 'object.c',   :output => :object }
    }
  },
  
  {
    :name => :Insp, :kind => :scalar, :visibility => :public,
    :documentation => "Returns a user readable string representation of the array.",
    :implementation => {
      [:integer]  => { :code => 'integer.c',  :output => :object },
      [:float]    => { :code => 'float.c',    :output => :object },
      [:complex]  => { :code => 'complex.c',  :output => :object },
      [:object]   => { :code => 'object.c',   :output => :object }
    }
  },
  
  {
    :name => :AddB, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns elementwise sum _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :SbtB, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns elementwise sum _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :MulB, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns elementwise sum _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :DivB, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns elementwise sum _x_ and _y_.",
    :implementation => {
      [:integer,  :previous] => { :code => 'integer.c', :output => :identity },
      [:float,    :previous] => { :code => 'float.c',   :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :ModB, :kind => :elementwise, :visibility => :public,
    :documentation => "Returns elementwise sum _x_ and _y_.",
    :implementation => {
      [:integer,  :previous] => { :code => 'integer.c', :output => :identity },
      [:float,    :previous] => { :code => 'float.c',   :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :MulAdd, :kind => :elementwise, :visibility => :public,
    :documentation => "Add _y_ times _z_ to _x_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :MulSbt, :kind => :elementwise, :visibility => :public,
    :documentation => "Subtract _y_ times _z_ from _x_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :identity },
      [:complex,  :previous] => { :code => 'complex.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :BAn, :kind => :elementwise, :visibility => :public,
    :documentation => "Bitwise and of _x_ and _y_.",
    :implementation => {
      [:integer,  :previous] => { :code => 'integer.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :BOr, :kind => :elementwise, :visibility => :public,
    :documentation => "Bitwise or of _x_ and _y_.",
    :implementation => {
      [:integer,  :previous] => { :code => 'integer.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :BXo, :kind => :elementwise, :visibility => :public,
    :documentation => "Bitwise xor of _x_ and _y_.",
    :implementation => {
      [:integer,  :previous] => { :code => 'integer.c', :output => :identity },
      [:object,   :previous] => { :code => 'object.c',  :output => :identity }
    }
  },
  
  {
    :name => :Eql, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise equality of _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :u8 },
      [:complex,  :previous] => { :code => 'complex.c', :output => :u8 },
      [:object,   :previous] => { :code => 'object.c',  :output => :u8 }
    }
  },
  
  {
    :name => :Cmp, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise comparison of _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :u8 },
      [:object,   :previous] => { :code => 'object.c',  :output => :u8 }
    }
  },
  
  {
    :name => :And, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise logical and of _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :u8 },
      [:complex,  :previous] => { :code => 'complex.c', :output => :u8 },
      [:object,   :previous] => { :code => 'object.c',  :output => :u8 }
    }
  },
  
  {
    :name => :Or_, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise logical or of _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :u8 },
      [:complex,  :previous] => { :code => 'complex.c', :output => :u8 },
      [:object,   :previous] => { :code => 'object.c',  :output => :u8 }
    }
  },
  
  {
    :name => :Xor, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise logical xor of _x_ and _y_.",
    :implementation => {
      [:real,     :previous] => { :code => 'real.c',    :output => :u8 },
      [:complex,  :previous] => { :code => 'complex.c', :output => :u8 },
      [:object,   :previous] => { :code => 'object.c',  :output => :u8 }
    }
  },
  
  {
    :name => :atan2, :kind => :elementwise, :visibility => :public,
    :documentation => "Elementwise atan2(_x_, _y_).",
    :implementation => {
      [:float, :previous] => { :code => 'float.c', :output => :identity }
    }
  },
  
  {
    :name => :RefMask, :kind => :mask, :visibility => :public,
    :documentation => "Unknown..?",
    :implementation => {
      [:number] => { :code => 'number.c', :output => :identity }
    }
  },

  {
    :name => :SetMask, :kind => :mask, :visibility => :public,
    :documentation => "Unknown..?",
    :implementation => {
      [:number] => { :code => 'number.c', :output => :identity }
    }
  }
].map { |f| NGenerator::Function.new(f) }

File.open('ext/na_op.c', 'w') do |f|
  f.puts ERB.new(File.read('op.erb.c')).result(binding)
end
