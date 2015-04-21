class Nextflow < Formula
  homepage "http://www.nextflow.io/"
  # tag "bioinformatics"
  version "0.13.3"
  url "http://www.nextflow.io/releases/v0.13.3/nextflow"
  sha256 "2de679ab789e5f4f39e0b971f1fee32707f99f200b3fe68e16a13b9af29be957"
  head "https://github.com/nextflow-io/nextflow.git"

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  def post_install
    system "#{bin}/nextflow", "-download"
  end

  test do
    system "echo \"println 'hello'\" |#{bin}/nextflow -q run - |grep hello"
  end
end
