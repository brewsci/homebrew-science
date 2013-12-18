require 'formula'

class Asl < Formula
  url 'http://www.ampl.com/netlib/ampl/solvers.tgz'
  sha1 'e5c8f11fc20a33cddb724d0909959b555e9da869'
  version '20131209'
  homepage 'http://www.ampl.com/hooking.html'

  def install
    args = ["CC=#{ENV.cc}", 'CFLAGS="-I. -O -fPIC"']

    # Dynamic libraries are more user friendly.
    # Inclusion of the following in ASL was suggested to David Gay.
    (buildpath / 'makefile.brew').write <<-EOS.undent
      include makefile.u

      libasl.dylib: ${a:.c=.o}
      \t$(CC) -shared -Wl,-install_name -Wl,#{lib}/libasl.dylib -o libasl.dylib $?

      libfuncadd0.dylib: funcadd0.o
      \t$(CC) -shared -Wl,-install_name -Wl,#{lib}/libfuncadd0.dylib -o libfuncadd0.dylib $?
    EOS

    ENV.deparallelize
    system *(%w[make -f makefile.brew arith.h stdio1.h libasl.dylib libfuncadd0.dylib] + args)

    lib.install 'libasl.dylib', 'libfuncadd0.dylib'
    (include+'asl').install Dir['*.h']
    (include+'asl').install Dir['*.hd']
    doc.install 'README'
  end

  def caveats; <<-EOS.undent
    Include files are in #{include}/asl.
    To link with the ASL, you may simply use
    -L#{lib} -lasl -lfuncadd0
    EOS
  end
end
