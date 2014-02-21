require 'formula'

class Circos < Formula
  homepage 'http://circos.ca'
  url 'http://circos.ca/distribution/circos-0.64.tgz'
  sha1 'f24a5806a533ae451d89bc441c03f77c87be0394'

  depends_on 'gd' => '--with-freetype'
  depends_on 'Config::General' => :perl
  depends_on 'Font::TTF::Font' => :perl
  depends_on 'GD::Polyline' => :perl
  depends_on 'Math::Bezier' => :perl
  depends_on 'Math::VecStat' => :perl
  depends_on 'Readonly' => :perl
  depends_on 'Set::IntSpan' => :perl
  depends_on 'Text::Format' => :perl

  def install
    inreplace 'bin/circos', '#!/bin/env perl', '#!/usr/bin/env perl'
    libexec.install Dir['*']
    bin.install_symlink '../libexec/bin/circos' => 'circos'
  end

  def caveats; <<-EOS.undent
    GD::Polyline fails to install with cpan.
    To install gd and circos, run the following commands:
      brew remove gd
      brew install gd --with-freetype
      brew install cpanminus
      sudo chown -R "$USER":admin /Library/Perl
      cpanm Config::General Font::TTF::Font Math::Bezier Math::VecStat Readonly Set::IntSpan Text::Format
      cpanm --force GD::Polyline
      brew install circos
    Alternatively, download and install GD.pm manually:
      perl Makefile.PL && make install
    EOS
  end

  test do
    system "cd #{libexec}/bin && ./test.modules"
    system "#{bin}/circos --version |grep -q ^circos"
    system "#{bin}/circos -conf #{libexec}/example/etc/circos.conf"
  end
end
