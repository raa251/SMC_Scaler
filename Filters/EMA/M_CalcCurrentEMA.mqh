bool M_CalcCurrentEMA()
{
   if(bEMAActive)
   {
      ResetLastError();
      if(CopyBuffer(stGVL.nSmallEMAHandle, 0, 0, nMaxCandles, stGVL.SmallEMABuffer) <= 0)
      {
         string Message = "Failed to copy EMA buffer, error: " + IntegerToString(GetLastError());
         M_LogError(Message);
      }
      
      ResetLastError();
      if(CopyBuffer(stGVL.nBigEMAHandle, 0, 0, nMaxCandles, stGVL.BigEMABuffer) <= 0)
      {
         string Message = "Failed to copy EMA buffer, error: " + IntegerToString(GetLastError());
         M_LogError(Message);
      }
   }
   
   if(bRunnerPosition)
   {
      ResetLastError();
      if(CopyBuffer(stGVL.nSmallEMAHandle_CurrTF, 0, 0, nMaxCandles, stGVL.SmallEMABuffer_CurrTF) <= 0)
      {
         string Message = "Failed to copy EMA buffer, error: " + IntegerToString(GetLastError());
         M_LogError(Message);
      }
      
      ResetLastError();
      if(CopyBuffer(stGVL.nBigEMAHandle_CurrTF, 0, 0, nMaxCandles, stGVL.BigEMABuffer_CurrTF) <= 0)
      {
         string Message = "Failed to copy EMA buffer, error: " + IntegerToString(GetLastError());
         M_LogError(Message);
      }
   }
   
   return true;
}