// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vapbm_swc_tb.h for the primary calling header

#include "verilated.h"

#include "Vapbm_swc_tb__Syms.h"
#include "Vapbm_swc_tb__Syms.h"
#include "Vapbm_swc_tb___024root.h"

VL_INLINE_OPT VlCoroutine Vapbm_swc_tb___024root___eval_initial__TOP__0(Vapbm_swc_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vapbm_swc_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vapbm_swc_tb___024root___eval_initial__TOP__0\n"); );
    // Init
    VlWide<4>/*127:0*/ __Vtemp_h1574a95c__0;
    // Body
    __Vtemp_h1574a95c__0[0U] = 0x2e766364U;
    __Vtemp_h1574a95c__0[1U] = 0x635f7462U;
    __Vtemp_h1574a95c__0[2U] = 0x6d5f7377U;
    __Vtemp_h1574a95c__0[3U] = 0x617062U;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(4, __Vtemp_h1574a95c__0));
    vlSymsp->_traceDumpOpen();
    co_await vlSelf->__VdlySched.delay(0x3e8ULL, nullptr, 
                                       "apbm_swc_tb.v", 
                                       86);
    VL_FINISH_MT("apbm_swc_tb.v", 86, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vapbm_swc_tb___024root___dump_triggers__act(Vapbm_swc_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vapbm_swc_tb___024root___eval_triggers__act(Vapbm_swc_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vapbm_swc_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vapbm_swc_tb___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->apbm_swc_tb__DOT__pclk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__apbm_swc_tb__DOT__pclk__0))));
    vlSelf->__VactTriggered.set(1U, vlSelf->__VdlySched.awaitingCurrentTime());
    vlSelf->__Vtrigprevexpr___TOP__apbm_swc_tb__DOT__pclk__0 
        = vlSelf->apbm_swc_tb__DOT__pclk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vapbm_swc_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
