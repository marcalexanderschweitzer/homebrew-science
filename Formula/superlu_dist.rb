class SuperluDist < Formula
  desc "Distributed LU factorization for large linear systems"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  # url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_5.1.0.tar.gz"
  # sha256 "30ac554a992441e6041c6fb07772da4fa2fa6b30714279de03573c2cad6e4b60"
  # revision 3
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_5.3.0.tar.gz"
  sha256 "de40808a7916f2ef002e0c1c17d24b556b5ef7af9478541a0faacd1d318c4549"

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  option "without-test", "skip build-time tests (not recommended)"
  option "with-openmp", "Enable OpenMP multithreading"
  needs :openmp if build.with? "openmp"

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi" => [:cc, :f77, :f90]

  depends_on "parmetis"

  def install
    # prevent linking errors on linuxbrew:
    ENV.deparallelize
    ENV["MPICC"] = "mpicc"
    ENV["MPICXX"] = "mpicxx"
    ENV["MPIF90"] = "mpif90"

    dylib_ext = OS.mac? ? "dylib" : "so"

    cmake_args = std_cmake_args
    cmake_args << "-DTPL_PARMETIS_LIBRARIES=#{Formula["parmetis"].opt_lib}/libparmetis.#{dylib_ext};#{Formula["metis"].opt_lib}/libmetis.#{dylib_ext}"
    cmake_args << "-DTPL_PARMETIS_INCLUDE_DIRS=#{Formula["parmetis"].opt_include};#{Formula["metis"].opt_include}"
    cmake_args << "-DCMAKE_C_FLAGS=-fPIC -O2"
    cmake_args << "-DBUILD_SHARED_LIBS=ON"
    cmake_args << "-DCMAKE_C_COMPILER=#{ENV["MPICC"]}"
    cmake_args << "-DCMAKE_Fortran_COMPILER=#{ENV["MPIF90"]}"
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

    blaslib = ("/System/Library/Frameworks/Accelerate.framework/Accelerate")
    cmake_args << "-DTPL_BLAS_LIBRARIES=#{blaslib}"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
      system "make", "test" if build.with? "test"
    end

    doc.install "DOC/ug.pdf"
    pkgshare.install "EXAMPLE"
  end

  test do
    ENV.fortran
    cp pkgshare/"EXAMPLE/dcreate_matrix.c", testpath
    cp pkgshare/"EXAMPLE/pddrive.c", testpath
    cp pkgshare/"EXAMPLE/g20.rua", testpath
    system "mpicc", "-o", "pddrive", "pddrive.c", "dcreate_matrix.c", "-L#{Formula["superlu_dist"].opt_lib}", "-lsuperlu_dist"
    system "mpirun", "-np", "4", "./pddrive", "-r", "2", "-c", "2", "g20.rua"
  end
end