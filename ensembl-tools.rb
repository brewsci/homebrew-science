require "formula"

class EnsemblTools < Formula
  homepage "http://www.ensembl.org/info/docs/tools/index.html"
  url "https://github.com/Ensembl/ensembl-tools/archive/release/75.tar.gz"
  sha1 "ba83c471c53c2d3192d9632a8601d110831db767"
  head "https://github.com/Ensembl/ensembl-tools.git"

  depends_on "Bio::Perl" => :perl
  depends_on "Mozilla::CA" => :perl

  def install
    libexec.mkdir
    cd "scripts/variant_effect_predictor" do
      ENV["PERL5LIB"] = libexec
      system "perl INSTALL.pl -a a -d #{libexec}"
    end
    (bin/"variant_effect_predictor").write <<-EOS.undent
      #!/bin/sh
      set -eu
      export PERL5LIB=#{libexec}
      exec #{libexec}/variant_effect_predictor.pl "$@"
    EOS

    libexec.install %w[
      scripts/assembly_converter/AssemblyMapper.pl
      scripts/id_history_converter/IDmapper.pl
      scripts/region_reporter/region_report.pl
      scripts/variant_effect_predictor/convert_cache.pl
      scripts/variant_effect_predictor/filter_vep.pl
      scripts/variant_effect_predictor/gtf2vep.pl
      scripts/variant_effect_predictor/variant_effect_predictor.pl]
  end

  def caveats; <<-EOS.undent
    Add the following to your ~/.bash_profile or ~/.zprofile:
      export PERL5LIB=$PERL5LIB:#{libexec}
    EOS
  end

  test do
    system "#{bin}/variant_effect_predictor --help"
  end
end
