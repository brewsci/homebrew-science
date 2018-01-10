class EnsemblTools < Formula
  homepage "https://www.ensembl.org/info/docs/tools/index.html"
  # tag "bioinformatics"
  url "https://github.com/Ensembl/ensembl-tools/archive/release/78.tar.gz"
  sha256 "4c2995f5cb169f07490166c78a1155260ba9651e30b872202a0362f6eed78e48"
  head "https://github.com/Ensembl/ensembl-tools.git"

  def install
    cd "scripts/variant_effect_predictor" do
      libexec.mkdir
      ENV["PERL5LIB"] = libexec
      system "perl", "INSTALL.pl", "-a", "a", "-d", libexec
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
      scripts/variant_effect_predictor/variant_effect_predictor.pl
    ]
  end

  def caveats; <<-EOS.undent
    You may need to append your PERL5LIB environment variable:
      export PERL5LIB=#{opt_libexec}:$PERL5LIB
    EOS
  end

  test do
    system "#{bin}/variant_effect_predictor", "--help"
  end
end
