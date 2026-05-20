#include "M_SM_IN_TRADE.mqh"
#include "M_SM_RESET.mqh"
#include "M_SM_WAIT_FOR_START.mqh"
#include "M_SM_WAIT_FVG_REACHED.mqh"
#include "M_SM_SEARCH_INVERSE_FVG.mqh"
#include "M_SM_WAIT_FVG_INVERSED.mqh"

void M_StateMachine()
{
   switch(stGVL.eStateMachine)
   {
      case SM_WAIT_FOR_START:
         M_SM_WAIT_FOR_START();
         break;
         
      case SM_WAIT_FVG_REACHED:
         M_SM_WAIT_FVG_REACHED();
         break;
         
      case SM_SEARCH_INVERSE_FVG:
         M_SM_SEARCH_INVERSE_FVG();
         break;
         
      case SM_WAIT_FVG_INVERSED:
         M_SM_WAIT_FVG_INVERSED();
         break;
         
      case SM_IN_TRADE:
         M_SM_IN_TRADE();
         break;
         
      case SM_RESET:
         M_SM_RESET();
         break;
   }
   
   if(stGVL.eStateMachine_Last != stGVL.eStateMachine)
   {
      M_LogInfo("Statemachine changed to " + EnumToString(stGVL.eStateMachine));
      stGVL.eStateMachine_Last = stGVL.eStateMachine;
   }
}