module NGenerator
  class Type
    ORDER, TYPES, CATEGORIES = [], {}, {}
    
    class << self
      def in_order
        ORDER
      end
      
      def from_id(id)
        TYPES[id]
      end
      
      def from_category(category)
        CATEGORIES[category]
      end
    end
    
    def initialize(options)
      @options = options
      
      ORDER << self
      TYPES[self.id] = self
      
      self.categories.each do |category|
        CATEGORIES[category] ||= []
        CATEGORIES[category] << self
      end
    end
    
    def to_s
      self.id.to_s
    end
    
    def inspect
      "<NType :#{self.id}>"
    end
    
    def [] (key)
      @options[key]
    end
    
    [:id, :code, :type, :categories].each do |symbol|
      define_method(symbol) do
        self[symbol]
      end
    end
    
    [:integer, :real, :complex].each do |symbol|
       define_method(symbol) do
          self.class.from_id(self[symbol])
       end
    end
    
    def object
      self.class.from_id(:object)
    end
    
    def identity
      self
    end
    
    def upcast(*others)
      others.reduce(self) do |x, y|
        self.class.from_id case
        when x == y || y == :previous
          x.id
        else
          x[:upcast][y.id] || y[:upcast][x.id]
        end
      end
    end
    
    def cast_table
      "{ #{Type.in_order.map { |x| Type.in_order.index(self.upcast(x)) }.join(', ')} }"
    end
  end
end


[
  {
    :id => :none,
    
    :code => 'n', :type => 'none',
    
    :integer => :none,
    :real => :none,
    :complex => :none,
    
    :categories => [],
    
    :upcast => {
      :u8     => :none,
      :i16    => :none,
      :i32    => :none,
      :f32    => :none,
      :f64    => :none,
      :c32    => :none,
      :c64    => :none,
      :object => :none
    }
  },
  
  {
    :id => :u8,
    
    :code => 'B', :type => 'u_int8_t',
    
    :integer => :u8,
    :real => :u8,
    :complex => :c32,
    
    :categories => [:number, :real, :integer, :size8],
    
    :upcast => { }
  },
  
  {
    :id => :i16,
    
    :code => 'I', :type => 'int16_t',
    
    :integer => :i16,
    :real => :i16,
    :complex => :c32,
    
    :categories => [:number, :real, :integer, :size16],
    
    :upcast => {
      :u8     => :i16,
    }
  },
  
  {
    :id => :i32,
    
    :code => 'L', :type => 'int32_t',
    
    :integer => :i32,
    :real => :i32,
    :complex => :c32,
    
    :categories => [:number, :real, :integer, :size32],
    
    :upcast => {
      :u8     => :i32,
      :i16    => :i32,
    }
  },
  
  {
    :id => :f32,
    
    :code => 'F', :type => 'float',
    
    :integer => :i32,
    :real => :f32,
    :complex => :c32,
    
    :categories => [:number, :real, :float, :size32],
    
    :upcast => {
      :u8     => :f32,
      :i16    => :f32,
      :i32    => :f32,
    }
  },
  
  {
    :id => :f64,
    
    :code => 'D', :type => 'double',
    
    :integer => :i32,
    :real => :f64,
    :complex => :c64,
    
    :categories => [:number, :real, :float, :size64],
    
    :upcast => {
      :u8     => :f64,
      :i16    => :f64,
      :i32    => :f64,
      :f32    => :f64,
    }
  },
  
  {
    :id => :c32,
    
    :code => 'X', :type => 'scomplex',
    
    :integer => :c32,
    :real => :f32,
    :complex => :c32,
    
    :categories => [:number, :complex, :size64],
    
    :upcast => {
      :u8     => :c32,
      :i16    => :c32,
      :i32    => :c32,
      :f32    => :c32,
      :f64    => :c64,
    }
  },
  
  {
    :id => :c64,
    
    :code => 'C', :type => 'dcomplex',
    
    :integer => :c64,
    :real => :f64,
    :complex => :c64,
    
    :categories => [:number, :complex, :size128],
    
    :upcast => {
      :u8     => :c64,
      :i16    => :c64,
      :i32    => :c64,
      :f32    => :c64,
      :f64    => :c64,
      :c32    => :c64,
    }
  },
  
  {
    :id => :object,
    
    :code => 'O', :type => 'VALUE',
    
    :integer => :object,
    :real => :object,
    :complex => :object,
    
    :categories => [],
    
    :upcast => {
      :u8     => :object,
      :i16    => :object,
      :i32    => :object,
      :f32    => :object,
      :f64    => :object,
      :c32    => :object,
      :c64    => :object,
    }
  }
].each { |type| NGenerator::Type.new(type) }
