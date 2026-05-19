bool M_NewsOK(bool bLog)
{
   if(eNewsImportance == CALENDAR_IMPORTANCE_NONE)
   {
      return true; // News filter disabled
   }
   
   ResetLastError();
   
   datetime start = stGVL.dtCurrentTime - nNewsMinutesAfter * 60;
   datetime end = stGVL.dtCurrentTime + nNewsMinutesBefore * 60;
   
   MqlCalendarValue values[];
   // We ask for the specified time range
   // When we hand over NULL for the country, it checks globaly
   if(CalendarValueHistory(values, start, end))
   {
      for(int i = 0; i < ArraySize(values); i++)
      {
         MqlCalendarEvent event;
         // Details zum Event holen (Währung, Wichtigkeit)
         if(CalendarEventById(values[i].event_id, event))
         {
            // Filter: Nur hohe Wichtigkeit und passende Währung
            if(event.importance >= eNewsImportance)
            {
               // Prüfen, ob die Währung des Events im Symbol vorkommt (z.B. "USD" in "EURUSD")
               string Currency = GetCurrencyByEvent(event);
               if((StringFind(sNewsCurrency1, Currency) >= 0 && Currency!="")
                  || (StringFind(sNewsCurrency2, Currency) >= 0 && Currency!="")
                  || (StringFind(sNewsCurrency3, Currency) >= 0 && Currency!="")
                  || (StringFind(sNewsCurrency4, Currency) >= 0 && Currency!="")
                  || (StringFind(sNewsCurrency5, Currency) >= 0 && Currency!=""))
               {
                  if(bLog)
                  {
                     string Message = "News Filter aktiv: " + event.name + " (" + Currency + ")";
                     M_LogInfo(Message);
                  }
                  return false;
               }
            }
         }
         else
         {
            M_LogError("Error when checking calendar event, error " + IntegerToString(GetLastError()));
         }
      }
   }
   return true; // No news found
}

