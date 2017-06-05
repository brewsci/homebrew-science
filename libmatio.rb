class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.10/matio-1.5.10.tar.gz"
  sha256 "41209918cebd8cc87a4aa815fed553610911be558f027aee54af8b599c78b501"
  revision 1

  bottle do
    cellar :any
    sha256 "4ddf545b7d22fbe06f87781d41c5133f08e5f445079ae49778257884693291f1" => :sierra
    sha256 "8f282fcfc63bb6816e17c687f45db8be5887ea371cad9bc10308c84092b2ed21" => :el_capitan
    sha256 "bbd4fa83a5d321555452ea243e826ec1812348e1e504d50558b8407b887b0287" => :yosemite
  end

  # sample MATLAB file from http://web.uvic.ca/~monahana/eos225/matlab_tutorial/tutorial_5/working_with_data.html
  resource "test_mat_file" do
    url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib=/usr
      --enable-extended-sparse=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --enable-mat73=yes
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    mv "poc_data.mat.sfx", "test.mat"
    (testpath/"not-a-mat-file.mat").write("Not a mat file\n")
    (testpath/"mat.c").write <<-'EOS'.undent
      #include <stdlib.h>
      #include <stdio.h>
      #include <matio.h>
      #include <errno.h>
      int main(int argc, char **argv)
      {
        mat_t *matfp;
        errno = 0;
        matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
        if (NULL == matfp) {
          printf("errno %d", errno);
          return EXIT_FAILURE;
        }
        printf("errno %d", errno);
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    assert_equal "errno 2", shell_output("./mat no-such-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat not-a-mat-file.mat", 1)
    assert_equal "errno 0", shell_output("./mat test.mat")
  end
end
