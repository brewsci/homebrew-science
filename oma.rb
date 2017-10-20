class Oma < Formula
  desc "Standalone package to infer orthologs with the OMA algorithm"
  homepage "https://omabrowser.org/standalone/"
  url "https://omabrowser.org/standalone/OMA.2.1.1.tgz"
  sha256 "c21fde703a1d13bd759ebc724e09b6d83b9e88abacc7cc1a78fee76972f93ec1"

  bottle do
    cellar :any_skip_relocation
    sha256 "82cd1c3c7e0f6acfa5cf5e74e13f133a98c712d0d9e36785eb1c8718ebd69dba" => :sierra
    sha256 "3a5199bf93d7e95af13be8d7b76d7cbb12362683ede8d63d946b8526737ab8d8" => :el_capitan
    sha256 "d4be2c5916d41dccab7b233714abb5f94dca78acff5cddb72207aed3f351923c" => :yosemite
    sha256 "5a0a5c0923fa90be2eaa4dc1d313bde16ddec374e8128e659b0d0703cdb73c16" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.1093/nar/gku1158"

  depends_on "python" => :recommended

  def install
    system "./install.sh", prefix
    bin.install_symlink prefix/"OMA/bin/oma"
  end

  test do
    system "#{bin}/oma", "-p"
    File.exist?("parameters.drw")
    inreplace "parameters.drw", "DoGroupFunctionPrediction := true", "DoGroupFunctionPrediction := false"
    mkdir_p "DB"
    (testpath/"DB/genome1.fa").write <<-EOS.undent
      >s1_1
      MEDSQSDMSIELPLSQETFSCLWKLLPPDDILPTTATGSPNSMEDLFLPQDVAELLEGPEEALQVSAPA
      >s1_2
      MWWLLRTLCFVHVIGSIFCFLNAKPKNPEANMNVSQIISYWGYESE
      >s1_3
      MQLLGRVICFVVGILLSGGPTGTISAVDPEANMNVTEIIMHWGYPGE
    EOS
    (testpath/"DB/genome2.fa").write <<-EOS.undent
      >s2_1
      MTAMEESQSDISLELPLSQETFSGLWKLLPPEDILPSPHCMDDLLLPQDVEEFFEGPSEALRVSGAPAAQDPVT
      >s2_2
      MTIHNVSLFTTIFNIFKFCVLYITSSLGISLERFIKCRKVKNINDIVSE
    EOS
    system "#{bin}/oma", "-s"
  end
end
