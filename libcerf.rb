class Libcerf < Formula
  desc "Efficient implementation of complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.5.tgz"
  sha256 "e36dc147e7fff81143074a21550c259b5aac1b99fc314fc0ae33294231ca5c86"

  bottle do
    cellar :any
    sha256 "5f83e48ae2d92abbfc75d8807944371c926f3fe3c991c119e3243bd14cf1481f" => :sierra
    sha256 "9bd8e5eda457b6ce7e78bdd56bb50e8d4185747d024c0d1973bb00f5dc01a800" => :el_capitan
    sha256 "91a46dd259e87aa1f803e62b15fe760498b03010662bfaa57d2e5a71a82b5063" => :yosemite
    sha256 "5a562cb94015f3a4d75a9caae77d36e4072ade6e5a58b41bbbb588769d8f43dc" => :x86_64_linux
  end

  option "without-test", "Disable build-time testing (not recommended)"

  deprecated_option "without-check" => "without-test"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cerf.h>
      #include <stdio.h>
      int main()
      {
        printf("%f\\n", voigt(0, 1, 0));
        return -1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    assert_in_delta `./test`.to_f, 1 / Math.sqrt(2 * Math::PI), 1e-6
  end
end
