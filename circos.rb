class Circos < Formula
  homepage "http://circos.ca"
  url "http://circos.ca/distribution/circos-0.67-7.tgz"
  mirror "http://science-annex.org/pub/circos/circos-0.67-7.tgz"
  sha256 "6e1fc82e1f2f74056fa3229eb43f069e5813e911e9d75e6267f5e1e569a87b49"

  bottle do
    sha256 "c0fae55ac184e19ca1cee85e335c31c98c9046d407648c7da976efe1ec7dfd2d" => :yosemite
    sha256 "30b9f02fd823e111562a102e6757ea43a7ecb9b8a735d6a3f597f2845c276564" => :mavericks
  end

  depends_on "gd"

  depends_on "Params::Validate" => :perl
  depends_on "Math::Round" => :perl
  depends_on "Regexp::Common" => :perl

  resource "Readonly" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SANKO/Readonly-2.00.tar.gz"
    sha256 "9bd0156e958842fdfd6c3bb27a23b47232d4737a407d81fabc4dc64b9363bf98"
  end
  resource "GD" do
    url "http://search.cpan.org/CPAN/authors/id/L/LD/LDS/GD-2.53.tar.gz"
    sha256 "d05d01fe95e581adb3468cf05ab5d405db7497c0fb3ec7ecf23d023705fab7aa"
  end
  resource "SVG" do
    url "https://cpan.metacpan.org/authors/id/S/SZ/SZABGAB/SVG-2.63.tar.gz"
    sha256 "0a32eb0d95bde0d56db7ed77a97c9d42ac8697abbee270070f8fafee34b38b89"
  end
  resource "Config::General" do
    url "http://search.cpan.org/CPAN/authors/id/T/TL/TLINDEN/Config-General-2.56.tar.gz"
    sha256 "0996c834ea2ad39ebddda9e59e62d7190ee6f2da3c5d2932c8379c0fa3eafd6b"
  end
  resource "Font::TTF::Font" do
    url "https://cpan.metacpan.org/authors/id/M/MH/MHOSKEN/Font-TTF-1.05.tar.gz"
    sha256 "26c48e4e76e00f0ac00766b3cfba79f0cb8cbf005b7a39033f0e8e0d9eeafb50"
  end
  resource "Text::Format" do
    url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Text-Format-0.59.tar.gz"
    sha256 "06ddf77b109c17115a3e1942eb92eb1728ee97f1a7cf61a501d2457cc51de8c9"
  end
  resource "Number::Format" do
    url "https://cpan.metacpan.org/authors/id/W/WR/WRW/Number-Format-1.73.tar.gz"
    sha256 "84a2b722ef21ab92bd09ee8de9ecf9969cd95a0655815e8c9b0720669986e46c"
  end
  resource "Math::Bezier" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABW/Math-Bezier-0.01.tar.gz"
    sha256 "11a815fc45fdf0efabb1822ab77faad8b9eea162572c5f0940c8ed7d56e6b8b8"
  end
  resource "Math::VecStat" do
    url "https://cpan.metacpan.org/authors/id/A/AS/ASPINELLI/Math-VecStat-0.08.tar.gz"
    sha256 "409a8e0e4b1025c8e80f628f65a9778aa77ab285161406ca4a6c097b13656d0d"
  end
  resource "Statistics::Basic" do
    url "https://cpan.metacpan.org/authors/id/J/JE/JETTERO/Statistics-Basic-1.6611.tar.gz"
    sha256 "6855ce5615fd3e1af4cfc451a9bf44ff29a3140b4e7130034f1f0af2511a94fb"
  end
  resource "Set::IntSpan" do
    url "https://cpan.metacpan.org/authors/id/S/SW/SWMCD/Set-IntSpan-1.19.tar.gz"
    sha256 "11b7549b13ec5d87cc695dd4c777cd02983dd5fe9866012877fb530f48b3dfd0"
  end

  def install
    inreplace "bin/circos", "#!/bin/env perl", "#!/usr/bin/env perl"
    libexec.install Dir["*"]

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Readonly").stage do
      system "perl", "Build.PL", "--install_base=#{libexec}"
      system "./Build"
      system "./Build", "install"
    end
    resources.each do |r|
      next if r.name == "Readonly"
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    (bin/"circos").write_env_script("#{libexec}/bin/circos", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"circos", "-conf", libexec/"example/etc/circos.conf", "-debug_group", "summary,timer"
    assert File.exist?("circos.svg")
    assert File.exist?("circos.png")
  end
end
