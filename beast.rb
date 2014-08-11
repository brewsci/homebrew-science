require 'formula'

class Beast < Formula
  homepage 'http://beast.bio.ed.ac.uk/'
  url 'https://beast-mcmc.googlecode.com/files/BEASTv1.8.0.tgz'
  sha1 'e4e483cee01263115a827b8c992be02a7bf9cf8e'

  head do
    url 'https://beast-mcmc.googlecode.com/svn/trunk/'
    depends_on :ant
  end

  def install
    system "ant", "linux" if build.head?

    # Move jars to libexec
    inreplace Dir["bin/*"] do |s|
      s['$BEAST/lib'] = '$BEAST/libexec'
    end

    mv 'lib', 'libexec'
    prefix.install Dir[build.head? ? 'release/Linux/BEASTv*/*' : '*']
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
