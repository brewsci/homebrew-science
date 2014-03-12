require "formula"

class Biopieces < Formula
  homepage "https://code.google.com/p/biopieces/"
  version '2291'
  url "http://biopieces.googlecode.com/svn/trunk/", :revision => version
  head "http://biopieces.googlecode.com/svn/trunk/"

  depends_on "biopieces" => :ruby

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

  def install
    prefix.install Dir['*']
    bin.mkdir
    cd bin do
      bin.install_symlink Dir['../bp_bin/*']
    end
    rm_f bin/'00README'

    # Install the documentation.
    cd prefix do
      system 'svn checkout http://biopieces.googlecode.com/svn/wiki bp_usage'
    end
  end

  def caveats; <<-EOS.undent
      To use Biopieces, set the following environment variables:
        export BP_DIR=#{opt_prefix}
        export BP_DATA="$BP_DIR/bp_data"
        export BP_LOG=~/Library/Logs/Biopieces
        export BP_TMP=/tmp
        export PERL5LIB="$BP_DIR/code_perl:$PERL5LIB"
        export RUBYLIB="$BP_DIR/code_ruby/lib:$RUBYLIB"
        mkdir -p $BP_LOG
    EOS
  end

  test do
    system "#{bin}/read_fasta --help"
  end
end
