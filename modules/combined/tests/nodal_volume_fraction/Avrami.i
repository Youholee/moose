
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  nz = 0

  xmax = 40
  ymax = 40
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  active = 'u'

  [./u]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SmoothCircleIC
      x1 = 20
      y1 = 20
      radius = 10
      int_width = 1
      invalue = 1
      outvalue = 0
    [../]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]

  [./dot]
    type = TimeDerivative
    variable = u
  [../]
[]

[Postprocessors]
  [./volume_fraction]
    type = NodalVolumeFraction
    variable = u
    threshold = 0.9
    execute_on = timestep
    Avrami_file = Avrami.csv
    mesh_volume = Volume
    equil_fraction = 0.5
  [../]

  [./Volume]
    type = VolumePostprocessor
    execute_on = initial
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.1
  num_steps = 2
[]

[Output]
  file_base = Avrami
  interval = 1
  exodus = true
  perf_log = true
[]
 
