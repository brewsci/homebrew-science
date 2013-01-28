require 'formula'

class Voroxx < Formula
  homepage 'http://math.lbl.gov/voro++'
  url 'http://math.lbl.gov/voro++/download/dir/voro++-0.4.5.tar.gz'
  sha1 '64f8431aa034085dda567fc6a9b14a4fdb7a62a3'
  head 'https://codeforge.lbl.gov/anonscm/voro/trunk', :using => :svn

  def install
    # configure the prefix
    inreplace 'config.mk' do |s|
      s.change_make_var! "PREFIX", prefix
    end

    system 'make'
    system 'make', 'install'

    (share/'voro++').install('examples')
    mv prefix/'man', share/'man'
  end

  def test
    system 'voro++','-h'
  end

  def caveats
    <<-EOS.undent
    Example scripts are installed here:
      #{HOMEBREW_PREFIX}/share/voro++/examples
    EOS
  end
end
