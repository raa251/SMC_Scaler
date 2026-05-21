bool M_EMA_INIT()
{
   if(bEMAActive)
   {
      stGVL.nSmallEMAHandle = iMA(_Symbol, eEMATimeframe, nSmallEMALength, 0, MODE_EMA, PRICE_CLOSE);
      stGVL.nBigEMAHandle = iMA(_Symbol, eEMATimeframe, nBigEMALength, 0, MODE_EMA, PRICE_CLOSE);
      if(stGVL.nSmallEMAHandle == INVALID_HANDLE)
      {
         M_LogError("Could not create stGVL.nSmallEMAHandle");
      }
      else if(stGVL.nBigEMAHandle == INVALID_HANDLE)
      {
         M_LogError("Could not create stGVL.nBigEMAHandle");
      }
   }
   
   if(bRunnerPosition)
   {
      stGVL.nSmallEMAHandle_CurrTF = iMA(_Symbol, PERIOD_CURRENT, nSmallEMALength, 0, MODE_EMA, PRICE_CLOSE);
      stGVL.nBigEMAHandle_CurrTF = iMA(_Symbol, PERIOD_CURRENT, nBigEMALength, 0, MODE_EMA, PRICE_CLOSE);
      if(stGVL.nSmallEMAHandle_CurrTF == INVALID_HANDLE)
      {
         M_LogError("Could not create stGVL.nSmallEMAHandle_CurrTF");
      }
      else if(stGVL.nBigEMAHandle_CurrTF == INVALID_HANDLE)
      {
         M_LogError("Could not create stGVL.nBigEMAHandle_CurrTF");
      }
   }
   
   return true;
}