require 'formula'

class Genewise < Formula
  homepage 'http://www.ebi.ac.uk/~birney/wise2/'
  url 'http://www.ebi.ac.uk/~birney/wise2/wise2.4.1.tar.gz'
  sha1 '5b1e5eb9ff9584dd04fd7db9327b79f719e723d1'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    # Use pkg-config glib-2.0 rather than glib-config
    inreplace %w[src/makefile src/corba/makefile
        src/dnaindex/assembly/makefile src/dnaindex/makefile
        src/dynlibsrc/makefile src/models/makefile
        src/network/makefile src/other_programs/makefile
        src/snp/makefile],
      'glib-config', 'pkg-config glib-2.0'

    # getline conflicts with stdio
    inreplace 'src/HMMer2//sqio.c', 'getline', 'getline_ReadSeqVars'

    # undefined reference to `isnumber'
    # patch suggested in http://korflab.ucdavis.edu/datasets/cegma/ubuntu_instructions_1.txt
    inreplace 'src/models/phasemodel.c', 'isnumber', 'isdigit' if OS.linux?

    system *%w[make -C src all]
    bin.install Dir['src/bin/*']
    doc.install %w[INSTALL LICENSE README], *Dir['docs/*']
    (share/'genewise').install Dir['wisecfg/*']
  end

  def caveats; <<-EOS.undent
    You must set WISECONFIGDIR:
      export WISECONFIGDIR=#{HOMEBREW_PREFIX/'share/genewise'}
    EOS
  end

  test do
    system 'genewise -version 2>&1 |grep -q genewise'
  end
end
