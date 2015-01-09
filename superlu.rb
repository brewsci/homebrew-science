class Superlu < Formula
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_4.3.tar.gz"
  sha1 "d2863610d8c545d250ffd020b8e74dc667d7cbdd"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 2
    sha1 "e6af03f74a1401aa7fe90810741498e00f9e50ff" => :yosemite
    sha1 "864caefe41169919a3041ec89b1252bcc34e09b7" => :mavericks
    sha1 "b6086ee4133eb84c335bb1ab5424e35113447811" => :mountain_lion
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on "openblas" => :optional

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"
    make_args = ["RANLIB=true", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                 "FORTRAN=#{ENV.fc}", "FFLAGS=#{ENV.fcflags}",
                 "SuperLUroot=#{buildpath}",
                 "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a"]

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
      f.puts(make_args.join(" "))  # Record options passed to make.
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
