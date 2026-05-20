void M_SM_WAIT_FVG_REACHED()
{
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(stGVL.Candle[0].low < stGVL.LastFVGTop) // FVG reached
      {
         stGVL.eStateMachine = SM_WAIT_INVERSE_FVG;
      }
   }
   else if(stGVL.eCurrentDirection == DIR_SHORT)
   {
      if(stGVL.Candle[0].high > stGVL.LastFVGBottom) // FVG reached
      {
         stGVL.eStateMachine = SM_WAIT_INVERSE_FVG;
      }
   }
}