/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#ifndef CAVITYPRESSUREPPACTION_H
#define CAVITYPRESSUREPPACTION_H

#include "Action.h"
#include "MooseTypes.h"

class CavityPressurePPAction: public Action
{
public:
  CavityPressurePPAction(InputParameters params);

  virtual void act();

};

template<>
InputParameters validParams<CavityPressurePPAction>();


#endif // CAVITYPRESSUREPPACTION_H
