class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.17.2/nextflow"
  version "0.17.2"
  sha256 "c92f9281787a747938a0c4d0f3c98a3b0d05798193b9248c3b055a935b323211"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b1d6830f77160f64bc7c3d3173a1dec2060d167300db4af07d4f53ac0d96c47" => :el_capitan
    sha256 "fcec6404ffd2970c272f7887b73ac47ab081d4c9d2755a4ab4e7d7ad340b35a5" => :yosemite
    sha256 "869e49bf1f8ef2ce5a4526a0b8c6793cc6067874cb70d6b34d6f7ced6c4586f7" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    bin.install "nextflow"
  end

  test do
    system "#{bin}/nextflow", "-download"
    system "echo", "println \'hello\' | #{bin}/nextflow -q run - |grep hello"
  end
end
