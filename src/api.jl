baremodule API

using Base
import Base: call

export .+, .-, .*, ./, .\, .%, .<<, .>>, div, mod, rem, &, |, $, cos, cosh, acos, sec, csc, cot, acot, sech, csch, coth, asech, acsch, cospi, sinc, cosd, cotd, cscd, secd, acosd, acotd, log, log2, log10, exp, exp2, exp10, sum, prod, setindex!, getindex, pointer

export cartesianarray

eval(x) = Core.eval(API, x)

# Unary operators/functions
for f in (:-, :+, :cos, :cosh, :acos, :sec, :csc, :cot, :acot, :sech,
           :csch, :coth, :asech, :acsch, :cospi, :sinc, :cosd,
           :cotd, :cscd, :secd, :acosd, :acotd, :log, :log2, :log10,
           :exp, :exp2, :exp10, :sum, :prod)
    @eval begin
        @noinline function ($f){T<:Number}(A::DenseArray{T})
            (Base.$f)(A)
        end
        function ($f)(A...)
            (Base.$f)(A...)
        end
    end
end

# Binary operators/functions
for f in (:-, :+, :.+, :.-, :.*, :./, :.\, :.%, :.<<, :.>>, :div, :mod, :rem, :&, :|, :$)
    @eval begin
        @noinline function ($f){T}(A::T, B::DenseArray{T})
            (Base.$f)(A, B)
        end
        @noinline function ($f){T}(B::DenseArray{T}, A::T)
            (Base.$f)(B, A)
        end
        @noinline function ($f){T}(A::DenseArray{T}, B::DenseArray{T})
            (Base.$f)(A, B)
        end
        function ($f)(A, B)
            (Base.$f)(A, B)
        end
    end
end

@noinline function setindex!{T}(A::DenseArray{T}, args...) 
  Base.setindex!(A, args...)
end

function setindex!(A, args...) 
  Base.setindex!(A, args...)
end

@noinline function getindex{T}(A::DenseArray{T}, args...) 
  Base.getindex(A, args...)
end

@noinline function pointer{T}(A::DenseArray{T})
  Base.pointer(A)
end

@noinline function pointer{T}(A::DenseArray{T}, offset)
  Base.pointer(A, offset)
end

function getindex(A, args...) 
  Base.getindex(A, args...)
end

function cartesianarray(body, T, ndims)
  a = Array(T, ndims...)
  for I in CartesianRange(ndims)
    a[I.I...] = body(I.I...)
  end
  a
end

function cartesianarray(body, T1, T2, ndims)
  a = Array(T1, ndims...)
  b = Array(T2, ndims...)
  for I in CartesianRange(ndims)
    (u, v) = body(I.I...)
    a[I.I...] = u
    b[I.I...] = v
  end
  return a, b
end

function cartesianarray(body, T1, T2, T3, ndims)
  a = Array(T1, ndims...)
  b = Array(T2, ndims...)
  c = Array(T3, ndims...)
  for I in CartesianRange(ndims)
    (u, v, w) = body(I.I...)
    a[I.I...] = u
    b[I.I...] = v
    c[I.I...] = w
  end
  return a, b, c
end

end

