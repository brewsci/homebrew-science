class TransProteomicPipeline < Formula
  desc "TransProteomicPipeline: Collection of proteomics tools"
  homepage "http://tools.proteomecenter.org/wiki/index.php?title=Software:TPP"
  url "https://github.com/iracooke/tpp/archive/v4.8.0p9.tar.gz"
  version "4.8.0"
  sha256 "2f500c867e86eee16e8be1c91a97d1c4e51cfba65a1a3b3fa2327e2731f28d80"

  # doi "10.1007/978-1-60761-444-9_15"
  # tag "bioinformatics"

  depends_on "gd"
  depends_on "gnuplot"

  def install
    cd "trans_proteomic_pipeline/src/" do
      File.open("Makefile.config.incl", "wb") do |f|
        f.write "TPP_ROOT=#{prefix}/\nTPP_WEB=#{prefix}/web/\nCGI_USERS_DIR=#{prefix}/cgi-bin/"
      end

      mkdir_p prefix/"web"
      mkdir_p prefix/"cgi-bin"
      mkdir_p prefix/"params"

      # Build fails with this set.  First failure is on building the gsl. There may be more
      ENV.deparallelize

      # If these are set TPP Makefiles will make incorrect inferences about the build system
      # Ideally this should be fixed in the TPP Makefiles but there are many of them and they have complex interdependencies
      ENV.delete("CC")
      ENV.delete("CXX")

      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/ProphetModels.pl"
    system "#{bin}/ProteinProphet", "-h"
  end
end
