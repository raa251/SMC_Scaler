bool M_EMABullish(bool bLog)
{   
   if(stGVL.SmallEMABuffer[1] > stGVL.BigEMABuffer[1] + stGVL.fMinDiffEMA_Price)
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogWarning("Buy not allowed because of EMA, small=" + DoubleToString(stGVL.SmallEMABuffer[1]) + " big=" + DoubleToString(stGVL.BigEMABuffer[0]));
      }
      return false;
   }
}