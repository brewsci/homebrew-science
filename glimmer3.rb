require 'formula'

class Glimmer3 < Formula
  homepage 'http://www.cbcb.umd.edu/software/glimmer/'
  url 'http://www.cbcb.umd.edu/software/glimmer/glimmer302a.tar.gz'
  version "3.02"
  sha1 '27fbd2498f997e0a47026b348b2fc95b073b712a'

  def install
    cd 'src' do
      system 'make'
    end

    cd 'bin' do
      # Lots of binaries with kind of common names. We put these in
      # libexec and not in bin. The shell scripts (see below)
      # know how to call these, because we set the $glimmerpath.
      libexec.install %w[window-acgt start-codon-distrib long-orfs
                     entropy-score build-fixed uncovered score-fixed glimmer3
                     entropy-profile anomaly multi-extract extract build-icm]
    end

    libexec.install Dir.glob('scripts/*.awk')

    (share/"#{name}").install Dir.glob('sample-run/*.predict')
    (share/"#{name}").install 'sample-run/tpall.fna'

    Dir.glob('scripts/*.csh').each do |script|
      inreplace script, '/fs/szgenefinding/Glimmer3/scripts', libexec
      inreplace script, '/fs/szgenefinding/Glimmer3', HOMEBREW_PREFIX
      inreplace script, '$glimmerpath', libexec
      bin.install script
    end

  end

  def caveats
    <<-EOS.undent
      Glimmer3 is mostly used by calling the .csh scripts but if you need the
      supporting binaries, they are in
          #{libexec}
    EOS
  end

  test do
    system "g3-from-scratch.csh #{share}/#{name}/tpall.fna test"

    if FileTest.exists? 'test.predict'
      %x(diff test.predict #{share}/#{name}/from-scratch.predict).empty? ? true : false
    else
      false
    end
  end
end
