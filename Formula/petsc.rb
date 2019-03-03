 class Petsc < Formula
  desc ""
  homepage "https://www.mcs.anl.gov/petsc/"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.8.3.tar.gz"
  # sha256 "5509e35d55d5ce9e92dbe7a83f5e509865aea2a4cc2d9f16f72b7a5ceaafed96"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.1.tar.gz"
  # sha256 "8e3455d2ef0aed637d4d8033dab752551e049a088f893610b799aa3188a5c246"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.2.tar.gz"
  # sha256 "65100189796f05991bb2e746f56eec27f8425f6eb901f8f08459ffd2a5e6c69a"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.3.tar.gz"
  # sha256 "8828fe1221f038d78a8eee3325cdb22ad1055a2f0671871815ee9f47365f93bb"
  # url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.10.3.tar.gz"
  # sha256 "f03650ea5592313dd2b8be7ae9cc498369da660185b58f9e98689a9bc355e982"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.10.4.tar.gz"
  sha256 "1921b2208801d6e03b44035d65d6c11901dbfa6c13a5a0f23864c04f4832613a"

  depends_on "cmake"
  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "marcalexanderschweitzer/science/parmetis"
  # depends_on "netcdf"
  # depends_on "superlu"
  # depends_on "suite-sparse"

  def install
    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["F77"] = "mpif77"
    ENV["FC"] = "mpif90"
    ENV["PETSC_DIR"] = Dir.getwd

    arch_real = "real"
    ENV["PETSC_ARCH"] = arch_real
    system "./configure", "CC=mpicc", "CXX=mpicxx", "FC=mpif90", "F77=mpif77",
                          "--with-shared-libraries=1",
                          "--with-pthread=0",
                          "--with-openmp=0",
                          "--with-cxx-dialect=C++11",
                          "--prefix=#{prefix}/#{arch_real}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
                          # "--with-netcdf-dir=#{Formula["netcdf"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5"].opt_prefix}",
                          "--with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-parmetis-dir=#{Formula["parmetis"].opt_prefix}",
                          # "--with-superlu-dir=#{Formula["superlu"].opt_prefix}",
                          "--with-netcdf=0",
                          "--with-suitesparse=0",
                          "--with-sundials=0",
                          "--download-superlu_dist", 
                          "--download-mumps",
                          "--download-hypre", 
                          "--download-ml", 
                          "--with-x=0"
    system "make", "all"
    system "make", "install"

    system "make", "distclean"

    arch_complex = "complex"
    ENV["PETSC_ARCH"] = arch_complex
    system "./configure", "CC=mpicc", "CXX=mpicxx", "FC=mpif90", "F77=mpif77",
                          "--with-shared-libraries=1",
                          "--with-pthread=0",
                          "--with-openmp=0",
                          "--with-cxx-dialect=C++11",
                          "--prefix=#{prefix}/#{arch_complex}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
                          # "--with-netcdf-dir=#{Formula["netcdf"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5"].opt_prefix}",
                          "--with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-parmetis-dir=#{Formula["parmetis"].opt_prefix}",
                          # "--with-superlu-dir=#{Formula["superlu"].opt_prefix}",
                          "--with-netcdf=0",
                          "--with-suitesparse=0",
                          "--with-sundials=0",
                          "--download-superlu_dist", 
                          "--download-mumps",
                          "--download-hypre", 
                          "--download-ml", 
                          "--with-x=0"
    system "make", "all"
    system "make", "install"

    petsc_arch = arch_real
    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"],
                                "#{prefix}/#{petsc_arch}/include/finclude",
                                "#{prefix}/#{petsc_arch}/include/petsc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    pkgshare.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/examples/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match /^Norm of error .+, Iterations/, line, "Unexpected output format"
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end