class Mathomatic < Formula
  desc "portable, command-line, educational computer algebra system"
  homepage "https://github.com/mfillpot/mathomatic"
  url "https://github.com/mfillpot/mathomatic/archive/mathomatic-16.0.5.tar.gz"
  sha256 "d93fe35914dbbafa0e67000480268d7ca3e4de773b70f4130a6b3f4fbb20fae2"
  head "https://github.com/mfillpot/mathomatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a8706e8eed80d001e8e7d8b2ce6bab4ec61eaca3e7e2077f900377a4fb9a527" => :el_capitan
    sha256 "7290a8d02d944b54330d9c2f5141b2d7443115e30e6a163c421f638877da6e8c" => :yosemite
    sha256 "d982a5a8fcc6a02e30b9b6d42f9af03759f2d9f9912a5d5c761811ee7d20ef4f" => :mavericks
  end

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
