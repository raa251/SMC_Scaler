void M_SM_IN_TRADE()
{
   if(PositionsTotal() > 0) // Open Position
   {
      if(!stGVL.bTPChecked)
      {
         M_RecalculateTP();
         stGVL.bTPChecked = true;
      }
      
      if(stGVL.eCurrentDirection == DIR_LONG)
      {
         if(stGVL.bRunnerPosition_CheckClose)
         {
            M_CloseRunner(M_EMACloseBuy());
            
            M_CheckRunnerToTP1();
         }
         else if(stGVL.Candle[0].high > stGVL.Entry + (stGVL.TakeProfit - stGVL.Entry) * (nMoveBeAtProfit / 100) && nMoveBeAtProfit != 0 && !stGVL.MovedBE)
         {
            stGVL.MovedBE = M_AllSLToEntry(); // Move all SL to entry when reached a certain amount of profit
            
            if(bRunnerPosition)
            {
               stGVL.bRunnerPosition_CheckClose = true;
            }
         }
      }
      else if(stGVL.eCurrentDirection == DIR_SHORT)
      {
         if(stGVL.bRunnerPosition_CheckClose)
         {
            M_CloseRunner(M_EMACloseSell());
            
            M_CheckRunnerToTP1();
         }
         else if(stGVL.Candle[0].low < stGVL.Entry - (stGVL.Entry - stGVL.TakeProfit) * (nMoveBeAtProfit / 100) && nMoveBeAtProfit != 0 && !stGVL.MovedBE)
         {
            stGVL.MovedBE = M_AllSLToEntry(); // Move all SL to entry when reached a certain amount of profit
            // Check to close runner position as soon tp1 hit
            if(bRunnerPosition)
            {
               stGVL.bRunnerPosition_CheckClose = true;
            }
         }
      }
   }
   else
   {
      M_LogInfo("Trade closed");
      stGVL.eStateMachine = SM_RESET;
   }
}