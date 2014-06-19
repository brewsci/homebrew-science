require "formula"

class Tisean < Formula
  homepage "http://www.mpipks-dresden.mpg.de/~tisean/"
  url "http://www.mpipks-dresden.mpg.de/~tisean/TISEAN_3.0.1.tar.gz"
  sha1 "7fe71899b063abe1b3d9aae88f153988495d623b"

  option "no-prefixed-binaries", "Do not prefix binaries with `tisean-`"

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
          "spikeauto", "henon", "ikeda", "lorenz", "ar-run", "xrecur"]

  def install
    system "./configure", "--prefix=#{prefix}"
    inreplace "./source_f/Makefile", "sed", "gsed"
    inreplace "./source_f/cluster.f",
              "999  if(iv_io(iverb).eq.1) write(0,'(a,i)') \"matrix size \", np",
              "999  if(iv_io(iverb).eq.1) write(0,*) \"matrix size \", np"
    bin.mkpath
    system "make"
    system "make install"
    if not build.include? "no-prefixed-binaries"
      Tisean::BINS.each { |item| system "mv #{bin}/#{item} #{bin}/tisean-#{item}" }
    end
  end

  test do
    if (Dir.glob "#{bin}/tisean-*").length > 0
      Tisean::BINS.each { |item| system "#{bin}/tisean-#{item} -h" }
    else
      Tisean::BINS.each { |item| system "#{bin}/#{item} -h" }
    end
  end
end
