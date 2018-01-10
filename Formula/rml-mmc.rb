class RmlMmc < Formula
  homepage "https://www.ida.liu.se/labs/pelab/rml"
  url "https://build.openmodelica.org/apt/pool/contrib/rml-mmc_280.orig.tar.gz"
  version "2.8.0"
  sha256 "7b184af0a802847fa4bfeb610d0f0ef12352debe68fe500fcf73c931b5cf3ffb"

  head "https://openmodelica.org/svn/MetaModelica/trunk", :using => :svn

  depends_on "smlnj"

  def install
    ENV.deparallelize
    ENV["SMLNJ_HOME"] = Formula["smlnj"].opt_prefix/"SMLNJ_HOME"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rml", "-v"
  end
end
