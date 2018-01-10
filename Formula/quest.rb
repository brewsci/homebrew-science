class Quest < Formula
  homepage "http://www-hsc.usc.edu/~valouev/QuEST/QuEST.html"
  # doi "10.1038/nmeth.1246"
  # tag "bioinformatics"
  url "http://www-hsc.usc.edu/~valouev/QuEST/QuEST_2.4.tar.gz"
  sha256 "4a1e75798192938b2bc709140181b16aa83e7add60471735b4d84e2c23679ac7"

  bottle do
    cellar :any
    sha256 "d6a7bdafb4229d4bca2837884c9ee50a073f7bfce181b0a34db94cb3c3455885" => :yosemite
    sha256 "68dca3f3bcb940b146768e18579dfbd7969ed3a6626f0e19bdf3fb1257620b53" => :mavericks
    sha256 "533ff62d0823dfcb74bbc3aaa6de47c61f65401585a36c3660a86d91f4eabfe4" => :mountain_lion
    sha256 "9521a762435f1d30ac5c12dc0f38ee5282987e23fdf200440521e6cfd7ba8bfc" => :x86_64_linux
  end

  def install
    ENV.deparallelize
    system "./configure.pl"
    system "make"
    bin.install %w[generate_profile peak_caller quick_window_scan
                   calibrate_peak_shift generate_profile_views metrics
                   profile_2_wig align_2_QuEST collapse_reads
                   bin_align_2_bedgraph report_bad_control_regions]
    bin.install Dir["*.pl"]
    doc.install "README.txt"
  end

  test do
    assert_match "Required", shell_output("#{bin}/align_2_QuEST", 1)
  end
end
