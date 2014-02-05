require 'formula'

class Cgap < Formula
  homepage 'http://www.herbbol.org:8000/chloroplast/default/index'
  url 'http://www.herbbol.org:8000/chloroplast/static/AllSourceCode.rar'
  sha1 'e85b9205f32341347ee97e898f7e734fea0918bf'
  version '20130314'

  depends_on 'matplotlib' => :python
  depends_on 'scipy' => :python
  depends_on LanguageModuleDependency.new :python, 'biopython', 'Bio'

  depends_on 'Bio::Perl' => :perl

  depends_on 'blast'
  depends_on 'circos'
  depends_on 'imagemagick'
  depends_on 'mummer'
  depends_on 'ogdraw'
  depends_on 'phylip'

  def install
    libexec.install Dir['web2py/*']
  end

  test do
    system "python #{libexec}/web2py.py --help"
  end
end
