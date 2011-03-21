module NGenerator
  class Implementation
    def initialize(name, kind, parameters, implementation)
      @input      = parameters
      @parameters = @input.dup
      
      @parameters.each_with_index do |x, i|
        @parameters[i] = @parameters[i - 1] if x == :previous
      end
      
      case kind
      when :assignment, :sort, :generator
      else
        @output = Type.from_id(implementation[:output]) || parameters[0].upcast(*parameters).send(implementation[:output])
      end
      
      @kind = kind
      @name = "#{name}#{@input.map { |t| t == :previous ? '' : t.code }.join('')}"
      @kernel = File.read("functions/#{kind}/#{name}/#{implementation[:code]}")
      
      @prototype = "static "
      
      case kind
      when :scalar
        @prototype << "void #{@name}(#{@output.type} * output"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}"
        end
      when :assignment
        @prototype << "void #{@name}(int count"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}, int input_#{i + 1}_stride"
        end
      when :elementwise
        @prototype << "void #{@name}(int count, #{@output.type} * output, int output_stride"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}, int input_#{i + 1}_stride"
        end
      when :generator
        @prototype << "void #{@name}(int count"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}, int input_#{i + 1}_stride"
        end
        
        @prototype << ", int counter, int counter_stride"
      when :sort
        @prototype << "int #{@name}(int count"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}"
        end
      when :mask
        @prototype << "void #{@name}(int count, #{@output.type} * output, int output_stride"
        
        @parameters.each_with_index do |x, i|
          @prototype << ", #{x.type} * input_#{i + 1}, int input_#{i + 1}_stride"
        end
        
        @prototype << ", #{Type.from_id(:u8).type} * mask, int mask_stride"
      else
        raise "Error: unknown kind"
      end
      
      @prototype << ")"
      
      if @input[1] && @input[1] != :previous
        @kernel = @kernel.
          gsub(/type2/, @input[1].type).
          gsub(/#CC/,   @input[0 .. 1].map { |t| t.code }.join(''))
      end
      
      if @input[0]
        @kernel = @kernel.
          gsub(/typer/, @input[0].real.type).
          gsub(/typed/, @input[0].type).
          gsub(/type1/, @input[0].type).
          gsub(/#C/,    @input[0].code)
      end
      
      @code = self.body.result(binding)
    end
    
    def arity
      @input.length
    end
    
    def body
      ERB.new(File.read("./generator/bodies/#{@kind}.erb.c"))
    end
    
    attr_reader :name, :prototype
    attr_reader :input, :output
    attr_reader :kernel, :code
  end
  
  class Function
    def initialize(options)
      @options = options
      
      @implementations = []
      
      @options[:implementation].map do |parameters, implementation|
        first, *rest = parameters.map do |id_or_category|
          if by_id = NGenerator::Type.from_id(id_or_category)
            [by_id]
          elsif by_category = NGenerator::Type.from_category(id_or_category)
            by_category
          elsif id_or_category == :previous
            [id_or_category]
          else
            raise "Error! Unknown id or category #{id_or_category}"
          end
        end

        first.product(*rest).each do |specific_parameters|
          @implementations << Implementation.new(self.name, self.kind, specific_parameters, implementation.dup)
        end
      end
    end
    
    attr_reader :implementations
    
    def [] (key)
      @options[key]
    end
    
    [:name, :kind, :visibility, :documentation].each do |symbol|
      define_method(symbol) do
        self[symbol]
      end
    end
    
    def arity
      @implementations[0].arity
    end
    
    def public?
      self.visibility == :public
    end
    
    def implementation_array
      faux_arity = @implementations[0].input.select { |x| x != :previous }.length
      
      imps = @implementations.map do |i|
        i.input[0 ... faux_arity]
      end
      
      case faux_arity
      when 1
        array = Type.in_order.map { |x| imps.include?([x]) ? "#{self.name}#{x.code}" : nil }
        
        case self.kind
        when :scalar
          "na_mathfunc_t #{self.name}Funcs = { #{array.map { |x| x ? x : 'TpErr' }.join(', ')} };"
        when :elementwise, :generator, :mask
          "na_func_t #{self.name}Funcs = { #{array.map { |x| x ? x : 'TpErr' }.join(', ')} };"
        when :sort
          "na_sortfunc_t #{self.name}Funcs = { #{array.map { |x| x ? x : 'TpErrI' }.map {|x| "(int (*)(const void *, const void *))#{x}"}.join(', ')} };"
        else
          raise "Error! function array for unknown kind"
        end
      when 2
        case self.kind
        when :assignment, :elementwise
          array = Type.in_order.map do |x|
            Type.in_order.map do |y|
              imps.include?([x, y]) ? "#{self.name}#{x.code}#{y.code}" : 'TpErr'
            end.join(', ')
          end
          
          "na_setfunc_t #{self.name}Funcs = { #{array.join(",\n")} };"
        end
      else
        raise "Error! Unimplemented arity!"
      end
    end
  end
end