class Biopieces < Formula
  desc "Bioinformatic framework"
  homepage "https://github.com/maasha/biopieces"
  url "https://github.com/maasha/biopieces.git",
    :tag => "2.0",
    :revision => "982f80f7c55e2cae67737d80fe35a4e784762856"
  sha256 "484877c4a844ed1e6c70594248c44b9f19a6e7a1fd08456e28f2cc83425151e8"
  head "https://github.com/maasha/biopieces.git"
  # tag "bioinformatics"

  depends_on "Bit::Vector" => :perl
  depends_on "Carp::Clan" => :perl
  depends_on "Class::Inspector" => :perl
  depends_on "DBI" => :perl
  depends_on "DB_File" => :perl
  depends_on "HTML::Parser" => :perl
  depends_on "Inline" => :perl
  depends_on "LWP" => :perl
  depends_on "Module::Build" => :perl
  depends_on "Parse::RecDescent" => :perl
  depends_on "SOAP::Lite" => :perl
  depends_on "SVG" => :perl
  depends_on "Term::ReadKey" => :perl
  depends_on "Time::HiRes" => :perl
  depends_on "URI" => :perl
  depends_on "XML::Parser" => :perl
  depends_on "version" => :perl

  depends_on "inline" => :ruby
  depends_on "narray" => :ruby

  def install
    rm "bin/00README"
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
      To use Biopieces, set the following environment variables:
        export BP_DIR=#{opt_prefix}
        export BP_DATA="$BP_DIR/bp_data"
        export BP_LOG=~/Library/Logs/Biopieces
        export BP_TMP=/tmp
        export PERL5LIB="$BP_DIR/src/perl:$PERL5LIB"
        export RUBYLIB="$BP_DIR/src/ruby/lib:$RUBYLIB"
        mkdir -p $BP_LOG
    EOS
  end

  test do
    system "#{bin}/read_fasta", "--help"
  end
end
