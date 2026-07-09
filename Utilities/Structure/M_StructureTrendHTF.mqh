void M_StructureTrendHTF() // Must be called on every new bar
{
   if(eTrendFilter != STRUCTURE)
   {
      return;
   }
   
   double fResult;
   
   fResult = M_SearchNewHigh(stGVL.CandleHigherTF);
   if(fResult != 0)
   {
      stGVL.fLastHigh_HTF = fResult;
   }
   
   fResult = M_SearchNewLow(stGVL.CandleHigherTF);
   if(fResult != 0)
   {
      stGVL.fLastLow_HTF = fResult;
   }
   
   if(stGVL.fLastHigh_HTF == 0 || stGVL.fLastLow_HTF == 0)
   {
      return; // No high/low found yet
   }
   
   if(stGVL.CandleHigherTF[1].close > stGVL.fLastHigh_HTF)
   {
      stGVL.eTrendStructure_HTF = DIR_LONG;
   }
   
   if(stGVL.CandleHigherTF[1].close < stGVL.fLastLow_HTF)
   {
      stGVL.eTrendStructure_HTF = DIR_SHORT;
   }
   
}