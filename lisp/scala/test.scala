class Rational(n: Int, d: Int){
  require(d != 0)
  private val g = gcd(n.abs, d.abs)
  val numer: Int = n / g
  val denom: Int = d / g
  override def toString = numer + "/"+ denom

  def this(n: Int) = this(n, 1)
  def + (that: Rational):Rational = 
    new Rational(
      numer * that.denom + that.numer * denom,
      denom * that.denom
    )
  def + (i: Int): Rational = 
      new Rational(numer + i * denom , denom)
  def - (that: Rational):Rational = 
	new Rational(
	  numer * that.denom - that.numer * denom,
	  denom * that.denom)
  def - (i: Int):Rational = 
	  new Rational(numer - i * denom, denom)
  def * (that:Rational):Rational = 
      new Rational(numer * that.numer, denom * that.denom)
  def * (i: Int ):Rational = 
	new Rational(numer * i, denom)
  def / (that:Rational):Rational = 
	  new Rational(numer * that.denom, denom * that.numer)
  def / (i: Int):Rational = 
	    new Rational(numer, denom * i)
  private def gcd(a:Int, b: Int):Int = 
      if (b == 0) a else gcd(b , a % b)
}
      
val rational1 = new Rational(1,2)
val rational2 = new Rational(4,5)

println(rational1 + " + "+ rational2 + " = "+(rational1 + rational2))
println(rational1.numer)
println(new Rational(66,42))
println(new Rational(5))
println(new Rational(2,3) * new Rational(5,6))
println(new Rational(2,3) * 2)
println(new Rational(2,3) / 2)
