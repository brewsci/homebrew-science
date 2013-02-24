require 'formula'

class Mummer < Formula
  homepage 'http://mummer.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz'
  sha1 '69261ed80bb77e7595100f0560973fe1f810c5fa'

  def install

    inreplace 'scripts/Makefile', '$(CURDIR)', prefix

    system 'make'

    %w[dnadiff mummerplot nucmer promer mapview].each do |script|
      inreplace script, "use lib \"#{prefix}", "use lib \"#{share}/mummer"
    end

    inreplace 'promer' do |s|
      s.gsub! /BIN_DIR = "[^"]+/ , "BIN_DIR = \"#{libexec}"
      s.gsub! /AUX_BIN_DIR = "[^"]+/ , "AUX_BIN_DIR = \"#{libexec}"
      s.gsub! /SCRIPT_DIR = "[^"]+/ , "SCRIPT_DIR = \"#{share}/mummer"
    end

    inreplace 'nucmer' do |s|
      s.gsub! /BIN_DIR = "[^"]+/ , "BIN_DIR = \"#{libexec}"
      s.gsub! /AUX_BIN_DIR = "[^"]+/ , "AUX_BIN_DIR = \"#{libexec}"
      s.gsub! /SCRIPT_DIR = "[^"]+/ , "SCRIPT_DIR = \"#{share}/mummer"
    end

    inreplace 'dnadiff' do |s|
      s.gsub! /BIN_DIR = "[^"]+/ , "BIN_DIR = \"#{libexec}"
      s.gsub! /SCRIPT_DIR = "[^"]+/ , "SCRIPT_DIR = \"#{share}/mummer"
    end

    inreplace 'mummerplot' do |s|
      s.gsub! /BIN_DIR = "[^"]+/ , "BIN_DIR = \"#{libexec}"
      s.gsub! /SCRIPT_DIR = "[^"]+/ , "SCRIPT_DIR = \"#{share}/mummer"
    end

    inreplace 'exact-tandems' do |s|
      s.gsub! /bindir = \S+/ , "bindir = #{libexec}"
      s.gsub! /scriptdir = \S+/ , "scriptdir = #{libexec}"
    end

    inreplace 'run-mummer1' do |s|
      s.gsub! /bindir = \S+/ , "bindir = #{libexec}"
    end

    inreplace 'run-mummer3' do |s|
      s.gsub! /bindir = \S+/ , "bindir = #{libexec}"
    end

    %w[run-mummer1 run-mummer3 nucmer promer].each do |app|
      bin.install app
    end
    %w[show-diff repeat-match show-snps combineMUMs mgaps dnadiff
      show-tiling delta-filter exact-tandems show-coords mummer mummerplot
       mapview nucmer2xfig annotate gaps].each do |app|
      libexec.install app
    end
    libexec.install 'scripts/tandem-repeat.awk'

    # postnuc, postpro, prenuc, prepro
    Dir.glob('aux_bin/*').each do |script|
      libexec.install script
    end

    (share/'mummer').install 'scripts/Foundation.pm'

  end

  def caveats
    <<-EOS.undent
      show-diff, repeat-match, show-snps, combineMUMs, mgaps, dnadiff, show-tiling,
      delta-filter, exact-tandems, show-coords, mummer, mummerplot, mapview, nucmer2xfig,
      annotate, and gaps have been installed in #{libexec}
    EOS
  end

  def test
    %w[ nucmer promer run-mummer1 run-mummer3 ].each do |script|
      system "#{bin}/#{script} -h 2>&1 | grep -i USAGE | grep #{script}"
    end
    %w[ dnadiff mapview mummerplot show-diff repeat-match show-snps combineMUMs
        mgaps show-tiling delta-filter show-coords mummer mummerplot mapview].each do |script|
      system "#{libexec}/#{script} -h 2>&1 | grep -i USAGE | grep #{script}"
    end
  end

end
