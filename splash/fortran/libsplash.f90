!-----------------------------------------------------------------
!
!  This file is (or was) part of SPLASH, a visualisation tool
!  for Smoothed Particle Hydrodynamics written by Daniel Price:
!
!  http://users.monash.edu.au/~dprice/splash
!
!  SPLASH comes with ABSOLUTELY NO WARRANTY.
!  This is free software; and you are welcome to redistribute
!  it under the terms of the GNU General Public License
!  (see LICENSE file for details) and the provision that
!  this notice remains intact. If you modify this file, please
!  note section 2a) of the GPLv2 states that:
!
!  a) You must cause the modified files to carry prominent notices
!     stating that you changed the files and the date of any change.
!
!  Copyright (C) 2005-2019 Daniel Price. All rights reserved.
!  Contact: daniel.price@monash.edu
!
!-----------------------------------------------------------------

!-------------------------------------------------------------------------
! module providing library version of splash interpolation routines
! specifies c interfaces to corresponding Fortran subroutines
!-------------------------------------------------------------------------
module libsplash

  use projections3D,         only: interpolate3d_projection_f => interpolate3d_projection, &
                                   interpolate3d_proj_vec_f => interpolate3d_proj_vec

  use xsections3D,           only: interpolate3d_fastxsec_f => interpolate3d_fastxsec,   &
                                   interpolate3d_xsec_vec_f => interpolate3d_xsec_vec

  use interpolate3D_opacity, only: interp3d_proj_opacity_f => interp3d_proj_opacity

  use iso_c_binding,         only: c_float, c_int, c_bool

  implicit none

contains
!-------------------------------------------------------------------------
! 3D projection (column density)
!-------------------------------------------------------------------------
subroutine interpolate3d_projection(                                           &
  x, y, z, hh, weight, dat, itype, npart, xmin, ymin, datsmooth, npixx, npixy, &
  pixwidthx, pixwidthy, normalise, zobserver, dscreen, useaccelerate           &
  ) bind(c)

  real(c_float),   intent(in)  :: x(npart),      &
                                  y(npart),      &
                                  z(npart),      &
                                  hh(npart),     &
                                  weight(npart), &
                                  dat(npart),    &
                                  xmin,          &
                                  ymin,          &
                                  pixwidthx,     &
                                  pixwidthy,     &
                                  zobserver,     &
                                  dscreen
  integer(c_int),  intent(in)  :: npart,         &
                                  npixx,         &
                                  npixy,         &
                                  itype(npart)
  logical(c_bool), intent(in)  :: normalise,     &
                                  useaccelerate
  real(c_float),   intent(out) :: datsmooth(npixx,npixy)

  logical :: normalise_f, &
             useaccelerate_f

  normalise_f     = normalise
  useaccelerate_f = useaccelerate

  call interpolate3d_projection_f(                                        &
    x, y, z, hh, weight, dat, itype, npart, xmin, ymin, datsmooth, npixx, &
    npixy, pixwidthx, pixwidthy, normalise_f, zobserver, dscreen,         &
    useaccelerate_f)

end subroutine interpolate3d_projection

!-------------------------------------------------------------------------
! 3D projection of vectors
!-------------------------------------------------------------------------
subroutine interpolate3d_proj_vec(                                       &
  x, y, z, hh, weight, vecx, vecy, itype, npart, xmin, ymin, vecsmoothx, &
  vecsmoothy, npixx, npixy, pixwidthx, pixwidthy, normalise, zobserver,  &
  dscreen                                                                &
  ) bind(c)

  integer(c_int),  intent(in)  :: npart,                   &
                                  npixx,                   &
                                  npixy,                   &
                                  itype(npart)
  real(c_float),   intent(in)  :: x(npart),                &
                                  y(npart),                &
                                  z(npart),                &
                                  hh(npart),               &
                                  weight(npart),           &
                                  vecx(npart),             &
                                  vecy(npart),             &
                                  xmin,                    &
                                  ymin,                    &
                                  pixwidthx,               &
                                  pixwidthy,               &
                                  zobserver,               &
                                  dscreen
  logical(c_bool), intent(in)  :: normalise
  real(c_float),   intent(out) :: vecsmoothx(npixx,npixy), &
                                  vecsmoothy(npixx,npixy)

  logical :: normalise_f

  normalise_f = normalise

  call interpolate3d_proj_vec_f(                                            &
    x, y, z, hh, weight, vecx, vecy, itype, npart, xmin, ymin, vecsmoothx,  &
    vecsmoothy, npixx, npixy, pixwidthx, pixwidthy, normalise_f, zobserver, &
    dscreen)

end subroutine interpolate3d_proj_vec

!-------------------------------------------------------------------------
! cross sections of 3D data
!-------------------------------------------------------------------------
subroutine interpolate3d_fastxsec(                                       &
  x, y, z, hh, weight, dat, itype, npart, xmin, ymin, zslice, datsmooth, &
  npixx, npixy, pixwidthx, pixwidthy, normalise                          &
  ) bind(c)

  integer(c_int),   intent(in) :: npart,         &
                                  npixx,         &
                                  npixy,         &
                                  itype(npart)
  real(c_float),   intent(in)  :: x(npart),      &
                                  y(npart),      &
                                  z(npart),      &
                                  hh(npart),     &
                                  weight(npart), &
                                  dat(npart),    &
                                  xmin,          &
                                  ymin,          &
                                  pixwidthx,     &
                                  pixwidthy,     &
                                  zslice
  logical(c_bool), intent(in)  :: normalise
  real(c_float),   intent(out) :: datsmooth(npixx,npixy)

  logical :: normalise_f

  normalise_f = normalise

  call interpolate3d_fastxsec_f(                                           &
    x, y, z, hh, weight, dat, itype, npart, xmin, ymin, zslice, datsmooth, &
    npixx, npixy, pixwidthx, pixwidthy, normalise_f)

end subroutine interpolate3d_fastxsec

!-------------------------------------------------------------------------
! cross sections of 3D vector data
!-------------------------------------------------------------------------
subroutine interpolate3d_xsec_vec(                                       &
  x, y, z, hh, weight, vecx, vecy, itype, npart, xmin, ymin, zslice,     &
  vecsmoothx, vecsmoothy, npixx, npixy, pixwidthx, pixwidthy, normalise  &
  ) bind(c)

  integer(c_int),  intent(in)  :: npart,                   &
                                  npixx,                   &
                                  npixy,                   &
                                  itype(npart)
  real(c_float),   intent(in)  :: x(npart),                &
                                  y(npart),                &
                                  z(npart),                &
                                  hh(npart),               &
                                  weight(npart),           &
                                  vecx(npart),             &
                                  vecy(npart),             &
                                  xmin,                    &
                                  ymin,                    &
                                  pixwidthx,               &
                                  pixwidthy,               &
                                  zslice
  logical(c_bool), intent(in)  :: normalise
  real(c_float),   intent(out) :: vecsmoothx(npixx,npixy), &
                                  vecsmoothy(npixx,npixy)

  logical :: normalise_f

  normalise_f = normalise

  call interpolate3d_xsec_vec_f(                                             &
    x, y, z, hh, weight, vecx, vecy, itype, npart, xmin, ymin, zslice,       &
    vecsmoothx, vecsmoothy, npixx, npixy, pixwidthx, pixwidthy, normalise_f)

end subroutine interpolate3d_xsec_vec

!-------------------------------------------------------------------------
! opacity rendering of 3D data
!-------------------------------------------------------------------------
subroutine interp3d_proj_opacity(                                           &
  x, y, z, pmass, npmass, hh, weight, dat, zorig, itype, npart, xmin, ymin, &
  datsmooth, brightness, npixx, npixy, pixwidth, zobserver,                 &
  dscreenfromobserver, rkappa, zcut                                         &
  ) bind(c)

  integer(c_int), intent(in)  :: npart,                  &
                                 npixx,                  &
                                 npixy,                  &
                                 npmass,                 &
                                 itype(npart)
  real(c_float),  intent(in)  :: x(npart),               &
                                 y(npart),               &
                                 z(npart),               &
                                 hh(npart),              &
                                 weight(npart),          &
                                 dat(npart),             &
                                 zorig(npart),           &
                                 pmass(npmass),          &
                                 xmin,                   &
                                 ymin,                   &
                                 pixwidth,               &
                                 zobserver,              &
                                 dscreenfromobserver,    &
                                 zcut,                   &
                                 rkappa
  real(c_float),  intent(out) :: datsmooth(npixx,npixy), &
                                 brightness(npixx,npixy)

  call interp3d_proj_opacity_f(x, y, z, pmass, npmass, hh, weight, dat, zorig, &
    itype, npart, xmin, ymin, datsmooth, brightness, npixx, npixy, pixwidth,   &
    zobserver, dscreenfromobserver, rkappa, zcut)

end subroutine interp3d_proj_opacity

end module libsplash
