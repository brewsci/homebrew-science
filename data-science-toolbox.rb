require 'formula'

class DataScienceToolbox < Formula
  # See also http://jeroenjanssens.com/2013/09/19/seven-command-line-tools-for-data-science.html
  homepage 'https://github.com/jeroenjanssens/data-science-toolbox'
  version '4bbe4cf'
  url "https://github.com/jeroenjanssens/data-science-toolbox/archive/#{version}.tar.gz"
  sha1 '15710d8bc588d1a72d7ca6b10678b8fa57e7485c'
  head 'https://github.com/jeroenjanssens/data-science-toolbox.git'

  def install
    bin.install %w[Rio dumbplot explain pbc pca sample scrape]
    doc.install 'README.md'
  end

  test do
    system 'Rio -h 2>&1 |grep -q Rio'
  end
end
