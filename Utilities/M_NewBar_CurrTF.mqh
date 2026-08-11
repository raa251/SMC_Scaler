void M_NewBar_CurrTF()
{
   if(tmpDebugTime == stGVL.dtCurrentTime)
   {
      tmpDebugTime = stGVL.dtCurrentTime;
   }
   
   stGVL.bWaitForNewCurrBar = false;
   
   M_StructureTrendCTF();
   
   M_CalcCurrentEMA();
   
   if(stGVL.dtTimeCurrent_HigherTF != stGVL.dtTimeLast_HigherTF)
   {
      M_NewBar_HigherTF();
      stGVL.dtTimeLast_HigherTF = stGVL.dtTimeCurrent_HigherTF;
   }
   
   stGVL.dtCurrentDay = stGVL.dtCurrentTime - (stGVL.dtCurrentTime % 86400);
   if(stGVL.dtCurrentDay != stGVL.dtLastDay)
   {
      stGVL.dtLastDay = stGVL.dtCurrentDay;
      M_NewDay();
   }
   
   MqlDateTime t;
   TimeToStruct(stGVL.dtCurrentTime, t);
   stGVL.nActualHour = t.hour;

   int currentMonthKey = t.year * 12 + t.mon;
   if(currentMonthKey != stGVL.nLastMonthKey)
   {
      stGVL.nLastMonthKey = currentMonthKey;
      M_NewMonth();
   }

   M_HandleBoxes();
}