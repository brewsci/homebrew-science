require 'formula'

class Beast < Formula
  homepage 'http://beast.bio.ed.ac.uk/'
  url 'http://tree.bio.ed.ac.uk/download.php?id=92&num=3'
  version '1.8.2'
  sha1 '47a5aca20fecf6cb61a301f8b03d1e750858721a'

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
