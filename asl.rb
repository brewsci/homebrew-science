require 'formula'

class Asl < Formula
  url 'http://www.ampl.com/netlib/ampl/solvers.tgz'
  sha1 '3d527e03fff6eea8d0eff43bdc72391d778f0e0b'
  version '20140205'
  homepage 'http://www.ampl.com/hooking.html'

  def install
    ENV.universal_binary
    # ENV.remove "CFLAGS", "-arch #{Hardware::CPU.arch_64_bit}"
    args = ["CC=#{ENV.cc}", "CFLAGS=-I. -O -fPIC -arch #{Hardware::CPU.arch_32_bit}"]

    # Dynamic libraries are more user friendly.
    # Inclusion of the following in ASL was suggested to David Gay.
    (buildpath / 'makefile.brew').write <<-EOS.undent
      include makefile.u

      libasl.dylib: ${a:.c=.o}
      \tlibtool -dynamic -undefined dynamic_lookup -install_name #{lib}/libasl.dylib -o libasl.dylib $?

      libfuncadd0.dylib: funcadd0.o
      \tlibtool -dynamic -undefined dynamic_lookup -install_name #{lib}/libfuncadd0.dylib -o libfuncadd0.dylib $?
    EOS

    ENV.deparallelize
    system *(%w[make -f makefile.brew arith.h stdio1.h libasl.dylib libfuncadd0.dylib] + args)

    lib.install 'libasl.dylib', 'libfuncadd0.dylib'
    (include / 'asl').install Dir["*.h"]
    (include / 'asl').install Dir["*.hd"]
    doc.install 'README'
  end

  def caveats; <<-EOS.undent
    Include files are in #{include}/asl.
    To link with the ASL, you may simply use
    -L#{lib} -lasl -lfuncadd0
    EOS
  end
end
