require 'formula'

class Glimmer3 < Formula
  homepage 'http://ccb.jhu.edu/software/glimmer/index.shtml'
  url 'http://ccb.jhu.edu/software/glimmer/glimmer302b.tar.gz'
  version "3.02b"
  sha1 '665ed5c676c6d495e4354893e67ee605ec3e00da'

  depends_on "elph"

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

    Dir.glob('scripts/*.awk').each do |script|
      inreplace script, '/bin/awk', '/usr/bin/awk'
      libexec.install script
    end

    (share/"#{name}").install Dir.glob('sample-run/*.predict')
    (share/"#{name}").install 'sample-run/tpall.fna'

    inreplace 'scripts/g3-iterated.csh', '/nfshomes/adelcher', HOMEBREW_PREFIX
    inreplace 'scripts/g3-from-training.csh', '/nfshomes/adelcher', HOMEBREW_PREFIX

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
