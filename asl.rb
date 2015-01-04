class Asl < Formula
  homepage "http://www.ampl.com/hooking.html"
  url "http://www.ampl.com/netlib/ampl/solvers.tgz"
  sha1 "4a380bc2bb7d8c3b0d87bd2071a9129a25809187"
  version "20150101"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "0260a15766491111e66feda8d3bf94fa7b8bf024" => :yosemite
    sha1 "bdf49bd86678c2f822ade8f71bd617f38fb65d28" => :mavericks
    sha1 "943ee72fccb055bb79b17d0aba94f84440a312d0" => :mountain_lion
  end

  option "with-matlab", "Build MEX file for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /Applications/Matlab/MATLAB_R2013b.app/bin/mex (default: mex)"

  resource "spamfunc" do
    url "http://netlib.org/ampl/solvers/examples/spamfunc.c"
    sha1 "429a79fc54facc5ef99219fe460280a883c75dfa"
  end

  def install
    ENV.universal_binary if OS.mac?
    cflags = %w(-I. -O -fPIC)

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
           "CFLAGS=#{cflags.join(' ')}", *(targets + libs)

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
