class Tisean < Formula
  desc "Nonlinear time series analysis"
  homepage "https://www.mpipks-dresden.mpg.de/~tisean/"
  url "https://www.mpipks-dresden.mpg.de/~tisean/TISEAN_3.0.1.tar.gz"
  sha256 "cd6662505a2e411218f5d34ccb8bf206a6148b6c79b1cc8e4fa4dc11dfd00534"
  revision 4

  bottle do
    cellar :any
    sha256 "83b99fb7f0468ed2a6e1cb60d942fc92e089727b1b32be741a749a89950f59a9" => :sierra
    sha256 "bfe43d57e148f0a309bd2f26f74ee8239ed213015ad8e34867f5c67579779958" => :el_capitan
    sha256 "e6d57dd859f6428077ec2b08bdc3bdf72f622705fe64ac25e7bff3a65c02e755" => :yosemite
  end

  option "without-prefixed-binaries", "Do not prefix binaries with `tisean-`"

  depends_on :fortran
  depends_on "gnu-sed"

  BINS = ["poincare", "extrema", "rescale", "recurr", "corr", "mutual",
          "false_nearest", "lyap_r", "lyap_k", "lyap_spec", "d2", "av-d2",
          "makenoise", "nrlazy", "low121", "lzo-test", "lfo-run", "lfo-test",
          "rbf", "polynom", "polyback", "polynomp", "polypar", "ar-model",
          "mem_spec", "pca", "ghkss", "lfo-ar", "xzero", "xcor", "boxcount",
          "fsle", "resample", "histogram", "nstat_z", "sav_gol", "delay",
          "lzo-gm", "arima-model", "lzo-run", "c1", "c2naive", "xc2", "c2d",
          "c2g", "c2t", "pc", "predict", "stp", "lazy", "project", "addnoise",
          "compare", "upo", "upoembed", "cluster", "choose", "rms", "notch",
          "autocor", "spectrum", "wiener1", "wiener2", "surrogates",
          "endtoend", "timerev", "events", "intervals", "spikespec",
          "spikeauto", "henon", "ikeda", "lorenz", "ar-run", "xrecur"].freeze

  def install
    system "./configure", "--prefix=#{prefix}"
    inreplace "./source_f/Makefile", "sed", "gsed"
    inreplace "./source_f/cluster.f",
              "999  if(iv_io(iverb).eq.1) write(0,'(a,i)') \"matrix size \", np",
              "999  if(iv_io(iverb).eq.1) write(0,*) \"matrix size \", np"
    bin.mkpath
    system "make"
    system "make", "install"
    if build.with? "prefixed-binaries"
      Tisean::BINS.each { |item| mv "#{bin}/#{item}", "#{bin}/tisean-#{item}" }
    end
  end

  def caveats
    if build.with? "prefixed-binaries" then <<-EOS.undent
      By default, all TISEAN binaries are prefixed with `tisean-`.
      For unprefixed binaries, use `--without-prefixed-binaries`.
      EOS
    end
  end

  test do
    pfx = build.with?("prefixed-binaries") ? "tisean-" : ""
    Tisean::BINS.each { |item| system "#{bin}/#{pfx}#{item}", "-h" }
  end
end
