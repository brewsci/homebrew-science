class Superlu43 < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_4.3.tar.gz"
  sha256 "169920322eb9b9c6a334674231479d04df72440257c17870aaa0139d74416781"

  bottle do
    cellar :any_skip_relocation
    sha256 "25490b508eb9f313805f03ed73e030651eab581e87cad6012ee22d247025f51f" => :el_capitan
    sha256 "2ae96704469e8fb478650dbfb6e6391e60feadf8ca1ace3dcba9876300941b8e" => :yosemite
    sha256 "fd459dc04c762fea5ca96615152cc8cf3cd405775782d1b032e422e6451597ff" => :mavericks
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional

  keg_only "Conflicts with superlu"

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"
    make_args = ["RANLIB=true", "CC=#{ENV.cc}", "CFLAGS=-fPIC #{ENV.cflags}",
                 "FORTRAN=#{ENV.fc}", "FFLAGS=#{ENV.fcflags}",
                 "SuperLUroot=#{buildpath}",
                 "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
                 "NOOPTS=-fPIC"
                ]

    make_args << ((build.with? "openblas") ? "BLASLIB=-L#{Formula["openblas"].opt_lib} -lopenblas" : "BLASLIB=-framework Accelerate")

    system "make", "lib", *make_args
    if build.with? "check"
      system "make", "testing", *make_args
      cd "TESTING" do
        system "make", *make_args
        %w[stest dtest ctest ztest].each do |tst|
          ohai `tail -1 #{tst}.out`.chomp
        end
      end
    end

    cd "EXAMPLE" do
      system "make", *make_args
    end

    prefix.install "make.inc"
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" ")) # Record options passed to make.
    end
    lib.install Dir["lib/*"]
    (include / "superlu").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]
    (share / "superlu").install Dir["EXAMPLE/*[^.o]"]
  end

  test do
    cd share / "superlu" do
      system "./superlu"
      system "./slinsol < g20.rua"
      system "./slinsolx  < g20.rua"
      system "./slinsolx1 < g20.rua"
      system "./slinsolx2 < g20.rua"

      system "./dlinsol < g20.rua"
      system "./dlinsolx  < g20.rua"
      system "./dlinsolx1 < g20.rua"
      system "./dlinsolx2 < g20.rua"

      system "./clinsol < cg20.cua"
      system "./clinsolx < cg20.cua"
      system "./clinsolx1 < cg20.cua"
      system "./clinsolx2 < cg20.cua"

      system "./zlinsol < cg20.cua"
      system "./zlinsolx < cg20.cua"
      system "./zlinsolx1 < cg20.cua"
      system "./zlinsolx2 < cg20.cua"

      system "./sitersol -h < g20.rua"
      system "./sitersol1 -h < g20.rua"
      system "./ditersol -h < g20.rua"
      system "./ditersol1 -h < g20.rua"
      system "./citersol -h < g20.rua"
      system "./citersol1 -h < g20.rua"
      system "./zitersol -h < cg20.cua"
      system "./zitersol1 -h < cg20.cua"
    end
  end
end
