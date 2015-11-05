class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.9.tar.gz"
  sha256 "c96f7d5932fad30c88300446cae9a49d35b6a1fcd5a971e02de129c5d7a53bb7"
  head "https://github.com/gmarcais/yaggo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32713e47b450a35af95f7eba664dd97c79c1e63653d35475173b7d55e5a6a9d7" => :el_capitan
    sha256 "64e70036dc8db79e168439e414c5760604ef5b87017be1957d386016527902ea" => :yosemite
    sha256 "bdc50a12ce87a7a578d9d3e972fc6b509399d346ff8acda7218bd2adb24a8341" => :mavericks
  end

  depends_on :ruby => ["1.9", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
