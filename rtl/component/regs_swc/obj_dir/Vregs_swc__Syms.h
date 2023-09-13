// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VREGS_SWC__SYMS_H_
#define VERILATED_VREGS_SWC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vregs_swc.h"

// INCLUDE MODULE CLASSES
#include "Vregs_swc___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vregs_swc__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vregs_swc* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vregs_swc___024root            TOP;

    // CONSTRUCTORS
    Vregs_swc__Syms(VerilatedContext* contextp, const char* namep, Vregs_swc* modelp);
    ~Vregs_swc__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
