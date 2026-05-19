#include "M_SM_IN_TRADE.mqh"
#include "M_SM_RESET.mqh"
#include "M_SM_WAIT_FOR_START.mqh"

void M_StateMachine()
{
   switch(stGVL.eStateMachine)
   {
      case SM_WAIT_FOR_START:
         M_SM_WAIT_FOR_START();
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