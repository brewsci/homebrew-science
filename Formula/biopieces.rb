class Biopieces < Formula
  desc "Bioinformatic framework"
  homepage "https://github.com/maasha/biopieces"
  url "https://github.com/maasha/biopieces.git",
    :tag => "2.0",
    :revision => "982f80f7c55e2cae67737d80fe35a4e784762856"
  sha256 "484877c4a844ed1e6c70594248c44b9f19a6e7a1fd08456e28f2cc83425151e8"
  head "https://github.com/maasha/biopieces.git"
  # tag "bioinformatics"

  # Depends_on "Bit::Vector" => :perl
  # Depends_on "Carp::Clan" => :perl
  # Depends_on "Class::Inspector" => :perl
  # Depends_on "DBI" => :perl
  # Depends_on "DB_File" => :perl
  # Depends_on "HTML::Parser" => :perl
  # Depends_on "Inline" => :perl
  # Depends_on "LWP" => :perl
  # Depends_on "Module::Build" => :perl
  # Depends_on "Parse::RecDescent" => :perl
  # Depends_on "SOAP::Lite" => :perl
  # Depends_on "SVG" => :perl
  # Depends_on "Term::ReadKey" => :perl
  # Depends_on "Time::HiRes" => :perl
  # Depends_on "URI" => :perl
  # Depends_on "XML::Parser" => :perl
  # Depends_on "version" => :perl

  # Depends_on "inline" => :ruby
  # Depends_on "narray" => :ruby

  def install
    rm "bin/00README"
    prefix.install Dir["*"]
  end

  def caveats; <<~EOS
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
