bool M_DayOK(bool bLog)
{
   MqlDateTime t;
   TimeToStruct(stGVL.dtCurrentTime, t);
   
   if(t.day_of_week == 1 && bMonday)
   {
      return true;
   }
   if(t.day_of_week == 2 && bTuesday)
   {
      return true;
   }
   if(t.day_of_week == 3 && bWednesday)
   {
      return true;
   }
   if(t.day_of_week == 4 && bThursday)
   {
      return true;
   }
   if(t.day_of_week == 5 && bFriday)
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogWarning("Day of week not OK");
      }
      return false;
   }
}