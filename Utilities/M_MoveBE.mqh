bool M_MoveBE(ulong ticket)
{
   ResetLastError();
   int Error;
   if(!PositionSelectByTicket(ticket))
   {
      Error = GetLastError();
      if(Error != 0)
      {
         M_LogError("PositionSelectByTicket, Error=" + IntegerToString(Error) + " ticket=" + IntegerToString(ticket));
      }
      return false;
   }
   
   double entry      = PositionGetDouble(POSITION_PRICE_OPEN);
   double volume     = PositionGetDouble(POSITION_VOLUME);
   double commission = PositionGetDouble(POSITION_COMMISSION);
   double swap       = PositionGetDouble(POSITION_SWAP);
   Error = GetLastError();
   if(Error != 0)
   {
      M_LogError("PositionSelectByTicket, Error=" + IntegerToString(Error));
      return false;
   }
   
   // Gesamtkosten (negativ)
   double totalCost = -(commission + swap);
   
   // Tick Value
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   // Preisverschiebung nötig um Kosten auszugleichen
   double priceOffset = (totalCost / (tickValue * volume)) * tickSize;
   
   // BE Preis
   double breakEvenPrice;
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      breakEvenPrice = entry + priceOffset;
   }
   else
   {
      breakEvenPrice = entry - priceOffset;
   }
   
   string symbol = PositionGetString(POSITION_SYMBOL);
   double tp     = PositionGetDouble(POSITION_TP);

   MqlTradeRequest  req;
   MqlTradeResult   res;
   ZeroMemory(req);
   ZeroMemory(res);

   req.action   = TRADE_ACTION_SLTP;
   req.position = ticket;
   req.symbol   = symbol;
   req.sl       = NormalizeDouble(breakEvenPrice, _Digits);
   req.tp       = tp;

   if(!OrderSend(req, res))
   {
      string Message = "Modify SL to BE failed: " + IntegerToString(GetLastError());
      M_LogError(Message);
      return false;
   }

   if(res.retcode != TRADE_RETCODE_DONE)
   {
      string Message = "Modify SL to BE retcode: " + IntegerToString(res.retcode);
      M_LogError(Message);
      return false;
   }
   
   M_LogInfo("Stoploss moved BE to " + DoubleToString(req.sl) + " entry=" + DoubleToString(entry));

   return true;
}
