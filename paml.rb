require 'formula'

class Paml < Formula
  homepage 'http://abacus.gene.ucl.ac.uk/software/paml.html'
  url 'http://abacus.gene.ucl.ac.uk/software/paml4.8.tgz'
  sha1 '831746bc497bb20d5d6f21c5ea4c00bcf0ec3956'

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
