class Pilercr < Formula
  desc "Finding CRISPR repeats in genome sequences"
  homepage "https://drive5.com/pilercr/"
  # doi "doi:10.1186/1471-2105-8-18"
  # tag "bioinformatics"

  url "https://www.drive5.com/pilercr/pilercr1.06.tar.gz"
  sha256 "50175f7aa171674cda5ba255631f340f9cc7f80e8cc25135a4cb857147d91068"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a16c91e43acf94bc30d43be3fa2b34fff56ebca3e60ddc5b99d7193aa7ebf8f" => :el_capitan
    sha256 "148af9f887886cf0b0605f83e8a8ce3f1783c6248828ebe0caaa170d8f233737" => :yosemite
    sha256 "6dda505f38845aa031b274637985c99dbc3060e01f85ee303af2536522e505f3" => :mavericks
    sha256 "cba523fc568944de3a6b7408af159d0b11483a433781b57a26f7e102e484185a" => :x86_64_linux
  end

  depends_on "muscle"

  def install
    system "make", "CC=#{ENV.cc} -c", "GPP=#{ENV.cxx}", "LDLIBS=-lm"
    bin.install "pilercr"
  end

  test do
    system "#{bin}/pilercr", "-version"
  end
end
