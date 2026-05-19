void M_SM_IN_TRADE()
{
   if(PositionsTotal() > 0) // Open Position
   {
      ;
   }
   else
   {
      M_LogInfo("Trade closed");
      stGVL.eStateMachine = SM_RESET;
   }
}