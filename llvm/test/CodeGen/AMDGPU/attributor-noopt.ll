; RUN: sed 's/CODE_OBJECT_VERSION/500/g' %s | opt -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -O2 | llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 | FileCheck -check-prefix=OPT %s
; RUN: sed 's/CODE_OBJECT_VERSION/400/g' %s | opt -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -O0 | llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 | FileCheck -check-prefix=NOOPT %s
; RUN: sed 's/CODE_OBJECT_VERSION/500/g' %s | opt -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -O0 | llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 | FileCheck -check-prefix=NOOPT %s

; Check that AMDGPUAttributor is not run with -O0.
; OPT: .amdhsa_user_sgpr_private_segment_buffer 1
; OPT: .amdhsa_user_sgpr_dispatch_ptr 0
; OPT: .amdhsa_user_sgpr_queue_ptr 0
; OPT: .amdhsa_user_sgpr_kernarg_segment_ptr 0
; OPT: .amdhsa_user_sgpr_dispatch_id 0
; OPT: .amdhsa_user_sgpr_flat_scratch_init 0
; OPT: .amdhsa_user_sgpr_private_segment_size 0
; OPT: .amdhsa_system_sgpr_private_segment_wavefront_offset 0
; OPT: .amdhsa_system_sgpr_workgroup_id_x 1
; OPT: .amdhsa_system_sgpr_workgroup_id_y 0
; OPT: .amdhsa_system_sgpr_workgroup_id_z 0
; OPT: .amdhsa_system_sgpr_workgroup_info 0
; OPT: .amdhsa_system_vgpr_workitem_id 0

; NOOPT: .amdhsa_user_sgpr_private_segment_buffer 1
; NOOPT: .amdhsa_user_sgpr_dispatch_ptr 1
; NOOPT: .amdhsa_user_sgpr_queue_ptr 1
; NOOPT: .amdhsa_user_sgpr_kernarg_segment_ptr 1
; NOOPT: .amdhsa_user_sgpr_dispatch_id 1
; NOOPT: .amdhsa_user_sgpr_flat_scratch_init 0
; NOOPT: .amdhsa_user_sgpr_private_segment_size 0
; NOOPT: .amdhsa_system_sgpr_private_segment_wavefront_offset 0
; NOOPT: .amdhsa_system_sgpr_workgroup_id_x 1
; NOOPT: .amdhsa_system_sgpr_workgroup_id_y 1
; NOOPT: .amdhsa_system_sgpr_workgroup_id_z 1
; NOOPT: .amdhsa_system_sgpr_workgroup_info 0
; NOOPT: .amdhsa_system_vgpr_workitem_id 2
define amdgpu_kernel void @foo() #0 {
  ret void
}

attributes #0 = { "amdgpu-no-flat-scratch-init" }

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"amdhsa_code_object_version", i32 CODE_OBJECT_VERSION}
