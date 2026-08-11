void M_SM_SEARCH_INVERSE_FVG()
{
   if(M_SearchFVG(stGVL.stFVG, stGVL.eCurrentDirection, nCandlesLookbackFVG))
   {
      stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
      return;
   }

   M_LogWarning("No FVG to inverse found in last " + IntegerToString(MathMin(nCandlesLookbackFVG, 97)) + " Candles!");
   M_LogWarning("Wait until a IFVG is formed in HTF FVG");
   if(bSearchFVGWithinHTF_FVG)
   {
      stGVL.bWaitForNewCurrBar = true; // Otherwise we would directly jump to reset on the next tick
      stGVL.eStateMachine = SM_WAIT_HTF_FVG_EXIT;
   }
   else
   {
      stGVL.eStateMachine = SM_RESET;
   }
}
