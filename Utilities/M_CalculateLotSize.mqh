double M_CalculateLotSize(double riskPercent, double stopLossPoints)
{
   // --- Safety checks
   if(riskPercent <= 0 || stopLossPoints <= 0)
      return 0.0;

   // --- Account & symbol info
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);

   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   if(tick_value <= 0)
      return 0.0;

   // --- Money to risk
   double riskMoney = balance * riskPercent / 100.0;

   double lot = riskMoney / (stopLossPoints * tick_value);

   // --- Loss per Lot
   double CalcedLoss = fLossPerLot * lot;
   riskMoney = riskMoney - CalcedLoss;
   lot = riskMoney / (stopLossPoints * tick_value);

   // Divide by number of positions
   lot = lot / stGVL.nNumberOfPositions;

   // --- Normalize to lot step
   lot = MathFloor(lot / lotStep) * lotStep;

   // --- Clamp to symbol limits
   lot = MathMax(minLot, MathMin(lot, maxLot));

   return NormalizeDouble(lot, 2);
}