CDF      
      
len_string     !   len_line   Q   four      	time_step          len_name   !   num_dim       	num_nodes      	   num_elem      
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_side_ss1      
num_df_ss1        num_side_ss2      
num_df_ss2        num_side_ss3      
num_df_ss3        num_side_ss4      
num_df_ss4        num_nod_ns1       num_nod_ns2       num_nod_ns3       num_nod_ns4       num_nod_var       num_info   �   num_glo_var             api_version       @��H   version       @��H   floating_point_word_size            	file_size               title         
out_0000.e     maximum_name_length                 $   
time_whole                        V�   	eb_status                         	t   eb_prop1               name      ID          	x   	ns_status         	                	|   ns_prop1      	         name      ID          	�   	ss_status         
                	�   ss_prop1      
         name      ID          	�   coordx                      H  	�   coordy                      H  
   eb_names                       $  
L   ns_names      	                 �  
p   ss_names      
                 �  
�   
coor_names                         D  x   connect1                  	elem_type         QUAD4         @  �   elem_num_map                      �   elem_ss1                         side_ss1                         dist_fact_ss1                             elem_ss2                      <   side_ss2                      D   dist_fact_ss2                          L   elem_ss3                      l   side_ss3                      t   dist_fact_ss3                          |   elem_ss4                      �   side_ss4                      �   dist_fact_ss4                          �   node_ns1                      �   node_ns2                      �   node_ns3                      �   node_ns4                      �   vals_nod_var1                          H  V�   name_nod_var                       $  �   info_records                      Ih      name_glo_var                       d  V�   vals_glo_var                         W<                                                                 ?�      ?�              ?�      ?�      ?�              ?�                      ?�      ?�              ?�      ?�      ?�      ?�                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                          	         	u                                   ####################                                                             # Created by MOOSE #                                                             ####################                                                             ### Command Line Arguments ###                                                   -i                                                                               2d_diffusion_dg_test.i                                                                                                                                            ### Input File ###                                                                                                                                                                                                                                 [Mesh]                                                                             file                           = '(no file supplied)'                            nemesis                        = 0                                               patch_size                     = 40                                              skip_partitioning              = 0                                               uniform_refine                 = 0                                                                                                                                [./Generation]                                                                     dim                          = 2                                                 elem_type                    = QUAD4                                             nx                           = 2                                                 ny                           = 2                                                 nz                           = 1                                                 xmax                         = 1                                                 xmin                         = 0                                                 ymax                         = 1                                                 ymin                         = 0                                                 zmax                         = 1                                                 zmin                         = 0                                               [../]                                                                                                                                                           [Mesh]                                                                             second_order                   = 0                                             []                                                                                                                                                                [Functions]                                                                        [./forcing_fn]                                                                     type                         = ParsedFunction                                    execute_on                   = residual                                          vals                         =                                                   value                        = 2*pow(e,-x-(y*y))*(1-2*y*y)                       vars                         =                                                 [../]                                                                                                                                                             [./exact_fn]                                                                       type                         = ParsedGradFunction                                execute_on                   = residual                                          grad_x                       = -pow(e,-x-(y*y))                                  grad_y                       = -2*y*pow(e,-x-(y*y))                              grad_z                       = 0                                                 vals                         =                                                   value                        = pow(e,-x-(y*y))                                   vars                         =                                                 [../]                                                                          []                                                                                                                                                                [Variables]                                                                        [./u]                                                                              [./InitialCondition]                                                               type                       = ConstantIC                                          execute_on                 = residual                                            value                      = 1                                                 [../]                                                                                                                                                           [./u]                                                                              family                       = MONOMIAL                                          initial_condition            = 0                                                 order                        = FIRST                                             scaling                      = 1                                                 initial_from_file_timestep   = 2                                               [../]                                                                          []                                                                                                                                                                [Kernels]                                                                          [./diff]                                                                           type                         = Diffusion                                         execute_on                   = residual                                          start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = u                                               [../]                                                                                                                                                             [./abs]                                                                            type                         = Reaction                                          execute_on                   = residual                                          start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = u                                               [../]                                                                                                                                                             [./forcing]                                                                        type                         = UserForcingFunction                               execute_on                   = residual                                          function                     = forcing_fn                                        start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = u                                               [../]                                                                          []                                                                                                                                                                [BCs]                                                                              [./all]                                                                            type                         = DGFunctionDiffusionDirichletBC                    boundary                     = '0 1 2 3'                                         epsilon                      = -1                                                execute_on                   = residual                                          function                     = exact_fn                                          sigma                        = 6                                                 value                        = 0                                                 variable                     = u                                               [../]                                                                          []                                                                                                                                                                [Materials]                                                                        [./empty]                                                                          type                         = EmptyMaterial                                     block                        = 0                                                 execute_on                   = residual                                        [../]                                                                          []                                                                                                                                                                [Postprocessors]                                                                   [./l2_err]                                                                         type                         = ElementL2Error                                    block                        = 255                                               execute_on                   = residual                                          function                     = exact_fn                                          output                       = 1                                                 variable                     = u                                               [../]                                                                                                                                                             [./dofs]                                                                           type                         = PrintDOFs                                         execute_on                   = residual                                          output                       = 1                                               [../]                                                                                                                                                             [./h]                                                                              type                         = AverageElementSize                                block                        = 255                                               execute_on                   = residual                                          output                       = 1                                                 variable                     = u                                               [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      l_abs_step_tol                 = -1                                              l_max_its                      = 10000                                           l_tol                          = 1e-05                                           nl_abs_step_tol                = 1e-50                                           nl_abs_tol                     = 1e-50                                           nl_max_funcs                   = 10000                                           nl_max_its                     = 50                                              nl_rel_step_tol                = 1e-50                                           nl_rel_tol                     = 1e-10                                           no_fe_reinit                   = 0                                               petsc_options                  = -snes_mf_operator                               scheme                         = backward-euler                                  type                           = Steady                                          execute_on                     = residual                                      []                                                                                                                                                                [Executioner]                                                                      [./Adaptivity]                                                                     coarsen_fraction             = 0                                                 error_estimator              = KellyErrorEstimator                               initial_adaptivity           = 0                                                 max_h_level                  = 8                                                 print_changed_info           = 0                                                 refine_fraction              = 1                                                 start_time                   = -1.79769e+308                                     steps                        = 2                                                 stop_time                    = 1.79769e+308                                    [../]                                                                          []                                                                                                                                                                [Output]                                                                           exodus                         = 1                                               file_base                      = out                                             gmv                            = 0                                               gnuplot_format                 = ps                                              interval                       = 1                                               iteration_plot_start_time      = 1.79769e+308                                    nemesis                        = 0                                               output_displaced               = 0                                               output_initial                 = 1                                               perf_log                       = 0                                               postprocessor_csv              = 1                                               postprocessor_ensight          = 0                                               postprocessor_gnuplot          = 0                                               postprocessor_screen           = 1                                               print_linear_residuals         = 0                                               print_out_info                 = 0                                               show_setup_log_early           = 0                                               tecplot                        = 0                                               tecplot_binary                 = 0                                               xda                            = 0                                             []                                                                                                                                                                [setup_dampers]                                                                  []                                                                                                                                                                [setup_quadrature]                                                                 order                          = AUTO                                            type                           = GAUSS                                         []                                                                                                                                                                [no_action]                                                                      []                                                                                                                                                                [init_problem]                                                                   []                                                                                                                                                                [copy_nodal_vars]                                                                  initial_from_file_timestep     = 2                                             []                                                                                                                                                                [check_integrity]                                                                []                                                                                                                                                                [DGKernels]                                                                        [./dg_diff]                                                                        type                         = DGDiffusion                                       epsilon                      = -1                                                execute_on                   = residual                                          sigma                        = 6                                                 variable                     = u                                               [../]                                                                          []                                                                                                                                                                [no_action]                                                                      dofs                             h                                l2_err                                    ?�      ?�      ?�      ?�      ?�      ?�      ?�      ?�      ?�      @(      ?栞f;�?���,w?�      ?�1�Cd?�$�f�?�_���a?�k����?�1�~�b?҉V%4�B?�q���O�?ً#�r!X?�h�.�d�@(      ?栞f;�?��5���