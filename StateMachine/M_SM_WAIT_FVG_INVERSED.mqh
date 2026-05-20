void M_SM_WAIT_FVG_INVERSED()
{
   // Long
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(stGVL.Candle[0].high <= stGVL.LastFVGTop) // FVG not inversed yet
      {
         return;
      }
      else if(!M_FiltersOK(true))
      {
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else
      {
         // Enter trade
         
         stGVL.eStateMachine = SM_IN_TRADE;
      }
   }
   // Short
   else if(stGVL.eCurrentDirection == DIR_SHORT)
   {
      if(stGVL.Candle[0].low >= stGVL.LastFVGBottom) // FVG not inversed yet
      {
         return;
      }
   }
}