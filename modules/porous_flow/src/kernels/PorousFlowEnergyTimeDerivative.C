/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#include "PorousFlowEnergyTimeDerivative.h"

template<>
InputParameters validParams<PorousFlowEnergyTimeDerivative>()
{
  InputParameters params = validParams<TimeKernel>();
  params.addRequiredParam<UserObjectName>("PorousFlowDictator", "The UserObject that holds the list of Porous-Flow variable names.");
  params.addClassDescription("derivative of heat-energy-density wrt time");
  return params;
}

PorousFlowEnergyTimeDerivative::PorousFlowEnergyTimeDerivative(const InputParameters & parameters) :
    TimeKernel(parameters),
    _dictator(getUserObject<PorousFlowDictator>("PorousFlowDictator")),
    _var_is_porflow_var(_dictator.isPorousFlowVariable(_var.number())),
    _num_phases(_dictator.numPhases()),
    _fluid_present(_num_phases > 0),
    _porosity(getMaterialProperty<Real>("PorousFlow_porosity_nodal")),
    _porosity_old(getMaterialPropertyOld<Real>("PorousFlow_porosity_nodal")),
    _dporosity_dvar(getMaterialProperty<std::vector<Real> >("dPorousFlow_porosity_nodal_dvar")),
    _dporosity_dgradvar(getMaterialProperty<std::vector<RealGradient> >("dPorousFlow_porosity_nodal_dgradvar")),
    _rock_energy_nodal(getMaterialProperty<Real>("PorousFlow_matrix_internal_energy_nodal")),
    _rock_energy_nodal_old(getMaterialPropertyOld<Real>("PorousFlow_matrix_internal_energy_nodal")),
    _drock_energy_nodal_dvar(getMaterialProperty<std::vector<Real> >("dPorousFlow_matrix_internal_energy_nodal_dvar")),
    _fluid_density(_fluid_present ? &getMaterialProperty<std::vector<Real> >("PorousFlow_fluid_phase_density") : NULL),
    _fluid_density_old(_fluid_present ? &getMaterialPropertyOld<std::vector<Real> >("PorousFlow_fluid_phase_density") : NULL),
    _dfluid_density_dvar(_fluid_present ? &getMaterialProperty<std::vector<std::vector<Real> > >("dPorousFlow_fluid_phase_density_dvar") : NULL),
    _fluid_saturation_nodal(_fluid_present ? &getMaterialProperty<std::vector<Real> >("PorousFlow_saturation_nodal") : NULL),
    _fluid_saturation_nodal_old(_fluid_present ? &getMaterialPropertyOld<std::vector<Real> >("PorousFlow_saturation_nodal") : NULL),
    _dfluid_saturation_nodal_dvar(_fluid_present ? &getMaterialProperty<std::vector<std::vector<Real> > >("dPorousFlow_saturation_nodal_dvar") : NULL),
    _energy_nodal(_fluid_present ? &getMaterialProperty<std::vector<Real> >("PorousFlow_fluid_phase_internal_energy_nodal") : NULL),
    _energy_nodal_old(_fluid_present ? &getMaterialPropertyOld<std::vector<Real> >("PorousFlow_fluid_phase_internal_energy_nodal") : NULL),
    _denergy_nodal_dvar(_fluid_present ? &getMaterialProperty<std::vector<std::vector<Real> > >("dPorousFlow_fluid_phase_internal_energy_nodal_dvar") : NULL)
{
}

Real
PorousFlowEnergyTimeDerivative::computeQpResidual()
{
  Real energy = (1.0 - _porosity[_i]) * _rock_energy_nodal[_i];
  Real energy_old = (1.0 - _porosity_old[_i]) * _rock_energy_nodal_old[_i];
  for (unsigned ph = 0; ph < _num_phases; ++ph)
  {
    energy += (*_fluid_density)[_i][ph] * (*_fluid_saturation_nodal)[_i][ph] * (*_energy_nodal)[_i][ph] * _porosity[_i];
    energy_old += (*_fluid_density_old)[_i][ph] * (*_fluid_saturation_nodal_old)[_i][ph] * (*_energy_nodal_old)[_i][ph] * _porosity_old[_i];
   }

  return _test[_i][_qp] * (energy - energy_old) / _dt;
}

Real
PorousFlowEnergyTimeDerivative::computeQpJacobian()
{
  /// If the variable is not a PorousFlow variable (very unusual), the diag Jacobian terms are 0
  if (!_var_is_porflow_var)
    return 0.0;
  return computeQpJac(_dictator.porousFlowVariableNum(_var.number()));
}

Real
PorousFlowEnergyTimeDerivative::computeQpOffDiagJacobian(unsigned int jvar)
{
  /// If the variable is not a PorousFlow variable, the OffDiag Jacobian terms are 0
  if (_dictator.notPorousFlowVariable(jvar))
    return 0.0;
  return computeQpJac(_dictator.porousFlowVariableNum(jvar));
}

Real
PorousFlowEnergyTimeDerivative::computeQpJac(unsigned int pvar)
{
  // porosity is dependent on variables that are lumped to the nodes,
  // but it can depend on the gradient
  // of variables, which are NOT lumped to the nodes, hence:
  Real denergy = - _dporosity_dgradvar[_i][pvar] * _grad_phi[_j][_i] * _rock_energy_nodal[_i];
  for (unsigned ph = 0; ph < _num_phases; ++ph)
    denergy += (*_fluid_density)[_i][ph] * (*_fluid_saturation_nodal)[_i][ph] * (*_energy_nodal)[_i][ph] * _dporosity_dgradvar[_i][pvar] * _grad_phi[_j][_i];

  if (_i != _j)
    return _test[_i][_qp] * denergy/_dt;

  /// As the fluid energy is lumped to the nodes, only non-zero terms are for _i==_j
  denergy += - _dporosity_dvar[_i][pvar] * _rock_energy_nodal[_i];
  denergy += (1.0 - _porosity[_i]) * _drock_energy_nodal_dvar[_i][pvar];
  for (unsigned ph = 0; ph < _num_phases; ++ph)
  {
    denergy += (*_dfluid_density_dvar)[_i][ph][pvar] * (*_fluid_saturation_nodal)[_i][ph] * (*_energy_nodal)[_i][ph] * _porosity[_i];
    denergy += (*_fluid_density)[_i][ph] * (*_dfluid_saturation_nodal_dvar)[_i][ph][pvar] * (*_energy_nodal)[_i][ph] * _porosity[_i];
    denergy += (*_fluid_density)[_i][ph] * (*_fluid_saturation_nodal)[_i][ph] * (*_denergy_nodal_dvar)[_i][ph][pvar] * _porosity[_i];
    denergy += (*_fluid_density)[_i][ph] * (*_fluid_saturation_nodal)[_i][ph] * (*_energy_nodal)[_i][ph] * _dporosity_dvar[_i][pvar];
  }
  return _test[_i][_qp] * denergy / _dt;
}
