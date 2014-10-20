require "formula"

class Sisl < Formula
  homepage "http://www.sintef.no/Informasjons--og-kommunikasjonsteknologi-IKT/Anvendt-matematikk/Fagomrader/Geometri/Prosjekter/The-SISL-Nurbs-Library/SISL-Homepage/"
  url "https://github.com/SINTEF-Geometry/SISL/archive/SISL-4.6.0.tar.gz"
  sha1 "d86d626408164bea53a129945b09146085c90325"

  head "https://github.com/SINTEF-Geometry/SISL.git", :branch => "master"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_OSX_ARCHITECTURES=" + ((MacOS.prefer_64_bit?) ? "#{Hardware::CPU.arch_64_bit}" : "i386")

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"s1013prob.C").write <<-EOS.undent

    #include "sisl.h"
    #include <iostream>

    using namespace std;

    int main()
    {
    int dim = 2;
    int kind = 1;
    double coefs[] = { -1, 1, 0, 0, 1, 0, 1, 1 };
    double knots[] = { 0, 0, 0, 0, 1, 1, 1, 1 };
    int num = 4;
    int order = 4;
    SISLCurve* sc = newCurve(num, order, knots, coefs, kind, dim, 1);

    double itpar;
    int stat;
    s1013(sc, 1.0, 0.01, 0.3, &itpar, &stat);
    double pt[4];
    int kleft;
    s1221(sc, 1, itpar, &kleft, pt, &stat);

    cout << itpar << ' ' << pt[2] << ' ' << pt[3] << endl;
    }

    EOS
    system ENV.cxx, "s1013prob.C", "-I#{include}", "-L#{lib}", "-lsisl", "-o", "s1013prob"
    system "./s1013prob"
  end
end
