!!  dmrg-interface-utils: interface to the Maquis DMRG program for various
!!                        quantum-chemistry program packages.
!!  Copyright 2013-2018 Leon Freitag, Erik Hedegaard, Sebastian Keller,
!!                      Stefan Knecht, Yingjin Ma, Christopher Stein
!!                      and Markus Reiher
!!                      Laboratory for Physical Chemistry, ETH Zurich
!!  dmrg-interface-utils is free software: you can redistribute it and/or modify
!!  it under the terms of the GNU Lesser General Public License as published by
!!  the Free Software Foundation, either version 3 of the License, or
!!  (at your option) any later version.
!!
!!  dmrg-interface-utils is distributed in the hope that it will be useful,
!!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
!!  GNU Lesser General Public License for more details.
!!
!!  You should have received a copy of the GNU Lesser General Public License
!!  along with dmrg-interface-utils. If not, see <http://www.gnu.org/licenses/>.

module qcmaquis_interface_cfg

! stefan: DMRG interface variables

  implicit none

  type dmrg_par
       !! QCMaquis-specific settings
       integer              :: M                        = 0       ! number of renormalized states
       integer              :: num_sweeps               = 0       ! number of sweeps from the configuration file
       real*8               :: conv_thresh              = 1.0d-9  ! convergence threshold from the configuration file, reasonable default
       integer              :: L                        = 0       ! number of orbitals
       ! TODO: consider also sweep_bond_dimensions

       !! OpenMOLCAS project name & current directory
       character*256        :: project_name             = '' ! MOLCAS/QCMaquis project prefix
       character*512        :: currdir                  = '' ! MOLCAS current directory

      !! OpenMOLCAS wavefunction settings (possibly redundant)
      integer               :: nactel                   = 0  ! number of active electrons
      integer               :: ms2                      = 0  ! spin


  end type dmrg_par
  type (dmrg_par), save, public :: qcmaquis_param


  type qcm_warmup
    logical       :: doCIDEAS                   = .false.
    logical       :: doFiedler                  = .false.
  end type qcm_warmup
  type (qcm_warmup), save, public :: dmrg_warmup

!   type qcm_orb_ordering
!        character(len=1000) , allocatable :: fiedler_order(:)
!   end type qcm_orb_ordering
!   type (qcm_orb_ordering), save :: dmrg_orbital_ordering

  !> Threshold for QCMaquis, should be transfered from parent code (e.g. Molcas)
  double precision :: E_threshold               =  0.0d0

  type type_host_settings
       logical :: runs_parallel                =  .false.
       integer :: myrank                       =  0 ! rank of MPI process in host program
       integer :: nprocs                       =  1 ! number of MPI processes in host program
       character(len=7) :: dmrg_host_program   =  'molcas '
  end type type_host_settings
  type (type_host_settings), save, public :: dmrg_host_program_settings

  ! Symmetry multiplication table, once and for all
  Integer, dimension(8, 8), parameter :: multd2h = &
     reshape( (/1,2,3,4,5,6,7,8, &
                2,1,4,3,6,5,8,7, &
                3,4,1,2,7,8,5,6, &
                4,3,2,1,8,7,6,5, &
                5,6,7,8,1,2,3,4, &
                6,5,8,7,2,1,4,3, &
                7,8,5,6,3,4,1,2, &
                8,7,6,5,4,3,2,1/), (/8,8/))
  !> definition of "symmetry" data type
  type type_symmetry
       integer :: nirrep                        = 0
       integer :: multiplication_table(8,8) = multd2h
  end type type_symmetry
  type (type_symmetry), save :: dmrg_symmetry


  !> definition of DMRG parameter/input variables

  type type_input
       character(len=500), allocatable :: qcmaquis_input(:)
       integer                         :: nr_qcmaquis_input_lines = -1
  end type type_input
  type (type_input), save, public :: dmrg_input

  type type_dmrgfiles
       character(len=256), allocatable  :: qcmaquis_checkpoint_file(:)
  end type type_dmrgfiles
  type (type_dmrgfiles), save, public :: dmrg_file


  !> definition of "state" data type
  type type_state
       integer              :: irefsm        = 0
       integer              :: nactel        = 0
       integer              :: ms2           = 0
       integer              :: nroot         = 0
       integer              :: maxroot       = 0
       integer, allocatable :: iroot(:)
       real*8 , allocatable :: weight(:)
  end type type_state
  type (type_state), save :: dmrg_state

  !> definition of "orbital_space" data type
  type type_orbital_space
       integer              ::  nash(1:8)        = 0
       integer, allocatable :: initial_occ(:,:) ! in order to get the starting determinant for each state (Maquis)
  end type type_orbital_space
  type (type_orbital_space), save :: dmrg_orbital_space

  !> definition of "energy" data type
  type type_energy
       real*8 :: rdm                   = 0.0d0
       real*8 :: dmrg                  = 0.0d0
       real*8 , allocatable :: dmrg_state_specific(:)
       real*8 , allocatable :: max_truncW(:)
       real*8 , allocatable :: max_truncW_old(:)
       integer, allocatable :: num_sweeps(:)
       integer, allocatable :: num_sweeps_old(:)
  end type type_energy
  type (type_energy), save :: dmrg_energy

  !> DMRG-RASSI parameters
  type external_PARAMETER
       integer              :: nalpha                   = 0       ! number of alpha electrons
       integer              :: nbeta                    = 0       ! number of beta electrons
       integer              :: irrep                    = 0       ! spatial irrep
       integer              :: maxroot                  = 0       ! number of states in RASSCF run
       ! TODO: consider also sweep_bond_dimensions
       logical              :: MPSrotated               = .false. ! MPSs of JOB1 and JOB2 were rotated
  end type external_PARAMETER
  type (external_PARAMETER), save, public :: dmrg_external

end module qcmaquis_interface_cfg

