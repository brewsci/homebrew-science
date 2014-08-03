require 'formula'

class Voroxx < Formula
  homepage 'http://math.lbl.gov/voro++'
  url 'http://math.lbl.gov/voro++/download/dir/voro++-0.4.6.tar.gz'
  sha1 '2ae72d1783ef01f673f0825afd119d7e6f8ed674'
  head 'https://codeforge.lbl.gov/anonscm/voro/trunk', :using => :svn

  def install
    system "make", "install", "PREFIX=#{prefix}"
    (share / "voro++").install("examples")
    mv prefix / "man", share / "man"
  end

  test do
    system "voro++", "-h"
  end

  def caveats
    <<-EOS.undent
    Example scripts are installed here:
      #{HOMEBREW_PREFIX}/share/voro++/examples
    EOS
  end
end
