require "formula"

class Superlu < Formula
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_4.3.tar.gz"
  sha1 "d2863610d8c545d250ffd020b8e74dc667d7cbdd"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "10e99526679f859e1710deece904cbdcc6a6972d" => :yosemite
    sha1 "03f84dd1230a766a67f50e5914bcf352fbd7be28" => :mavericks
    sha1 "6acb853facb9f89b16958e044d7ddb8f7f255fc3" => :mountain_lion
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on 'openblas' => :optional

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
      cd "TESTING"
      system "make", *make_args
      %w[stest dtest ctest ztest].each do |tst|
        ohai `tail -1 #{tst}.out`.chomp
      end
      cd ".."
    end
    prefix.install "make.inc"
    File.open(prefix / "make_args.txt", "w") do |f|
      f.puts(make_args.join(" "))  # Record options passed to make.
    end
    lib.install Dir["lib/*"]
    (include / "superlu").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]
    (share / "superlu").install "EXAMPLE"
  end
end
