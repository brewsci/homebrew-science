class Nextflow < Formula
  desc "Data-driven computational pipelines"
  homepage "http://www.nextflow.io/"
  # doi "10.6084/m9.figshare.1254958"
  # tag "bioinformatics"

  url "http://www.nextflow.io/releases/v0.16.5/nextflow"
  version "0.16.5"
  sha256 "c2dd8c0cd4503e37705842e67185fb4d0027a658e7d258d45630628f6e854922"

  head "https://github.com/nextflow-io/nextflow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e7420b4ecf9a9429c5dc8f6cfdd78431fe67688b4e7c72c01658a999312a982" => :el_capitan
    sha256 "2179af0e508c867049df4f1ff2fe2a97ec3b8f0192d14e4b8df3d3782aac1905" => :yosemite
    sha256 "e75ca2f8558415093b5e4f4dd9fa1b1049f67b78b152e34a734e85fb39fec4fb" => :mavericks
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
