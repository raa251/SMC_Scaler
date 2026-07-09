void M_StructureTrendCTF() // Must be called on every new bar
{
   double fResult;
   
   fResult = M_SearchNewHigh(stGVL.Candle);
   if(fResult != 0)
   {
      stGVL.fLastHigh_CTF = fResult;
      datetime dtArrowTime = stGVL.Candle[nFreeCandlesForExtrema_Right + 1].time; 
      ObjectCreate(0, "High_" + IntegerToString(dtArrowTime), OBJ_ARROW, 0, dtArrowTime, fResult + 2);
      ObjectSetInteger(0, "High_" + IntegerToString(dtArrowTime), OBJPROP_ARROWCODE, 234); // Wingdings
      ObjectSetInteger(0, "High_" + IntegerToString(dtArrowTime), OBJPROP_COLOR, clrLightPink);
      ObjectSetInteger(0, "High_" + IntegerToString(dtArrowTime), OBJPROP_WIDTH, 7);
   }
   
   fResult = M_SearchNewLow(stGVL.Candle);
   if(fResult != 0)
   {
      stGVL.fLastLow_CTF = fResult;
      datetime dtArrowTime = stGVL.Candle[nFreeCandlesForExtrema_Right + 1].time; 
      ObjectCreate(0, "Low_" + IntegerToString(dtArrowTime), OBJ_ARROW, 0, dtArrowTime, fResult - 1);
      ObjectSetInteger(0, "Low_" + IntegerToString(dtArrowTime), OBJPROP_ARROWCODE, 233);
      ObjectSetInteger(0, "Low_" + IntegerToString(dtArrowTime), OBJPROP_COLOR, clrDeepSkyBlue);
      ObjectSetInteger(0, "Low_" + IntegerToString(dtArrowTime), OBJPROP_WIDTH, 7);
   }
   
   if(stGVL.fLastHigh_CTF == 0 || stGVL.fLastLow_CTF == 0)
   {
      return; // No high/low found yet
   }
   
   if(stGVL.Candle[1].close > stGVL.fLastHigh_CTF)
   {
      stGVL.eTrendStructure_CTF = DIR_LONG;
   }
   
   if(stGVL.Candle[1].close < stGVL.fLastLow_CTF)
   {
      stGVL.eTrendStructure_CTF = DIR_SHORT;
   }
}