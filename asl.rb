require 'formula'

class Asl < Formula
  url 'http://www.ampl.com/netlib/ampl/solvers.tgz'
  sha1 '3d527e03fff6eea8d0eff43bdc72391d778f0e0b'
  version '20140205'
  homepage 'http://www.ampl.com/hooking.html'

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
    (buildpath / 'makefile.brew').write <<-EOS.undent
      include makefile.u

      libasl.#{soname}: ${a:.c=.o}
      \t#{libtool_cmd.join(" ")} -o $@ $?

      libfuncadd0.#{soname}: funcadd0.o
      \t#{libtool_cmd.join(" ")} -o $@ $?
    EOS

    ENV.deparallelize
    targets = ["arith.h", "stdio1.h"]
    libs = ["libasl.#{soname}", "libfuncadd0.#{soname}"]
    system "make", "-f", "makefile.brew",
           "CFLAGS=#{cflags.join(' ')}", *(targets + libs)

    lib.install *libs
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
