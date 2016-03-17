class Smrtanalysis < Formula
  desc "Analyze PacBio sequencing data"
  homepage "http://www.pacb.com/products-and-services/analytical-software/smrt-analysis/"
  # doi "10.1038/nmeth.2474"
  # tag "bioinformatics"
  url "http://files.pacb.com/software/smrtanalysis/2.3.0/smrtanalysis_2.3.0.140936.run"
  sha256 "242cd175816949f2cd649244fa38b49045c86026244481d34a6f6d254c49f5cd"

  bottle :unneeded

  # Patch
  resource "patch" do
    url "https://s3.amazonaws.com/files.pacb.com/software/smrtanalysis/2.3.0/smrtanalysis-patch_2.3.0.140936.p5.run"
    sha256 "171fcd51462da16c7cc30bf5ea665b511f68394c951d37510ac64af63aaf4d73"
  end

  def install
    raise "SMRT Analysis cannot be installed on Mac OS" if OS.mac?
    system "sh", "./smrtanalysis_#{version}.run", "--extract-only",
      "--patchfile", resource("patch").cached_download,
      "--rootdir", prefix
  end

  test do
    system "#{prefix}/install/smrtanalysis_#{version}/analysis/bin/blasr"
  end
end
