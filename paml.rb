require 'formula'

class Paml < Formula
  homepage 'http://abacus.gene.ucl.ac.uk/software/paml.html'
  url 'http://abacus.gene.ucl.ac.uk/software/paml4.7.tgz'
  sha1 '908cae1e81659f653df1030f4cdf62178947fd64'

  def install
    cd 'src' do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg codeml pamp evolver yn00 chi2]
    end

    (share+'paml').install 'dat'
    (share+'paml').install Dir['*.ctl']
    doc.install Dir['doc/*']
    doc.install 'examples'
  end

  def caveats
    <<-EOS.undent
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end
end
