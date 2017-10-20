// Credits to Nickr5 for the useful procs I've taken from his library resource.

var/const/E		= 2.71828183
var/const/Sqrt2	= 1.41421356

// List of square roots for the numbers 1-100.
var/list/sqrtTable = list(1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
                          5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7,
                          7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
                          8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/Ceiling(x)
	return -round(-x)

/proc/Clamp(val, min, max)
	return max(min, min(val, max))

// cotangent
/proc/Cot(x)
	return 1 / Tan(x)

// cosecant
/proc/Csc(x)
	return 1 / sin(x)

/proc/Default(a, b)
	return a ? a : b

/proc/Floor(x)
	return round(x)

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, a % b) : a

/proc/Inverse(x)
	return 1 / x

/proc/IsAboutEqual(a, b, deviation = 0.1)
	return abs(a - b) <= deviation

/proc/IsEven(x)
	return x % 2 == 0

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return min <= val && val <= max

/proc/IsInteger(x)
	return Floor(x) == x

/proc/IsOdd(x)
	return !IsEven(x)

/proc/IsMultiple(x, y)
	return x % y == 0

// Least Common Multiple
/proc/Lcm(a, b)
	return abs(a) / Gcd(a, b) * abs(b)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
/proc/Lerp(a, b, amount = 0.5)
	return a + (b - a) * amount

/proc/Mean(...)
	var/values 	= 0
	var/sum		= 0
	for(var/val in args)
		values++
		sum += val
	return sum / values


// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// secant
/proc/Sec(x)
	return 1 / cos(x)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0) return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d) return
	. += (-b - root) / bottom

// tangent
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/ToDegrees(radians)
				  // 180 / Pi
	return radians * 57.2957795

/proc/ToRadians(degrees)
				  // Pi / 180
	return degrees * 0.0174532925

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = Floor((val - min) / d)
	return val - (t * d)

/**
 * Lerps x to a value between [a, b]. x must be in the range [0, 1].
 * My undying gratitude goes out to wwjnc.
 *
 * Basically this returns the number corresponding to a certain
 * percentage in a range. 0% would be a, 100% would be b, 50% would
 * be halfways between a and b, and so on.
 *
 * Other methods of lerping might not yield the exact value of a or b
 * when x = 0 or 1. This one guarantees that.
 *
 * Examples:
 *   - mix(0.0,  30, 60) = 30
 *   - mix(1.0,  30, 60) = 60
 *   - mix(0.5,  30, 60) = 45
 *   - mix(0.75, 30, 60) = 52.5
 */
/proc/mix(a, b, x)
	return a*(1 - x) + b*x

/**
 * Lerps x to a value between [0, 1]. x must be in the range [a, b].
 *
 * This is the counterpart to the mix() function. It returns the actual
 * percentage x is at inside the [a, b] range.
 *
 * Note that this is theoretically equivalent to calling lerp(x, a, b)
 * (y0 and y1 default to 0 and 1) but this one is slightly faster
 * because Byond is too dumb to optimize procs with default values. It
 * shouldn't matter which one you use (since there are no FP issues)
 * but this one is more explicit as to what you're doing.
 *
 * @todo Find a better name for this. I can't into english.
 * http://i.imgur.com/8Pu0x7M.png
 */
/proc/unmix(x, a, b, min = 0, max = 1)
	if(a==b)
		return 1
	return Clamp( (b - x)/(b - a), min, max )

/proc/triangular_seq(input, scale)
	if(input < 0)
		return -triangular_seq(-input, scale)
	var/mult = input/scale
	var/trinum = (sqrt(8 * mult + 1) - 1 ) / 2
	return trinum * scale
