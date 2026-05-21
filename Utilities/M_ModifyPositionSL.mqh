bool M_ModifyPositionSL(ulong ticket, double NewSL)
{
   ResetLastError();
   int Error;
   
   PositionSelectByTicket(ticket);
   
   Error = GetLastError();
   if(Error != 0)
   {
      M_LogError("PositionSelectByTicket, Error=" + IntegerToString(Error));
      return false;
   }
   
   string symbol = PositionGetString(POSITION_SYMBOL);
   double tp     = PositionGetDouble(POSITION_TP);
   
   Error = GetLastError();
   if(Error != 0)
   {
      M_LogError("PositionGetDouble(POSITION_TP), Error=" + IntegerToString(Error) + " ticket=" + IntegerToString(ticket));
      return false;
   }

   MqlTradeRequest  req;
   MqlTradeResult   res;
   ZeroMemory(req);
   ZeroMemory(res);

   req.action   = TRADE_ACTION_SLTP;
   req.position = ticket;
   req.symbol   = symbol;
   req.sl       = NormalizeDouble(NewSL, _Digits);
   req.tp       = tp;

   if(!OrderSend(req, res))
   {
      string Message = "Modify SL failed: " + IntegerToString(GetLastError());
      M_LogError(Message);
      return false;
   }

   if(res.retcode != TRADE_RETCODE_DONE)
   {
      string Message = "Modify SL retcode: " + IntegerToString(res.retcode);
      M_LogError(Message);
      return false;
   }
   
   M_LogInfo("Stoploss modified to " + DoubleToString(req.sl));

   return true;
}
