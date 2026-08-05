bool M_CheckRunnerToTP1()
{
   if(stGVL.fDistanceMoveRunnerSLTP1_Price <= 0)
   {
      return false;
   }
   
   if(stGVL.Candle[0].high > stGVL.TakeProfit + stGVL.fDistanceMoveRunnerSLTP1_Price && stGVL.eCurrentDirection == DIR_LONG)
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
               
         if(PositionSelectByTicket(ticket))
         {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == nMagicNumber)
            {
               if(PositionGetDouble(POSITION_TP) == 0 && PositionGetDouble(POSITION_SL) != stGVL.TakeProfit) // Runner Position
               {
                  return M_ModifyPositionSL(ticket, stGVL.TakeProfit);
               }
            }
         }
      }
   }
   else if(stGVL.Candle[0].low < stGVL.TakeProfit - stGVL.fDistanceMoveRunnerSLTP1_Price && stGVL.eCurrentDirection == DIR_SHORT)
   {
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
               
         if(PositionSelectByTicket(ticket))
         {
            if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == nMagicNumber)
            {
               if(PositionGetDouble(POSITION_TP) == 0 && PositionGetDouble(POSITION_SL) != stGVL.TakeProfit) // Runner Position
               {
                  return M_ModifyPositionSL(ticket, stGVL.TakeProfit);
               }
            }
         }
      }
   }
      
   return false;
}