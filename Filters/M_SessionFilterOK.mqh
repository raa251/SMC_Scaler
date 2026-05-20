bool M_SessionFilterOK(bool bLog)
{
   int nTimeDebug = stGVL.nActualHour; 
   if ((stGVL.nActualHour >= nStartTime1 && stGVL.nActualHour < nEndTime1)
      || ((stGVL.nActualHour >= nStartTime2 && stGVL.nActualHour < nEndTime2) && nStartTime2 != -1 && nEndTime2 != -1))
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogInfo("Out of session");
      }
      return false;
   }
}