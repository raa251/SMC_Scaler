void M_SM_WAIT_FVG_REACHED()
{
   int FVGCreatedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGCreated_Time_HTF);
   if(FVGCreatedIndex > nMaxCandlesToReachFVG || (nMaxCandlesToReachFVG < 0 || nMaxCandlesToReachFVG > 100))
   {
      M_LogWarning("Abort because the FVG got not reached within " + IntegerToString(nMaxCandlesToReachFVG) + ", Index=" + IntegerToString(FVGCreatedIndex));
      stGVL.eStateMachine = SM_RESET;
      return;
   }
   else if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(stGVL.Candle[0].low < stGVL.LastFVGTop_HTF) // FVG reached
      {
         stGVL.dtFVGReached_Time_HTF = stGVL.dtCurrentTime;
         stGVL.eStateMachine = SM_SEARCH_INVERSE_FVG;
      }
   }
   else if(stGVL.eCurrentDirection == DIR_SHORT)
   {
      if(stGVL.Candle[0].high > stGVL.LastFVGBottom_HTF) // FVG reached
      {
         stGVL.dtFVGReached_Time_HTF = stGVL.dtCurrentTime;
         stGVL.eStateMachine = SM_SEARCH_INVERSE_FVG;
      }
   }
}