class Concorde < Formula
  desc "Symmetric traveling salesman problem (TSP) solver"
  homepage "http://www.math.uwaterloo.ca/tsp/concorde/index.html"
  url "http://www.math.uwaterloo.ca/tsp/concorde/downloads/codes/src/co031219.tgz"
  sha256 "c3650a59c8d57e0a00e81c1288b994a99c5aa03e5d96a314834c2d8f9505c724"

  option "with-cplex=", "Compile with CPLEX bindings, you must install CPLEX beforehand and pass the CPLEX installation directory. For example, with version 12.6.3 Community, the default installation directory is /Users/username/Applications/IBM/ILOG/CPLEX_Studio_Community1263/cplex"
  depends_on "qsopt" if build.without? "cplex="

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --host=x86]
    if build.with? "cplex="
      cplex_path = ARGV.value("with-cplex")
      mkdir "cplex_files"
      cd "cplex_files" do
        ln_s Dir["#{cplex_path}/include/ilcplex/*.h"], "."
        if MacOS.prefer_64_bit?
          ln_s "#{cplex_path}/lib/x86-64_osx/static_pic/libcplex.a", "."
        else
          ln_s "#{cplex_path}/lib/x86-32_osx/static_pic/libcplex.a", "."
        end
      end
      args << "--with-cplex=#{buildpath}/cplex_files"
    else
      args << "--with-qsopt=#{Formula["qsopt"].opt_lib}"
    end
    system "./configure", *args

    if build.with? "cplex"
      # based on http://www.leandro-coelho.com/installing-concorde-tsp-with-cplex-linux/
      inreplace "TSP/Makefile", "LIBFLAGS = -lm", "LIBFLAGS = -lm -lpthread"
      inreplace "Makefile", "LIBFLAGS = -lm", "LIBFLAGS = -lm -lpthread"
    end
    system "make"
    lib.install "concorde.a"
    include.install "concorde.h"
    bin.install "TSP/concorde"
    bin.install "LINKERN/linkern"
    bin.install "EDGEGEN/edgegen"
    bin.install "FMATCH/fmatch"
  end

  test do
    system "concorde", "-s", "99", "-k", "100"
  end
end
