#  Numerical Array Extention for Ruby
#    (C) Copyright 2000-2003 by Masahiro TANAKA
#

#
# Subclass of NArray.
#
# - First 2 dimensions are used as Matrix.
# - Residual dimensions are treated as Multi-dimensional array.
# - The order of Matrix dimensions is opposite from the notation of
#   mathematics:  a_ij => a[j,i].
#

class NMatrix < NArray
  # Number of dimensions treated as data, the rest as a multi-dimensional array.
  CLASS_DIMENSION = 2

  #
  # Element-wise addition of another NMatrix.
  #

  def +(other)
    case other
    when NMatrix
      return super(NArray.refer(other))
    when NArray
      unless other.instance_of?(NArray)
        return other.coerce_rev( self, :+ )
      end
    end
    raise TypeError,"Illegal operation: NMatrix + %s" % other.class
  end

  #
  # Element-wise subtraction of another NMatrix.
  #

  def -(other)
    case other
    when NMatrix
      return super(NArray.refer(other))
    when NArray
      unless other.instance_of?(NArray)
        return other.coerce_rev( self, :- )
      end
    end
    raise TypeError,"Illegal operation: NMatrix - %s" % other.class
  end

  #
  # Depending on _other_,
  #
  # - NMatrix: matrix-matrix multiplication.
  # - NVector: matrix-vector multiplication.
  # - NArray, Array or Numeric: element-wise multiplication.
  #

  def *(other)
    case other
    when NMatrix
      NMatrix.mul_add( NArray.refer(self).newdim!(0),other.newdim(2), 1 )
      #NMatrix.mul_add( NArray.refer(self).newdim!(0),
      #		       other.transpose(1,0).newdim!(2), 0 )
    when NVector
      NVector.mul_add( NArray.refer(self), other.newdim(1), 0 )
    when NArray
      if other.instance_of?(NArray)
	NMatrix.mul( NArray.refer(self), other.newdim(0,0) )
      else
	other.coerce_rev( self, :* )
      end
    when Numeric
      super
      #NMatrix.mul( NArray.refer(self), other )
    when Array
      NMatrix.mul( self, NArray[*other].newdim!(0,0) )
    else
      raise TypeError,"Illegal operation: NMatrix * %s" % other.class
    end
  end

  #
  # Depending on _other_,
  #
  # - NMatrix: Solve system by LU factorization and then back-substitution.
  # - NArray, Array or Numeric: element-wise multiplication.
  #

  def /(other)
    case other
    when NMatrix
      other.lu.solve(self)
    when NVector
      raise TypeError,"Illegal operation: NMatrix / %s" % other.class
    when NArray
      if other.instance_of?(NArray)
	NMatrix.div( NArray.refer(self), other.newdim(0,0) )
      else
	other.coerce_rev( self, :/ )
      end
    when Numeric
      NMatrix.div( NArray.refer(self), other )
    when Array
      NMatrix.div( self, NArray[*other].newdim!(0,0) )
    else
      raise TypeError,"Illegal operation: NMatrix / %s" % other.class
    end
  end

  #
  # Matrix exponential, only supports integer powers.
  #

  def **(n)
    case n
    when Integer
      if n==0
	return 1.0
      elsif n<0
	m = self.inverse
	n = -n
      else
	m = self
      end
      (2..n).each{ m *= self }
      m
    else
      raise TypeError,"Illegal operation: NMatrix ** %s" % other.class
    end
  end

  # :nodoc:
  def coerce_rev(other,id)
    case id
    when :*
	if other.instance_of?(NArray)
	  return NMatrix.mul( other.newdim(0,0), self )
	end
	if other.instance_of?(NArrayScalar)
	  return NMatrix.mul( other.newdim(0), self )
	end
    when :/
	if other.instance_of?(NArray)
	  return NMatrix.mul( other.newdim(0,0), self.inverse )
	end
	if other.instance_of?(NArrayScalar)
	  return NMatrix.mul( other.newdim(0), self.inverse )
	end
    end
    raise TypeError,"Illegal operation: %s %s NMatrix" %
      [other.class, id.id2name]
  end

  #
  # Computes the matrix inverse.
  #

  def inverse
    self.lu.solve( NMatrix.new(self.typecode, *self.shape).fill!(0).unit )
  end

  #
  # Transpose Matrix dimensions the if argument is omitted.
  #

  def transpose(*arg)
    if arg.size==0
      super(1,0)
    else
      super
    end
  end

  #
  # Replaces the diagonal values with _val_ (default 1).
  #

  def diagonal!(val=1)
    shp = self.shape
    idx = NArray.int(shp[0..1].min).indgen! * (shp[0]+1)
    ref = reshape(shp[0]*shp[1],true)
    if val.kind_of?(Numeric)
      ref[idx,true] = val
    else
      val = NArray.to_na(val)
      raise ArgumentError, "must be 1-d array" if val.dim!=1
      ref[idx,true] = val.newdim!(-1)
    end
    self
  end

  #
  # Returns a copy with the diagonal values set to _val_.
  #

  def diagonal(val)
    self.dup.diagonal!(val)
  end

  #
  # Replace the diagonal values with 1.
  #

  def unit
    diagonal!
  end
  alias identity unit
  alias I unit

end # class NMatrix


#
# Subclass of NArray.
#
# - First 1 dimension is used as Vector.
# - Residual dimensions are treated as Multi-dimensional array.
#

class NVector < NArray
  # Number of dimensions treated as data, the rest as a multi-dimensional array.
  CLASS_DIMENSION = 1

  #
  # Element-wise addition of another NVector.
  #

  def +(other)
    case other
    when NVector
      return super(NArray.refer(other))
    when NArray
      unless other.instance_of?(NArray)
        return other.coerce_rev( self, :+ )
      end
    end
    raise TypeError,"Illegal operation: NVector + %s" % other.class
  end

  #
  # Element-wise subtraction of another NVector.
  #

  def -(other)
    case other
    when NVector
      return super(NArray.refer(other))
    when NArray
      unless other.instance_of?(NArray)
        return other.coerce_rev( self, :- )
      end
    end
    raise TypeError,"Illegal operation: NVector - %s" % other.class
  end

  #
  # Depending on _other_,
  #
  # - NMatrix: vector-matrix multiplication.
  # - NVector: inner product.
  # - NArray or Numeric: element-wise multiplication.
  #

  def *(other)
    case other
    when NMatrix
      NVector.mul_add( NArray.refer(self).newdim!(0), other, 1 )
    when NVector
      NArray.mul_add( NArray.refer(self), other, 0 ) # inner product
    when NArray
      if other.instance_of?(NArray)
	NVector.mul( NArray.refer(self), other.newdim(0) )
      else
	other.coerce_rev( self, :* )
      end
    when Numeric
      NVector.mul( NArray.refer(self), other )
    else
      raise TypeError,"Illegal operation: NVector * %s" % other.class
    end
  end

  #
  # Depending on _other_,
  #
  # - NMatrix: Solve system by LU factorization and then back-substitution.
  # - NArray or Numeric: element-wise multiplication.
  #

  def /(other)
    case other
    when NMatrix
      other.lu.solve(self)
    when NVector
      raise TypeError,"Illegal operation: NVector / %s" % other.class
    when NArray
      if other.instance_of?(NArray)
	NVector.div( NArray.refer(self), other.newdim(0) )
      else
	other.coerce_rev( self, :/ )
      end
    when Numeric
      NVector.div( NArray.refer(self), other )
    else
      raise TypeError,"Illegal operation: NVector / %s" % other.class
    end
  end

  #
  # Element-wise exponentiation.
  #
  # FIX: Only supports n = 2.
  #

  def **(n)
    if n==2
      self*self
    else
      raise ArgumentError,"Only v**2 is implemented"
    end
  end

  # :nodoc:
  def coerce_rev(other,id)
    case id
    when :*
	if other.instance_of?(NArray)
	  return NVector.mul( other.newdim(0), self )
	end
	if other.instance_of?(NArrayScalar)
	  return NVector.mul( other, self )
	end
    end
    raise TypeError,"Illegal operation: %s %s NVector" %
      [other.class, id.id2name]
  end

end # class NVector
