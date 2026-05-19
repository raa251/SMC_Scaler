bool M_GetCandleData(ENUM_TIMEFRAMES TimeFrame, MqlRates &CDL[], int NrOfCandles)
{
   ArraySetAsSeries(CDL, true);
   bool copied = CopyRates(_Symbol, TimeFrame, 0, NrOfCandles, CDL);
   if(copied)
   {
      return true;
   } 
   else
   {
      string Message = "CopyRates() " + EnumToString(TimeFrame) + " Error: " + IntegerToString(GetLastError());
      M_LogError(Message);
      
      return false;
   }
   
}