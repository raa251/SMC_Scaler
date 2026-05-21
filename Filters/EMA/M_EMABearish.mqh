bool M_EMABearish(bool bLog)
{
   if(!bEMAActive)
   {
      return true;
   }
   
   if(stGVL.SmallEMABuffer[1] < stGVL.BigEMABuffer[1] - stGVL.fMinDiffEMA_Price)
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogWarning("Sell not allowed because of EMA, small=" + DoubleToString(stGVL.SmallEMABuffer[1]) + " big=" + DoubleToString(stGVL.BigEMABuffer[1]) + " minimum difference=" + DoubleToString(stGVL.fMinDiffEMA_Price));
      }
      return false;
   }
}