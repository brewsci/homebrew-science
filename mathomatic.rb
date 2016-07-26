class Mathomatic < Formula
  desc "portable, command-line, educational computer algebra system"
  homepage "https://github.com/mfillpot/mathomatic"
  url "https://github.com/mfillpot/mathomatic/archive/mathomatic-16.0.5.tar.gz"
  sha256 "d93fe35914dbbafa0e67000480268d7ca3e4de773b70f4130a6b3f4fbb20fae2"
  head "https://github.com/mfillpot/mathomatic.git"

  def install
    args = ["prefix=#{prefix}", "datadir=#{pkgshare}", "mandir=#{man}", "mathdocdir=#{doc}", "datadocdir=#{doc}", "READLINE=1"]
    system "make", *args
    system "make", "m4install", *args
    cd "primes" do
      system "make", *args
      system "make", "install", *args
    end
  end

  test do
    (testpath/"testo.c").write <<-EOS.undent
      #include <stdio.h>
      #include <math.h>

      extern double factorial(double);

      int main(void) {
        double x = 7.188076642536564;
        double y = factorial(3.141592);
        printf("%lf\\n", fabs(x-y)/x);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "testo", "testo.c", "#{doc}/examples/fact.c", "-lm"
    assert (`./testo`.to_f < 1.0e-8)
  end
end
