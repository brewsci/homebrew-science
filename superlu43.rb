class Superlu43 < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_4.3.tar.gz"
  sha256 "169920322eb9b9c6a334674231479d04df72440257c17870aaa0139d74416781"

  bottle do
    cellar :any
    sha256 "55c85e1b687b25cd43473499ea977269d9ec40fde4ef42a456ce8b6c5efa7287" => :yosemite
    sha256 "98be45e96305c0d49578b6d9938eed1dc3df49f4144f44dbe904e5faaebe3159" => :mavericks
    sha256 "6f4e344d0eb901394e69e88cad6f51d0cf595a9e382f28a8a7cc6b288a2ab8a5" => :mountain_lion
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
                 "NOOPTS=-fPIC",
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
