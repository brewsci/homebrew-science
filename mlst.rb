class Mlst < Formula
  homepage "https://github.com/Victorian-Bioinformatics-Consortium/mlst"
  url "https://github.com/Victorian-Bioinformatics-Consortium/mlst/archive/1.0.tar.gz"
  sha256 "d7962779d79e9151cce2d9fbb5250fccf7b3fc8efb512eb34666ef6708cc1144"
  # tag "bioinformatics"

  depends_on "blat"
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "senterica", shell_output("mlst --list 2>&1", 0)
  end
end
