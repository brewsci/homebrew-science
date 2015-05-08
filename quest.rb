class Quest < Formula
  homepage "http://www-hsc.usc.edu/~valouev/QuEST/QuEST.html"
  # doi "10.1038/nmeth.1246"
  # tag "bioinformatics"
  url "http://www-hsc.usc.edu/~valouev/QuEST/QuEST_2.4.tar.gz"
  sha256 "4a1e75798192938b2bc709140181b16aa83e7add60471735b4d84e2c23679ac7"

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
