bool M_FiltersOK(bool bLog)
{
   if(!M_SessionFilterOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Out of session");
      return false;
   }

   if(!M_SpreadOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Spread too high");
      return false;
   }

   if(!M_NewsOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "News active");
      return false;
   }
   
   if(!M_MaxTradesPerDayOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Maximum number of trades reached");
      return false;
   }
   
   if(!M_MaxDailyProfitOk(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Maximum daily profit reached");
      return false;
   }
   
   if(!M_MaxDailyLossOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Maximum daily loss reached");
      return false;
   }
   
   if(!M_DayOK(bLog))
   {
      M_ChangeLabelText("FilterLabel", "Trading is disaled on this day");
      return false;
   }
   
   M_ChangeLabelText("FilterLabel", "Looking for trades");
   
   return true;
}