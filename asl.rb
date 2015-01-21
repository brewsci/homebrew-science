class Asl < Formula
  homepage "http://www.ampl.com/hooking.html"
  url "http://www.ampl.com/netlib/ampl/solvers.tgz"
  sha1 "f9d0da264c999c9f7f4667a441a9e90dd131f3e0"
  version "20150112"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    revision 1
    sha1 "375d55a734bfc615773aa1748e95954b924af222" => :yosemite
    sha1 "b8f9988c5a2407ca2fea3cbe199ebab098612ca1" => :mavericks
    sha1 "d817c5543e6b017ab7c284e4bd240ea77063fca8" => :mountain_lion
  end

  option "with-matlab", "Build MEX file for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /Applications/Matlab/MATLAB_R2013b.app/bin/mex (default: mex)"

  resource "spamfunc" do
    url "http://netlib.org/ampl/solvers/examples/spamfunc.c"
    sha1 "429a79fc54facc5ef99219fe460280a883c75dfa"
  end

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha1 "4518ee9a9895b0782169085126ee149d05ba66a7"
  end

  def install
    ENV.universal_binary if OS.mac?
    cflags = %w[-I. -O -fPIC]

    if OS.mac?
      cflags += ["-arch", "#{Hardware::CPU.arch_32_bit}"]
      soname = "dylib"
      libtool_cmd = ["libtool", "-dynamic", "-undefined", "dynamic_lookup",
                     "-install_name", "#{lib}/libasl.#{soname}"]
    else
      soname = "so"
      libtool_cmd = ["ld", "-shared"]
    end

    # Dynamic libraries are more user friendly.
    (buildpath / "makefile.brew").write <<-EOS.undent
      include makefile.u

      libasl.#{soname}: ${a:.c=.o}
      \t#{libtool_cmd.join(" ")} -o $@ $?

      libfuncadd0.#{soname}: funcadd0.o
      \t#{libtool_cmd.join(" ")} -o $@ $?
    EOS

    ENV.deparallelize
    targets = ["arith.h", "stdio1.h"]
    libs = ["libasl.#{soname}", "libfuncadd0.#{soname}"]
    system "make", "-f", "makefile.brew", "CC=#{ENV.cc}",
           "CFLAGS=#{cflags.join(" ")}", *(targets + libs)

    lib.install(*libs)
    (include / "asl").install Dir["*.h"]
    (include / "asl").install Dir["*.hd"]
    doc.install "README"

    if build.with? "matlab"
      mex = ARGV.value("with-mex-path") || "mex"
      resource("spamfunc").stage do
        system mex, "-f", File.join(File.dirname(mex), "mexopts.sh"),
                    "-I#{include}/asl", "spamfunc.c", "-largeArrayDims",
                    "-L#{lib}", "-lasl", "-lfuncadd0", "-outdir", bin
      end
    end

    resource("miniampl").stage do
      system "make", "CXX=#{ENV["CC"]} -std=c99", "LIBAMPL_DIR=#{prefix}"
      bin.install "bin/miniampl"
      (share / "asl/example").install "Makefile", "README.rst", "src", "examples"
    end
  end

  test do
    system "#{bin}/miniampl", "#{share}/asl/example/examples/wb", "showname=1", "showgrad=1"
  end

  def caveats
    s = <<-EOS.undent
      Include files are in #{opt_include}/asl.
      To link with the ASL, you may simply use
      -L#{opt_lib} -lasl -lfuncadd0
    EOS
    s += "\nAdd #{opt_bin} to your MATLABPATH." if build.with? "matlab"
    s
  end
end
