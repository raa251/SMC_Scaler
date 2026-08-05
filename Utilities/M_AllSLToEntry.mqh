bool M_AllSLToEntry()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
               
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == nMagicNumber)
         {
            stGVL.StopLoss = stGVL.Entry;
            M_MoveBE(ticket);
         }
         else
         {
            M_LogInfo("Position " + IntegerToString(ticket) + " is not from actual symbol, actual symbol(" + _Symbol + "), position symbol=" + PositionGetString(POSITION_SYMBOL));
         }
      }
      else
      {
         M_LogError("Error on PositionSelect " + IntegerToString(GetLastError()));
      }
   }
   
   return true;
}