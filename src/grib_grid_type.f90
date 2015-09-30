!-------------------------------------------------------------------------
! National Center for Atmospheric Research
! Research Applications Laboratory
!-------------------------------------------------------------------------

subroutine grib_grid_type(len1,fileIn,gridType,error)

  !DESCRIPTION:
  !  Subroutine that opens GRIB file and determines grid type based
  !  on first message (variable). Arguments are as follows:
  !  len1 - Length of character string fileIn. This is needed to properly
  !         read in character strings.
  !  fileIn - Character string of GRIB file name to be read.
  !  gridType - Character string out of grid type. Common values include:
  !             regular_ll, mercator, lambert, polar_stereographic, UTM,
  !             rotated_ll, regular_gg
  !  error - Error value out. 0 for success, greater than 0 for error.

  !AUTHOR:
  ! Logan Karsten
  ! National Center for Atmospheric Research
  ! Research Applications Laboratory
  ! 303-497-2693
  ! karsten@ucar.edu
 
  !USES:
  use grib_api

  implicit none

  !ARGUMENTS:
  integer, intent(in)          :: len1
  character(len1), intent(in)  :: fileIn
  character(30), intent(inout) :: gridType
  integer, intent(inout)       :: error

  !LOCAL VARIABLES:
  integer :: iret, ftn, nvars, igrib
  logical :: file_exists

  !Inquire for file existence
  inquire(file=trim(fileIn),exist=file_exists)

  if(file_exists) then
    !Open GRIB file
    call grib_open_file(ftn,trim(fileIn),'r',iret)
    error = iret
  else
    error = 1
  endif

  !Pull the first message (variable) as we are only interested in grid type information
  call grib_count_in_file(ftn,nvars,iret)
  if(nvars .le. 0) then
    error = 1
  else
    !Pull grid type from first message
    call grib_new_from_file(ftn,igrib,iret)
    error = iret

    call grib_get(igrib,'gridType',gridType,iret)
    error = iret
    gridType = trim(gridType)
  endif

  !Close GRIB file
  call grib_close_file(ftn,iret)
  error = iret

end subroutine grib_grid_type
