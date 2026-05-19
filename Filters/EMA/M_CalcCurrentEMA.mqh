void M_CalcCurrentEMA()
{
   ResetLastError();
   if(CopyBuffer(stGVL.EMA1Handle, 0, 0, nMaxCandles, stGVL.EMA1Buffer) <= 0)
   {
      M_LogError("Failed to copy EMA1 buffer, error: " + IntegerToString(GetLastError()));
   }
   
   ResetLastError();
   if(CopyBuffer(stGVL.EMA2Handle, 0, 0, nMaxCandles, stGVL.EMA2Buffer) <= 0)
   {
      M_LogError("Failed to copy EMA2 buffer, error: " + IntegerToString(GetLastError()));
   }
   
   ResetLastError();
   if(CopyBuffer(stGVL.EMA3Handle, 0, 0, nMaxCandles, stGVL.EMA3Buffer) <= 0)
   {
      M_LogError("Failed to copy EMA3 buffer, error: " + IntegerToString(GetLastError()));
   }
   
   ResetLastError();
   if(CopyBuffer(stGVL.EMA4Handle, 0, 0, nMaxCandles, stGVL.EMA4Buffer) <= 0)
   {
      M_LogError("Failed to copy EMA4 buffer, error: " + IntegerToString(GetLastError()));
   }
   
   
}