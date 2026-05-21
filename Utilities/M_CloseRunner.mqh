bool M_CloseRunner(bool now)
{
   if(now)
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
               
         if(PositionSelectByTicket(ticket))
         {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol)
            {
               if(PositionGetDouble(POSITION_TP) == 0)
               {
                  // close runner position
                  Trade.PositionClose(ticket);
                  return true;
               }
            }
         }
      }
   }
   return false;
}