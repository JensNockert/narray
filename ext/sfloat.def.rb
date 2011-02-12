define_type  "SFloat", "float"
define_alias "Float32"
define_real  "SFloat", "float"

$has_math   = true
$is_bit     = false
$is_int     = false
$is_float   = true
$is_complex = false
$is_object  = false
$is_real    = true
$is_comparable = true

upcast "DComplex", "DComplex"
upcast "SComplex", "SComplex"
upcast "DFloat",   "DFloat"
upcast "SFloat",   "SFloat"
upcast "Int64",    "SFloat"
upcast "Int32",    "SFloat"
upcast "Int16",    "SFloat"
upcast "Int8",     "SFloat"
upcast "UInt64",   "SFloat"
upcast "UInt32",   "SFloat"
upcast "UInt16",   "SFloat"
upcast "UInt8",    "SFloat"
upcast "Complex",  "SComplex"
