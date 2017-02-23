class Acado < Formula
  desc "Toolkit for Automatic Control and Dynamic Optimization"
  homepage "https://acado.github.io/index.html"
  url "https://github.com/acado/acado/archive/v1.2.2beta.tar.gz"
  version "1.2.2beta"
  sha256 "cf0779e64dd5d20989e97340c04ecccf542fe8d993c96b53e5c465693cb354b7"
  # doi "10.1002/oca.939"

  depends_on "cmake" => :build
  depends_on "gnuplot" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"simple_ocp.cpp").write <<-EOS.undent
      #include <acado_toolkit.hpp>
      USING_NAMESPACE_ACADO

      int main() {
        DifferentialState x;
        Control u;
        Parameter T;
        DifferentialEquation f(0.0, T);
        OCP ocp(0.0, T);
        ocp.minimizeMayerTerm(T);
        f << dot(x) == u;
        ocp.subjectTo(f);
        ocp.subjectTo(AT_START, x == 1.0);
        ocp.subjectTo(AT_END, x == 0.0);
        ocp.subjectTo(1.0 <= T);
        ocp.subjectTo(-1.0 <= u <= 1.0);
        OptimizationAlgorithm algorithm(ocp);
        algorithm.solve();
        return 0;
      }
    EOS

    flags = %W[
      -I#{include}/acado
      -L#{lib}
      -lacado_toolkit_s.1
    ]
    system ENV.cxx, "simple_ocp.cpp", "-o", "simple_ocp", *flags
    system "./simple_ocp"
  end
end
