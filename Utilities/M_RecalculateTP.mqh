bool M_RecalculateTP()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
               
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol)
         {
            if(PositionGetDouble(POSITION_TP) != 0) // Runner Position
            {
               double SL = PositionGetDouble(POSITION_SL);
               double Entry = PositionGetDouble(POSITION_PRICE_OPEN);
               double TP;
               if(stGVL.eCurrentDirection == DIR_LONG)
               {
                  TP = Entry + (Entry - SL) * fRiskReward;
               }
               else
               {
                  TP = Entry - (SL - Entry) * fRiskReward;
               }
               
               MqlTradeRequest  req;
               MqlTradeResult   res;
               ZeroMemory(req);
               ZeroMemory(res);
            
               req.action   = TRADE_ACTION_SLTP;
               req.position = ticket;
               req.symbol   = PositionGetString(POSITION_SYMBOL);
               req.sl       = SL;
               req.tp       = TP;
            
               if(!OrderSend(req, res))
               {
                  string Message = "Modify TP failed: " + IntegerToString(GetLastError());
                  M_LogError(Message);
                  return false;
               }
            
               if(res.retcode != TRADE_RETCODE_DONE)
               {
                  string Message = "Modify TP retcode: " + IntegerToString(res.retcode);
                  M_LogError(Message);
                  return false;
               }
               
               stGVL.TakeProfit = req.tp;
               M_LogInfo("Takeprofit recalculated and modified to " + DoubleToString(req.tp));
               
            }
         }
      }
   }
   
   return true;
}