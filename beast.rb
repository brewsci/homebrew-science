require 'formula'

class Beast < Formula
  homepage 'http://beast.bio.ed.ac.uk/'
  url 'https://beast-mcmc.googlecode.com/files/BEASTv1.7.5.tgz'
  sha1 '825ddd87b67e4f13e078010810b028af78238c44'
  head 'http://beast-mcmc.googlecode.com/svn/trunk/'

  depends_on :ant if build.head?

  def install
    system "ant", "linux" if build.head?

    # Move jars to libexec
    inreplace Dir["bin/*"] do |s|
      s['$BEAST/lib'] = '$BEAST/libexec'
    end

    mv 'lib', 'libexec'
    prefix.install Dir[build.head? ? 'release/Linux/BEASTv1.8.0pre/*' : '*']
  end

  test do
    system "beast -help"
  end

  def caveats; <<-EOS.undent
    Examples are installed in:
      #{opt_prefix}/examples/
  EOS
  end
end
