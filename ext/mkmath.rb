require 'erb'

require "#{File.dirname(__FILE__)}/generator/ntype"
require "#{File.dirname(__FILE__)}/generator/nfunction"

NFunctions = [
  {
    :name => :square, :kind => :scalar, :visibility => :private,
    :documentation => "Calculates _x^2_.",
    :implementation => {
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :mul, :kind => :scalar, :visibility => :private,
    :documentation => "Calculates _x_ * _y_.",
    :implementation => {
      [:complex, :previous] => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :div, :kind => :scalar, :visibility => :private,
    :documentation => "Calculates _x_ / _y_.",
    :implementation => {
      [:complex, :previous] => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :recip, :kind => :scalar, :visibility => :private,
    :documentation => "Calculates _x^-1_.",
    :implementation => {
      [:complex] => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :pow, :kind => :scalar, :visibility => :private,
    :documentation => "Calculates _x^y_.",
    :implementation => {
      [:integer,  :integer] => { :code => 'integer_integer.c',  :output => :identity },
      [:float,    :integer] => { :code => 'float_integer.c',    :output => :identity },
      [:complex,  :integer] => { :code => 'complex_integer.c',  :output => :identity }
    }
  },

  {
    :name => :sqrt, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates the principal square root of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :log, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates natural logarithm of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :acos, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates arccosine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :acosh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic arccosine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :asin, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates arcsine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :asinh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic arcsine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },

  {
    :name => :atan, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates arctangent of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :atanh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic arctangent of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },

  {
    :name => :cos, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates cosine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :cosh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic cosine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },

  {
    :name => :exp, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates exponential of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :log10, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates 10-logarithm of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :log2, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates 2-logarithm of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },

  {
    :name => :sin, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates sine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :sinh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic sine of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },

  {
    :name => :tan, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates tangent of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :tanh, :kind => :scalar, :visibility => :public,
    :documentation => "Calculates hyperbolic tangent of _x_.",
    :implementation => {
      [:float]    => { :code => 'real.c',    :output => :identity },
      [:complex]  => { :code => 'complex.c', :output => :identity },
    }
  },
  
  {
    :name => :Rcp, :kind => :elementwise, :visibility => :public,
    :documentation => "Calculates the reciprocal of every element in _x_.",
    :implementation => {
      [:real]     => { :code => 'real.c',     :output => :identity },
      [:complex]  => { :code => 'complex.c',  :output => :identity },
      [:object]   => { :code => 'object.c',   :output => :identity }
    }
  },
  
  {
    :name => :Pow, :kind => :elementwise, :visibility => :public,
    :documentation => "Calculates _x_ to the power of _y_ for every element.",
    :implementation => {
      [:number,  :integer]  => { :code => 'number_integer.c',   :output => :identity },
      [:real,    :float]    => { :code => 'real_float.c',       :output => :identity },
      [:complex, :float]    => { :code => 'complex_float.c',    :output => :identity },
      [:complex, :complex]  => { :code => 'complex_complex.c',  :output => :identity },
      [:object,  :object]   => { :code => 'object_object.c',    :output => :identity }
    }
  }
].map { |f| NGenerator::Function.new(f) }

File.open('ext/na_math.c', 'w') do |f|
  f.puts ERB.new(File.read('math.erb.c')).result(binding)
end